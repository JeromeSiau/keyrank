import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PlatformTabs extends StatelessWidget {
  final String selectedPlatform;
  final List<String> availablePlatforms;
  final ValueChanged<String> onPlatformChanged;

  const PlatformTabs({
    super.key,
    required this.selectedPlatform,
    required this.availablePlatforms,
    required this.onPlatformChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgActive,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        border: Border.all(color: AppColors.glassBorder),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: availablePlatforms.map((platform) {
          final isSelected = platform == selectedPlatform;
          return GestureDetector(
            onTap: () => onPlatformChanged(platform),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.glassPanel : Colors.transparent,
                borderRadius: BorderRadius.circular(AppColors.radiusSmall - 2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    platform == 'ios' ? '🍎' : '🤖',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    platform == 'ios' ? 'iOS' : 'Android',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? AppColors.textPrimary : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
