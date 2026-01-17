import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/metadata_model.dart';

class MetadataLocaleList extends StatelessWidget {
  final List<MetadataLocale> locales;
  final String? selectedLocale;
  final ValueChanged<String> onLocaleSelected;

  const MetadataLocaleList({
    super.key,
    required this.locales,
    this.selectedLocale,
    required this.onLocaleSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (locales.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.language, size: 48, color: AppColors.textMuted),
              const SizedBox(height: AppSpacing.md),
              Text(
                'No locales available',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      itemCount: locales.length,
      itemBuilder: (context, index) {
        final locale = locales[index];
        final isSelected = locale.locale == selectedLocale;

        return _LocaleTile(
          locale: locale,
          isSelected: isSelected,
          onTap: () => onLocaleSelected(locale.locale),
        );
      },
    );
  }
}

class _LocaleTile extends StatelessWidget {
  final MetadataLocale locale;
  final bool isSelected;
  final VoidCallback onTap;

  const _LocaleTile({
    required this.locale,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.accentMuted : Colors.transparent,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        border: isSelected
            ? Border.all(color: AppColors.accent.withOpacity(0.3))
            : null,
      ),
      child: ListTile(
        onTap: onTap,
        leading: _buildLocaleFlag(locale.locale),
        title: Text(
          _getLocaleName(locale.locale),
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          locale.locale,
          style: AppTypography.caption.copyWith(
            color: AppColors.textMuted,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (locale.hasDraft)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.yellowBright.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Draft',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.yellowBright,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            const SizedBox(width: AppSpacing.xs),
            _buildCompletionIndicator(locale.completionPercentage),
          ],
        ),
      ),
    );
  }

  Widget _buildLocaleFlag(String locale) {
    // Simple flag emoji based on locale code
    final countryCode = locale.contains('-')
        ? locale.split('-').last.toUpperCase()
        : locale.toUpperCase();

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.bgHover,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          _countryCodeToEmoji(countryCode),
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  String _countryCodeToEmoji(String countryCode) {
    // Convert country code to flag emoji
    if (countryCode.length != 2) return '🌐';

    final firstLetter = countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final secondLetter = countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;

    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }

  Widget _buildCompletionIndicator(int percentage) {
    Color color;
    if (percentage >= 100) {
      color = AppColors.green;
    } else if (percentage >= 50) {
      color = AppColors.yellow;
    } else {
      color = AppColors.red;
    }

    return SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: percentage / 100,
            strokeWidth: 3,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation(color),
          ),
          if (percentage >= 100)
            Icon(Icons.check, size: 12, color: color),
        ],
      ),
    );
  }

  String _getLocaleName(String locale) {
    // Common locale names
    const localeNames = {
      'en-US': 'English (US)',
      'en-GB': 'English (UK)',
      'en-AU': 'English (Australia)',
      'en-CA': 'English (Canada)',
      'fr-FR': 'French',
      'fr-CA': 'French (Canada)',
      'de-DE': 'German',
      'es-ES': 'Spanish (Spain)',
      'es-MX': 'Spanish (Mexico)',
      'it-IT': 'Italian',
      'pt-BR': 'Portuguese (Brazil)',
      'pt-PT': 'Portuguese (Portugal)',
      'ja-JP': 'Japanese',
      'ko-KR': 'Korean',
      'zh-Hans': 'Chinese (Simplified)',
      'zh-Hant': 'Chinese (Traditional)',
      'zh-CN': 'Chinese (Simplified)',
      'zh-TW': 'Chinese (Traditional)',
      'ru-RU': 'Russian',
      'ar-SA': 'Arabic',
      'nl-NL': 'Dutch',
      'sv-SE': 'Swedish',
      'da-DK': 'Danish',
      'fi-FI': 'Finnish',
      'no-NO': 'Norwegian',
      'pl-PL': 'Polish',
      'tr-TR': 'Turkish',
      'th-TH': 'Thai',
      'vi-VN': 'Vietnamese',
      'id-ID': 'Indonesian',
      'ms-MY': 'Malay',
      'hi-IN': 'Hindi',
      'he-IL': 'Hebrew',
      'cs-CZ': 'Czech',
      'el-GR': 'Greek',
      'hu-HU': 'Hungarian',
      'ro-RO': 'Romanian',
      'sk-SK': 'Slovak',
      'uk-UA': 'Ukrainian',
    };

    return localeNames[locale] ?? locale;
  }
}
