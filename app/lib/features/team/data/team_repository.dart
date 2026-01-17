import 'package:dio/dio.dart';
import '../domain/team_model.dart';

class TeamRepository {
  final Dio _dio;

  TeamRepository(this._dio);

  /// Get all teams the user belongs to.
  Future<List<TeamModel>> getTeams() async {
    final response = await _dio.get('/teams');
    final data = response.data['teams'] as List<dynamic>;
    return data.map((json) => TeamModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Create a new team.
  Future<TeamModel> createTeam({
    required String name,
    String? description,
  }) async {
    final response = await _dio.post('/teams', data: {
      'name': name,
      if (description != null) 'description': description,
    });
    return TeamModel.fromJson(response.data['team'] as Map<String, dynamic>);
  }

  /// Get team details.
  Future<TeamModel> getTeam(int teamId) async {
    final response = await _dio.get('/teams/$teamId');
    return TeamModel.fromJson(response.data['team'] as Map<String, dynamic>);
  }

  /// Update team details.
  Future<TeamModel> updateTeam(int teamId, {String? name, String? description}) async {
    final response = await _dio.put('/teams/$teamId', data: {
      if (name != null) 'name': name,
      'description': description,
    });
    return TeamModel.fromJson(response.data['team'] as Map<String, dynamic>);
  }

  /// Delete a team.
  Future<void> deleteTeam(int teamId) async {
    await _dio.delete('/teams/$teamId');
  }

  /// Switch to a different team.
  Future<TeamModel> switchTeam(int teamId) async {
    final response = await _dio.post('/teams/$teamId/switch');
    return TeamModel.fromJson(response.data['current_team'] as Map<String, dynamic>);
  }

  /// Leave a team.
  Future<void> leaveTeam(int teamId) async {
    await _dio.post('/teams/$teamId/leave');
  }

  /// Transfer team ownership.
  Future<TeamModel> transferOwnership(int teamId, int newOwnerId) async {
    final response = await _dio.post('/teams/$teamId/transfer-ownership', data: {
      'user_id': newOwnerId,
    });
    return TeamModel.fromJson(response.data['team'] as Map<String, dynamic>);
  }

  // ===== MEMBERS =====

  /// Get team members.
  Future<List<TeamMemberModel>> getMembers(int teamId) async {
    final response = await _dio.get('/teams/$teamId/members');
    final data = response.data['members'] as List<dynamic>;
    return data.map((json) => TeamMemberModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Remove a member from the team.
  Future<void> removeMember(int teamId, int memberId) async {
    await _dio.delete('/teams/$teamId/members/$memberId');
  }

  /// Update a member's role.
  Future<TeamMemberModel> updateMemberRole(int teamId, int memberId, String role) async {
    final response = await _dio.patch('/teams/$teamId/members/$memberId/role', data: {
      'role': role,
    });
    return TeamMemberModel.fromJson(response.data['member'] as Map<String, dynamic>);
  }

  // ===== INVITATIONS =====

  /// Get pending invitations for the team.
  Future<List<TeamInvitationModel>> getTeamInvitations(int teamId) async {
    final response = await _dio.get('/teams/$teamId/invitations');
    final data = response.data['invitations'] as List<dynamic>;
    return data.map((json) => TeamInvitationModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Invite a user to the team.
  Future<TeamInvitationModel> inviteMember(int teamId, {
    required String email,
    required String role,
  }) async {
    final response = await _dio.post('/teams/$teamId/invitations', data: {
      'email': email,
      'role': role,
    });
    return TeamInvitationModel.fromJson(response.data['invitation'] as Map<String, dynamic>);
  }

  /// Cancel/revoke an invitation.
  Future<void> cancelInvitation(int teamId, int invitationId) async {
    await _dio.delete('/teams/$teamId/invitations/$invitationId');
  }

  /// Get pending invitations for the current user.
  Future<List<TeamInvitationModel>> getMyInvitations() async {
    final response = await _dio.get('/teams/invitations');
    final data = response.data['invitations'] as List<dynamic>;
    return data.map((json) => TeamInvitationModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Accept an invitation.
  Future<TeamModel> acceptInvitation(String token) async {
    final response = await _dio.post('/teams/invitations/$token/accept');
    return TeamModel.fromJson(response.data['team'] as Map<String, dynamic>);
  }

  /// Decline an invitation.
  Future<void> declineInvitation(String token) async {
    await _dio.post('/teams/invitations/$token/decline');
  }
}
