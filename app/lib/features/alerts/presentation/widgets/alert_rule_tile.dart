import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/l10n_extension.dart';
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

  String _scopeLabel(BuildContext context, String scopeType) {
    return switch (scopeType) {
      'global' => context.l10n.alerts_scopeGlobal,
      'app' => context.l10n.alerts_scopeApp,
      'category' => context.l10n.alerts_scopeCategory,
      'keyword' => context.l10n.alerts_scopeKeyword,
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
                _scopeLabel(context, rule.scopeType),
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
            PopupMenuItem(value: 'edit', child: Text(context.l10n.alerts_edit)),
            PopupMenuItem(
              value: 'delete',
              child: Text(context.l10n.common_delete, style: TextStyle(color: isDark ? AppColors.red : AppColorsLight.red)),
            ),
          ],
        ),
      ),
    );
  }
}
