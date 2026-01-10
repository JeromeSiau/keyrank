import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

/// Alert type configuration with metadata for display
class AlertTypeConfig {
  final String type;
  final String label;
  final IconData icon;
  final String description;

  const AlertTypeConfig({
    required this.type,
    required this.label,
    required this.icon,
    required this.description,
  });
}

/// Available alert types for the builder
const alertTypes = [
  AlertTypeConfig(
    type: 'position_change',
    label: 'Position Change',
    icon: Icons.trending_up,
    description: 'Alert when app rank changes significantly',
  ),
  AlertTypeConfig(
    type: 'rating_change',
    label: 'Rating Change',
    icon: Icons.star,
    description: 'Alert when app rating changes',
  ),
  AlertTypeConfig(
    type: 'review_spike',
    label: 'Review Spike',
    icon: Icons.reviews,
    description: 'Alert on unusual review activity',
  ),
  AlertTypeConfig(
    type: 'review_keyword',
    label: 'Review Keyword',
    icon: Icons.search,
    description: 'Alert when keywords appear in reviews',
  ),
  AlertTypeConfig(
    type: 'new_competitor',
    label: 'New Competitor',
    icon: Icons.group_add,
    description: 'Alert when new apps enter your space',
  ),
  AlertTypeConfig(
    type: 'competitor_passed',
    label: 'Competitor Passed',
    icon: Icons.sports_martial_arts,
    description: 'Alert when you overtake a competitor',
  ),
  AlertTypeConfig(
    type: 'mass_movement',
    label: 'Mass Movement',
    icon: Icons.waves,
    description: 'Alert on large ranking shifts',
  ),
  AlertTypeConfig(
    type: 'keyword_popularity',
    label: 'Keyword Trend',
    icon: Icons.local_fire_department,
    description: 'Alert when keyword popularity changes',
  ),
  AlertTypeConfig(
    type: 'opportunity',
    label: 'Opportunity',
    icon: Icons.diamond,
    description: 'Alert on new ranking opportunities',
  ),
];

/// Step 1: Choose alert type
class TypeStep extends StatelessWidget {
  final String? selectedType;
  final ValueChanged<String> onTypeSelected;

  const TypeStep({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
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
            'SELECT ALERT TYPE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose what kind of alert you want to create',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: alertTypes.length,
              itemBuilder: (context, index) {
                final type = alertTypes[index];
                final isSelected = selectedType == type.type;
                return _TypeTile(
                  config: type,
                  isSelected: isSelected,
                  onTap: () => onTypeSelected(type.type),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeTile extends StatelessWidget {
  final AlertTypeConfig config;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeTile({
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
                      Text(
                        config.label,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                        ),
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
