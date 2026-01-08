import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final themeMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgBase : AppColorsLight.bgBase,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 32),

            // Appearance section
            _SectionCard(
              isDark: isDark,
              title: 'Apparence',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thème',
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
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Account section
            _SectionCard(
              isDark: isDark,
              title: 'Compte',
              child: Column(
                children: [
                  _InfoRow(
                    isDark: isDark,
                    label: 'Email',
                    value: user?.email ?? '-',
                  ),
                  const SizedBox(height: 16),
                  _InfoRow(
                    isDark: isDark,
                    label: 'Membre depuis',
                    value: user?.createdAt != null
                        ? DateFormat.yMMMMd('fr_FR').format(user!.createdAt)
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
                  'Se déconnecter',
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

class _ThemeSelector extends StatelessWidget {
  final bool isDark;
  final ThemeMode selectedMode;
  final ValueChanged<ThemeMode> onChanged;

  const _ThemeSelector({
    required this.isDark,
    required this.selectedMode,
    required this.onChanged,
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
            label: 'Système',
            isSelected: selectedMode == ThemeMode.system,
            onTap: () => onChanged(ThemeMode.system),
            isFirst: true,
          ),
          _ThemeOption(
            isDark: isDark,
            icon: Icons.dark_mode,
            label: 'Sombre',
            isSelected: selectedMode == ThemeMode.dark,
            onTap: () => onChanged(ThemeMode.dark),
          ),
          _ThemeOption(
            isDark: isDark,
            icon: Icons.light_mode,
            label: 'Clair',
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
