import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../domain/optimization_model.dart';

class SuggestionOptionCard extends StatelessWidget {
  final OptimizationSuggestion suggestion;
  final bool isSelected;
  final VoidCallback onTap;

  const SuggestionOptionCard({
    super.key,
    required this.suggestion,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentMuted : AppColors.bgSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with option label and impact
            Row(
              children: [
                // Option label (A, B, C)
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: suggestion.isRecommended
                        ? AppColors.accent
                        : isSelected
                            ? AppColors.accent
                            : AppColors.bgHover,
                  ),
                  child: Center(
                    child: Text(
                      suggestion.option,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: suggestion.isRecommended || isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),

                // Recommended badge
                if (suggestion.isRecommended)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.greenMuted,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      context.l10n.wizard_recommended,
                      style: AppTypography.micro.copyWith(
                        color: AppColors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                const Spacer(),

                // Estimated impact
                _buildImpactBadge(context),

                const SizedBox(width: AppSpacing.sm),

                // Selection indicator
                Icon(
                  isSelected
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: isSelected ? AppColors.accent : AppColors.textMuted,
                  size: 22,
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.sm),

            // Value text
            Text(
              suggestion.value,
              style: AppTypography.body.copyWith(
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),

            const SizedBox(height: AppSpacing.xs),

            // Character count
            Text(
              '${suggestion.characterCount}/${suggestion.characterLimit} ${context.l10n.wizard_characters}',
              style: AppTypography.caption.copyWith(
                color: suggestion.characterCount > suggestion.characterLimit
                    ? AppColors.red
                    : AppColors.textMuted,
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            // Reasoning
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 16,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      suggestion.reasoning,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Keywords changes
            if (suggestion.keywordsAdded.isNotEmpty ||
                suggestion.keywordsRemoved.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              _buildKeywordChanges(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImpactBadge(BuildContext context) {
    final impact = suggestion.estimatedImpact;
    final color = impact >= 15
        ? AppColors.green
        : impact >= 8
            ? AppColors.yellow
            : AppColors.textMuted;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.trending_up, size: 14, color: color),
          const SizedBox(width: 2),
          Text(
            '+$impact%',
            style: AppTypography.micro.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeywordChanges(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        // Added keywords
        ...suggestion.keywordsAdded.map((kw) => _buildKeywordChip(
              kw,
              AppColors.greenMuted,
              AppColors.green,
              Icons.add,
            )),
        // Removed keywords
        ...suggestion.keywordsRemoved.map((kw) => _buildKeywordChip(
              kw,
              AppColors.redMuted,
              AppColors.red,
              Icons.remove,
            )),
      ],
    );
  }

  Widget _buildKeywordChip(
    String keyword,
    Color bgColor,
    Color fgColor,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fgColor),
          const SizedBox(width: 2),
          Text(
            keyword,
            style: AppTypography.micro.copyWith(color: fgColor),
          ),
        ],
      ),
    );
  }
}
