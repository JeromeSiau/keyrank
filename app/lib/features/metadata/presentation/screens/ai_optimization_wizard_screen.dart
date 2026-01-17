import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../domain/optimization_model.dart';
import '../../providers/metadata_provider.dart';
import '../widgets/optimization_step_content.dart';
import '../widgets/wizard_review_step.dart';

class AiOptimizationWizardScreen extends ConsumerStatefulWidget {
  final int appId;
  final String appName;
  final String locale;
  final String platform;

  const AiOptimizationWizardScreen({
    super.key,
    required this.appId,
    required this.appName,
    required this.locale,
    required this.platform,
  });

  @override
  ConsumerState<AiOptimizationWizardScreen> createState() =>
      _AiOptimizationWizardScreenState();
}

class _AiOptimizationWizardScreenState
    extends ConsumerState<AiOptimizationWizardScreen> {
  late WizardParams _wizardParams;

  @override
  void initState() {
    super.initState();
    _wizardParams = WizardParams(
      appId: widget.appId,
      locale: widget.locale,
      platform: widget.platform,
    );
  }

  @override
  Widget build(BuildContext context) {
    final wizardState = ref.watch(optimizationWizardProvider(_wizardParams));
    final wizardNotifier =
        ref.read(optimizationWizardProvider(_wizardParams).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.wizard_title),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showExitConfirmation(context),
        ),
      ),
      body: Column(
        children: [
          // Progress indicator
          _buildProgressHeader(context, wizardState),

          // Step content
          Expanded(
            child: wizardState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : wizardState.error != null
                    ? _buildError(context, wizardState.error!, wizardNotifier)
                    : _buildStepContent(context, wizardState, wizardNotifier),
          ),

          // Navigation buttons
          _buildNavigationBar(context, wizardState, wizardNotifier),
        ],
      ),
    );
  }

  Widget _buildProgressHeader(BuildContext context, WizardState state) {
    final steps = WizardStep.forPlatform(widget.platform);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Column(
        children: [
          // Step indicator
          Row(
            children: [
              for (int i = 0; i < steps.length; i++) ...[
                if (i > 0) Expanded(child: _buildStepConnector(i, state)),
                _buildStepIndicator(i, steps[i], state),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // Step label
          Text(
            '${context.l10n.wizard_step} ${state.currentStepNumber} ${context.l10n.wizard_of} ${state.totalSteps}: ${_getStepLabel(context, state.currentStep)}',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int index, WizardStep step, WizardState state) {
    final steps = WizardStep.forPlatform(widget.platform);
    final currentIndex = steps.indexOf(state.currentStep);
    final isCompleted = index < currentIndex;
    final isCurrent = index == currentIndex;
    final isSelected = state.selectedValues.containsKey(step.field);

    return GestureDetector(
      onTap: isCompleted
          ? () => ref
              .read(optimizationWizardProvider(_wizardParams).notifier)
              .goToStep(step)
          : null,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCompleted || isCurrent
              ? AppColors.accent
              : AppColors.border,
          border: isCurrent
              ? Border.all(color: AppColors.accent, width: 2)
              : null,
        ),
        child: Center(
          child: isCompleted
              ? Icon(
                  isSelected ? Icons.check : Icons.skip_next,
                  size: 16,
                  color: Colors.white,
                )
              : Text(
                  '${index + 1}',
                  style: AppTypography.caption.copyWith(
                    color: isCurrent ? Colors.white : AppColors.textSecondary,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildStepConnector(int index, WizardState state) {
    final steps = WizardStep.forPlatform(widget.platform);
    final currentIndex = steps.indexOf(state.currentStep);
    final isCompleted = index <= currentIndex;

    return Container(
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: isCompleted ? AppColors.accent : AppColors.border,
    );
  }

  String _getStepLabel(BuildContext context, WizardStep step) {
    switch (step) {
      case WizardStep.title:
        return context.l10n.wizard_stepTitle;
      case WizardStep.subtitle:
        return context.l10n.wizard_stepSubtitle;
      case WizardStep.keywords:
        return context.l10n.wizard_stepKeywords;
      case WizardStep.description:
        return context.l10n.wizard_stepDescription;
      case WizardStep.review:
        return context.l10n.wizard_stepReview;
    }
  }

  Widget _buildError(
    BuildContext context,
    String error,
    OptimizationWizardNotifier notifier,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.red),
            const SizedBox(height: AppSpacing.md),
            Text(
              error,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: () => notifier.loadSuggestionsForCurrentStep(),
              child: Text(context.l10n.common_retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(
    BuildContext context,
    WizardState state,
    OptimizationWizardNotifier notifier,
  ) {
    if (state.currentStep == WizardStep.review) {
      return WizardReviewStep(
        selectedValues: state.selectedValues,
        suggestions: state.suggestions,
        locale: widget.locale,
        onEdit: (step) => notifier.goToStep(step),
      );
    }

    return OptimizationStepContent(
      appId: widget.appId,
      locale: widget.locale,
      field: state.currentStep.field,
      suggestions: state.suggestions[state.currentStep.field],
      selectedValue: state.selectedValues[state.currentStep.field],
      onSelect: (value) => notifier.selectValue(state.currentStep.field, value),
      onLoadSuggestions: () => notifier.loadSuggestionsForCurrentStep(),
    );
  }

  Widget _buildNavigationBar(
    BuildContext context,
    WizardState state,
    OptimizationWizardNotifier notifier,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Back button
            if (state.canGoBack)
              OutlinedButton.icon(
                onPressed: () => notifier.previousStep(),
                icon: const Icon(Icons.arrow_back),
                label: Text(context.l10n.common_back),
              )
            else
              const SizedBox(width: 100),

            const Spacer(),

            // Skip button (for non-review steps)
            if (state.currentStep != WizardStep.review &&
                !state.selectedValues.containsKey(state.currentStep.field))
              TextButton(
                onPressed: () => notifier.nextStep(),
                child: Text(context.l10n.wizard_skip),
              ),

            const SizedBox(width: AppSpacing.sm),

            // Next/Finish button
            if (state.currentStep == WizardStep.review)
              FilledButton.icon(
                onPressed: state.selectedValues.isEmpty
                    ? null
                    : () => _saveAndPublish(context, notifier),
                icon: const Icon(Icons.save),
                label: Text(context.l10n.wizard_saveDrafts),
              )
            else
              FilledButton.icon(
                onPressed: () => notifier.nextStep(),
                icon: const Icon(Icons.arrow_forward),
                label: Text(context.l10n.common_next),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveAndPublish(
    BuildContext context,
    OptimizationWizardNotifier notifier,
  ) async {
    final success = await notifier.saveAllDrafts();

    if (success && mounted) {
      // Invalidate metadata to refresh
      ref.invalidate(appMetadataProvider(widget.appId));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.wizard_draftsSaved),
          backgroundColor: AppColors.green,
        ),
      );

      context.pop(true); // Return true to indicate changes were made
    }
  }

  Future<void> _showExitConfirmation(BuildContext context) async {
    final wizardState = ref.read(optimizationWizardProvider(_wizardParams));

    // If no changes, just exit
    if (wizardState.selectedValues.isEmpty) {
      context.pop(false);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.wizard_exitTitle),
        content: Text(context.l10n.wizard_exitMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.l10n.common_cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.l10n.wizard_exitConfirm),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      context.pop(false);
    }
  }
}
