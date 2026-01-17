import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/team_model.dart';

class PendingInvitationsCard extends StatelessWidget {
  final List<TeamInvitationModel> invitations;
  final bool isDark;
  final void Function(String token) onAccept;
  final void Function(String token) onDecline;

  const PendingInvitationsCard({
    super.key,
    required this.invitations,
    required this.isDark,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.accent : AppColorsLight.accent).withAlpha(15),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(
          color: (isDark ? AppColors.accent : AppColorsLight.accent).withAlpha(50),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.mail_outline,
                size: 20,
                color: isDark ? AppColors.accent : AppColorsLight.accent,
              ),
              const SizedBox(width: 8),
              Text(
                'PENDING INVITATIONS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: isDark ? AppColors.accent : AppColorsLight.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...invitations.map((invitation) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _InvitationTile(
              invitation: invitation,
              isDark: isDark,
              onAccept: () => onAccept(invitation.token),
              onDecline: () => onDecline(invitation.token),
            ),
          )),
        ],
      ),
    );
  }
}

class _InvitationTile extends StatelessWidget {
  final TeamInvitationModel invitation;
  final bool isDark;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _InvitationTile({
    required this.invitation,
    required this.isDark,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgBase : AppColorsLight.bgBase,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        border: Border.all(
          color: isDark ? AppColors.border : AppColorsLight.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Team icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.accent : AppColorsLight.accent).withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    invitation.team?.name.isNotEmpty == true
                        ? invitation.team!.name[0].toUpperCase()
                        : 'T',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.accent : AppColorsLight.accent,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Team info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invitation.team?.name ?? 'Team',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Invited by ${invitation.inviter.name} as ${invitation.teamRole.displayName}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onDecline,
                child: Text(
                  'Decline',
                  style: TextStyle(
                    color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: onAccept,
                style: FilledButton.styleFrom(
                  backgroundColor: isDark ? AppColors.accent : AppColorsLight.accent,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text('Accept'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
