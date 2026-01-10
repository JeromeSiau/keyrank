import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/alert_rule_model.dart';
import '../providers/alerts_provider.dart';
import 'widgets/builder_steps/type_step.dart';
import 'widgets/builder_steps/scope_step.dart';
import 'widgets/builder_steps/conditions_step.dart';
import 'widgets/builder_steps/name_step.dart';

/// Multi-step wizard for creating and editing custom alert rules
class AlertRuleBuilderScreen extends ConsumerStatefulWidget {
  final AlertRuleModel? existingRule;

  const AlertRuleBuilderScreen({super.key, this.existingRule});

  @override
  ConsumerState<AlertRuleBuilderScreen> createState() => _AlertRuleBuilderScreenState();
}

class _AlertRuleBuilderScreenState extends ConsumerState<AlertRuleBuilderScreen> {
  late PageController _pageController;
  int _currentStep = 0;
  bool _isSaving = false;

  // Form state
  String? _selectedType;
  String _scopeType = 'global';
  int? _scopeId;
  Map<String, dynamic> _conditions = {};
  String _name = '';

  bool get _isEditing => widget.existingRule != null;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Initialize from existing rule if editing
    if (widget.existingRule != null) {
      final rule = widget.existingRule!;
      _selectedType = rule.type;
      _scopeType = rule.scopeType;
      _scopeId = rule.scopeId;
      _conditions = Map<String, dynamic>.from(rule.conditions);
      _name = rule.name;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.pop();
    }
  }

  bool _canProceed() {
    return switch (_currentStep) {
      0 => _selectedType != null,
      1 => true, // Global scope is always valid
      2 => true, // Conditions can be empty (defaults used)
      3 => _name.trim().isNotEmpty,
      _ => false,
    };
  }

  Future<void> _save() async {
    if (_selectedType == null || _name.trim().isEmpty) return;

    setState(() => _isSaving = true);

    try {
      final notifier = ref.read(alertRulesNotifierProvider.notifier);

      if (_isEditing) {
        // Update existing rule
        await notifier.updateConditions(widget.existingRule!.id, _conditions);
      } else {
        // Create new rule
        await notifier.createCustomRule(
          name: _name.trim(),
          type: _selectedType!,
          scopeType: _scopeType,
          scopeId: _scopeId,
          conditions: _conditions,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? 'Rule updated!' : 'Rule created!'),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgBase : AppColorsLight.bgBase,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Alert Rule' : 'Create Alert Rule'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (_currentStep < 3 && _canProceed())
            TextButton(
              onPressed: _nextStep,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Next',
                    style: TextStyle(
                      color: isDark ? AppColors.accent : AppColorsLight.accent,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 18,
                    color: isDark ? AppColors.accent : AppColorsLight.accent,
                  ),
                ],
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Step indicator
          _StepIndicator(
            currentStep: _currentStep,
            totalSteps: 4,
          ),

          // Page content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (page) {
                setState(() => _currentStep = page);
              },
              children: [
                // Step 1: Type
                TypeStep(
                  selectedType: _selectedType,
                  onTypeSelected: (type) {
                    setState(() {
                      _selectedType = type;
                      // Initialize default conditions for the type
                      _conditions = _getDefaultConditions(type);
                    });
                  },
                ),

                // Step 2: Scope
                ScopeStep(
                  selectedScope: _scopeType,
                  scopeId: _scopeId,
                  onScopeSelected: (scope) {
                    setState(() => _scopeType = scope);
                  },
                  onScopeIdChanged: (id) {
                    setState(() => _scopeId = id);
                  },
                ),

                // Step 3: Conditions
                ConditionsStep(
                  alertType: _selectedType ?? 'position_change',
                  conditions: _conditions,
                  onConditionsChanged: (conditions) {
                    setState(() => _conditions = conditions);
                  },
                ),

                // Step 4: Name
                NameStep(
                  name: _name,
                  alertType: _selectedType ?? '',
                  scopeType: _scopeType,
                  onNameChanged: (name) {
                    setState(() => _name = name);
                  },
                  onSave: _save,
                  isSaving: _isSaving,
                ),
              ],
            ),
          ),

          // Bottom navigation
          if (_currentStep < 3)
            _BottomNavigation(
              currentStep: _currentStep,
              canProceed: _canProceed(),
              onBack: _previousStep,
              onNext: _nextStep,
            ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getDefaultConditions(String type) {
    return switch (type) {
      'position_change' => {'direction': 'any', 'threshold': 5},
      'rating_change' => {'direction': 'any', 'threshold': 0.5},
      'review_spike' => {'threshold_percent': 50},
      'review_keyword' => {'keywords': []},
      'new_competitor' => {},
      'competitor_passed' => {},
      'mass_movement' => {'threshold_percent': 20},
      'keyword_popularity' => {'direction': 'up', 'threshold': 10},
      'opportunity' => {'max_difficulty': 50},
      _ => {},
    };
  }
}

/// Step indicator showing progress through the wizard
class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _StepIndicator({
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.accent : AppColorsLight.accent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            children: List.generate(totalSteps, (index) {
              final isActive = index <= currentStep;

              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: isActive
                              ? accent
                              : (isDark ? AppColors.bgActive : AppColorsLight.bgActive),
                          borderRadius: index == 0
                              ? const BorderRadius.horizontal(left: Radius.circular(2))
                              : index == totalSteps - 1
                                  ? const BorderRadius.horizontal(right: Radius.circular(2))
                                  : null,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StepLabel(
                step: 1,
                label: 'Type',
                isActive: currentStep >= 0,
                isCurrent: currentStep == 0,
              ),
              _StepLabel(
                step: 2,
                label: 'Scope',
                isActive: currentStep >= 1,
                isCurrent: currentStep == 1,
              ),
              _StepLabel(
                step: 3,
                label: 'Conditions',
                isActive: currentStep >= 2,
                isCurrent: currentStep == 2,
              ),
              _StepLabel(
                step: 4,
                label: 'Save',
                isActive: currentStep >= 3,
                isCurrent: currentStep == 3,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepLabel extends StatelessWidget {
  final int step;
  final String label;
  final bool isActive;
  final bool isCurrent;

  const _StepLabel({
    required this.step,
    required this.label,
    required this.isActive,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.accent : AppColorsLight.accent;

    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isActive
                ? accent
                : (isDark ? AppColors.bgActive : AppColorsLight.bgActive),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$step',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive
                    ? Colors.white
                    : (isDark ? AppColors.textMuted : AppColorsLight.textMuted),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
            color: isActive
                ? (isDark ? AppColors.textPrimary : AppColorsLight.textPrimary)
                : (isDark ? AppColors.textMuted : AppColorsLight.textMuted),
          ),
        ),
      ],
    );
  }
}

/// Bottom navigation with back/next buttons
class _BottomNavigation extends StatelessWidget {
  final int currentStep;
  final bool canProceed;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const _BottomNavigation({
    required this.currentStep,
    required this.canProceed,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.accent : AppColorsLight.accent;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.glassPanelAlpha : AppColorsLight.glassPanelAlpha,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.glassBorder : AppColorsLight.glassBorder,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Back button
            OutlinedButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back, size: 18),
              label: Text(currentStep == 0 ? 'Cancel' : 'Back'),
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                side: BorderSide(
                  color: isDark ? AppColors.border : AppColorsLight.border,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(width: 12),
            // Next button
            Expanded(
              child: ElevatedButton(
                onPressed: canProceed ? onNext : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: accent.withAlpha(100),
                  disabledForegroundColor: Colors.white.withAlpha(150),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
