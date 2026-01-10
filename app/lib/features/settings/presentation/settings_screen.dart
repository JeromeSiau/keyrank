import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../auth/providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final themeMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentLocale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgBase : AppColorsLight.bgBase,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.settings_title,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 32),

            // Language section
            _SectionCard(
              isDark: isDark,
              title: context.l10n.settings_language,
              child: _LanguageSelector(
                isDark: isDark,
                currentPreference: ref.watch(localePreferenceProvider),
                onChanged: (code) => ref.read(localeProvider.notifier).setLocale(code),
              ),
            ),

            const SizedBox(height: 16),

            // Appearance section
            _SectionCard(
              isDark: isDark,
              title: context.l10n.settings_appearance,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.settings_theme,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ThemeSelector(
                    isDark: isDark,
                    selectedMode: themeMode,
                    onChanged: (mode) {
                      ref.read(themeModeProvider.notifier).setThemeMode(mode);
                    },
                    systemLabel: context.l10n.settings_themeSystem,
                    darkLabel: context.l10n.settings_themeDark,
                    lightLabel: context.l10n.settings_themeLight,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Account section
            _SectionCard(
              isDark: isDark,
              title: context.l10n.settings_account,
              child: Column(
                children: [
                  _InfoRow(
                    isDark: isDark,
                    label: context.l10n.auth_emailLabel,
                    value: user?.email ?? '-',
                  ),
                  const SizedBox(height: 16),
                  _InfoRow(
                    isDark: isDark,
                    label: context.l10n.settings_memberSince,
                    value: user?.createdAt != null
                        ? DateFormat.yMMMMd(currentLocale).format(user!.createdAt)
                        : '-',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Logout button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ref.read(authStateProvider.notifier).logout();
                },
                icon: Icon(
                  Icons.logout_rounded,
                  color: isDark ? AppColors.red : AppColorsLight.red,
                ),
                label: Text(
                  context.l10n.settings_logout,
                  style: TextStyle(
                    color: isDark ? AppColors.red : AppColorsLight.red,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: isDark ? AppColors.red.withAlpha(100) : AppColorsLight.red.withAlpha(100),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final bool isDark;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.isDark,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.glassPanelAlpha : AppColorsLight.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(
          color: isDark ? AppColors.glassBorder : AppColorsLight.glassBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final bool isDark;
  final String label;
  final String value;

  const _InfoRow({
    required this.isDark,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  final bool isDark;
  final String currentPreference;
  final ValueChanged<String> onChanged;

  const _LanguageSelector({
    required this.isDark,
    required this.currentPreference,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final accent = isDark ? AppColors.accent : AppColorsLight.accent;
    final textPrimary = isDark ? AppColors.textPrimary : AppColorsLight.textPrimary;
    final bgColor = isDark ? AppColors.bgBase : AppColorsLight.bgBase;
    final borderColor = isDark ? AppColors.border : AppColorsLight.border;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        border: Border.all(color: borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentPreference,
          isExpanded: true,
          dropdownColor: bgColor,
          icon: Icon(Icons.keyboard_arrow_down, color: textPrimary),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
          items: localeNames.entries.map((entry) {
            final isSelected = entry.key == currentPreference;
            return DropdownMenuItem<String>(
              value: entry.key,
              child: Row(
                children: [
                  if (isSelected)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(Icons.check, size: 16, color: accent),
                    ),
                  Text(entry.value),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  final bool isDark;
  final ThemeMode selectedMode;
  final ValueChanged<ThemeMode> onChanged;
  final String systemLabel;
  final String darkLabel;
  final String lightLabel;

  const _ThemeSelector({
    required this.isDark,
    required this.selectedMode,
    required this.onChanged,
    required this.systemLabel,
    required this.darkLabel,
    required this.lightLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgBase : AppColorsLight.bgBase,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        border: Border.all(
          color: isDark ? AppColors.border : AppColorsLight.border,
        ),
      ),
      child: Row(
        children: [
          _ThemeOption(
            isDark: isDark,
            icon: Icons.brightness_auto,
            label: systemLabel,
            isSelected: selectedMode == ThemeMode.system,
            onTap: () => onChanged(ThemeMode.system),
            isFirst: true,
          ),
          _ThemeOption(
            isDark: isDark,
            icon: Icons.dark_mode,
            label: darkLabel,
            isSelected: selectedMode == ThemeMode.dark,
            onTap: () => onChanged(ThemeMode.dark),
          ),
          _ThemeOption(
            isDark: isDark,
            icon: Icons.light_mode,
            label: lightLabel,
            isSelected: selectedMode == ThemeMode.light,
            onTap: () => onChanged(ThemeMode.light),
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  const _ThemeOption({
    required this.isDark,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final accent = isDark ? AppColors.accent : AppColorsLight.accent;
    final textPrimary = isDark ? AppColors.textPrimary : AppColorsLight.textPrimary;
    final textMuted = isDark ? AppColors.textMuted : AppColorsLight.textMuted;

    return Expanded(
      child: Material(
        color: isSelected ? accent.withAlpha(25) : Colors.transparent,
        borderRadius: BorderRadius.horizontal(
          left: isFirst ? const Radius.circular(AppColors.radiusSmall - 1) : Radius.zero,
          right: isLast ? const Radius.circular(AppColors.radiusSmall - 1) : Radius.zero,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.horizontal(
            left: isFirst ? const Radius.circular(AppColors.radiusSmall - 1) : Radius.zero,
            right: isLast ? const Radius.circular(AppColors.radiusSmall - 1) : Radius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected ? accent : textMuted,
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? textPrimary : textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
