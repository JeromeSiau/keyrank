import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../domain/metadata_model.dart';

class MetadataCoverageCard extends StatelessWidget {
  final List<MetadataLocale> locales;

  const MetadataCoverageCard({
    super.key,
    required this.locales,
  });

  @override
  Widget build(BuildContext context) {
    final stats = _calculateStats();

    return Card(
      margin: const EdgeInsets.all(AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.language, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  context.l10n.metadataLocalization,
                  style: AppTypography.title,
                ),
                const Spacer(),
                _buildCoverageChip(stats.coveragePercent),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: stats.coveragePercent / 100,
                minHeight: 8,
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation(
                  stats.coveragePercent >= 80
                      ? AppColors.green
                      : stats.coveragePercent >= 50
                          ? AppColors.yellow
                          : AppColors.red,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Stats row
            Row(
              children: [
                _buildStatItem(
                  context,
                  icon: Icons.check_circle,
                  color: AppColors.green,
                  label: context.l10n.metadataLive,
                  count: stats.liveCount,
                ),
                const SizedBox(width: AppSpacing.lg),
                _buildStatItem(
                  context,
                  icon: Icons.edit_note,
                  color: AppColors.yellowBright,
                  label: context.l10n.metadataDraft,
                  count: stats.draftCount,
                ),
                const SizedBox(width: AppSpacing.lg),
                _buildStatItem(
                  context,
                  icon: Icons.warning_amber,
                  color: AppColors.textMuted,
                  label: context.l10n.metadataEmpty,
                  count: stats.emptyCount,
                ),
              ],
            ),
            if (stats.emptyCount > 0) ...[
              const SizedBox(height: AppSpacing.md),
              _buildInsight(context, stats),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCoverageChip(int percent) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: percent >= 80
            ? AppColors.green.withValues(alpha: 0.1)
            : percent >= 50
                ? AppColors.yellow.withValues(alpha: 0.1)
                : AppColors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
      ),
      child: Text(
        '$percent%',
        style: AppTypography.label.copyWith(
          color: percent >= 80
              ? AppColors.green
              : percent >= 50
                  ? AppColors.yellow
                  : AppColors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String label,
    required int count,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: AppSpacing.xxs),
        Text(
          '$count $label',
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildInsight(BuildContext context, _CoverageStats stats) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.accentMuted,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline, size: 16, color: AppColors.accent),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              context.l10n.metadataCoverageInsight(stats.emptyCount),
              style: AppTypography.caption.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _CoverageStats _calculateStats() {
    int liveCount = 0;
    int draftCount = 0;
    int emptyCount = 0;

    for (final locale in locales) {
      final hasLiveContent = locale.live != null &&
          (locale.live!.title?.isNotEmpty == true ||
              locale.live!.description?.isNotEmpty == true);

      if (locale.hasDraft) {
        draftCount++;
      } else if (hasLiveContent) {
        if (locale.isComplete) {
          liveCount++;
        } else {
          // Has some content but not complete
          liveCount++;
        }
      } else {
        emptyCount++;
      }
    }

    final totalLocales = locales.length;
    final completedLocales = liveCount + draftCount;
    final coveragePercent =
        totalLocales > 0 ? ((completedLocales / totalLocales) * 100).round() : 0;

    return _CoverageStats(
      liveCount: liveCount,
      draftCount: draftCount,
      emptyCount: emptyCount,
      totalCount: totalLocales,
      coveragePercent: coveragePercent,
    );
  }
}

class _CoverageStats {
  final int liveCount;
  final int draftCount;
  final int emptyCount;
  final int totalCount;
  final int coveragePercent;

  _CoverageStats({
    required this.liveCount,
    required this.draftCount,
    required this.emptyCount,
    required this.totalCount,
    required this.coveragePercent,
  });
}
