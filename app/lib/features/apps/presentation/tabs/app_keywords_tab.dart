import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../../keywords/providers/keywords_provider.dart';
import '../../../keywords/domain/keyword_model.dart';
import '../../../keywords/domain/ranking_history_point.dart';
import '../../../keywords/data/keywords_repository.dart';
import '../../domain/app_model.dart';

/// Provider for fetching keyword ranking history (cached).
/// Now supports aggregated data (daily, weekly, monthly).
final keywordRankingHistoryProvider = FutureProvider.family<
    List<RankingHistoryPoint>,
    ({int appId, int keywordId, DateTime? from})>((ref, params) async {
  final repository = ref.watch(keywordsRepositoryProvider);
  return repository.getRankingHistory(
    params.appId,
    keywordId: params.keywordId,
    from: params.from ?? DateTime.now().subtract(const Duration(days: 90)),
  );
});

class AppKeywordsTab extends ConsumerWidget {
  final int appId;
  final AppModel app;

  const AppKeywordsTab({
    super.key,
    required this.appId,
    required this.app,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final keywordsState = ref.watch(keywordsNotifierProvider(appId));

    if (keywordsState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (keywordsState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: colors.red),
            const SizedBox(height: 12),
            Text(
              keywordsState.error!,
              style: TextStyle(color: colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => ref.read(keywordsNotifierProvider(appId).notifier).load(),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.l10n.common_retry),
            ),
          ],
        ),
      );
    }

    final keywords = keywordsState.keywords;

    if (keywords.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.key_off_rounded, size: 48, color: colors.textMuted),
            const SizedBox(height: 12),
            Text(
              context.l10n.appDetail_noKeywordsTracked,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.appDetail_addKeywordHint,
              style: TextStyle(color: colors.textMuted),
            ),
          ],
        ),
      );
    }

    // Calculate stats
    final rankedKeywords = keywords.where((k) => k.isRanked).length;
    final improvedKeywords = keywords.where((k) => k.hasImproved).length;
    final declinedKeywords = keywords.where((k) => k.hasDeclined).length;
    final avgPosition = keywords.where((k) => k.isRanked).isEmpty
        ? 0.0
        : keywords.where((k) => k.isRanked).map((k) => k.position!).reduce((a, b) => a + b) /
            keywords.where((k) => k.isRanked).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats row
          _buildStatsRow(context, keywords.length, rankedKeywords, improvedKeywords, declinedKeywords, avgPosition),
          const SizedBox(height: 20),
          // Keywords table
          _buildKeywordsTable(context, ref, keywords),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, int total, int ranked, int improved, int declined, double avgPos) {
    final colors = context.colors;
    return Row(
      children: [
        _StatCard(
          icon: Icons.key_rounded,
          iconColor: colors.accent,
          label: 'Total',
          value: total.toString(),
        ),
        const SizedBox(width: 12),
        _StatCard(
          icon: Icons.visibility_rounded,
          iconColor: colors.green,
          label: 'Ranked',
          value: ranked.toString(),
        ),
        const SizedBox(width: 12),
        _StatCard(
          icon: Icons.trending_up_rounded,
          iconColor: colors.green,
          label: 'Improved',
          value: improved.toString(),
        ),
        const SizedBox(width: 12),
        _StatCard(
          icon: Icons.trending_down_rounded,
          iconColor: colors.red,
          label: 'Declined',
          value: declined.toString(),
        ),
        const SizedBox(width: 12),
        _StatCard(
          icon: Icons.analytics_rounded,
          iconColor: colors.yellow,
          label: 'Avg Position',
          value: avgPos > 0 ? '#${avgPos.toStringAsFixed(0)}' : '-',
        ),
      ],
    );
  }

  Widget _buildKeywordsTable(BuildContext context, WidgetRef ref, List<Keyword> keywords) {
    final colors = context.colors;
    // Sort by position (ranked first)
    final sortedKeywords = List<Keyword>.from(keywords)
      ..sort((a, b) {
        if (a.position == null && b.position == null) return 0;
        if (a.position == null) return 1;
        if (b.position == null) return -1;
        return a.position!.compareTo(b.position!);
      });

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(color: colors.glassBorder),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.glassBorder)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Keyword',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    'Position',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: Text(
                    'Change',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    'Trend',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: Text(
                    'Popularity',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    'Country',
                    textAlign: TextAlign.center,
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
          ...sortedKeywords.map((keyword) => _KeywordRow(
                appId: appId,
                keyword: keyword,
                onToggleFavorite: () {
                  ref.read(keywordsNotifierProvider(appId).notifier).toggleFavorite(keyword);
                },
              )),
        ],
      ),
    );
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
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
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
                Icon(icon, size: 16, color: iconColor),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KeywordRow extends ConsumerWidget {
  final int appId;
  final Keyword keyword;
  final VoidCallback onToggleFavorite;

  const _KeywordRow({
    required this.appId,
    required this.keyword,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder.withAlpha(100))),
      ),
      child: Row(
        children: [
          // Keyword name with favorite
          Expanded(
            flex: 3,
            child: Row(
              children: [
                InkWell(
                  onTap: onToggleFavorite,
                  borderRadius: BorderRadius.circular(4),
                  child: Icon(
                    keyword.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 18,
                    color: keyword.isFavorite ? colors.yellow : colors.textMuted,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        keyword.keyword,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: colors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (keyword.tags.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          children: keyword.tags.take(2).map((tag) => Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: tag.colorValue.withAlpha(30),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  tag.name,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: tag.colorValue,
                                  ),
                                ),
                              )).toList(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Position
          SizedBox(
            width: 80,
            child: Center(
              child: keyword.isRanked
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getPositionColor(colors, keyword.position!).withAlpha(30),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '#${keyword.position}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _getPositionColor(colors, keyword.position!),
                        ),
                      ),
                    )
                  : Text(
                      '-',
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.textMuted,
                      ),
                    ),
            ),
          ),
          // Change
          SizedBox(
            width: 70,
            child: Center(
              child: keyword.change != null && keyword.change != 0
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          keyword.change! > 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                          size: 14,
                          color: keyword.change! > 0 ? colors.green : colors.red,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${keyword.change!.abs()}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: keyword.change! > 0 ? colors.green : colors.red,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      '-',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textMuted,
                      ),
                    ),
            ),
          ),
          // Trend Sparkline
          SizedBox(
            width: 80,
            height: 30,
            child: _KeywordSparkline(
              appId: appId,
              keyword: keyword,
            ),
          ),
          // Popularity
          SizedBox(
            width: 70,
            child: Center(
              child: keyword.popularity != null
                  ? _PopularityBar(popularity: keyword.popularity!)
                  : Text(
                      '-',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textMuted,
                      ),
                    ),
            ),
          ),
          // Country
          SizedBox(
            width: 60,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: colors.bgActive,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  keyword.storefront.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPositionColor(AppColorsExtension colors, int position) {
    if (position <= 3) return colors.green;
    if (position <= 10) return colors.greenBright;
    if (position <= 50) return colors.yellow;
    return colors.textSecondary;
  }
}

class _KeywordSparkline extends ConsumerWidget {
  final int appId;
  final Keyword keyword;

  const _KeywordSparkline({
    required this.appId,
    required this.keyword,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    // Only show sparkline for ranked keywords
    if (!keyword.isRanked) {
      return Center(
        child: Text(
          '-',
          style: TextStyle(fontSize: 12, color: colors.textMuted),
        ),
      );
    }

    final historyAsync = ref.watch(
      keywordRankingHistoryProvider((
        appId: appId,
        keywordId: keyword.id,
        from: DateTime.now().subtract(const Duration(days: 90)),
      )),
    );

    return historyAsync.when(
      data: (history) {
        if (history.isEmpty || history.length < 2) {
          // Show a simple trend indicator based on change
          return _SimpleTrendIndicator(change: keyword.change, position: keyword.position);
        }

        // Filter out entries without displayable position
        final validHistory = history.where((h) => h.displayPosition != null).toList();
        if (validHistory.isEmpty) {
          return _SimpleTrendIndicator(change: keyword.change, position: keyword.position);
        }

        // Create spots using displayPosition (works for both daily and aggregates)
        final spots = validHistory.asMap().entries.map((entry) {
          // Invert: position 1 -> high value, position 100 -> low value
          final pos = entry.value.displayPosition ?? 100;
          final invertedValue = 101.0 - pos;
          return FlSpot(entry.key.toDouble(), invertedValue.clamp(1, 100));
        }).toList();

        // Determine if trending up (improving = positions getting lower = inverted getting higher)
        final isImproving = spots.length >= 2 && spots.last.y > spots.first.y;
        final lineColor = isImproving ? colors.green : colors.red;

        // Check if we have aggregated data
        final hasAggregates = history.any((h) => h.isAggregate);

        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineTouchData: const LineTouchData(enabled: false),
                  clipData: const FlClipData.all(),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.3,
                      color: lineColor,
                      barWidth: 1.5,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: lineColor.withAlpha(30),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Show indicator if data includes aggregates
            if (hasAggregates)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                  decoration: BoxDecoration(
                    color: colors.yellow.withAlpha(40),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(
                    'avg',
                    style: TextStyle(fontSize: 7, color: colors.yellow),
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => Center(
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            valueColor: AlwaysStoppedAnimation<Color>(colors.textMuted),
          ),
        ),
      ),
      error: (_, __) => _SimpleTrendIndicator(change: keyword.change, position: keyword.position),
    );
  }
}

class _SimpleTrendIndicator extends StatelessWidget {
  final int? change;
  final int? position;

  const _SimpleTrendIndicator({this.change, this.position});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (change == null || change == 0) {
      return Center(
        child: Container(
          width: 40,
          height: 2,
          decoration: BoxDecoration(
            color: colors.textMuted.withAlpha(100),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      );
    }

    final isUp = change! > 0;
    final color = isUp ? colors.green : colors.red;

    // Create a simple trend line based on change direction
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: CustomPaint(
        size: const Size(double.infinity, 20),
        painter: _TrendLinePainter(isUp: isUp, color: color),
      ),
    );
  }
}

class _TrendLinePainter extends CustomPainter {
  final bool isUp;
  final Color color;

  _TrendLinePainter({required this.isUp, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color.withAlpha(30)
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    if (isUp) {
      // Upward trend
      path.moveTo(0, size.height * 0.8);
      path.quadraticBezierTo(size.width * 0.5, size.height * 0.5, size.width, size.height * 0.2);

      fillPath.moveTo(0, size.height);
      fillPath.lineTo(0, size.height * 0.8);
      fillPath.quadraticBezierTo(size.width * 0.5, size.height * 0.5, size.width, size.height * 0.2);
      fillPath.lineTo(size.width, size.height);
      fillPath.close();
    } else {
      // Downward trend
      path.moveTo(0, size.height * 0.2);
      path.quadraticBezierTo(size.width * 0.5, size.height * 0.5, size.width, size.height * 0.8);

      fillPath.moveTo(0, size.height);
      fillPath.lineTo(0, size.height * 0.2);
      fillPath.quadraticBezierTo(size.width * 0.5, size.height * 0.5, size.width, size.height * 0.8);
      fillPath.lineTo(size.width, size.height);
      fillPath.close();
    }

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TrendLinePainter oldDelegate) {
    return oldDelegate.isUp != isUp || oldDelegate.color != color;
  }
}

class _PopularityBar extends StatelessWidget {
  final int popularity;

  const _PopularityBar({required this.popularity});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final normalizedPopularity = popularity.clamp(0, 100) / 100;

    return Column(
      children: [
        Text(
          popularity.toString(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 50,
          height: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: normalizedPopularity,
              backgroundColor: colors.bgHover,
              color: _getPopularityColor(colors, popularity),
            ),
          ),
        ),
      ],
    );
  }

  Color _getPopularityColor(AppColorsExtension colors, int popularity) {
    if (popularity >= 70) return colors.green;
    if (popularity >= 40) return colors.yellow;
    return colors.red;
  }
}
