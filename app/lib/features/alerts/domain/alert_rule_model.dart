import 'package:freezed_annotation/freezed_annotation.dart';

part 'alert_rule_model.freezed.dart';
part 'alert_rule_model.g.dart';

@freezed
class AlertRuleModel with _$AlertRuleModel {
  const factory AlertRuleModel({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    required String name,
    required String type,
    @JsonKey(name: 'scope_type') required String scopeType,
    @JsonKey(name: 'scope_id') int? scopeId,
    required Map<String, dynamic> conditions,
    @JsonKey(name: 'is_template') required bool isTemplate,
    @JsonKey(name: 'is_active') required bool isActive,
    required int priority,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _AlertRuleModel;

  factory AlertRuleModel.fromJson(Map<String, dynamic> json) =>
      _$AlertRuleModelFromJson(json);
}

@freezed
class AlertTemplateModel with _$AlertTemplateModel {
  const factory AlertTemplateModel({
    required String name,
    required String type,
    required String icon,
    required String description,
    @JsonKey(name: 'default_conditions')
    required Map<String, dynamic> defaultConditions,
  }) = _AlertTemplateModel;

  factory AlertTemplateModel.fromJson(Map<String, dynamic> json) =>
      _$AlertTemplateModelFromJson(json);
}
