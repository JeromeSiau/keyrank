import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/alert_rule_model.dart';

class AlertRuleTile extends StatelessWidget {
  final AlertRuleModel rule;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AlertRuleTile({
    super.key,
    required this.rule,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  String _scopeLabel(String scopeType) {
    return switch (scopeType) {
      'global' => 'All apps',
      'app' => 'Specific app',
      'category' => 'Category',
      'keyword' => 'Keyword',
      _ => scopeType,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.accent : AppColorsLight.accent;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.glassPanelAlpha : AppColorsLight.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(
          color: isDark ? AppColors.glassBorder : AppColorsLight.glassBorder,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Switch.adaptive(
          value: rule.isActive,
          onChanged: (_) => onToggle(),
          activeTrackColor: accentColor,
        ),
        title: Text(
          rule.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: rule.isActive
                ? (isDark ? AppColors.textPrimary : AppColorsLight.textPrimary)
                : (isDark ? AppColors.textMuted : AppColorsLight.textMuted),
          ),
        ),
        subtitle: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: accentColor.withAlpha(20),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _scopeLabel(rule.scopeType),
                style: TextStyle(
                  fontSize: 10,
                  color: accentColor,
                ),
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert,
            color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
          ),
          onSelected: (value) {
            switch (value) {
              case 'edit':
                onEdit();
                break;
              case 'delete':
                onDelete();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(
              value: 'delete',
              child: Text('Delete', style: TextStyle(color: isDark ? AppColors.red : AppColorsLight.red)),
            ),
          ],
        ),
      ),
    );
  }
}
