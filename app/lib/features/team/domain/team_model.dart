import 'package:freezed_annotation/freezed_annotation.dart';

part 'team_model.freezed.dart';
part 'team_model.g.dart';

/// Team roles with their permissions
enum TeamRole {
  owner,
  admin,
  editor,
  viewer;

  String get displayName {
    switch (this) {
      case TeamRole.owner:
        return 'Owner';
      case TeamRole.admin:
        return 'Admin';
      case TeamRole.editor:
        return 'Editor';
      case TeamRole.viewer:
        return 'Viewer';
    }
  }

  String get description {
    switch (this) {
      case TeamRole.owner:
        return 'Full access including billing and team deletion';
      case TeamRole.admin:
        return 'Can manage apps, invite members, and access all features';
      case TeamRole.editor:
        return 'Can manage apps, keywords, and metadata';
      case TeamRole.viewer:
        return 'Read-only access to apps and analytics';
    }
  }

  bool get canManageTeam => this == TeamRole.owner || this == TeamRole.admin;
  bool get canInviteMembers => this == TeamRole.owner || this == TeamRole.admin;
  bool get canEditApps => this != TeamRole.viewer;
  bool get isOwner => this == TeamRole.owner;
}

/// Team model
@freezed
class TeamModel with _$TeamModel {
  const TeamModel._();

  const factory TeamModel({
    required int id,
    required String name,
    required String slug,
    String? description,
    @JsonKey(name: 'owner_id') required int ownerId,
    @JsonKey(name: 'members_count') required int membersCount,
    @JsonKey(name: 'my_role') required String myRole,
    required List<String> permissions,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _TeamModel;

  factory TeamModel.fromJson(Map<String, dynamic> json) =>
      _$TeamModelFromJson(json);

  TeamRole get role {
    switch (myRole) {
      case 'owner':
        return TeamRole.owner;
      case 'admin':
        return TeamRole.admin;
      case 'editor':
        return TeamRole.editor;
      case 'viewer':
      default:
        return TeamRole.viewer;
    }
  }

  bool hasPermission(String permission) => permissions.contains(permission);
}

/// Team member model
@freezed
class TeamMemberModel with _$TeamMemberModel {
  const TeamMemberModel._();

  const factory TeamMemberModel({
    required int id,
    required String name,
    required String email,
    required String role,
    @JsonKey(name: 'joined_at') String? joinedAt,
  }) = _TeamMemberModel;

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) =>
      _$TeamMemberModelFromJson(json);

  TeamRole get teamRole {
    switch (role) {
      case 'owner':
        return TeamRole.owner;
      case 'admin':
        return TeamRole.admin;
      case 'editor':
        return TeamRole.editor;
      case 'viewer':
      default:
        return TeamRole.viewer;
    }
  }
}

/// Team invitation model
@freezed
class TeamInvitationModel with _$TeamInvitationModel {
  const TeamInvitationModel._();

  const factory TeamInvitationModel({
    required int id,
    required String email,
    required String role,
    required String status,
    required String token,
    @JsonKey(name: 'expires_at') required String expiresAt,
    required InviterInfo inviter,
    @JsonKey(name: 'created_at') required String createdAt,
    TeamBasicInfo? team,
  }) = _TeamInvitationModel;

  factory TeamInvitationModel.fromJson(Map<String, dynamic> json) =>
      _$TeamInvitationModelFromJson(json);

  bool get isExpired => DateTime.parse(expiresAt).isBefore(DateTime.now());
  bool get isPending => status == 'pending' && !isExpired;

  TeamRole get teamRole {
    switch (role) {
      case 'admin':
        return TeamRole.admin;
      case 'editor':
        return TeamRole.editor;
      case 'viewer':
      default:
        return TeamRole.viewer;
    }
  }
}

/// Inviter info
@freezed
class InviterInfo with _$InviterInfo {
  const factory InviterInfo({
    required int id,
    required String name,
  }) = _InviterInfo;

  factory InviterInfo.fromJson(Map<String, dynamic> json) =>
      _$InviterInfoFromJson(json);
}

/// Basic team info (for invitations)
@freezed
class TeamBasicInfo with _$TeamBasicInfo {
  const factory TeamBasicInfo({
    required int id,
    required String name,
    String? description,
  }) = _TeamBasicInfo;

  factory TeamBasicInfo.fromJson(Map<String, dynamic> json) =>
      _$TeamBasicInfoFromJson(json);
}

/// Teams list response
@freezed
class TeamsResponse with _$TeamsResponse {
  const factory TeamsResponse({
    required List<TeamModel> teams,
  }) = _TeamsResponse;

  factory TeamsResponse.fromJson(Map<String, dynamic> json) =>
      _$TeamsResponseFromJson(json);
}

/// Team details response
@freezed
class TeamResponse with _$TeamResponse {
  const factory TeamResponse({
    required TeamModel team,
  }) = _TeamResponse;

  factory TeamResponse.fromJson(Map<String, dynamic> json) =>
      _$TeamResponseFromJson(json);
}

/// Team members response
@freezed
class TeamMembersResponse with _$TeamMembersResponse {
  const factory TeamMembersResponse({
    required List<TeamMemberModel> members,
  }) = _TeamMembersResponse;

  factory TeamMembersResponse.fromJson(Map<String, dynamic> json) =>
      _$TeamMembersResponseFromJson(json);
}

/// Team invitations response
@freezed
class TeamInvitationsResponse with _$TeamInvitationsResponse {
  const factory TeamInvitationsResponse({
    required List<TeamInvitationModel> invitations,
  }) = _TeamInvitationsResponse;

  factory TeamInvitationsResponse.fromJson(Map<String, dynamic> json) =>
      _$TeamInvitationsResponseFromJson(json);
}

/// Invitation response (single)
@freezed
class InvitationResponse with _$InvitationResponse {
  const factory InvitationResponse({
    required TeamInvitationModel invitation,
  }) = _InvitationResponse;

  factory InvitationResponse.fromJson(Map<String, dynamic> json) =>
      _$InvitationResponseFromJson(json);
}

/// Create team request
@freezed
class CreateTeamRequest with _$CreateTeamRequest {
  const factory CreateTeamRequest({
    required String name,
    String? description,
  }) = _CreateTeamRequest;

  factory CreateTeamRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTeamRequestFromJson(json);
}

/// Update team request
@freezed
class UpdateTeamRequest with _$UpdateTeamRequest {
  const factory UpdateTeamRequest({
    String? name,
    String? description,
  }) = _UpdateTeamRequest;

  factory UpdateTeamRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateTeamRequestFromJson(json);
}

/// Invite member request
@freezed
class InviteMemberRequest with _$InviteMemberRequest {
  const factory InviteMemberRequest({
    required String email,
    required String role,
  }) = _InviteMemberRequest;

  factory InviteMemberRequest.fromJson(Map<String, dynamic> json) =>
      _$InviteMemberRequestFromJson(json);
}

/// Update member role request
@freezed
class UpdateMemberRoleRequest with _$UpdateMemberRoleRequest {
  const factory UpdateMemberRoleRequest({
    required String role,
  }) = _UpdateMemberRoleRequest;

  factory UpdateMemberRoleRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateMemberRoleRequestFromJson(json);
}

/// Transfer ownership request
@freezed
class TransferOwnershipRequest with _$TransferOwnershipRequest {
  const factory TransferOwnershipRequest({
    @JsonKey(name: 'user_id') required int userId,
  }) = _TransferOwnershipRequest;

  factory TransferOwnershipRequest.fromJson(Map<String, dynamic> json) =>
      _$TransferOwnershipRequestFromJson(json);
}

/// Current team response
@freezed
class CurrentTeamResponse with _$CurrentTeamResponse {
  const factory CurrentTeamResponse({
    @JsonKey(name: 'current_team') required TeamModel currentTeam,
  }) = _CurrentTeamResponse;

  factory CurrentTeamResponse.fromJson(Map<String, dynamic> json) =>
      _$CurrentTeamResponseFromJson(json);
}

/// Member response
@freezed
class MemberResponse with _$MemberResponse {
  const factory MemberResponse({
    required TeamMemberModel member,
  }) = _MemberResponse;

  factory MemberResponse.fromJson(Map<String, dynamic> json) =>
      _$MemberResponseFromJson(json);
}
