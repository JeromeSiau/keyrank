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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.glassPanelAlpha : AppColorsLight.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(
          color: isActivated ? accentColor : (isDark ? AppColors.glassBorder : AppColorsLight.glassBorder),
          width: isActivated ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _parseIcon(template.icon),
                color: isActivated ? accentColor : (isDark ? AppColors.textSecondary : AppColorsLight.textSecondary),
                size: 24,
              ),
              const Spacer(),
              if (isActivated)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Active',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: accentColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            template.name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            template.description,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: isActivated ? null : onActivate,
              style: OutlinedButton.styleFrom(
                foregroundColor: accentColor,
                side: BorderSide(color: accentColor.withAlpha(isActivated ? 50 : 150)),
              ),
              child: Text(isActivated ? 'Already active' : 'Activate'),
            ),
          ),
        ],
      ),
    );
  }
}
