import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_context_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../shared/widgets/star_histogram.dart';
import '../../apps/domain/app_model.dart';
import '../../apps/providers/apps_provider.dart';
import '../providers/ratings_provider.dart';
import '../domain/rating_model.dart';

/// Selected period for trend chart
final ratingsAnalysisPeriodProvider = StateProvider<int>((ref) => 30);

class RatingsAnalysisScreen extends ConsumerWidget {
  const RatingsAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final appsAsync = ref.watch(appsNotifierProvider);

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanel,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
      ),
      child: Column(
        children: [
          // Toolbar
          _buildToolbar(context, ref),
          // Content
          Expanded(
            child: appsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text(
                  'Error: $e',
                  style: TextStyle(color: colors.textPrimary),
                ),
              ),
              data: (apps) => _RatingsContent(apps: apps),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final selectedApp = ref.watch(appContextProvider);

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder)),
      ),
      child: Row(
        children: [
          Icon(Icons.star_rounded, color: colors.yellow, size: 24),
          const SizedBox(width: 12),
          Text(
            context.l10n.nav_ratingsAnalysis,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          if (selectedApp != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colors.accentMuted,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                selectedApp.name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.accent,
                ),
              ),
            ),
          ],
          const Spacer(),
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: colors.textMuted),
            onPressed: () => ref.invalidate(appsNotifierProvider),
            tooltip: context.l10n.common_refresh,
          ),
        ],
      ),
    );
  }
}

class _RatingsContent extends ConsumerWidget {
  final List<AppModel> apps;

  const _RatingsContent({required this.apps});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contextApp = ref.watch(appContextProvider);
    final selectedAppId = contextApp?.id;

    // Calculate aggregate stats from apps
    final totalRatings = apps.fold<int>(0, (sum, app) => sum + app.ratingCount);
    final avgRating = apps.isEmpty
        ? 0.0
        : apps.where((a) => a.rating != null).fold<double>(0, (sum, app) => sum + app.rating!) /
            apps.where((a) => a.rating != null).length;

    // Find selected app or use aggregate
    final selectedApp = contextApp;

    final displayRating = selectedApp?.rating ?? avgRating;
    final displayCount = selectedApp?.ratingCount ?? totalRatings;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left column - Summary cards
                    Expanded(
                      child: Column(
                        children: [
                          _buildSummaryCards(context, apps, displayRating, displayCount),
                          const SizedBox(height: 20),
                          _buildCurrentRatingCard(context, displayRating, displayCount),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Right column - Distribution + Trend
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          _buildDistributionCard(context, displayRating, displayCount),
                          const SizedBox(height: 20),
                          _RatingTrendCard(appId: selectedAppId),
                        ],
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    _buildSummaryCards(context, apps, displayRating, displayCount),
                    const SizedBox(height: 20),
                    _buildCurrentRatingCard(context, displayRating, displayCount),
                    const SizedBox(height: 20),
                    _buildDistributionCard(context, displayRating, displayCount),
                    const SizedBox(height: 20),
                    _RatingTrendCard(appId: selectedAppId),
                  ],
                ),

              const SizedBox(height: 20),
              // Apps comparison table
              _AppsRatingsTable(apps: apps),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCards(BuildContext context, List<AppModel> apps, double avgRating, int totalRatings) {
    final colors = context.colors;

    // Calculate stats
    final highRatedApps = apps.where((a) => (a.rating ?? 0) >= 4.5).length;
    final lowRatedApps = apps.where((a) => (a.rating ?? 0) < 3.0 && a.rating != null).length;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.star_rounded,
            iconColor: colors.yellow,
            label: 'Average',
            value: avgRating.toStringAsFixed(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.reviews_rounded,
            iconColor: colors.accent,
            label: 'Total Ratings',
            value: _formatNumber(totalRatings),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.thumb_up_rounded,
            iconColor: colors.green,
            label: 'High Rated (4.5+)',
            value: highRatedApps.toString(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.warning_rounded,
            iconColor: colors.red,
            label: 'Low Rated (<3)',
            value: lowRatedApps.toString(),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentRatingCard(BuildContext context, double avgRating, int totalRatings) {
    final colors = context.colors;
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star_rounded, size: 18, color: colors.yellow),
              const SizedBox(width: 8),
              Text(
                'Current Rating',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          RatingSummary(
            averageRating: avgRating,
            totalRatings: totalRatings,
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionCard(BuildContext context, double avgRating, int totalRatings) {
    final colors = context.colors;
    final distribution = _estimateDistribution(avgRating, totalRatings);

    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart_rounded, size: 18, color: colors.accent),
              const SizedBox(width: 8),
              Text(
                'Rating Distribution',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          StarHistogram(
            fiveStars: distribution[5] ?? 0,
            fourStars: distribution[4] ?? 0,
            threeStars: distribution[3] ?? 0,
            twoStars: distribution[2] ?? 0,
            oneStar: distribution[1] ?? 0,
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
    );
  }

  Map<int, int> _estimateDistribution(double avgRating, int totalRatings) {
    if (totalRatings == 0) return {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

    // More realistic distribution based on average
    double w5, w4, w3, w2, w1;

    if (avgRating >= 4.5) {
      w5 = 0.70; w4 = 0.18; w3 = 0.07; w2 = 0.03; w1 = 0.02;
    } else if (avgRating >= 4.0) {
      w5 = 0.50; w4 = 0.28; w3 = 0.12; w2 = 0.06; w1 = 0.04;
    } else if (avgRating >= 3.5) {
      w5 = 0.30; w4 = 0.30; w3 = 0.20; w2 = 0.12; w1 = 0.08;
    } else if (avgRating >= 3.0) {
      w5 = 0.15; w4 = 0.25; w3 = 0.30; w2 = 0.18; w1 = 0.12;
    } else {
      w5 = 0.08; w4 = 0.12; w3 = 0.20; w2 = 0.25; w1 = 0.35;
    }

    return {
      5: (totalRatings * w5).round(),
      4: (totalRatings * w4).round(),
      3: (totalRatings * w3).round(),
      2: (totalRatings * w2).round(),
      1: (totalRatings * w1).round(),
    };
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

class _RatingTrendCard extends ConsumerWidget {
  final int? appId;

  const _RatingTrendCard({this.appId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final selectedPeriod = ref.watch(ratingsAnalysisPeriodProvider);

    // If no specific app, show a message or aggregate
    if (appId == null) {
      return _GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.show_chart_rounded, size: 18, color: colors.yellow),
                const SizedBox(width: 8),
                Text(
                  'Rating Trend',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: colors.bgActive.withAlpha(50),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.touch_app_rounded, size: 32, color: colors.textMuted),
                    const SizedBox(height: 8),
                    Text(
                      'Select an app to view rating trend',
                      style: TextStyle(color: colors.textMuted, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Watch the history for the selected app
    final historyAsync = ref.watch(
      ratingHistoryProvider((appId: appId!, country: 'us', days: selectedPeriod)),
    );

    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.show_chart_rounded, size: 18, color: colors.yellow),
              const SizedBox(width: 8),
              Text(
                'Rating Trend',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.textMuted,
                ),
              ),
              const Spacer(),
              // Period selector
              _PeriodSelector(),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: historyAsync.when(
              data: (history) => _buildChart(context, history),
              loading: () => Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(colors.accent),
                ),
              ),
              error: (_, _) => Center(
                child: Text(
                  'Unable to load rating history',
                  style: TextStyle(color: colors.textMuted),
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

    final sortedHistory = List.of(history)
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));

    final spots = sortedHistory.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        (entry.value.rating ?? 0).clamp(0, 5).toDouble(),
      );
    }).toList();

    if (spots.length < 2) {
      return Center(
        child: Text(
          'Not enough data points',
          style: TextStyle(color: colors.textMuted),
        ),
      );
    }

    final firstRating = spots.first.y;
    final lastRating = spots.last.y;
    final lineColor = lastRating > firstRating
        ? colors.green
        : lastRating < firstRating
            ? colors.red
            : colors.yellow;

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 5,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: colors.glassBorder, strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value % 1 != 0) return const SizedBox.shrink();
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(fontSize: 10, color: colors.textMuted),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              interval: (sortedHistory.length / 5).ceil().toDouble().clamp(1, double.infinity),
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= sortedHistory.length) {
                  return const SizedBox.shrink();
                }
                final date = sortedHistory[index].recordedAt;
                return Text(
                  '${date.day}/${date.month}',
                  style: TextStyle(fontSize: 9, color: colors.textMuted),
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
      ),
    );
  }
}

class _PeriodSelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final currentPeriod = ref.watch(ratingsAnalysisPeriodProvider);

    final periods = [(7, '7d'), (30, '30d'), (90, '90d')];

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
              onTap: () => ref.read(ratingsAnalysisPeriodProvider.notifier).state = period.$1,
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

class _AppsRatingsTable extends StatelessWidget {
  final List<AppModel> apps;

  const _AppsRatingsTable({required this.apps});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // Sort apps by rating descending
    final sortedApps = List.of(apps)
      ..sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));

    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.leaderboard_rounded, size: 18, color: colors.accent),
              const SizedBox(width: 8),
              Text(
                'Apps Ranking by Rating',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.glassBorder)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 40, child: Text('#', style: TextStyle(fontWeight: FontWeight.w600))),
                const Expanded(flex: 3, child: Text('App', style: TextStyle(fontWeight: FontWeight.w600))),
                const Expanded(child: Text('Rating', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600))),
                const Expanded(child: Text('Reviews', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w600))),
              ],
            ),
          ),
          // Rows
          ...sortedApps.asMap().entries.map((entry) {
            final index = entry.key;
            final app = entry.value;
            return _AppRatingRow(rank: index + 1, app: app);
          }),
        ],
      ),
    );
  }
}

class _AppRatingRow extends StatelessWidget {
  final int rank;
  final AppModel app;

  const _AppRatingRow({required this.rank, required this.app});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final ratingColor = (app.rating ?? 0) >= 4.5
        ? colors.green
        : (app.rating ?? 0) >= 3.5
            ? colors.yellow
            : colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder.withAlpha(80))),
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 40,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: rank <= 3 ? colors.accent.withAlpha(30) : colors.bgActive,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: rank <= 3 ? colors.accent : colors.textMuted,
                  ),
                ),
              ),
            ),
          ),
          // App info
          Expanded(
            flex: 3,
            child: Row(
              children: [
                if (app.iconUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      app.iconUrl!,
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        width: 32,
                        height: 32,
                        color: colors.bgActive,
                        child: Icon(Icons.apps, size: 18, color: colors.textMuted),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: colors.bgActive,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.apps, size: 18, color: colors.textMuted),
                  ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        app.name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: colors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        app.isIos ? 'iOS' : 'Android',
                        style: TextStyle(
                          fontSize: 10,
                          color: colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Rating
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star_rounded, size: 16, color: colors.yellow),
                const SizedBox(width: 4),
                Text(
                  app.rating?.toStringAsFixed(1) ?? '-',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ratingColor,
                  ),
                ),
              ],
            ),
          ),
          // Reviews count
          Expanded(
            child: Text(
              _formatNumber(app.ratingCount),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
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

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatCard({
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
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: colors.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(color: colors.glassBorder),
      ),
      child: child,
    );
  }
}
