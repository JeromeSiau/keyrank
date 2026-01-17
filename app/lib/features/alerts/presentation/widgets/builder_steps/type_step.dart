import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/app_localizations.dart';

/// Alert type configuration with metadata for display
class AlertTypeConfig {
  final String type;
  final IconData icon;

  const AlertTypeConfig({
    required this.type,
    required this.icon,
  });

  String getLabel(AppLocalizations l10n) {
    return switch (type) {
      'position_change' => l10n.alertType_positionChange,
      'rating_change' => l10n.alertType_ratingChange,
      'review_spike' => l10n.alertType_reviewSpike,
      'review_keyword' => l10n.alertType_reviewKeyword,
      'new_competitor' => l10n.alertType_newCompetitor,
      'competitor_passed' => l10n.alertType_competitorPassed,
      'mass_movement' => l10n.alertType_massMovement,
      'keyword_popularity' => l10n.alertType_keywordTrend,
      'opportunity' => l10n.alertType_opportunity,
      _ => type,
    };
  }

  String getDescription(AppLocalizations l10n) {
    return switch (type) {
      'position_change' => l10n.alertType_positionChangeDesc,
      'rating_change' => l10n.alertType_ratingChangeDesc,
      'review_spike' => l10n.alertType_reviewSpikeDesc,
      'review_keyword' => l10n.alertType_reviewKeywordDesc,
      'new_competitor' => l10n.alertType_newCompetitorDesc,
      'competitor_passed' => l10n.alertType_competitorPassedDesc,
      'mass_movement' => l10n.alertType_massMovementDesc,
      'keyword_popularity' => l10n.alertType_keywordTrendDesc,
      'opportunity' => l10n.alertType_opportunityDesc,
      _ => '',
    };
  }
}

/// Available alert types for the builder
const alertTypes = [
  AlertTypeConfig(type: 'position_change', icon: Icons.trending_up),
  AlertTypeConfig(type: 'rating_change', icon: Icons.star),
  AlertTypeConfig(type: 'review_spike', icon: Icons.reviews),
  AlertTypeConfig(type: 'review_keyword', icon: Icons.search),
  AlertTypeConfig(type: 'new_competitor', icon: Icons.group_add),
  AlertTypeConfig(type: 'competitor_passed', icon: Icons.sports_martial_arts),
  AlertTypeConfig(type: 'mass_movement', icon: Icons.waves),
  AlertTypeConfig(type: 'keyword_popularity', icon: Icons.local_fire_department),
  AlertTypeConfig(type: 'opportunity', icon: Icons.diamond),
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
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.alertBuilder_selectAlertType,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.alertBuilder_selectAlertTypeDescription,
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
                  l10n: l10n,
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
  final AppLocalizations l10n;

  const _TypeTile({
    required this.config,
    required this.isSelected,
    required this.onTap,
    required this.l10n,
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
                        config.getLabel(l10n),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        config.getDescription(l10n),
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
