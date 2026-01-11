import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../../../core/providers/country_provider.dart';
import '../../../../shared/widgets/star_histogram.dart';
import '../../../ratings/providers/ratings_provider.dart';
import '../../../ratings/domain/rating_model.dart';
import '../../domain/app_model.dart';

/// Selected country for rating history chart
final ratingChartCountryProvider = StateProvider.family<String, int>((ref, appId) => 'us');

/// Selected period for rating history
final ratingChartPeriodProvider = StateProvider<int>((ref) => 30);

class AppRatingsTab extends ConsumerWidget {
  final int appId;
  final AppModel app;

  const AppRatingsTab({
    super.key,
    required this.appId,
    required this.app,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final ratingsAsync = ref.watch(appRatingsProvider(appId));

    return ratingsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: colors.red),
            const SizedBox(height: 12),
            Text(
              error.toString(),
              style: TextStyle(color: colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => ref.invalidate(appRatingsProvider(appId)),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.l10n.common_retry),
            ),
          ],
        ),
      ),
      data: (response) => _buildContent(context, ref, response),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, AppRatingsResponse response) {
    final colors = context.colors;
    final dateFormat = DateFormat('d MMM yyyy');

    if (response.ratings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star_outline_rounded, size: 48, color: colors.textMuted),
            const SizedBox(height: 12),
            Text(
              'No ratings data available',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Rating information will appear here once collected',
              style: TextStyle(color: colors.textMuted),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary cards
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  icon: Icons.star_rounded,
                  iconColor: colors.yellow,
                  label: 'Average Rating',
                  value: response.averageRating?.toStringAsFixed(2) ?? '-',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  icon: Icons.reviews_rounded,
                  iconColor: colors.accent,
                  label: 'Total Ratings',
                  value: _formatNumber(response.totalRatings),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  icon: Icons.public_rounded,
                  iconColor: colors.green,
                  label: 'Countries',
                  value: response.ratings.length.toString(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  icon: Icons.update_rounded,
                  iconColor: colors.textSecondary,
                  label: 'Last Updated',
                  value: response.lastUpdated != null ? dateFormat.format(response.lastUpdated!) : '-',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Rating Trend Chart
          _RatingTrendChart(appId: appId, countries: response.ratings),
          const SizedBox(height: 24),
          // Current rating widget
          _buildCurrentRatingCard(context),
          const SizedBox(height: 24),
          // Ratings by country
          _buildCountryRatingsSection(context, response.ratings),
        ],
      ),
    );
  }

  Widget _buildCurrentRatingCard(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(color: colors.glassBorder),
      ),
      child: Row(
        children: [
          // Left: Rating display
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'App Store Rating',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.textMuted,
                  ),
                ),
                const SizedBox(height: 12),
                RatingSummary(
                  averageRating: app.rating ?? 0.0,
                  totalRatings: app.ratingCount,
                ),
              ],
            ),
          ),
          // Right: Star histogram (if we had distribution data)
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.bgActive.withAlpha(50),
                borderRadius: BorderRadius.circular(AppColors.radiusMedium),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rating Distribution',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Estimated distribution based on average rating
                  StarHistogram(
                    fiveStars: _estimateDistribution(app.rating ?? 0, app.ratingCount, 5),
                    fourStars: _estimateDistribution(app.rating ?? 0, app.ratingCount, 4),
                    threeStars: _estimateDistribution(app.rating ?? 0, app.ratingCount, 3),
                    twoStars: _estimateDistribution(app.rating ?? 0, app.ratingCount, 2),
                    oneStar: _estimateDistribution(app.rating ?? 0, app.ratingCount, 1),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Distribution estimated based on average rating',
                    style: TextStyle(
                      fontSize: 10,
                      fontStyle: FontStyle.italic,
                      color: colors.textMuted.withAlpha(150),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryRatingsSection(BuildContext context, List<CountryRating> ratings) {
    final colors = context.colors;
    // Sort by rating count
    final sortedRatings = List<CountryRating>.from(ratings)..sort((a, b) => b.ratingCount.compareTo(a.ratingCount));

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(color: colors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.public_rounded, size: 20, color: colors.accent),
                const SizedBox(width: 8),
                Text(
                  'Ratings by Country',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: colors.glassBorder, height: 1),
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: colors.bgActive.withAlpha(30),
            child: Row(
              children: [
                const SizedBox(
                  width: 100,
                  child: Text(
                    'Country',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Rating',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    'Count',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Rows
          ...sortedRatings.map((rating) => _CountryRatingRow(rating: rating)),
        ],
      ),
    );
  }

  int _estimateDistribution(double avgRating, int totalRatings, int stars) {
    if (totalRatings == 0) return 0;
    // Simple estimation based on normal distribution around average
    final distance = (avgRating - stars).abs();
    double weight;
    if (distance < 0.5) {
      weight = 0.45;
    } else if (distance < 1.5) {
      weight = 0.25;
    } else if (distance < 2.5) {
      weight = 0.15;
    } else {
      weight = 0.05;
    }
    // Adjust weights so 5 stars is heavily favored for high ratings
    if (avgRating >= 4.5 && stars == 5) weight = 0.65;
    if (avgRating >= 4.5 && stars == 4) weight = 0.20;
    if (avgRating < 2.0 && stars == 1) weight = 0.50;
    return (totalRatings * weight).round();
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}

class _RatingTrendChart extends ConsumerWidget {
  final int appId;
  final List<CountryRating> countries;

  const _RatingTrendChart({
    required this.appId,
    required this.countries,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final selectedCountry = ref.watch(ratingChartCountryProvider(appId));
    final selectedPeriod = ref.watch(ratingChartPeriodProvider);

    // Watch the history for selected country and period
    final historyAsync = ref.watch(
      ratingHistoryProvider((appId: appId, country: selectedCountry, days: selectedPeriod)),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(color: colors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with selectors
          Row(
            children: [
              Icon(Icons.show_chart_rounded, size: 20, color: colors.yellow),
              const SizedBox(width: 8),
              Text(
                'Rating Trend',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              const Spacer(),
              // Period selector
              _PeriodSelector(appId: appId),
            ],
          ),
          const SizedBox(height: 12),
          // Country selector
          _CountrySelector(appId: appId, countries: countries),
          const SizedBox(height: 16),
          // Chart
          SizedBox(
            height: 200,
            child: historyAsync.when(
              data: (history) => _buildChart(context, history),
              loading: () => Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(colors.accent),
                ),
              ),
              error: (_, __) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: colors.textMuted, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'Unable to load rating history',
                      style: TextStyle(color: colors.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context, List<CountryRating> history) {
    final colors = context.colors;

    if (history.isEmpty) {
      return Center(
        child: Text(
          'No historical data available',
          style: TextStyle(color: colors.textMuted),
        ),
      );
    }

    // Sort by date and create spots
    final sortedHistory = List.of(history)
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));

    final spots = sortedHistory.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        (entry.value.rating ?? 0).clamp(0, 5).toDouble(),
      );
    }).toList();

    if (spots.isEmpty || spots.length < 2) {
      return Center(
        child: Text(
          'Not enough data points',
          style: TextStyle(color: colors.textMuted),
        ),
      );
    }

    // Calculate trend
    final firstRating = spots.first.y;
    final lastRating = spots.last.y;
    final isImproving = lastRating > firstRating;
    final lineColor = isImproving ? colors.green : lastRating < firstRating ? colors.red : colors.yellow;

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 5,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: colors.glassBorder,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value % 1 != 0) return const SizedBox.shrink();
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontSize: 10,
                    color: colors.textMuted,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              interval: (sortedHistory.length / 5).ceil().toDouble().clamp(1, double.infinity),
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= sortedHistory.length) {
                  return const SizedBox.shrink();
                }
                final date = sortedHistory[index].recordedAt;
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '${date.day}/${date.month}',
                    style: TextStyle(
                      fontSize: 10,
                      color: colors.textMuted,
                    ),
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.3,
            color: lineColor,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 3,
                  color: lineColor,
                  strokeWidth: 1,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  lineColor.withAlpha(60),
                  lineColor.withAlpha(5),
                ],
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final index = spot.x.toInt();
                final date = index < sortedHistory.length
                    ? DateFormat('d MMM').format(sortedHistory[index].recordedAt)
                    : '';
                return LineTooltipItem(
                  '${spot.y.toStringAsFixed(2)}\n$date',
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}

class _PeriodSelector extends ConsumerWidget {
  final int appId;

  const _PeriodSelector({required this.appId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final currentPeriod = ref.watch(ratingChartPeriodProvider);

    final periods = [
      (7, '7d'),
      (30, '30d'),
      (90, '90d'),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: periods.map((period) {
        final isSelected = period.$1 == currentPeriod;
        return Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Material(
            color: isSelected ? colors.accent : colors.bgActive,
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
            child: InkWell(
              onTap: () => ref.read(ratingChartPeriodProvider.notifier).state = period.$1,
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Text(
                  period.$2,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : colors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _CountrySelector extends ConsumerWidget {
  final int appId;
  final List<CountryRating> countries;

  const _CountrySelector({
    required this.appId,
    required this.countries,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final selectedCountry = ref.watch(ratingChartCountryProvider(appId));

    // Sort countries by rating count
    final sortedCountries = List.of(countries)
      ..sort((a, b) => b.ratingCount.compareTo(a.ratingCount));
    final topCountries = sortedCountries.take(8).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: topCountries.map((country) {
          final isSelected = country.country.toLowerCase() == selectedCountry.toLowerCase();
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Material(
              color: isSelected ? colors.accent : colors.bgActive,
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              child: InkWell(
                onTap: () => ref.read(ratingChartCountryProvider(appId).notifier).state = country.country.toLowerCase(),
                borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        getFlagForStorefront(country.country),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        country.country.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _SummaryCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(color: colors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountryRatingRow extends StatelessWidget {
  final CountryRating rating;

  const _CountryRatingRow({required this.rating});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final ratingColor = rating.rating != null
        ? rating.rating! >= 4.0
            ? colors.green
            : rating.rating! >= 3.0
                ? colors.yellow
                : colors.red
        : colors.textMuted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder.withAlpha(100))),
      ),
      child: Row(
        children: [
          // Country
          SizedBox(
            width: 100,
            child: Row(
              children: [
                Text(
                  getFlagForStorefront(rating.country),
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 8),
                Text(
                  rating.country.toUpperCase(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          // Rating bar
          Expanded(
            child: Row(
              children: [
                // Rating value
                SizedBox(
                  width: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star_rounded, size: 16, color: colors.yellow),
                      const SizedBox(width: 4),
                      Text(
                        rating.rating?.toStringAsFixed(1) ?? '-',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Progress bar
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (rating.rating ?? 0) / 5,
                      backgroundColor: colors.bgHover,
                      color: ratingColor,
                      minHeight: 8,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Count
          SizedBox(
            width: 100,
            child: Text(
              _formatNumber(rating.ratingCount),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
