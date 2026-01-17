import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../domain/review_intelligence_model.dart';
import '../../providers/reviews_provider.dart';

/// Displays the Review Intelligence dashboard with
/// Feature Requests, Bug Reports, and Version Sentiment
class ReviewIntelligenceCard extends ConsumerWidget {
  final int appId;

  const ReviewIntelligenceCard({super.key, required this.appId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final intelligenceAsync = ref.watch(reviewIntelligenceProvider(appId));

    return Container(
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: intelligenceAsync.when(
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
            data: (intelligence) {
              final hasData = intelligence.featureRequests.isNotEmpty ||
                  intelligence.bugReports.isNotEmpty ||
                  intelligence.versionSentiment.isNotEmpty;

              if (!hasData) {
                return _EmptyIntelligenceView();
              }

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary stats
                    _SummaryStats(summary: intelligence.summary),
                    const SizedBox(height: 20),

                    // Feature Requests section
                    if (intelligence.featureRequests.isNotEmpty) ...[
                      _InsightSection(
                        title: context.l10n.reviewIntelligence_featureRequests,
                        icon: Icons.lightbulb_outline_rounded,
                        iconColor: colors.yellow,
                        items: intelligence.featureRequests,
                        totalCount: intelligence.summary.totalFeatureRequests,
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Bug Reports section
                    if (intelligence.bugReports.isNotEmpty) ...[
                      _InsightSection(
                        title: context.l10n.reviewIntelligence_bugReports,
                        icon: Icons.bug_report_rounded,
                        iconColor: colors.red,
                        items: intelligence.bugReports,
                        totalCount: intelligence.summary.totalBugReports,
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Version Sentiment section
                    if (intelligence.versionSentiment.isNotEmpty) ...[
                      _VersionSentimentSection(
                        versions: intelligence.versionSentiment,
                        insight: intelligence.versionInsight,
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
    );
  }
}

/// Summary statistics row
class _SummaryStats extends StatelessWidget {
  final ReviewIntelligenceSummary summary;

  const _SummaryStats({required this.summary});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Expanded(
          child: _StatBox(
            label: context.l10n.reviewIntelligence_openFeatures,
            value: summary.openFeatureRequests.toString(),
            icon: Icons.lightbulb_outline_rounded,
            iconColor: colors.yellow,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatBox(
            label: context.l10n.reviewIntelligence_openBugs,
            value: summary.openBugReports.toString(),
            icon: Icons.bug_report_rounded,
            iconColor: colors.red,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatBox(
            label: context.l10n.reviewIntelligence_highPriority,
            value: summary.highPriorityBugs.toString(),
            icon: Icons.priority_high_rounded,
            iconColor: colors.orange,
          ),
        ),
      ],
    );
  }
}

/// Single stat box
class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
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
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: colors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Section displaying a list of insights (feature requests or bugs)
class _InsightSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<InsightItem> items;
  final int totalCount;

  const _InsightSection({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.items,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
            const Spacer(),
            Text(
              '$totalCount ${context.l10n.reviewIntelligence_total}',
              style: TextStyle(
                fontSize: 11,
                color: colors.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...items.take(5).map((item) => _InsightRow(item: item, iconColor: iconColor)),
      ],
    );
  }
}

/// Single insight row
class _InsightRow extends StatelessWidget {
  final InsightItem item;
  final Color iconColor;

  const _InsightRow({required this.item, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.bgSurface,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        border: Border.all(color: colors.glassBorder),
      ),
      child: Row(
        children: [
          // Priority indicator
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: _getPriorityColor(item.priority, colors),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _PriorityBadge(priority: item.priority),
                    const SizedBox(width: 8),
                    if (item.platform != null) ...[
                      Icon(
                        item.platform == 'ios' ? Icons.apple : Icons.android,
                        size: 12,
                        color: colors.textMuted,
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      '${item.mentionCount} ${context.l10n.reviewIntelligence_mentions}',
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Status badge
          _StatusBadge(status: item.status),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority, AppColorsExtension colors) {
    return switch (priority) {
      'critical' => colors.red,
      'high' => colors.orange,
      'medium' => colors.yellow,
      'low' => colors.green,
      _ => colors.textMuted,
    };
  }
}

/// Priority badge
class _PriorityBadge extends StatelessWidget {
  final String priority;

  const _PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = switch (priority) {
      'critical' => colors.red,
      'high' => colors.orange,
      'medium' => colors.yellow,
      'low' => colors.green,
      _ => colors.textMuted,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        priority.toUpperCase(),
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Status badge
class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (color, icon) = switch (status) {
      'open' => (colors.accent, Icons.radio_button_unchecked),
      'planned' => (colors.purple, Icons.event_note_rounded),
      'in_progress' => (colors.yellow, Icons.pending_rounded),
      'resolved' => (colors.green, Icons.check_circle_rounded),
      'wont_fix' => (colors.textMuted, Icons.cancel_rounded),
      _ => (colors.textMuted, Icons.help_outline_rounded),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withAlpha(40)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            _formatStatus(status),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatStatus(String status) {
    return switch (status) {
      'open' => 'Open',
      'planned' => 'Planned',
      'in_progress' => 'In Progress',
      'resolved' => 'Resolved',
      'wont_fix' => "Won't Fix",
      _ => status,
    };
  }
}

/// Version sentiment section
class _VersionSentimentSection extends StatelessWidget {
  final List<VersionSentiment> versions;
  final String? insight;

  const _VersionSentimentSection({
    required this.versions,
    this.insight,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.history_rounded, size: 16, color: colors.accent),
            const SizedBox(width: 8),
            Text(
              context.l10n.reviewIntelligence_sentimentByVersion,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...versions.take(5).map((version) => _VersionRow(version: version)),
        // Insight message
        if (insight != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.accent.withAlpha(15),
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              border: Border.all(color: colors.accent.withAlpha(40)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_rounded, size: 16, color: colors.accent),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    insight!,
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// Single version sentiment row
class _VersionRow extends StatelessWidget {
  final VersionSentiment version;

  const _VersionRow({required this.version});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sentimentColor = version.isPositive
        ? colors.green
        : version.isNegative
            ? colors.red
            : colors.yellow;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colors.bgSurface,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        border: Border.all(color: colors.glassBorder),
      ),
      child: Row(
        children: [
          // Version number
          SizedBox(
            width: 60,
            child: Text(
              version.version,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ),
          // Sentiment bar
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: colors.glassBorder,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: version.sentimentRatio.clamp(0.0, 1.0),
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: sentimentColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Sentiment percentage
          SizedBox(
            width: 45,
            child: Text(
              '${version.sentimentPercent.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: sentimentColor,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 8),
          // Review count
          Text(
            '(${version.reviewCount})',
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

/// Empty state when no intelligence data is available
class _EmptyIntelligenceView extends StatelessWidget {
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
              color: colors.purple.withAlpha(20),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.psychology_rounded,
              size: 28,
              color: colors.purple,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.reviewIntelligence_noData,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.l10n.reviewIntelligence_noDataHint,
            style: TextStyle(
              fontSize: 12,
              color: colors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
