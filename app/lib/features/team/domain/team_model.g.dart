// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeamModelImpl _$$TeamModelImplFromJson(Map<String, dynamic> json) =>
    _$TeamModelImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      ownerId: (json['owner_id'] as num).toInt(),
      membersCount: (json['members_count'] as num).toInt(),
      myRole: json['my_role'] as String,
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$$TeamModelImplToJson(_$TeamModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'owner_id': instance.ownerId,
      'members_count': instance.membersCount,
      'my_role': instance.myRole,
      'permissions': instance.permissions,
      'created_at': instance.createdAt,
    };

_$TeamMemberModelImpl _$$TeamMemberModelImplFromJson(
  Map<String, dynamic> json,
) => _$TeamMemberModelImpl(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  email: json['email'] as String,
  role: json['role'] as String,
  joinedAt: json['joined_at'] as String?,
);

Map<String, dynamic> _$$TeamMemberModelImplToJson(
  _$TeamMemberModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'role': instance.role,
  'joined_at': instance.joinedAt,
};

_$TeamInvitationModelImpl _$$TeamInvitationModelImplFromJson(
  Map<String, dynamic> json,
) => _$TeamInvitationModelImpl(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  role: json['role'] as String,
  status: json['status'] as String,
  token: json['token'] as String,
  expiresAt: json['expires_at'] as String,
  inviter: InviterInfo.fromJson(json['inviter'] as Map<String, dynamic>),
  createdAt: json['created_at'] as String,
  team: json['team'] == null
      ? null
      : TeamBasicInfo.fromJson(json['team'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$TeamInvitationModelImplToJson(
  _$TeamInvitationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'role': instance.role,
  'status': instance.status,
  'token': instance.token,
  'expires_at': instance.expiresAt,
  'inviter': instance.inviter,
  'created_at': instance.createdAt,
  'team': instance.team,
};

_$InviterInfoImpl _$$InviterInfoImplFromJson(Map<String, dynamic> json) =>
    _$InviterInfoImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$$InviterInfoImplToJson(_$InviterInfoImpl instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

_$TeamBasicInfoImpl _$$TeamBasicInfoImplFromJson(Map<String, dynamic> json) =>
    _$TeamBasicInfoImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$TeamBasicInfoImplToJson(_$TeamBasicInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };

_$TeamsResponseImpl _$$TeamsResponseImplFromJson(Map<String, dynamic> json) =>
    _$TeamsResponseImpl(
      teams: (json['teams'] as List<dynamic>)
          .map((e) => TeamModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$TeamsResponseImplToJson(_$TeamsResponseImpl instance) =>
    <String, dynamic>{'teams': instance.teams};

_$TeamResponseImpl _$$TeamResponseImplFromJson(Map<String, dynamic> json) =>
    _$TeamResponseImpl(
      team: TeamModel.fromJson(json['team'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TeamResponseImplToJson(_$TeamResponseImpl instance) =>
    <String, dynamic>{'team': instance.team};

_$TeamMembersResponseImpl _$$TeamMembersResponseImplFromJson(
  Map<String, dynamic> json,
) => _$TeamMembersResponseImpl(
  members: (json['members'] as List<dynamic>)
      .map((e) => TeamMemberModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$TeamMembersResponseImplToJson(
  _$TeamMembersResponseImpl instance,
) => <String, dynamic>{'members': instance.members};

_$TeamInvitationsResponseImpl _$$TeamInvitationsResponseImplFromJson(
  Map<String, dynamic> json,
) => _$TeamInvitationsResponseImpl(
  invitations: (json['invitations'] as List<dynamic>)
      .map((e) => TeamInvitationModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$TeamInvitationsResponseImplToJson(
  _$TeamInvitationsResponseImpl instance,
) => <String, dynamic>{'invitations': instance.invitations};

_$InvitationResponseImpl _$$InvitationResponseImplFromJson(
  Map<String, dynamic> json,
) => _$InvitationResponseImpl(
  invitation: TeamInvitationModel.fromJson(
    json['invitation'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$InvitationResponseImplToJson(
  _$InvitationResponseImpl instance,
) => <String, dynamic>{'invitation': instance.invitation};

_$CreateTeamRequestImpl _$$CreateTeamRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreateTeamRequestImpl(
  name: json['name'] as String,
  description: json['description'] as String?,
);

Map<String, dynamic> _$$CreateTeamRequestImplToJson(
  _$CreateTeamRequestImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
};

_$UpdateTeamRequestImpl _$$UpdateTeamRequestImplFromJson(
  Map<String, dynamic> json,
) => _$UpdateTeamRequestImpl(
  name: json['name'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$$UpdateTeamRequestImplToJson(
  _$UpdateTeamRequestImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
};

_$InviteMemberRequestImpl _$$InviteMemberRequestImplFromJson(
  Map<String, dynamic> json,
) => _$InviteMemberRequestImpl(
  email: json['email'] as String,
  role: json['role'] as String,
);

Map<String, dynamic> _$$InviteMemberRequestImplToJson(
  _$InviteMemberRequestImpl instance,
) => <String, dynamic>{'email': instance.email, 'role': instance.role};

_$UpdateMemberRoleRequestImpl _$$UpdateMemberRoleRequestImplFromJson(
  Map<String, dynamic> json,
) => _$UpdateMemberRoleRequestImpl(role: json['role'] as String);

Map<String, dynamic> _$$UpdateMemberRoleRequestImplToJson(
  _$UpdateMemberRoleRequestImpl instance,
) => <String, dynamic>{'role': instance.role};

_$TransferOwnershipRequestImpl _$$TransferOwnershipRequestImplFromJson(
  Map<String, dynamic> json,
) => _$TransferOwnershipRequestImpl(userId: (json['user_id'] as num).toInt());

Map<String, dynamic> _$$TransferOwnershipRequestImplToJson(
  _$TransferOwnershipRequestImpl instance,
) => <String, dynamic>{'user_id': instance.userId};

_$CurrentTeamResponseImpl _$$CurrentTeamResponseImplFromJson(
  Map<String, dynamic> json,
) => _$CurrentTeamResponseImpl(
  currentTeam: TeamModel.fromJson(json['current_team'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$CurrentTeamResponseImplToJson(
  _$CurrentTeamResponseImpl instance,
) => <String, dynamic>{'current_team': instance.currentTeam};

_$MemberResponseImpl _$$MemberResponseImplFromJson(Map<String, dynamic> json) =>
    _$MemberResponseImpl(
      member: TeamMemberModel.fromJson(json['member'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$MemberResponseImplToJson(
  _$MemberResponseImpl instance,
) => <String, dynamic>{'member': instance.member};
