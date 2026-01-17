import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../domain/conversion_funnel_model.dart';
import '../../providers/analytics_provider.dart';

/// Displays the conversion funnel visualization with
/// Impressions → Page Views → Downloads stages
class ConversionFunnelCard extends ConsumerWidget {
  final int appId;

  const ConversionFunnelCard({super.key, required this.appId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final funnelAsync = ref.watch(conversionFunnelProvider(appId));

    return Container(
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.filter_alt_rounded, size: 20, color: colors.accent),
                const SizedBox(width: 8),
                Text(
                  context.l10n.funnel_title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.glassBorder),
          funnelAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                e.toString(),
                style: TextStyle(color: colors.red, fontSize: 12),
              ),
            ),
            data: (funnel) {
              if (!funnel.hasData) {
                return _EmptyFunnelView(message: funnel.message);
              }
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Funnel stages visualization
                    _FunnelStages(summary: funnel.summary),
                    const SizedBox(height: 16),
                    // Category comparison
                    if (funnel.summary.categoryAverage != null)
                      _CategoryComparison(summary: funnel.summary),
                    const SizedBox(height: 16),
                    // Source breakdown
                    if (funnel.bySource.isNotEmpty)
                      _SourceBreakdown(sources: funnel.bySource),
                    // Insight based on source comparison
                    if (funnel.bySource.length >= 2) ...[
                      const SizedBox(height: 16),
                      _FunnelInsight(sources: funnel.bySource),
                    ],
                    // Trend chart
                    if (funnel.trend.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _FunnelTrendChart(trend: funnel.trend),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Visual funnel stages: Impressions → Page Views → Downloads
class _FunnelStages extends StatelessWidget {
  final FunnelSummary summary;

  const _FunnelStages({required this.summary});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        // Impressions
        Expanded(
          child: _FunnelStage(
            icon: Icons.visibility_rounded,
            iconColor: colors.accent,
            label: context.l10n.funnel_impressions,
            value: _formatNumber(summary.impressions),
            rate: null, // First stage has no conversion rate
            rateChange: null,
          ),
        ),
        // Arrow
        _FunnelArrow(rate: summary.impressionToPageViewRate),
        // Page Views
        Expanded(
          child: _FunnelStage(
            icon: Icons.touch_app_rounded,
            iconColor: colors.purple,
            label: context.l10n.funnel_pageViews,
            value: _formatNumber(summary.pageViews),
            rate: summary.impressionToPageViewRate,
            rateChange: null,
          ),
        ),
        // Arrow
        _FunnelArrow(rate: summary.pageViewToDownloadRate),
        // Downloads
        Expanded(
          child: _FunnelStage(
            icon: Icons.download_rounded,
            iconColor: colors.green,
            label: context.l10n.funnel_downloads,
            value: _formatNumber(summary.downloads),
            rate: summary.pageViewToDownloadRate,
            rateChange: null,
          ),
        ),
      ],
    );
  }

  String _formatNumber(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }
}

/// Single stage in the funnel
class _FunnelStage extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final double? rate;
  final double? rateChange;

  const _FunnelStage({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.rate,
    this.rateChange,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: iconColor.withAlpha(15),
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        border: Border.all(color: iconColor.withAlpha(40)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: colors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
          if (rate != null) ...[
            const SizedBox(height: 4),
            Text(
              '${rate!.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: iconColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Arrow between funnel stages showing conversion rate
class _FunnelArrow extends StatelessWidget {
  final double rate;

  const _FunnelArrow({required this.rate});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Icon(
            Icons.arrow_forward_rounded,
            size: 16,
            color: colors.textMuted,
          ),
          const SizedBox(height: 2),
          Text(
            '${rate.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

/// Category comparison badge
class _CategoryComparison extends StatelessWidget {
  final FunnelSummary summary;

  const _CategoryComparison({required this.summary});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final vsCategory = summary.vsCategory;
    final isPositive = vsCategory != null && vsCategory.startsWith('+');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: (isPositive ? colors.green : colors.yellow).withAlpha(15),
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        border: Border.all(
          color: (isPositive ? colors.green : colors.yellow).withAlpha(40),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${context.l10n.funnel_overallCvr}: ',
            style: TextStyle(
              fontSize: 12,
              color: colors.textMuted,
            ),
          ),
          Text(
            '${summary.overallConversionRate.toStringAsFixed(2)}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${context.l10n.funnel_categoryAvg}: ${summary.categoryAverage?.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 12,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isPositive ? colors.green : colors.yellow,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              vsCategory ?? 'N/A',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Source breakdown table
class _SourceBreakdown extends StatelessWidget {
  final List<SourceConversion> sources;

  const _SourceBreakdown({required this.sources});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            context.l10n.funnel_bySource,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
        ),
        ...sources.map((source) => _SourceRow(source: source)),
      ],
    );
  }
}

/// Single row in source breakdown
class _SourceRow extends StatelessWidget {
  final SourceConversion source;

  const _SourceRow({required this.source});

  IconData _getSourceIcon() {
    return switch (source.source) {
      'search' => Icons.search_rounded,
      'browse' => Icons.explore_rounded,
      'referral' => Icons.link_rounded,
      'app_referrer' => Icons.apps_rounded,
      'web_referrer' => Icons.language_rounded,
      _ => Icons.help_outline_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder.withAlpha(100))),
      ),
      child: Row(
        children: [
          Icon(_getSourceIcon(), size: 16, color: colors.textMuted),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              source.sourceLabel,
              style: TextStyle(
                fontSize: 12,
                color: colors.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _formatNumber(source.impressions),
              style: TextStyle(
                fontSize: 12,
                color: colors.textMuted,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _formatNumber(source.downloads),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              '${source.conversionRate.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colors.accent,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }
}

/// Empty state when no funnel data is available
class _EmptyFunnelView extends StatelessWidget {
  final String? message;

  const _EmptyFunnelView({this.message});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colors.accent.withAlpha(20),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.link_off_rounded,
              size: 28,
              color: colors.accent,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.funnel_noData,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message ?? context.l10n.funnel_noDataHint,
            style: TextStyle(
              fontSize: 12,
              color: colors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => context.push('/settings/integrations'),
            style: FilledButton.styleFrom(
              backgroundColor: colors.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: const Icon(Icons.link_rounded, size: 18),
            label: Text(context.l10n.funnel_connectStore),
          ),
        ],
      ),
    );
  }
}

/// AI-generated insight based on source conversion comparison
class _FunnelInsight extends StatelessWidget {
  final List<SourceConversion> sources;

  const _FunnelInsight({required this.sources});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final insight = _generateInsight(context);
    if (insight == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.accent.withAlpha(15),
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        border: Border.all(color: colors.accent.withAlpha(40)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_rounded,
            size: 18,
            color: colors.accent,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.funnel_insight,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colors.accent,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  insight,
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? _generateInsight(BuildContext context) {
    if (sources.length < 2) return null;

    // Sort by conversion rate descending
    final sorted = List<SourceConversion>.from(sources)
      ..sort((a, b) => b.conversionRate.compareTo(a.conversionRate));

    final best = sorted.first;
    final worst = sorted.last;

    // Only generate insight if there's meaningful difference
    if (best.conversionRate <= 0 || worst.conversionRate <= 0) return null;
    final ratio = best.conversionRate / worst.conversionRate;
    if (ratio < 1.3) return null; // Less than 30% difference, not insightful

    // Generate the insight text
    final ratioText = ratio.toStringAsFixed(1);
    return context.l10n.funnel_insightText(
      best.sourceLabel,
      ratioText,
      worst.sourceLabel,
      _getRecommendation(context, best.source),
    );
  }

  String _getRecommendation(BuildContext context, String bestSource) {
    return switch (bestSource) {
      'search' => context.l10n.funnel_insightRecommendSearch,
      'browse' => context.l10n.funnel_insightRecommendBrowse,
      'referral' => context.l10n.funnel_insightRecommendReferral,
      'app_referrer' => context.l10n.funnel_insightRecommendAppReferrer,
      'web_referrer' => context.l10n.funnel_insightRecommendWebReferrer,
      _ => context.l10n.funnel_insightRecommendDefault,
    };
  }
}

/// Trend chart showing CVR % over time
class _FunnelTrendChart extends StatelessWidget {
  final List<FunnelDataPoint> trend;

  const _FunnelTrendChart({required this.trend});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (trend.isEmpty) return const SizedBox.shrink();

    // Aggregate by week if more than 14 days of data
    final dataPoints = trend.length > 14 ? _aggregateByWeek() : trend;
    if (dataPoints.isEmpty) return const SizedBox.shrink();

    final maxY = dataPoints.map((p) => p.conversionRate).reduce(math.max);
    final minY = dataPoints.map((p) => p.conversionRate).reduce(math.min);
    final yRange = maxY - minY;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            context.l10n.funnel_trendTitle,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
        ),
        SizedBox(
          height: 150,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: yRange > 0 ? yRange / 4 : 1,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: colors.glassBorder.withAlpha(80),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text(
                      '${value.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 10,
                        color: colors.textMuted,
                      ),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 24,
                    interval: (dataPoints.length / 5).ceilToDouble(),
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= dataPoints.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          _formatDateLabel(dataPoints[index].date, trend.length > 14),
                          style: TextStyle(
                            fontSize: 9,
                            color: colors.textMuted,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: dataPoints
                      .asMap()
                      .entries
                      .map((e) => FlSpot(e.key.toDouble(), e.value.conversionRate))
                      .toList(),
                  isCurved: true,
                  curveSmoothness: 0.3,
                  color: colors.accent,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: dataPoints.length <= 10,
                    getDotPainter: (spot, percent, barData, index) =>
                        FlDotCirclePainter(
                      radius: 3,
                      color: colors.accent,
                      strokeWidth: 1,
                      strokeColor: colors.bgSurface,
                    ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colors.accent.withAlpha(60),
                        colors.accent.withAlpha(10),
                      ],
                    ),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => colors.bgActive,
                  tooltipRoundedRadius: 8,
                  getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
                    final index = spot.x.toInt();
                    final point = dataPoints[index];
                    return LineTooltipItem(
                      '${point.conversionRate.toStringAsFixed(2)}%\n${_formatDateLabel(point.date, false)}',
                      TextStyle(
                        fontSize: 11,
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }).toList(),
                ),
              ),
              minY: (minY - yRange * 0.1).clamp(0, double.infinity),
              maxY: maxY + yRange * 0.1,
            ),
          ),
        ),
      ],
    );
  }

  List<FunnelDataPoint> _aggregateByWeek() {
    if (trend.isEmpty) return [];

    final Map<String, List<FunnelDataPoint>> weeks = {};
    for (final point in trend) {
      // Parse date and get week number
      final date = DateTime.tryParse(point.date);
      if (date == null) continue;

      // Use start of week as key
      final weekStart = date.subtract(Duration(days: date.weekday - 1));
      final weekKey = '${weekStart.year}-${weekStart.month.toString().padLeft(2, '0')}-${weekStart.day.toString().padLeft(2, '0')}';

      weeks.putIfAbsent(weekKey, () => []).add(point);
    }

    // Aggregate each week
    final result = <FunnelDataPoint>[];
    final sortedKeys = weeks.keys.toList()..sort();

    for (final key in sortedKeys) {
      final points = weeks[key]!;
      final avgCvr = points.map((p) => p.conversionRate).reduce((a, b) => a + b) / points.length;
      final totalImpressions = points.map((p) => p.impressions).reduce((a, b) => a + b);
      final totalPageViews = points.map((p) => p.pageViews).reduce((a, b) => a + b);
      final totalDownloads = points.map((p) => p.downloads).reduce((a, b) => a + b);

      result.add(FunnelDataPoint(
        date: key,
        impressions: totalImpressions,
        pageViews: totalPageViews,
        downloads: totalDownloads,
        conversionRate: avgCvr,
      ));
    }

    return result;
  }

  String _formatDateLabel(String dateStr, bool isWeekly) {
    final date = DateTime.tryParse(dateStr);
    if (date == null) return dateStr;

    if (isWeekly) {
      // Format as "W1", "W2", etc. or "Jan 1"
      return '${date.month}/${date.day}';
    }
    return '${date.month}/${date.day}';
  }
}
