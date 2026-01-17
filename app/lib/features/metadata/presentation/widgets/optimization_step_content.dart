import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../domain/optimization_model.dart';
import 'suggestion_option_card.dart';

class OptimizationStepContent extends StatefulWidget {
  final int appId;
  final String locale;
  final String field;
  final OptimizationResponse? suggestions;
  final String? selectedValue;
  final Function(String) onSelect;
  final VoidCallback onLoadSuggestions;

  const OptimizationStepContent({
    super.key,
    required this.appId,
    required this.locale,
    required this.field,
    this.suggestions,
    this.selectedValue,
    required this.onSelect,
    required this.onLoadSuggestions,
  });

  @override
  State<OptimizationStepContent> createState() =>
      _OptimizationStepContentState();
}

class _OptimizationStepContentState extends State<OptimizationStepContent> {
  final _customController = TextEditingController();
  bool _isCustomMode = false;

  @override
  void initState() {
    super.initState();
    // Load suggestions if not already loaded
    if (widget.suggestions == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onLoadSuggestions();
      });
    }
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.suggestions == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final suggestions = widget.suggestions!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current value card
          _buildCurrentValueCard(context, suggestions),

          const SizedBox(height: AppSpacing.lg),

          // Context info
          _buildContextInfo(context, suggestions),

          const SizedBox(height: AppSpacing.lg),

          // AI suggestions section
          Text(
            context.l10n.wizard_aiSuggestions,
            style: AppTypography.title,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            context.l10n.wizard_chooseSuggestion,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Suggestion cards
          ...suggestions.suggestions.map((suggestion) {
            final isSelected = widget.selectedValue == suggestion.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: SuggestionOptionCard(
                suggestion: suggestion,
                isSelected: isSelected,
                onTap: () {
                  setState(() => _isCustomMode = false);
                  widget.onSelect(suggestion.value);
                },
              ),
            );
          }),

          const SizedBox(height: AppSpacing.md),

          // Custom input section
          _buildCustomInputSection(context, suggestions),

          const SizedBox(height: AppSpacing.lg),

          // Keep current button
          _buildKeepCurrentButton(context, suggestions),
        ],
      ),
    );
  }

  Widget _buildCurrentValueCard(
      BuildContext context, OptimizationResponse suggestions) {
    final currentValue = suggestions.currentValue;
    final isEmpty = currentValue.isEmpty;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.article_outlined,
                size: 20,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                context.l10n.wizard_currentValue,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              // Character count
              Text(
                '${currentValue.length}/${suggestions.characterLimit}',
                style: AppTypography.caption.copyWith(
                  color: currentValue.length > suggestions.characterLimit
                      ? AppColors.red
                      : AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            isEmpty ? context.l10n.wizard_noCurrentValue : currentValue,
            style: isEmpty
                ? AppTypography.body.copyWith(
                    color: AppColors.textMuted,
                    fontStyle: FontStyle.italic,
                  )
                : AppTypography.body,
          ),
        ],
      ),
    );
  }

  Widget _buildContextInfo(
      BuildContext context, OptimizationResponse suggestions) {
    final ctx = suggestions.context;

    if (ctx.trackedKeywordsCount == 0 && ctx.competitorsCount == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.accentMuted,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, size: 16, color: AppColors.accent),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              context.l10n.wizard_contextInfo(
                ctx.trackedKeywordsCount,
                ctx.competitorsCount,
              ),
              style: AppTypography.caption.copyWith(color: AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomInputSection(
      BuildContext context, OptimizationResponse suggestions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Write my own button/section
        InkWell(
          onTap: () => setState(() => _isCustomMode = !_isCustomMode),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: _isCustomMode ? AppColors.accent : AppColors.border,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.edit,
                  size: 18,
                  color: _isCustomMode ? AppColors.accent : AppColors.textMuted,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  context.l10n.wizard_writeOwn,
                  style: AppTypography.bodyMedium.copyWith(
                    color:
                        _isCustomMode ? AppColors.accent : AppColors.textMuted,
                  ),
                ),
                const Spacer(),
                Icon(
                  _isCustomMode
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),

        // Custom input field
        if (_isCustomMode) ...[
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _customController,
            maxLines: widget.field == 'description' ? 6 : 2,
            maxLength: suggestions.characterLimit,
            decoration: InputDecoration(
              hintText: context.l10n.wizard_customPlaceholder,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                widget.onSelect(value);
              }
            },
          ),
          const SizedBox(height: AppSpacing.xs),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.tonal(
              onPressed: _customController.text.isNotEmpty
                  ? () => widget.onSelect(_customController.text)
                  : null,
              child: Text(context.l10n.wizard_useCustom),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildKeepCurrentButton(
      BuildContext context, OptimizationResponse suggestions) {
    final currentValue = suggestions.currentValue;
    if (currentValue.isEmpty) return const SizedBox.shrink();

    final isSelected = widget.selectedValue == currentValue;

    return OutlinedButton.icon(
      onPressed: () {
        setState(() => _isCustomMode = false);
        widget.onSelect(currentValue);
      },
      icon: Icon(
        isSelected ? Icons.check_circle : Icons.history,
        size: 18,
      ),
      label: Text(context.l10n.wizard_keepCurrent),
      style: OutlinedButton.styleFrom(
        foregroundColor: isSelected ? AppColors.accent : null,
        side: BorderSide(
          color: isSelected ? AppColors.accent : AppColors.border,
        ),
      ),
    );
  }
}
