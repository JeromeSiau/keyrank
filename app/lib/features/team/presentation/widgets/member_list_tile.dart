import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/team_model.dart';

class MemberListTile extends StatelessWidget {
  final TeamMemberModel member;
  final bool isDark;
  final bool isCurrentUser;
  final bool canManage;
  final VoidCallback? onChangeRole;
  final VoidCallback? onRemove;

  const MemberListTile({
    super.key,
    required this.member,
    required this.isDark,
    this.isCurrentUser = false,
    this.canManage = false,
    this.onChangeRole,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.glassPanelAlpha : AppColorsLight.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        border: Border.all(
          color: isDark ? AppColors.glassBorder : AppColorsLight.glassBorder,
        ),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: (isDark ? AppColors.accent : AppColorsLight.accent).withAlpha(25),
            child: Text(
              member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.accent : AppColorsLight.accent,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Member info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        member.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isCurrentUser) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: (isDark ? AppColors.accent : AppColorsLight.accent).withAlpha(25),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'You',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.accent : AppColorsLight.accent,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  member.email,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Role badge
          _RoleBadge(role: member.teamRole, isDark: isDark),

          // Actions
          if (canManage && !member.teamRole.isOwner) ...[
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
              ),
              onSelected: (value) {
                if (value == 'change_role') {
                  onChangeRole?.call();
                } else if (value == 'remove') {
                  onRemove?.call();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'change_role',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18),
                      SizedBox(width: 8),
                      Text('Change Role'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'remove',
                  child: Row(
                    children: [
                      Icon(Icons.person_remove, size: 18, color: Colors.red),
                      const SizedBox(width: 8),
                      const Text('Remove', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final TeamRole role;
  final bool isDark;

  const _RoleBadge({required this.role, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = _getRoleColor(role, isDark);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        role.displayName,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Color _getRoleColor(TeamRole role, bool isDark) {
    switch (role) {
      case TeamRole.owner:
        return isDark ? AppColors.orange : AppColorsLight.orange;
      case TeamRole.admin:
        return isDark ? AppColors.accent : AppColorsLight.accent;
      case TeamRole.editor:
        return isDark ? AppColors.green : AppColorsLight.green;
      case TeamRole.viewer:
        return isDark ? AppColors.textSecondary : AppColorsLight.textSecondary;
    }
  }
}
