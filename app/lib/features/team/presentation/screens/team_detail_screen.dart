import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../domain/team_model.dart';
import '../../providers/team_provider.dart';
import '../widgets/invite_member_dialog.dart';
import '../widgets/member_list_tile.dart';

class TeamDetailScreen extends ConsumerWidget {
  final int teamId;

  const TeamDetailScreen({super.key, required this.teamId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamAsync = ref.watch(teamProvider(teamId));
    final membersAsync = ref.watch(teamMembersProvider(teamId));
    final invitationsAsync = ref.watch(teamInvitationsProvider(teamId));
    final currentUser = ref.watch(authStateProvider).valueOrNull;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgBase : AppColorsLight.bgBase,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        title: teamAsync.when(
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Team'),
          data: (team) => Text(team.name),
        ),
        actions: teamAsync.when(
          loading: () => [],
          error: (_, __) => [],
          data: (team) => [
            if (team.role.canManageTeam)
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => _showTeamSettings(context, ref, team),
              ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(teamProvider(teamId));
          ref.invalidate(teamMembersProvider(teamId));
          ref.invalidate(teamInvitationsProvider(teamId));
        },
        child: teamAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: isDark ? AppColors.red : AppColorsLight.red,
                ),
                const SizedBox(height: 16),
                Text('Failed to load team'),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => ref.invalidate(teamProvider(teamId)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (team) => SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Team Info Card
                _TeamInfoCard(team: team, isDark: isDark),
                const SizedBox(height: 24),

                // Members Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'MEMBERS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                      ),
                    ),
                    if (team.role.canInviteMembers)
                      TextButton.icon(
                        onPressed: () => _showInviteDialog(context, ref),
                        icon: const Icon(Icons.person_add, size: 18),
                        label: const Text('Invite'),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                membersAsync.when(
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (_, __) => const Text('Failed to load members'),
                  data: (members) => Column(
                    children: members.map((member) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: MemberListTile(
                        member: member,
                        isDark: isDark,
                        isCurrentUser: member.id == currentUser?.id,
                        canManage: team.role.canManageTeam,
                        onChangeRole: () => _showChangeRoleDialog(context, ref, team, member),
                        onRemove: () => _confirmRemoveMember(context, ref, member),
                      ),
                    )).toList(),
                  ),
                ),

                // Pending Invitations Section
                if (team.role.canManageTeam) ...[
                  const SizedBox(height: 24),
                  Text(
                    'PENDING INVITATIONS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                    ),
                  ),
                  const SizedBox(height: 12),

                  invitationsAsync.when(
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (_, __) => const Text('Failed to load invitations'),
                    data: (invitations) {
                      if (invitations.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.glassPanelAlpha : AppColorsLight.glassPanelAlpha,
                            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                            border: Border.all(
                              color: isDark ? AppColors.glassBorder : AppColorsLight.glassBorder,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.mail_outline,
                                size: 20,
                                color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'No pending invitations',
                                style: TextStyle(
                                  color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Column(
                        children: invitations.map((inv) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _InvitationTile(
                            invitation: inv,
                            isDark: isDark,
                            onCancel: () => _cancelInvitation(context, ref, inv),
                          ),
                        )).toList(),
                      );
                    },
                  ),
                ],

                // Leave/Delete Team
                const SizedBox(height: 32),
                if (!team.role.isOwner)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _confirmLeaveTeam(context, ref, team),
                      icon: Icon(
                        Icons.exit_to_app,
                        color: isDark ? AppColors.red : AppColorsLight.red,
                      ),
                      label: Text(
                        'Leave Team',
                        style: TextStyle(
                          color: isDark ? AppColors.red : AppColorsLight.red,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: (isDark ? AppColors.red : AppColorsLight.red).withAlpha(100),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                if (team.role.isOwner)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _confirmDeleteTeam(context, ref, team),
                      icon: Icon(
                        Icons.delete_forever,
                        color: isDark ? AppColors.red : AppColorsLight.red,
                      ),
                      label: Text(
                        'Delete Team',
                        style: TextStyle(
                          color: isDark ? AppColors.red : AppColorsLight.red,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: (isDark ? AppColors.red : AppColorsLight.red).withAlpha(100),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showInviteDialog(BuildContext context, WidgetRef ref) async {
    await showDialog(
      context: context,
      builder: (context) => InviteMemberDialog(teamId: teamId),
    );
  }

  Future<void> _showTeamSettings(BuildContext context, WidgetRef ref, TeamModel team) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nameController = TextEditingController(text: team.name);
    final descriptionController = TextEditingController(text: team.description ?? '');

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.bgSurface : AppColorsLight.bgSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        ),
        title: Text(
          'Team Settings',
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
          ),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Team Name',
                  labelStyle: TextStyle(
                    color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                  ),
                ),
                style: TextStyle(
                  color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description (optional)',
                  labelStyle: TextStyle(
                    color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                  ),
                ),
                style: TextStyle(
                  color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: isDark ? AppColors.accent : AppColorsLight.accent,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result == true) {
      final updatedTeam = await ref.read(teamNotifierProvider.notifier).updateTeam(
        teamId,
        name: nameController.text.trim(),
        description: descriptionController.text.trim().isEmpty
            ? null
            : descriptionController.text.trim(),
      );

      if (updatedTeam != null) {
        ref.invalidate(teamProvider(teamId));
      }
    }

    nameController.dispose();
    descriptionController.dispose();
  }

  Future<void> _showChangeRoleDialog(
    BuildContext context,
    WidgetRef ref,
    TeamModel team,
    TeamMemberModel member,
  ) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    TeamRole? newRole = member.teamRole;

    final result = await showDialog<TeamRole>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.bgSurface : AppColorsLight.bgSurface,
        title: Text('Change Role for ${member.name}'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: TeamRole.values
                .where((role) => role != TeamRole.owner)
                .map((role) => RadioListTile<TeamRole>(
                      title: Text(role.displayName),
                      subtitle: Text(role.description, style: const TextStyle(fontSize: 12)),
                      value: role,
                      groupValue: newRole,
                      onChanged: (value) => setState(() => newRole = value),
                    ))
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(newRole),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null && result != member.teamRole) {
      await ref.read(memberNotifierProvider.notifier).updateMemberRole(
        teamId,
        member.id,
        result.name,
      );
    }
  }

  Future<void> _confirmRemoveMember(
    BuildContext context,
    WidgetRef ref,
    TeamMemberModel member,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Member'),
        content: Text('Are you sure you want to remove ${member.name} from this team?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(memberNotifierProvider.notifier).removeMember(teamId, member.id);
    }
  }

  Future<void> _cancelInvitation(
    BuildContext context,
    WidgetRef ref,
    TeamInvitationModel invitation,
  ) async {
    await ref.read(memberNotifierProvider.notifier).cancelInvitation(teamId, invitation.id);
  }

  Future<void> _confirmLeaveTeam(BuildContext context, WidgetRef ref, TeamModel team) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Team'),
        content: Text('Are you sure you want to leave "${team.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Leave'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await ref.read(teamNotifierProvider.notifier).leaveTeam(teamId);
      if (success && context.mounted) {
        context.pop();
      }
    }
  }

  Future<void> _confirmDeleteTeam(BuildContext context, WidgetRef ref, TeamModel team) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Team'),
        content: Text(
          'Are you sure you want to delete "${team.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await ref.read(teamNotifierProvider.notifier).deleteTeam(teamId);
      if (success && context.mounted) {
        context.pop();
      }
    }
  }
}

class _TeamInfoCard extends StatelessWidget {
  final TeamModel team;
  final bool isDark;

  const _TeamInfoCard({required this.team, required this.isDark});

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
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.accent : AppColorsLight.accent).withAlpha(25),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    team.name.isNotEmpty ? team.name[0].toUpperCase() : 'T',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.accent : AppColorsLight.accent,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      team.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${team.membersCount} member${team.membersCount != 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (team.description != null && team.description!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              team.description!,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InvitationTile extends StatelessWidget {
  final TeamInvitationModel invitation;
  final bool isDark;
  final VoidCallback onCancel;

  const _InvitationTile({
    required this.invitation,
    required this.isDark,
    required this.onCancel,
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
          Icon(
            Icons.mail_outline,
            size: 20,
            color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invitation.email,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                  ),
                ),
                Text(
                  'Invited as ${invitation.teamRole.displayName}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onCancel,
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark ? AppColors.red : AppColorsLight.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
