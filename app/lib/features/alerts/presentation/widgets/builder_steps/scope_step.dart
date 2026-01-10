import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

/// Scope configuration with metadata for display
class ScopeConfig {
  final String type;
  final String label;
  final IconData icon;
  final String description;
  final bool requiresSelection;

  const ScopeConfig({
    required this.type,
    required this.label,
    required this.icon,
    required this.description,
    this.requiresSelection = false,
  });
}

/// Available scope types for alerts
const scopeOptions = [
  ScopeConfig(
    type: 'global',
    label: 'All Apps',
    icon: Icons.public,
    description: 'Monitor all your tracked apps',
  ),
  ScopeConfig(
    type: 'app',
    label: 'Specific App',
    icon: Icons.apps,
    description: 'Monitor a single app',
    requiresSelection: true,
  ),
  ScopeConfig(
    type: 'category',
    label: 'Category',
    icon: Icons.category,
    description: 'Monitor apps in a category',
    requiresSelection: true,
  ),
  ScopeConfig(
    type: 'keyword',
    label: 'Keyword',
    icon: Icons.key,
    description: 'Monitor a specific keyword',
    requiresSelection: true,
  ),
];

/// Step 2: Choose scope (global, app, category, keyword)
class ScopeStep extends StatelessWidget {
  final String selectedScope;
  final int? scopeId;
  final ValueChanged<String> onScopeSelected;
  final ValueChanged<int?> onScopeIdChanged;

  const ScopeStep({
    super.key,
    required this.selectedScope,
    required this.scopeId,
    required this.onScopeSelected,
    required this.onScopeIdChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SELECT SCOPE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose what this alert applies to',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: scopeOptions.length,
              itemBuilder: (context, index) {
                final scope = scopeOptions[index];
                final isSelected = selectedScope == scope.type;
                return _ScopeTile(
                  config: scope,
                  isSelected: isSelected,
                  onTap: () {
                    onScopeSelected(scope.type);
                    // Reset scope ID when switching scope types
                    if (!scope.requiresSelection) {
                      onScopeIdChanged(null);
                    }
                  },
                );
              },
            ),
          ),
          // Show picker placeholder for non-global scopes
          if (selectedScope != 'global') ...[
            const SizedBox(height: 16),
            _ScopeSelectionPlaceholder(
              scopeType: selectedScope,
              scopeId: scopeId,
              onSelect: onScopeIdChanged,
            ),
          ],
        ],
      ),
    );
  }
}

class _ScopeTile extends StatelessWidget {
  final ScopeConfig config;
  final bool isSelected;
  final VoidCallback onTap;

  const _ScopeTile({
    required this.config,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.accent : AppColorsLight.accent;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isSelected
            ? accentColor.withAlpha(25)
            : (isDark ? AppColors.glassPanelAlpha : AppColorsLight.glassPanelAlpha),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppColors.radiusMedium),
              border: Border.all(
                color: isSelected
                    ? accentColor
                    : (isDark ? AppColors.glassBorder : AppColorsLight.glassBorder),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? accentColor.withAlpha(30)
                        : (isDark ? AppColors.bgActive : AppColorsLight.bgActive),
                    borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                  ),
                  child: Icon(
                    config.icon,
                    color: isSelected
                        ? accentColor
                        : (isDark ? AppColors.textSecondary : AppColorsLight.textSecondary),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            config.label,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                            ),
                          ),
                          if (config.requiresSelection) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: (isDark ? AppColors.yellow : AppColorsLight.yellow).withAlpha(30),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'TODO',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.yellow : AppColorsLight.yellow,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        config.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: accentColor,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Placeholder for app/category/keyword picker
/// TODO: Implement actual pickers for each scope type
class _ScopeSelectionPlaceholder extends StatelessWidget {
  final String scopeType;
  final int? scopeId;
  final ValueChanged<int?> onSelect;

  const _ScopeSelectionPlaceholder({
    required this.scopeType,
    required this.scopeId,
    required this.onSelect,
  });

  String get _label {
    return switch (scopeType) {
      'app' => 'Select an app',
      'category' => 'Select a category',
      'keyword' => 'Select a keyword',
      _ => 'Select',
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgPanel : AppColorsLight.bgPanel,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(
          color: isDark ? AppColors.border : AppColorsLight.border,
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Picker not yet implemented. For now, use global scope.',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
