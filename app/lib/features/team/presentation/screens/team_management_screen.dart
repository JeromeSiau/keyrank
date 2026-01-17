import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/team_model.dart';
import '../../providers/team_provider.dart';
import '../widgets/create_team_dialog.dart';
import '../widgets/pending_invitations_card.dart';

class TeamManagementScreen extends ConsumerWidget {
  const TeamManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamsAsync = ref.watch(teamsProvider);
    final myInvitationsAsync = ref.watch(myInvitationsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgBase : AppColorsLight.bgBase,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(teamsProvider);
          ref.invalidate(myInvitationsProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Team Management',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  FilledButton.icon(
                    onPressed: () => _showCreateTeamDialog(context, ref),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Create Team'),
                    style: FilledButton.styleFrom(
                      backgroundColor: isDark ? AppColors.accent : AppColorsLight.accent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Pending Invitations (for user)
              myInvitationsAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (invitations) {
                  if (invitations.isEmpty) return const SizedBox.shrink();
                  return Column(
                    children: [
                      PendingInvitationsCard(
                        invitations: invitations,
                        isDark: isDark,
                        onAccept: (token) => _acceptInvitation(context, ref, token),
                        onDecline: (token) => _declineInvitation(context, ref, token),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),

              // Teams list
              teamsAsync.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(48),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, _) => _ErrorCard(
                  isDark: isDark,
                  message: 'Failed to load teams',
                  onRetry: () => ref.invalidate(teamsProvider),
                ),
                data: (teams) {
                  if (teams.isEmpty) {
                    return _EmptyTeamsCard(
                      isDark: isDark,
                      onCreateTeam: () => _showCreateTeamDialog(context, ref),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'YOUR TEAMS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...teams.map((team) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _TeamCard(
                          team: team,
                          isDark: isDark,
                          onTap: () => context.push('/settings/team/${team.id}'),
                        ),
                      )),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showCreateTeamDialog(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const CreateTeamDialog(),
    );

    if (result == true) {
      ref.invalidate(teamsProvider);
    }
  }

  Future<void> _acceptInvitation(BuildContext context, WidgetRef ref, String token) async {
    final team = await ref.read(memberNotifierProvider.notifier).acceptInvitation(token);
    if (team != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Joined ${team.name}')),
      );
    }
  }

  Future<void> _declineInvitation(BuildContext context, WidgetRef ref, String token) async {
    final success = await ref.read(memberNotifierProvider.notifier).declineInvitation(token);
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invitation declined')),
      );
    }
  }
}

class _TeamCard extends StatelessWidget {
  final TeamModel team;
  final bool isDark;
  final VoidCallback onTap;

  const _TeamCard({
    required this.team,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark ? AppColors.glassPanelAlpha : AppColorsLight.glassPanelAlpha,
      borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppColors.radiusMedium),
            border: Border.all(
              color: isDark ? AppColors.glassBorder : AppColorsLight.glassBorder,
            ),
          ),
          child: Row(
            children: [
              // Team icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.accent : AppColorsLight.accent).withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    team.name.isNotEmpty ? team.name[0].toUpperCase() : 'T',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.accent : AppColorsLight.accent,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Team info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            team.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                            ),
                          ),
                        ),
                        _RoleBadge(role: team.role, isDark: isDark),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${team.membersCount} member${team.membersCount != 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Chevron
              Icon(
                Icons.chevron_right,
                color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
              ),
            ],
          ),
        ),
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

class _EmptyTeamsCard extends StatelessWidget {
  final bool isDark;
  final VoidCallback onCreateTeam;

  const _EmptyTeamsCard({required this.isDark, required this.onCreateTeam});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.glassPanelAlpha : AppColorsLight.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(
          color: isDark ? AppColors.glassBorder : AppColorsLight.glassBorder,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.group_outlined,
            size: 48,
            color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            'No Teams Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a team to collaborate with others on your apps',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onCreateTeam,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Create Your First Team'),
            style: FilledButton.styleFrom(
              backgroundColor: isDark ? AppColors.accent : AppColorsLight.accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final bool isDark;
  final String message;
  final VoidCallback onRetry;

  const _ErrorCard({
    required this.isDark,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.red : AppColorsLight.red).withAlpha(25),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(
          color: (isDark ? AppColors.red : AppColorsLight.red).withAlpha(50),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 32,
            color: isDark ? AppColors.red : AppColorsLight.red,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
