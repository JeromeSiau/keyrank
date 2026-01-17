import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../alerts/providers/alerts_provider.dart';
import '../../apps/providers/apps_provider.dart';
import '../../competitors/providers/competitors_provider.dart';
import '../../dashboard/providers/dashboard_providers.dart';
import '../../insights/providers/global_insights_provider.dart';
import '../../keywords/providers/global_keywords_provider.dart';
import '../../tags/providers/tags_provider.dart';
import '../data/team_repository.dart';
import '../domain/team_model.dart';

/// Repository provider
final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return TeamRepository(dio);
});

/// Teams list provider
final teamsProvider = FutureProvider<List<TeamModel>>((ref) async {
  final repository = ref.watch(teamRepositoryProvider);
  return repository.getTeams();
});

/// Single team provider
final teamProvider = FutureProvider.family<TeamModel, int>((ref, teamId) async {
  final repository = ref.watch(teamRepositoryProvider);
  return repository.getTeam(teamId);
});

/// Team members provider
final teamMembersProvider = FutureProvider.family<List<TeamMemberModel>, int>((ref, teamId) async {
  final repository = ref.watch(teamRepositoryProvider);
  return repository.getMembers(teamId);
});

/// Team invitations provider (for team management)
final teamInvitationsProvider = FutureProvider.family<List<TeamInvitationModel>, int>((ref, teamId) async {
  final repository = ref.watch(teamRepositoryProvider);
  return repository.getTeamInvitations(teamId);
});

/// My pending invitations provider (for user)
final myInvitationsProvider = FutureProvider<List<TeamInvitationModel>>((ref) async {
  final repository = ref.watch(teamRepositoryProvider);
  return repository.getMyInvitations();
});

/// Current/selected team provider
final currentTeamIdProvider = StateProvider<int?>((ref) => null);

/// Current team data provider
final currentTeamProvider = Provider<AsyncValue<TeamModel?>>((ref) {
  final teamId = ref.watch(currentTeamIdProvider);
  if (teamId == null) {
    return const AsyncValue.data(null);
  }
  return ref.watch(teamProvider(teamId));
});

/// Team management notifier for CRUD operations
class TeamNotifier extends StateNotifier<AsyncValue<void>> {
  final TeamRepository _repository;
  final Ref _ref;

  TeamNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  /// Create a new team
  Future<TeamModel?> createTeam({
    required String name,
    String? description,
  }) async {
    state = const AsyncValue.loading();
    try {
      final team = await _repository.createTeam(
        name: name,
        description: description,
      );
      _ref.invalidate(teamsProvider);
      state = const AsyncValue.data(null);
      return team;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Update team
  Future<TeamModel?> updateTeam(int teamId, {String? name, String? description}) async {
    state = const AsyncValue.loading();
    try {
      final team = await _repository.updateTeam(teamId, name: name, description: description);
      _ref.invalidate(teamsProvider);
      _ref.invalidate(teamProvider(teamId));
      state = const AsyncValue.data(null);
      return team;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Delete team
  Future<bool> deleteTeam(int teamId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteTeam(teamId);
      _ref.invalidate(teamsProvider);

      // Clear current team if it was deleted
      final currentTeamId = _ref.read(currentTeamIdProvider);
      if (currentTeamId == teamId) {
        _ref.read(currentTeamIdProvider.notifier).state = null;
      }

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Switch to a different team
  Future<TeamModel?> switchTeam(int teamId) async {
    state = const AsyncValue.loading();
    try {
      final team = await _repository.switchTeam(teamId);
      _ref.read(currentTeamIdProvider.notifier).state = teamId;

      // Invalidate all team-dependent providers
      _ref.invalidate(myAppsProvider);
      _ref.invalidate(appsNotifierProvider);
      _ref.invalidate(competitorsProvider);
      _ref.invalidate(tagsProvider);
      _ref.invalidate(tagsNotifierProvider);
      _ref.invalidate(alertTemplatesProvider);
      _ref.invalidate(alertRulesNotifierProvider);
      _ref.invalidate(globalInsightsProvider);
      _ref.invalidate(globalKeywordsProvider);
      _ref.invalidate(heroMetricsProvider);
      _ref.invalidate(currentMoversProvider);

      state = const AsyncValue.data(null);
      return team;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Leave a team
  Future<bool> leaveTeam(int teamId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.leaveTeam(teamId);
      _ref.invalidate(teamsProvider);

      // Clear current team if user left it
      final currentTeamId = _ref.read(currentTeamIdProvider);
      if (currentTeamId == teamId) {
        _ref.read(currentTeamIdProvider.notifier).state = null;
      }

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Transfer ownership
  Future<TeamModel?> transferOwnership(int teamId, int newOwnerId) async {
    state = const AsyncValue.loading();
    try {
      final team = await _repository.transferOwnership(teamId, newOwnerId);
      _ref.invalidate(teamProvider(teamId));
      _ref.invalidate(teamMembersProvider(teamId));
      state = const AsyncValue.data(null);
      return team;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}

final teamNotifierProvider = StateNotifierProvider<TeamNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(teamRepositoryProvider);
  return TeamNotifier(repository, ref);
});

/// Member management notifier
class MemberNotifier extends StateNotifier<AsyncValue<void>> {
  final TeamRepository _repository;
  final Ref _ref;

  MemberNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  /// Invite a member
  Future<TeamInvitationModel?> inviteMember(int teamId, {
    required String email,
    required String role,
  }) async {
    state = const AsyncValue.loading();
    try {
      final invitation = await _repository.inviteMember(
        teamId,
        email: email,
        role: role,
      );
      _ref.invalidate(teamInvitationsProvider(teamId));
      state = const AsyncValue.data(null);
      return invitation;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Remove a member
  Future<bool> removeMember(int teamId, int memberId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.removeMember(teamId, memberId);
      _ref.invalidate(teamMembersProvider(teamId));
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Update member role
  Future<TeamMemberModel?> updateMemberRole(int teamId, int memberId, String role) async {
    state = const AsyncValue.loading();
    try {
      final member = await _repository.updateMemberRole(teamId, memberId, role);
      _ref.invalidate(teamMembersProvider(teamId));
      state = const AsyncValue.data(null);
      return member;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Cancel invitation
  Future<bool> cancelInvitation(int teamId, int invitationId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.cancelInvitation(teamId, invitationId);
      _ref.invalidate(teamInvitationsProvider(teamId));
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Accept invitation (user action)
  Future<TeamModel?> acceptInvitation(String token) async {
    state = const AsyncValue.loading();
    try {
      final team = await _repository.acceptInvitation(token);
      _ref.invalidate(teamsProvider);
      _ref.invalidate(myInvitationsProvider);
      state = const AsyncValue.data(null);
      return team;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Decline invitation (user action)
  Future<bool> declineInvitation(String token) async {
    state = const AsyncValue.loading();
    try {
      await _repository.declineInvitation(token);
      _ref.invalidate(myInvitationsProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final memberNotifierProvider = StateNotifierProvider<MemberNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(teamRepositoryProvider);
  return MemberNotifier(repository, ref);
});
