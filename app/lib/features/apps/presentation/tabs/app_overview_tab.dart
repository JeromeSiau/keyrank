import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/providers/country_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../analytics/domain/analytics_summary_model.dart';
import '../../../analytics/providers/analytics_provider.dart';
import '../../../keywords/providers/keywords_provider.dart';
import '../../domain/app_model.dart';

class AppOverviewTab extends ConsumerWidget {
  final int appId;
  final AppModel app;

  const AppOverviewTab({
    super.key,
    required this.appId,
    required this.app,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(analyticsSummaryProvider(appId));
    final downloadsAsync = ref.watch(analyticsDownloadsProvider(appId));
    final countriesAsync = ref.watch(analyticsCountriesProvider(appId));
    final keywordsState = ref.watch(keywordsNotifierProvider(appId));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Period selector
          _PeriodSelector(appId: appId),
          const SizedBox(height: 16),

          // Key Metrics Row with real analytics
          summaryAsync.when(
            data: (summary) => _buildMetricsGrid(context, summary, keywordsState),
            loading: () => _buildMetricsGridLoading(context),
            error: (_, _) => _buildMetricsGridFallback(context, keywordsState),
          ),
          const SizedBox(height: 20),

          // Downloads Chart
          downloadsAsync.when(
            data: (data) => _DownloadsChart(data: data),
            loading: () => _ChartLoading(),
            error: (_, _) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 20),

          // Country Breakdown
          countriesAsync.when(
            data: (countries) => countries.isNotEmpty
                ? _CountryBreakdown(countries: countries)
                : const SizedBox.shrink(),
            loading: () => _SectionLoading(title: 'By Country'),
            error: (_, _) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 20),

          // Keywords Summary
          if (!keywordsState.isLoading && keywordsState.keywords.isNotEmpty)
            _KeywordsSummary(keywords: keywordsState.keywords),
          const SizedBox(height: 20),

          // App Info Section
          _buildAppInfoSection(context),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(
      BuildContext context, AnalyticsSummary summary, KeywordsState keywordsState) {
    final colors = context.colors;

    // Calculate keyword stats
    final totalKeywords = keywordsState.keywords.length;
    final rankedKeywords =
        keywordsState.keywords.where((k) => k.isRanked).length;
    final improvedKeywords =
        keywordsState.keywords.where((k) => k.hasImproved).length;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricCardWithTrend(
                icon: Icons.download_rounded,
                iconColor: colors.accent,
                label: 'Downloads',
                value: _formatNumber(summary.totalDownloads),
                trend: summary.downloadsChangePct,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCardWithTrend(
                icon: Icons.attach_money_rounded,
                iconColor: colors.green,
                label: 'Revenue',
                value: '\$${_formatCurrency(summary.totalRevenue)}',
                trend: summary.revenueChangePct,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MetricCardWithTrend(
                icon: Icons.people_rounded,
                iconColor: colors.purple,
                label: 'Subscribers',
                value: _formatNumber(summary.activeSubscribers),
                trend: summary.subscribersChangePct,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                icon: Icons.key_rounded,
                iconColor: colors.yellow,
                label: 'Keywords',
                value: '$rankedKeywords/$totalKeywords',
                subtitle: '$improvedKeywords improved',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.star_rounded,
                iconColor: colors.yellow,
                label: 'Rating',
                value: app.rating?.toStringAsFixed(1) ?? '-',
                subtitle: '${_formatNumber(app.ratingCount)} reviews',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                icon: Icons.emoji_events_rounded,
                iconColor: colors.green,
                label: 'Best Rank',
                value: app.bestRank != null ? '#${app.bestRank}' : '-',
                subtitle: 'position',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricsGridLoading(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Expanded(child: _MetricCardLoading()),
          const SizedBox(width: 12),
          Expanded(child: _MetricCardLoading()),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _MetricCardLoading()),
          const SizedBox(width: 12),
          Expanded(child: _MetricCardLoading()),
        ]),
      ],
    );
  }

  Widget _buildMetricsGridFallback(BuildContext context, KeywordsState keywordsState) {
    final colors = context.colors;
    final totalKeywords = keywordsState.keywords.length;
    final rankedKeywords = keywordsState.keywords.where((k) => k.isRanked).length;

    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            icon: Icons.star_rounded,
            iconColor: colors.yellow,
            label: 'Rating',
            value: app.rating?.toStringAsFixed(1) ?? '-',
            subtitle: '${_formatNumber(app.ratingCount)} reviews',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricCard(
            icon: Icons.key_rounded,
            iconColor: colors.accent,
            label: 'Keywords',
            value: '$totalKeywords',
            subtitle: '$rankedKeywords ranked',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricCard(
            icon: Icons.emoji_events_rounded,
            iconColor: colors.green,
            label: 'Best Rank',
            value: app.bestRank != null ? '#${app.bestRank}' : '-',
            subtitle: 'position',
          ),
        ),
      ],
    );
  }

  Widget _buildAppInfoSection(BuildContext context) {
    final colors = context.colors;
    final dateFormat = DateFormat('d MMM yyyy');

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
              Icon(Icons.info_outline, size: 18, color: colors.textMuted),
              const SizedBox(width: 8),
              Text(
                'App Information',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InfoRow(label: 'Developer', value: app.developer ?? '-'),
          _InfoRow(label: 'Version', value: app.version ?? '-'),
          _InfoRow(
            label: 'Release Date',
            value: app.releaseDate != null ? dateFormat.format(app.releaseDate!) : '-',
          ),
          _InfoRow(
            label: 'Last Update',
            value: app.updatedDate != null ? dateFormat.format(app.updatedDate!) : '-',
          ),
          _InfoRow(
            label: 'Size',
            value: app.sizeBytes != null ? _formatBytes(app.sizeBytes!) : '-',
          ),
          _InfoRow(
            label: 'Price',
            value: app.price == 0 || app.price == null
                ? 'Free'
                : '${app.currency ?? '\$'}${app.price!.toStringAsFixed(2)}',
          ),
          if (app.storeUrl != null) ...[
            const SizedBox(height: 12),
            _StoreButton(app: app),
          ],
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

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }

  String _formatBytes(int bytes) {
    if (bytes >= 1073741824) {
      return '${(bytes / 1073741824).toStringAsFixed(1)} GB';
    } else if (bytes >= 1048576) {
      return '${(bytes / 1048576).toStringAsFixed(1)} MB';
    } else if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '$bytes B';
  }
}

class _PeriodSelector extends ConsumerWidget {
  final int appId;

  const _PeriodSelector({required this.appId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final currentPeriod = ref.watch(analyticsPeriodProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: analyticsPeriodOptions.map((option) {
          final isSelected = option.$1 == currentPeriod;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Material(
              color: isSelected ? colors.accent : colors.bgActive,
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              child: InkWell(
                onTap: () => ref.read(analyticsPeriodProvider.notifier).state = option.$1,
                borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    option.$2,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : colors.textSecondary,
                    ),
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

class _MetricCardWithTrend extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final double? trend;

  const _MetricCardWithTrend({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.trend,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isPositive = trend != null && trend! > 0;
    final isNegative = trend != null && trend! < 0;

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
              const Spacer(),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPositive
                        ? colors.green.withAlpha(30)
                        : isNegative
                            ? colors.red.withAlpha(30)
                            : colors.bgActive,
                    borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive
                            ? Icons.trending_up_rounded
                            : isNegative
                                ? Icons.trending_down_rounded
                                : Icons.trending_flat_rounded,
                        size: 14,
                        color: isPositive
                            ? colors.green
                            : isNegative
                                ? colors.red
                                : colors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${trend!.abs().toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isPositive
                              ? colors.green
                              : isNegative
                                  ? colors.red
                                  : colors.textMuted,
                        ),
                      ),
                    ],
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
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String subtitle;

  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.subtitle,
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
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: colors.textMuted,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: colors.textMuted.withAlpha(180),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCardLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(color: colors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: colors.bgActive,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const Spacer(),
          Container(
            width: 60,
            height: 24,
            decoration: BoxDecoration(
              color: colors.bgActive,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 80,
            height: 12,
            decoration: BoxDecoration(
              color: colors.bgActive,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}

class _DownloadsChart extends StatelessWidget {
  final DownloadsChartData data;

  const _DownloadsChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (data.current.isEmpty) return const SizedBox.shrink();

    final spots = data.current.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.downloads.toDouble());
    }).toList();

    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);

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
              Icon(Icons.show_chart_rounded, size: 18, color: colors.accent),
              const SizedBox(width: 8),
              Text(
                'Downloads',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '${data.current.length} days',
                style: TextStyle(
                  fontSize: 12,
                  color: colors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 4,
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
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          _formatAxisNumber(value.toInt()),
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
                      interval: (data.current.length / 5).ceil().toDouble(),
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= data.current.length) {
                          return const SizedBox.shrink();
                        }
                        final date = data.current[index].date;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _formatShortDate(date),
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
                    color: colors.accent,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          colors.accent.withAlpha(60),
                          colors.accent.withAlpha(5),
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
                        final date = index < data.current.length
                            ? data.current[index].date
                            : '';
                        return LineTooltipItem(
                          '${spot.y.toInt()} downloads\n$date',
                          TextStyle(
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
            ),
          ),
        ],
      ),
    );
  }

  String _formatAxisNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    }
    return number.toString();
  }

  String _formatShortDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}';
    } catch (_) {
      return dateStr;
    }
  }
}

class _CountryBreakdown extends StatelessWidget {
  final List<CountryAnalytics> countries;

  const _CountryBreakdown({required this.countries});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final totalDownloads = countries.fold(0, (sum, c) => sum + c.downloads);
    final sortedCountries = List.of(countries)
      ..sort((a, b) => b.downloads.compareTo(a.downloads));
    final displayCountries = sortedCountries.take(6).toList();

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
              Icon(Icons.public_rounded, size: 18, color: colors.accent),
              const SizedBox(width: 8),
              Text(
                'By Country',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '${countries.length} countries',
                style: TextStyle(
                  fontSize: 12,
                  color: colors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...displayCountries.map((country) {
            final percentage = totalDownloads > 0
                ? (country.downloads / totalDownloads * 100)
                : 0.0;
            return _CountryRow(
              country: country,
              percentage: percentage,
              maxPercentage: displayCountries.first.downloads / totalDownloads * 100,
            );
          }),
        ],
      ),
    );
  }
}

class _CountryRow extends StatelessWidget {
  final CountryAnalytics country;
  final double percentage;
  final double maxPercentage;

  const _CountryRow({
    required this.country,
    required this.percentage,
    required this.maxPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final barWidth = maxPercentage > 0 ? percentage / maxPercentage : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                getFlagForStorefront(country.countryCode),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  country.countryCode.toUpperCase(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                  ),
                ),
              ),
              Text(
                _formatNumber(country.downloads),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 45,
                child: Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textMuted,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: barWidth,
              minHeight: 4,
              backgroundColor: colors.bgActive,
              valueColor: AlwaysStoppedAnimation<Color>(colors.accent),
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

class _KeywordsSummary extends StatelessWidget {
  final List keywords;

  const _KeywordsSummary({required this.keywords});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final total = keywords.length;
    final ranked = keywords.where((k) => k.isRanked).length;
    final improved = keywords.where((k) => k.hasImproved).length;
    final declined = keywords.where((k) => k.hasDeclined).length;
    final topKeywords = keywords
        .where((k) => k.position != null)
        .toList()
      ..sort((a, b) => (a.position ?? 999).compareTo(b.position ?? 999));

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
              Icon(Icons.key_rounded, size: 18, color: colors.yellow),
              const SizedBox(width: 8),
              Text(
                'Keywords',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _KeywordStat(label: 'Total', value: total, color: colors.accent),
              _KeywordStat(label: 'Ranked', value: ranked, color: colors.accent),
              _KeywordStat(label: 'Up', value: improved, color: colors.green),
              _KeywordStat(label: 'Down', value: declined, color: colors.red),
            ],
          ),
          if (topKeywords.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Top Performing',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: colors.textMuted,
              ),
            ),
            const SizedBox(height: 8),
            ...topKeywords.take(3).map((k) => _TopKeywordRow(keyword: k)),
          ],
        ],
      ),
    );
  }
}

class _KeywordStat extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _KeywordStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Expanded(
      child: Column(
        children: [
          Text(
            '$value',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopKeywordRow extends StatelessWidget {
  final dynamic keyword;

  const _TopKeywordRow({required this.keyword});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final change = keyword.change as int?;
    final isPositive = change != null && change > 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: colors.accent.withAlpha(30),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                '#${keyword.position}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: colors.accent,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              keyword.keyword as String,
              style: TextStyle(
                fontSize: 13,
                color: colors.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (change != null && change != 0)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                  size: 14,
                  color: isPositive ? colors.green : colors.red,
                ),
                Text(
                  '${change.abs()}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isPositive ? colors.green : colors.red,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _ChartLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(color: colors.glassBorder),
      ),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(colors.accent),
        ),
      ),
    );
  }
}

class _SectionLoading extends StatelessWidget {
  final String title;

  const _SectionLoading({required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(color: colors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const Spacer(),
          Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(colors.accent),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: colors.textMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
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
}

class _StoreButton extends StatelessWidget {
  final AppModel app;

  const _StoreButton({required this.app});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.accent,
      borderRadius: BorderRadius.circular(AppColors.radiusSmall),
      child: InkWell(
        onTap: () {
          Clipboard.setData(ClipboardData(text: app.storeUrl!));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Store URL copied to clipboard'),
              backgroundColor: colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                app.isIos ? Icons.apple : Icons.android,
                size: 18,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              const Text(
                'Copy Store URL',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
