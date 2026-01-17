import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../domain/optimization_model.dart';

class WizardReviewStep extends StatelessWidget {
  final Map<String, String> selectedValues;
  final Map<String, OptimizationResponse?> suggestions;
  final String locale;
  final Function(WizardStep) onEdit;

  const WizardReviewStep({
    super.key,
    required this.selectedValues,
    required this.suggestions,
    required this.locale,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final hasChanges = selectedValues.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            context.l10n.wizard_reviewTitle,
            style: AppTypography.title,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            context.l10n.wizard_reviewDescription,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          if (!hasChanges) ...[
            _buildNoChangesCard(context),
          ] else ...[
            // Summary of changes
            _buildChangesSummary(context),

            const SizedBox(height: AppSpacing.lg),

            // Individual field changes
            ..._buildFieldReviewCards(context),
          ],

          const SizedBox(height: AppSpacing.lg),

          // Info about what happens next
          _buildNextStepsInfo(context, hasChanges),
        ],
      ),
    );
  }

  Widget _buildNoChangesCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.accentMuted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.info_outline,
            size: 48,
            color: AppColors.accent,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            context.l10n.wizard_noChanges,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            context.l10n.wizard_noChangesHint,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChangesSummary(BuildContext context) {
    final changesCount = selectedValues.length;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.greenMuted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.green.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: AppColors.green,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.wizard_changesCount(changesCount),
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.green,
                  ),
                ),
                Text(
                  context.l10n.wizard_changesSummary,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFieldReviewCards(BuildContext context) {
    final fields = ['title', 'subtitle', 'keywords', 'description'];
    final cards = <Widget>[];

    for (final field in fields) {
      final selectedValue = selectedValues[field];
      final suggestionResponse = suggestions[field];
      final originalValue = suggestionResponse?.currentValue ?? '';

      // Skip if no change for this field
      if (selectedValue == null) continue;

      // Skip if value is same as original
      if (selectedValue == originalValue) continue;

      cards.add(
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: _buildFieldCard(
            context,
            field: field,
            originalValue: originalValue,
            newValue: selectedValue,
            characterLimit: suggestionResponse?.characterLimit ?? 0,
          ),
        ),
      );
    }

    return cards;
  }

  Widget _buildFieldCard(
    BuildContext context, {
    required String field,
    required String originalValue,
    required String newValue,
    required int characterLimit,
  }) {
    final step = _getStepForField(field);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getFieldIcon(field),
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  _getFieldLabel(context, field),
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                // Edit button
                TextButton.icon(
                  onPressed: step != null ? () => onEdit(step) : null,
                  icon: const Icon(Icons.edit, size: 16),
                  label: Text(context.l10n.common_edit),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Original value (crossed out)
                if (originalValue.isNotEmpty) ...[
                  Text(
                    context.l10n.wizard_before,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    originalValue,
                    style: AppTypography.body.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: AppColors.textMuted,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],

                // New value
                Text(
                  context.l10n.wizard_after,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.green,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  newValue,
                  style: AppTypography.body.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  maxLines: field == 'description' ? 5 : 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: AppSpacing.sm),

                // Character count
                Text(
                  '${newValue.length}/$characterLimit ${context.l10n.wizard_characters}',
                  style: AppTypography.caption.copyWith(
                    color: newValue.length > characterLimit
                        ? AppColors.red
                        : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepsInfo(BuildContext context, bool hasChanges) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: AppColors.accent,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.wizard_nextStepsTitle,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  hasChanges
                      ? context.l10n.wizard_nextStepsWithChanges
                      : context.l10n.wizard_nextStepsNoChanges,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  WizardStep? _getStepForField(String field) {
    switch (field) {
      case 'title':
        return WizardStep.title;
      case 'subtitle':
        return WizardStep.subtitle;
      case 'keywords':
        return WizardStep.keywords;
      case 'description':
        return WizardStep.description;
      default:
        return null;
    }
  }

  IconData _getFieldIcon(String field) {
    switch (field) {
      case 'title':
        return Icons.title;
      case 'subtitle':
        return Icons.short_text;
      case 'keywords':
        return Icons.tag;
      case 'description':
        return Icons.description;
      default:
        return Icons.text_fields;
    }
  }

  String _getFieldLabel(BuildContext context, String field) {
    switch (field) {
      case 'title':
        return context.l10n.wizard_stepTitle;
      case 'subtitle':
        return context.l10n.wizard_stepSubtitle;
      case 'keywords':
        return context.l10n.wizard_stepKeywords;
      case 'description':
        return context.l10n.wizard_stepDescription;
      default:
        return field;
    }
  }
}
