// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OnboardingStatus _$OnboardingStatusFromJson(Map<String, dynamic> json) {
  return _OnboardingStatus.fromJson(json);
}

/// @nodoc
mixin _$OnboardingStatus {
  @JsonKey(name: 'current_step')
  String get currentStep => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_completed')
  bool get isCompleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt => throw _privateConstructorUsedError;
  List<String> get steps => throw _privateConstructorUsedError;
  int get progress => throw _privateConstructorUsedError;

  /// Serializes this OnboardingStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OnboardingStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OnboardingStatusCopyWith<OnboardingStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingStatusCopyWith<$Res> {
  factory $OnboardingStatusCopyWith(
    OnboardingStatus value,
    $Res Function(OnboardingStatus) then,
  ) = _$OnboardingStatusCopyWithImpl<$Res, OnboardingStatus>;
  @useResult
  $Res call({
    @JsonKey(name: 'current_step') String currentStep,
    @JsonKey(name: 'is_completed') bool isCompleted,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    List<String> steps,
    int progress,
  });
}

/// @nodoc
class _$OnboardingStatusCopyWithImpl<$Res, $Val extends OnboardingStatus>
    implements $OnboardingStatusCopyWith<$Res> {
  _$OnboardingStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OnboardingStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? isCompleted = null,
    Object? completedAt = freezed,
    Object? steps = null,
    Object? progress = null,
  }) {
    return _then(
      _value.copyWith(
            currentStep: null == currentStep
                ? _value.currentStep
                : currentStep // ignore: cast_nullable_to_non_nullable
                      as String,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            steps: null == steps
                ? _value.steps
                : steps // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            progress: null == progress
                ? _value.progress
                : progress // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OnboardingStatusImplCopyWith<$Res>
    implements $OnboardingStatusCopyWith<$Res> {
  factory _$$OnboardingStatusImplCopyWith(
    _$OnboardingStatusImpl value,
    $Res Function(_$OnboardingStatusImpl) then,
  ) = __$$OnboardingStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'current_step') String currentStep,
    @JsonKey(name: 'is_completed') bool isCompleted,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    List<String> steps,
    int progress,
  });
}

/// @nodoc
class __$$OnboardingStatusImplCopyWithImpl<$Res>
    extends _$OnboardingStatusCopyWithImpl<$Res, _$OnboardingStatusImpl>
    implements _$$OnboardingStatusImplCopyWith<$Res> {
  __$$OnboardingStatusImplCopyWithImpl(
    _$OnboardingStatusImpl _value,
    $Res Function(_$OnboardingStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OnboardingStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? isCompleted = null,
    Object? completedAt = freezed,
    Object? steps = null,
    Object? progress = null,
  }) {
    return _then(
      _$OnboardingStatusImpl(
        currentStep: null == currentStep
            ? _value.currentStep
            : currentStep // ignore: cast_nullable_to_non_nullable
                  as String,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        steps: null == steps
            ? _value._steps
            : steps // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        progress: null == progress
            ? _value.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OnboardingStatusImpl extends _OnboardingStatus {
  const _$OnboardingStatusImpl({
    @JsonKey(name: 'current_step') required this.currentStep,
    @JsonKey(name: 'is_completed') required this.isCompleted,
    @JsonKey(name: 'completed_at') this.completedAt,
    required final List<String> steps,
    required this.progress,
  }) : _steps = steps,
       super._();

  factory _$OnboardingStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$OnboardingStatusImplFromJson(json);

  @override
  @JsonKey(name: 'current_step')
  final String currentStep;
  @override
  @JsonKey(name: 'is_completed')
  final bool isCompleted;
  @override
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;
  final List<String> _steps;
  @override
  List<String> get steps {
    if (_steps is EqualUnmodifiableListView) return _steps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_steps);
  }

  @override
  final int progress;

  @override
  String toString() {
    return 'OnboardingStatus(currentStep: $currentStep, isCompleted: $isCompleted, completedAt: $completedAt, steps: $steps, progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingStatusImpl &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            const DeepCollectionEquality().equals(other._steps, _steps) &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    currentStep,
    isCompleted,
    completedAt,
    const DeepCollectionEquality().hash(_steps),
    progress,
  );

  /// Create a copy of OnboardingStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingStatusImplCopyWith<_$OnboardingStatusImpl> get copyWith =>
      __$$OnboardingStatusImplCopyWithImpl<_$OnboardingStatusImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OnboardingStatusImplToJson(this);
  }
}

abstract class _OnboardingStatus extends OnboardingStatus {
  const factory _OnboardingStatus({
    @JsonKey(name: 'current_step') required final String currentStep,
    @JsonKey(name: 'is_completed') required final bool isCompleted,
    @JsonKey(name: 'completed_at') final DateTime? completedAt,
    required final List<String> steps,
    required final int progress,
  }) = _$OnboardingStatusImpl;
  const _OnboardingStatus._() : super._();

  factory _OnboardingStatus.fromJson(Map<String, dynamic> json) =
      _$OnboardingStatusImpl.fromJson;

  @override
  @JsonKey(name: 'current_step')
  String get currentStep;
  @override
  @JsonKey(name: 'is_completed')
  bool get isCompleted;
  @override
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt;
  @override
  List<String> get steps;
  @override
  int get progress;

  /// Create a copy of OnboardingStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnboardingStatusImplCopyWith<_$OnboardingStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
