import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class UserMenu extends StatelessWidget {
  final String userName;
  final String userEmail;
  final VoidCallback onLogout;

  const UserMenu({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final _MenuColors colors = isDark ? _DarkColors() : _LightColors();

    final initials = userName.isNotEmpty
        ? userName.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
        : 'U';

    return PopupMenuButton<String>(
      offset: const Offset(0, -120),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        side: BorderSide(color: colors.border),
      ),
      color: colors.surface,
      onSelected: (value) {
        switch (value) {
          case 'settings':
            context.push('/settings');
            break;
          case 'logout':
            onLogout();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          enabled: false,
          height: 40,
          child: Text(
            userEmail,
            style: TextStyle(
              fontSize: 12,
              color: colors.textMuted,
            ),
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'settings',
          height: 44,
          child: Row(
            children: [
              Icon(Icons.settings_outlined, size: 18, color: colors.textSecondary),
              const SizedBox(width: 12),
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: 13,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'logout',
          height: 44,
          child: Row(
            children: [
              Icon(Icons.logout_rounded, size: 18, color: colors.textSecondary),
              const SizedBox(width: 12),
              Text(
                'Se déconnecter',
                style: TextStyle(
                  fontSize: 13,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
      child: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.bgActive,
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppColors.radiusMedium),
            hoverColor: colors.bgHover,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366f1), Color(0xFF8b5cf6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          userEmail,
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.textMuted,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.unfold_more,
                    size: 18,
                    color: colors.textMuted,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

abstract class _MenuColors {
  Color get textPrimary;
  Color get textSecondary;
  Color get textMuted;
  Color get bgActive;
  Color get bgHover;
  Color get surface;
  Color get border;
}

class _DarkColors implements _MenuColors {
  @override
  final Color textPrimary = AppColors.textPrimary;
  @override
  final Color textSecondary = AppColors.textSecondary;
  @override
  final Color textMuted = AppColors.textMuted;
  @override
  final Color bgActive = AppColors.bgActive.withAlpha(100);
  @override
  final Color bgHover = AppColors.bgHover;
  @override
  final Color surface = AppColors.bgSurface;
  @override
  final Color border = AppColors.glassBorder;
}

class _LightColors implements _MenuColors {
  @override
  final Color textPrimary = AppColorsLight.textPrimary;
  @override
  final Color textSecondary = AppColorsLight.textSecondary;
  @override
  final Color textMuted = AppColorsLight.textMuted;
  @override
  final Color bgActive = AppColorsLight.bgActive.withAlpha(200);
  @override
  final Color bgHover = AppColorsLight.bgHover;
  @override
  final Color surface = AppColorsLight.bgSurface;
  @override
  final Color border = AppColorsLight.glassBorder;
}
