import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/alert_rule_model.dart';

class AlertTemplateCard extends StatelessWidget {
  final AlertTemplateModel template;
  final bool isActivated;
  final VoidCallback onActivate;

  const AlertTemplateCard({
    super.key,
    required this.template,
    required this.isActivated,
    required this.onActivate,
  });

  IconData _parseIcon(String iconStr) {
    return switch (iconStr) {
      'trending_down' => Icons.trending_down,
      'trending_up' => Icons.trending_up,
      'emoji_events' => Icons.emoji_events,
      'star_half' => Icons.star_half,
      'sentiment_very_dissatisfied' => Icons.sentiment_very_dissatisfied,
      'search' => Icons.search,
      'person_add' => Icons.person_add,
      'sports_martial_arts' => Icons.sports_martial_arts,
      'waves' => Icons.waves,
      'local_fire_department' => Icons.local_fire_department,
      'diamond' => Icons.diamond,
      _ => Icons.notifications,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.accent : AppColorsLight.accent;

    return Material(
      color: isDark ? AppColors.glassPanelAlpha : AppColorsLight.glassPanelAlpha,
      borderRadius: BorderRadius.circular(AppColors.radiusSmall),
      child: InkWell(
        onTap: isActivated ? null : onActivate,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
            border: Border.all(
              color: isActivated ? accentColor : (isDark ? AppColors.glassBorder : AppColorsLight.glassBorder),
              width: isActivated ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                _parseIcon(template.icon),
                color: isActivated ? accentColor : (isDark ? AppColors.textSecondary : AppColorsLight.textSecondary),
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  template.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isActivated)
                Icon(
                  Icons.check_circle,
                  color: accentColor,
                  size: 18,
                )
              else
                Icon(
                  Icons.add_circle_outline,
                  color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
