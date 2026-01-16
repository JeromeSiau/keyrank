import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/providers/app_context_provider.dart';
import '../../../insights/domain/aso_score_model.dart';
import '../../../insights/providers/insights_provider.dart';

/// Widget displaying the ASO Score on the dashboard
class AsoScoreSection extends ConsumerWidget {
  const AsoScoreSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final selectedApp = ref.watch(appContextProvider);

    // Only show when an app is selected
    if (selectedApp == null) {
      return _buildEmptyState(context);
    }

    final scoreAsync = ref.watch(asoScoreProvider(selectedApp.id));

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(color: colors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Divider(height: 1, color: colors.glassBorder),
          scoreAsync.when(
            data: (score) => _AsoScoreContent(score: score),
            loading: () => const Padding(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.error_outline, color: colors.red, size: 32),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Failed to load ASO score',
                      style: AppTypography.caption.copyWith(color: colors.textMuted),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextButton(
                      onPressed: () => ref.invalidate(asoScoreProvider(selectedApp.id)),
                      child: const Text('Retry'),
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

  Widget _buildHeader(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.cardPadding,
        vertical: AppSpacing.sm + 2,
      ),
      child: Row(
        children: [
          Icon(Icons.speed_outlined, size: 18, color: colors.accent),
          const SizedBox(width: AppSpacing.iconTextGap),
          Text(
            'ASO Health Score',
            style: AppTypography.titleSmall.copyWith(color: colors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(color: colors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Divider(height: 1, color: colors.glassBorder),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.apps_outlined, size: 40, color: colors.textMuted),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Select an app to see ASO score',
                    style: AppTypography.body.copyWith(color: colors.textMuted),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AsoScoreContent extends StatelessWidget {
  final AsoScore score;

  const _AsoScoreContent({required this.score});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main score display
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Score number with circular progress
              _ScoreCircle(score: score.score, status: score.status),
              const SizedBox(width: AppSpacing.md),
              // Score label and trend
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      score.label,
                      style: AppTypography.title.copyWith(
                        color: _getStatusColor(colors, score.status),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _TrendIndicator(trend: score.trend),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // Breakdown bars
          _BreakdownSection(breakdown: score.breakdown),
          // Recommendations (if any)
          if (score.recommendations.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            _RecommendationsSection(recommendations: score.recommendations),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(AppColorsExtension colors, String status) {
    switch (status) {
      case 'excellent':
        return colors.green;
      case 'good':
        return colors.accent;
      case 'fair':
        return colors.yellow;
      default:
        return colors.red;
    }
  }
}

class _ScoreCircle extends StatelessWidget {
  final int score;
  final String status;

  const _ScoreCircle({required this.score, required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final statusColor = _getStatusColor(colors);

    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 8,
              backgroundColor: colors.bgActive,
              valueColor: AlwaysStoppedAnimation(colors.bgActive),
            ),
          ),
          // Progress circle
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              value: score / 100,
              strokeWidth: 8,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation(statusColor),
            ),
          ),
          // Score text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$score',
                style: AppTypography.largeMetric.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
              Text(
                '/100',
                style: AppTypography.micro.copyWith(
                  color: colors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(AppColorsExtension colors) {
    switch (status) {
      case 'excellent':
        return colors.green;
      case 'good':
        return colors.accent;
      case 'fair':
        return colors.yellow;
      default:
        return colors.red;
    }
  }
}

class _TrendIndicator extends StatelessWidget {
  final AsoScoreTrend trend;

  const _TrendIndicator({required this.trend});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final (icon, color, text) = _getTrendData(colors);

    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTypography.caption.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'vs last ${trend.period}',
          style: AppTypography.caption.copyWith(color: colors.textMuted),
        ),
      ],
    );
  }

  (IconData, Color, String) _getTrendData(AppColorsExtension colors) {
    if (trend.isPositive) {
      return (
        Icons.trending_up,
        colors.green,
        '+${trend.change}',
      );
    } else if (trend.isNegative) {
      return (
        Icons.trending_down,
        colors.red,
        '${trend.change}',
      );
    } else {
      return (
        Icons.trending_flat,
        colors.textMuted,
        'Stable',
      );
    }
  }
}

class _BreakdownSection extends StatelessWidget {
  final AsoScoreBreakdown breakdown;

  const _BreakdownSection({required this.breakdown});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BreakdownBar(
          label: 'Metadata',
          category: breakdown.metadata,
          icon: Icons.description_outlined,
        ),
        const SizedBox(height: AppSpacing.sm),
        _BreakdownBar(
          label: 'Keywords',
          category: breakdown.keywords,
          icon: Icons.key_outlined,
        ),
        const SizedBox(height: AppSpacing.sm),
        _BreakdownBar(
          label: 'Reviews',
          category: breakdown.reviews,
          icon: Icons.rate_review_outlined,
        ),
        const SizedBox(height: AppSpacing.sm),
        _BreakdownBar(
          label: 'Ratings',
          category: breakdown.ratings,
          icon: Icons.star_outline,
        ),
      ],
    );
  }
}

class _BreakdownBar extends StatelessWidget {
  final String label;
  final AsoScoreCategory category;
  final IconData icon;

  const _BreakdownBar({
    required this.label,
    required this.category,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final barColor = _getBarColor(colors, category.status);

    return Row(
      children: [
        Icon(icon, size: 14, color: colors.textMuted),
        const SizedBox(width: 8),
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: AppTypography.caption.copyWith(color: colors.textSecondary),
          ),
        ),
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: colors.bgActive,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: category.percent / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 40,
          child: Text(
            '${category.percent}%',
            style: AppTypography.caption.copyWith(
              color: barColor,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Color _getBarColor(AppColorsExtension colors, String status) {
    switch (status) {
      case 'excellent':
        return colors.green;
      case 'good':
        return colors.accent;
      case 'fair':
        return colors.yellow;
      default:
        return colors.red;
    }
  }
}

class _RecommendationsSection extends StatelessWidget {
  final List<AsoScoreRecommendation> recommendations;

  const _RecommendationsSection({required this.recommendations});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.lightbulb_outline, size: 14, color: colors.yellow),
            const SizedBox(width: 6),
            Text(
              'Top Recommendations',
              style: AppTypography.label.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ...recommendations.take(3).map((rec) => _RecommendationItem(recommendation: rec)),
      ],
    );
  }
}

class _RecommendationItem extends StatelessWidget {
  final AsoScoreRecommendation recommendation;

  const _RecommendationItem({required this.recommendation});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final priorityColor = _getPriorityColor(colors);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: priorityColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              recommendation.action,
              style: AppTypography.caption.copyWith(
                color: colors.textSecondary,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: colors.greenMuted,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              recommendation.impact,
              style: AppTypography.micro.copyWith(
                color: colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(AppColorsExtension colors) {
    switch (recommendation.priority) {
      case 'critical':
        return colors.red;
      case 'high':
        return colors.yellow;
      case 'medium':
        return colors.accent;
      default:
        return colors.textMuted;
    }
  }
}
