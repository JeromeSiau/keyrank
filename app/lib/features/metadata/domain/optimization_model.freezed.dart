// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'optimization_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OptimizationResponse _$OptimizationResponseFromJson(Map<String, dynamic> json) {
  return _OptimizationResponse.fromJson(json);
}

/// @nodoc
mixin _$OptimizationResponse {
  String get field => throw _privateConstructorUsedError;
  String get locale => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_value')
  String get currentValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'character_limit')
  int get characterLimit => throw _privateConstructorUsedError;
  List<OptimizationSuggestion> get suggestions =>
      throw _privateConstructorUsedError;
  OptimizationContext get context => throw _privateConstructorUsedError;

  /// Serializes this OptimizationResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OptimizationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OptimizationResponseCopyWith<OptimizationResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OptimizationResponseCopyWith<$Res> {
  factory $OptimizationResponseCopyWith(
    OptimizationResponse value,
    $Res Function(OptimizationResponse) then,
  ) = _$OptimizationResponseCopyWithImpl<$Res, OptimizationResponse>;
  @useResult
  $Res call({
    String field,
    String locale,
    @JsonKey(name: 'current_value') String currentValue,
    @JsonKey(name: 'character_limit') int characterLimit,
    List<OptimizationSuggestion> suggestions,
    OptimizationContext context,
  });

  $OptimizationContextCopyWith<$Res> get context;
}

/// @nodoc
class _$OptimizationResponseCopyWithImpl<
  $Res,
  $Val extends OptimizationResponse
>
    implements $OptimizationResponseCopyWith<$Res> {
  _$OptimizationResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OptimizationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field = null,
    Object? locale = null,
    Object? currentValue = null,
    Object? characterLimit = null,
    Object? suggestions = null,
    Object? context = null,
  }) {
    return _then(
      _value.copyWith(
            field: null == field
                ? _value.field
                : field // ignore: cast_nullable_to_non_nullable
                      as String,
            locale: null == locale
                ? _value.locale
                : locale // ignore: cast_nullable_to_non_nullable
                      as String,
            currentValue: null == currentValue
                ? _value.currentValue
                : currentValue // ignore: cast_nullable_to_non_nullable
                      as String,
            characterLimit: null == characterLimit
                ? _value.characterLimit
                : characterLimit // ignore: cast_nullable_to_non_nullable
                      as int,
            suggestions: null == suggestions
                ? _value.suggestions
                : suggestions // ignore: cast_nullable_to_non_nullable
                      as List<OptimizationSuggestion>,
            context: null == context
                ? _value.context
                : context // ignore: cast_nullable_to_non_nullable
                      as OptimizationContext,
          )
          as $Val,
    );
  }

  /// Create a copy of OptimizationResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OptimizationContextCopyWith<$Res> get context {
    return $OptimizationContextCopyWith<$Res>(_value.context, (value) {
      return _then(_value.copyWith(context: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OptimizationResponseImplCopyWith<$Res>
    implements $OptimizationResponseCopyWith<$Res> {
  factory _$$OptimizationResponseImplCopyWith(
    _$OptimizationResponseImpl value,
    $Res Function(_$OptimizationResponseImpl) then,
  ) = __$$OptimizationResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String field,
    String locale,
    @JsonKey(name: 'current_value') String currentValue,
    @JsonKey(name: 'character_limit') int characterLimit,
    List<OptimizationSuggestion> suggestions,
    OptimizationContext context,
  });

  @override
  $OptimizationContextCopyWith<$Res> get context;
}

/// @nodoc
class __$$OptimizationResponseImplCopyWithImpl<$Res>
    extends _$OptimizationResponseCopyWithImpl<$Res, _$OptimizationResponseImpl>
    implements _$$OptimizationResponseImplCopyWith<$Res> {
  __$$OptimizationResponseImplCopyWithImpl(
    _$OptimizationResponseImpl _value,
    $Res Function(_$OptimizationResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OptimizationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field = null,
    Object? locale = null,
    Object? currentValue = null,
    Object? characterLimit = null,
    Object? suggestions = null,
    Object? context = null,
  }) {
    return _then(
      _$OptimizationResponseImpl(
        field: null == field
            ? _value.field
            : field // ignore: cast_nullable_to_non_nullable
                  as String,
        locale: null == locale
            ? _value.locale
            : locale // ignore: cast_nullable_to_non_nullable
                  as String,
        currentValue: null == currentValue
            ? _value.currentValue
            : currentValue // ignore: cast_nullable_to_non_nullable
                  as String,
        characterLimit: null == characterLimit
            ? _value.characterLimit
            : characterLimit // ignore: cast_nullable_to_non_nullable
                  as int,
        suggestions: null == suggestions
            ? _value._suggestions
            : suggestions // ignore: cast_nullable_to_non_nullable
                  as List<OptimizationSuggestion>,
        context: null == context
            ? _value.context
            : context // ignore: cast_nullable_to_non_nullable
                  as OptimizationContext,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OptimizationResponseImpl implements _OptimizationResponse {
  const _$OptimizationResponseImpl({
    required this.field,
    required this.locale,
    @JsonKey(name: 'current_value') required this.currentValue,
    @JsonKey(name: 'character_limit') required this.characterLimit,
    required final List<OptimizationSuggestion> suggestions,
    required this.context,
  }) : _suggestions = suggestions;

  factory _$OptimizationResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$OptimizationResponseImplFromJson(json);

  @override
  final String field;
  @override
  final String locale;
  @override
  @JsonKey(name: 'current_value')
  final String currentValue;
  @override
  @JsonKey(name: 'character_limit')
  final int characterLimit;
  final List<OptimizationSuggestion> _suggestions;
  @override
  List<OptimizationSuggestion> get suggestions {
    if (_suggestions is EqualUnmodifiableListView) return _suggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suggestions);
  }

  @override
  final OptimizationContext context;

  @override
  String toString() {
    return 'OptimizationResponse(field: $field, locale: $locale, currentValue: $currentValue, characterLimit: $characterLimit, suggestions: $suggestions, context: $context)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OptimizationResponseImpl &&
            (identical(other.field, field) || other.field == field) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.currentValue, currentValue) ||
                other.currentValue == currentValue) &&
            (identical(other.characterLimit, characterLimit) ||
                other.characterLimit == characterLimit) &&
            const DeepCollectionEquality().equals(
              other._suggestions,
              _suggestions,
            ) &&
            (identical(other.context, context) || other.context == context));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    field,
    locale,
    currentValue,
    characterLimit,
    const DeepCollectionEquality().hash(_suggestions),
    context,
  );

  /// Create a copy of OptimizationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OptimizationResponseImplCopyWith<_$OptimizationResponseImpl>
  get copyWith =>
      __$$OptimizationResponseImplCopyWithImpl<_$OptimizationResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OptimizationResponseImplToJson(this);
  }
}

abstract class _OptimizationResponse implements OptimizationResponse {
  const factory _OptimizationResponse({
    required final String field,
    required final String locale,
    @JsonKey(name: 'current_value') required final String currentValue,
    @JsonKey(name: 'character_limit') required final int characterLimit,
    required final List<OptimizationSuggestion> suggestions,
    required final OptimizationContext context,
  }) = _$OptimizationResponseImpl;

  factory _OptimizationResponse.fromJson(Map<String, dynamic> json) =
      _$OptimizationResponseImpl.fromJson;

  @override
  String get field;
  @override
  String get locale;
  @override
  @JsonKey(name: 'current_value')
  String get currentValue;
  @override
  @JsonKey(name: 'character_limit')
  int get characterLimit;
  @override
  List<OptimizationSuggestion> get suggestions;
  @override
  OptimizationContext get context;

  /// Create a copy of OptimizationResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OptimizationResponseImplCopyWith<_$OptimizationResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

OptimizationSuggestion _$OptimizationSuggestionFromJson(
  Map<String, dynamic> json,
) {
  return _OptimizationSuggestion.fromJson(json);
}

/// @nodoc
mixin _$OptimizationSuggestion {
  String get option => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  @JsonKey(name: 'character_count')
  int get characterCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'character_limit')
  int get characterLimit => throw _privateConstructorUsedError;
  String get reasoning => throw _privateConstructorUsedError;
  @JsonKey(name: 'keywords_added')
  List<String> get keywordsAdded => throw _privateConstructorUsedError;
  @JsonKey(name: 'keywords_removed')
  List<String> get keywordsRemoved => throw _privateConstructorUsedError;
  @JsonKey(name: 'estimated_impact')
  int get estimatedImpact => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_recommended')
  bool get isRecommended => throw _privateConstructorUsedError;

  /// Serializes this OptimizationSuggestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OptimizationSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OptimizationSuggestionCopyWith<OptimizationSuggestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OptimizationSuggestionCopyWith<$Res> {
  factory $OptimizationSuggestionCopyWith(
    OptimizationSuggestion value,
    $Res Function(OptimizationSuggestion) then,
  ) = _$OptimizationSuggestionCopyWithImpl<$Res, OptimizationSuggestion>;
  @useResult
  $Res call({
    String option,
    String value,
    @JsonKey(name: 'character_count') int characterCount,
    @JsonKey(name: 'character_limit') int characterLimit,
    String reasoning,
    @JsonKey(name: 'keywords_added') List<String> keywordsAdded,
    @JsonKey(name: 'keywords_removed') List<String> keywordsRemoved,
    @JsonKey(name: 'estimated_impact') int estimatedImpact,
    @JsonKey(name: 'is_recommended') bool isRecommended,
  });
}

/// @nodoc
class _$OptimizationSuggestionCopyWithImpl<
  $Res,
  $Val extends OptimizationSuggestion
>
    implements $OptimizationSuggestionCopyWith<$Res> {
  _$OptimizationSuggestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OptimizationSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? option = null,
    Object? value = null,
    Object? characterCount = null,
    Object? characterLimit = null,
    Object? reasoning = null,
    Object? keywordsAdded = null,
    Object? keywordsRemoved = null,
    Object? estimatedImpact = null,
    Object? isRecommended = null,
  }) {
    return _then(
      _value.copyWith(
            option: null == option
                ? _value.option
                : option // ignore: cast_nullable_to_non_nullable
                      as String,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as String,
            characterCount: null == characterCount
                ? _value.characterCount
                : characterCount // ignore: cast_nullable_to_non_nullable
                      as int,
            characterLimit: null == characterLimit
                ? _value.characterLimit
                : characterLimit // ignore: cast_nullable_to_non_nullable
                      as int,
            reasoning: null == reasoning
                ? _value.reasoning
                : reasoning // ignore: cast_nullable_to_non_nullable
                      as String,
            keywordsAdded: null == keywordsAdded
                ? _value.keywordsAdded
                : keywordsAdded // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            keywordsRemoved: null == keywordsRemoved
                ? _value.keywordsRemoved
                : keywordsRemoved // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            estimatedImpact: null == estimatedImpact
                ? _value.estimatedImpact
                : estimatedImpact // ignore: cast_nullable_to_non_nullable
                      as int,
            isRecommended: null == isRecommended
                ? _value.isRecommended
                : isRecommended // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OptimizationSuggestionImplCopyWith<$Res>
    implements $OptimizationSuggestionCopyWith<$Res> {
  factory _$$OptimizationSuggestionImplCopyWith(
    _$OptimizationSuggestionImpl value,
    $Res Function(_$OptimizationSuggestionImpl) then,
  ) = __$$OptimizationSuggestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String option,
    String value,
    @JsonKey(name: 'character_count') int characterCount,
    @JsonKey(name: 'character_limit') int characterLimit,
    String reasoning,
    @JsonKey(name: 'keywords_added') List<String> keywordsAdded,
    @JsonKey(name: 'keywords_removed') List<String> keywordsRemoved,
    @JsonKey(name: 'estimated_impact') int estimatedImpact,
    @JsonKey(name: 'is_recommended') bool isRecommended,
  });
}

/// @nodoc
class __$$OptimizationSuggestionImplCopyWithImpl<$Res>
    extends
        _$OptimizationSuggestionCopyWithImpl<$Res, _$OptimizationSuggestionImpl>
    implements _$$OptimizationSuggestionImplCopyWith<$Res> {
  __$$OptimizationSuggestionImplCopyWithImpl(
    _$OptimizationSuggestionImpl _value,
    $Res Function(_$OptimizationSuggestionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OptimizationSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? option = null,
    Object? value = null,
    Object? characterCount = null,
    Object? characterLimit = null,
    Object? reasoning = null,
    Object? keywordsAdded = null,
    Object? keywordsRemoved = null,
    Object? estimatedImpact = null,
    Object? isRecommended = null,
  }) {
    return _then(
      _$OptimizationSuggestionImpl(
        option: null == option
            ? _value.option
            : option // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as String,
        characterCount: null == characterCount
            ? _value.characterCount
            : characterCount // ignore: cast_nullable_to_non_nullable
                  as int,
        characterLimit: null == characterLimit
            ? _value.characterLimit
            : characterLimit // ignore: cast_nullable_to_non_nullable
                  as int,
        reasoning: null == reasoning
            ? _value.reasoning
            : reasoning // ignore: cast_nullable_to_non_nullable
                  as String,
        keywordsAdded: null == keywordsAdded
            ? _value._keywordsAdded
            : keywordsAdded // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        keywordsRemoved: null == keywordsRemoved
            ? _value._keywordsRemoved
            : keywordsRemoved // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        estimatedImpact: null == estimatedImpact
            ? _value.estimatedImpact
            : estimatedImpact // ignore: cast_nullable_to_non_nullable
                  as int,
        isRecommended: null == isRecommended
            ? _value.isRecommended
            : isRecommended // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OptimizationSuggestionImpl implements _OptimizationSuggestion {
  const _$OptimizationSuggestionImpl({
    required this.option,
    required this.value,
    @JsonKey(name: 'character_count') required this.characterCount,
    @JsonKey(name: 'character_limit') required this.characterLimit,
    required this.reasoning,
    @JsonKey(name: 'keywords_added')
    final List<String> keywordsAdded = const [],
    @JsonKey(name: 'keywords_removed')
    final List<String> keywordsRemoved = const [],
    @JsonKey(name: 'estimated_impact') this.estimatedImpact = 0,
    @JsonKey(name: 'is_recommended') this.isRecommended = false,
  }) : _keywordsAdded = keywordsAdded,
       _keywordsRemoved = keywordsRemoved;

  factory _$OptimizationSuggestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$OptimizationSuggestionImplFromJson(json);

  @override
  final String option;
  @override
  final String value;
  @override
  @JsonKey(name: 'character_count')
  final int characterCount;
  @override
  @JsonKey(name: 'character_limit')
  final int characterLimit;
  @override
  final String reasoning;
  final List<String> _keywordsAdded;
  @override
  @JsonKey(name: 'keywords_added')
  List<String> get keywordsAdded {
    if (_keywordsAdded is EqualUnmodifiableListView) return _keywordsAdded;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keywordsAdded);
  }

  final List<String> _keywordsRemoved;
  @override
  @JsonKey(name: 'keywords_removed')
  List<String> get keywordsRemoved {
    if (_keywordsRemoved is EqualUnmodifiableListView) return _keywordsRemoved;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keywordsRemoved);
  }

  @override
  @JsonKey(name: 'estimated_impact')
  final int estimatedImpact;
  @override
  @JsonKey(name: 'is_recommended')
  final bool isRecommended;

  @override
  String toString() {
    return 'OptimizationSuggestion(option: $option, value: $value, characterCount: $characterCount, characterLimit: $characterLimit, reasoning: $reasoning, keywordsAdded: $keywordsAdded, keywordsRemoved: $keywordsRemoved, estimatedImpact: $estimatedImpact, isRecommended: $isRecommended)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OptimizationSuggestionImpl &&
            (identical(other.option, option) || other.option == option) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.characterCount, characterCount) ||
                other.characterCount == characterCount) &&
            (identical(other.characterLimit, characterLimit) ||
                other.characterLimit == characterLimit) &&
            (identical(other.reasoning, reasoning) ||
                other.reasoning == reasoning) &&
            const DeepCollectionEquality().equals(
              other._keywordsAdded,
              _keywordsAdded,
            ) &&
            const DeepCollectionEquality().equals(
              other._keywordsRemoved,
              _keywordsRemoved,
            ) &&
            (identical(other.estimatedImpact, estimatedImpact) ||
                other.estimatedImpact == estimatedImpact) &&
            (identical(other.isRecommended, isRecommended) ||
                other.isRecommended == isRecommended));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    option,
    value,
    characterCount,
    characterLimit,
    reasoning,
    const DeepCollectionEquality().hash(_keywordsAdded),
    const DeepCollectionEquality().hash(_keywordsRemoved),
    estimatedImpact,
    isRecommended,
  );

  /// Create a copy of OptimizationSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OptimizationSuggestionImplCopyWith<_$OptimizationSuggestionImpl>
  get copyWith =>
      __$$OptimizationSuggestionImplCopyWithImpl<_$OptimizationSuggestionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OptimizationSuggestionImplToJson(this);
  }
}

abstract class _OptimizationSuggestion implements OptimizationSuggestion {
  const factory _OptimizationSuggestion({
    required final String option,
    required final String value,
    @JsonKey(name: 'character_count') required final int characterCount,
    @JsonKey(name: 'character_limit') required final int characterLimit,
    required final String reasoning,
    @JsonKey(name: 'keywords_added') final List<String> keywordsAdded,
    @JsonKey(name: 'keywords_removed') final List<String> keywordsRemoved,
    @JsonKey(name: 'estimated_impact') final int estimatedImpact,
    @JsonKey(name: 'is_recommended') final bool isRecommended,
  }) = _$OptimizationSuggestionImpl;

  factory _OptimizationSuggestion.fromJson(Map<String, dynamic> json) =
      _$OptimizationSuggestionImpl.fromJson;

  @override
  String get option;
  @override
  String get value;
  @override
  @JsonKey(name: 'character_count')
  int get characterCount;
  @override
  @JsonKey(name: 'character_limit')
  int get characterLimit;
  @override
  String get reasoning;
  @override
  @JsonKey(name: 'keywords_added')
  List<String> get keywordsAdded;
  @override
  @JsonKey(name: 'keywords_removed')
  List<String> get keywordsRemoved;
  @override
  @JsonKey(name: 'estimated_impact')
  int get estimatedImpact;
  @override
  @JsonKey(name: 'is_recommended')
  bool get isRecommended;

  /// Create a copy of OptimizationSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OptimizationSuggestionImplCopyWith<_$OptimizationSuggestionImpl>
  get copyWith => throw _privateConstructorUsedError;
}

OptimizationContext _$OptimizationContextFromJson(Map<String, dynamic> json) {
  return _OptimizationContext.fromJson(json);
}

/// @nodoc
mixin _$OptimizationContext {
  @JsonKey(name: 'tracked_keywords_count')
  int get trackedKeywordsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'competitors_count')
  int get competitorsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'top_keywords')
  List<String> get topKeywords => throw _privateConstructorUsedError;

  /// Serializes this OptimizationContext to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OptimizationContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OptimizationContextCopyWith<OptimizationContext> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OptimizationContextCopyWith<$Res> {
  factory $OptimizationContextCopyWith(
    OptimizationContext value,
    $Res Function(OptimizationContext) then,
  ) = _$OptimizationContextCopyWithImpl<$Res, OptimizationContext>;
  @useResult
  $Res call({
    @JsonKey(name: 'tracked_keywords_count') int trackedKeywordsCount,
    @JsonKey(name: 'competitors_count') int competitorsCount,
    @JsonKey(name: 'top_keywords') List<String> topKeywords,
  });
}

/// @nodoc
class _$OptimizationContextCopyWithImpl<$Res, $Val extends OptimizationContext>
    implements $OptimizationContextCopyWith<$Res> {
  _$OptimizationContextCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OptimizationContext
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trackedKeywordsCount = null,
    Object? competitorsCount = null,
    Object? topKeywords = null,
  }) {
    return _then(
      _value.copyWith(
            trackedKeywordsCount: null == trackedKeywordsCount
                ? _value.trackedKeywordsCount
                : trackedKeywordsCount // ignore: cast_nullable_to_non_nullable
                      as int,
            competitorsCount: null == competitorsCount
                ? _value.competitorsCount
                : competitorsCount // ignore: cast_nullable_to_non_nullable
                      as int,
            topKeywords: null == topKeywords
                ? _value.topKeywords
                : topKeywords // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OptimizationContextImplCopyWith<$Res>
    implements $OptimizationContextCopyWith<$Res> {
  factory _$$OptimizationContextImplCopyWith(
    _$OptimizationContextImpl value,
    $Res Function(_$OptimizationContextImpl) then,
  ) = __$$OptimizationContextImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'tracked_keywords_count') int trackedKeywordsCount,
    @JsonKey(name: 'competitors_count') int competitorsCount,
    @JsonKey(name: 'top_keywords') List<String> topKeywords,
  });
}

/// @nodoc
class __$$OptimizationContextImplCopyWithImpl<$Res>
    extends _$OptimizationContextCopyWithImpl<$Res, _$OptimizationContextImpl>
    implements _$$OptimizationContextImplCopyWith<$Res> {
  __$$OptimizationContextImplCopyWithImpl(
    _$OptimizationContextImpl _value,
    $Res Function(_$OptimizationContextImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OptimizationContext
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trackedKeywordsCount = null,
    Object? competitorsCount = null,
    Object? topKeywords = null,
  }) {
    return _then(
      _$OptimizationContextImpl(
        trackedKeywordsCount: null == trackedKeywordsCount
            ? _value.trackedKeywordsCount
            : trackedKeywordsCount // ignore: cast_nullable_to_non_nullable
                  as int,
        competitorsCount: null == competitorsCount
            ? _value.competitorsCount
            : competitorsCount // ignore: cast_nullable_to_non_nullable
                  as int,
        topKeywords: null == topKeywords
            ? _value._topKeywords
            : topKeywords // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OptimizationContextImpl implements _OptimizationContext {
  const _$OptimizationContextImpl({
    @JsonKey(name: 'tracked_keywords_count') this.trackedKeywordsCount = 0,
    @JsonKey(name: 'competitors_count') this.competitorsCount = 0,
    @JsonKey(name: 'top_keywords') final List<String> topKeywords = const [],
  }) : _topKeywords = topKeywords;

  factory _$OptimizationContextImpl.fromJson(Map<String, dynamic> json) =>
      _$$OptimizationContextImplFromJson(json);

  @override
  @JsonKey(name: 'tracked_keywords_count')
  final int trackedKeywordsCount;
  @override
  @JsonKey(name: 'competitors_count')
  final int competitorsCount;
  final List<String> _topKeywords;
  @override
  @JsonKey(name: 'top_keywords')
  List<String> get topKeywords {
    if (_topKeywords is EqualUnmodifiableListView) return _topKeywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topKeywords);
  }

  @override
  String toString() {
    return 'OptimizationContext(trackedKeywordsCount: $trackedKeywordsCount, competitorsCount: $competitorsCount, topKeywords: $topKeywords)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OptimizationContextImpl &&
            (identical(other.trackedKeywordsCount, trackedKeywordsCount) ||
                other.trackedKeywordsCount == trackedKeywordsCount) &&
            (identical(other.competitorsCount, competitorsCount) ||
                other.competitorsCount == competitorsCount) &&
            const DeepCollectionEquality().equals(
              other._topKeywords,
              _topKeywords,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    trackedKeywordsCount,
    competitorsCount,
    const DeepCollectionEquality().hash(_topKeywords),
  );

  /// Create a copy of OptimizationContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OptimizationContextImplCopyWith<_$OptimizationContextImpl> get copyWith =>
      __$$OptimizationContextImplCopyWithImpl<_$OptimizationContextImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OptimizationContextImplToJson(this);
  }
}

abstract class _OptimizationContext implements OptimizationContext {
  const factory _OptimizationContext({
    @JsonKey(name: 'tracked_keywords_count') final int trackedKeywordsCount,
    @JsonKey(name: 'competitors_count') final int competitorsCount,
    @JsonKey(name: 'top_keywords') final List<String> topKeywords,
  }) = _$OptimizationContextImpl;

  factory _OptimizationContext.fromJson(Map<String, dynamic> json) =
      _$OptimizationContextImpl.fromJson;

  @override
  @JsonKey(name: 'tracked_keywords_count')
  int get trackedKeywordsCount;
  @override
  @JsonKey(name: 'competitors_count')
  int get competitorsCount;
  @override
  @JsonKey(name: 'top_keywords')
  List<String> get topKeywords;

  /// Create a copy of OptimizationContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OptimizationContextImplCopyWith<_$OptimizationContextImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$WizardState {
  WizardStep get currentStep => throw _privateConstructorUsedError;
  String get locale => throw _privateConstructorUsedError;
  String get platform => throw _privateConstructorUsedError;
  Map<String, String> get selectedValues => throw _privateConstructorUsedError;
  Map<String, OptimizationResponse?> get suggestions =>
      throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of WizardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WizardStateCopyWith<WizardState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WizardStateCopyWith<$Res> {
  factory $WizardStateCopyWith(
    WizardState value,
    $Res Function(WizardState) then,
  ) = _$WizardStateCopyWithImpl<$Res, WizardState>;
  @useResult
  $Res call({
    WizardStep currentStep,
    String locale,
    String platform,
    Map<String, String> selectedValues,
    Map<String, OptimizationResponse?> suggestions,
    bool isLoading,
    String? error,
  });
}

/// @nodoc
class _$WizardStateCopyWithImpl<$Res, $Val extends WizardState>
    implements $WizardStateCopyWith<$Res> {
  _$WizardStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WizardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? locale = null,
    Object? platform = null,
    Object? selectedValues = null,
    Object? suggestions = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            currentStep: null == currentStep
                ? _value.currentStep
                : currentStep // ignore: cast_nullable_to_non_nullable
                      as WizardStep,
            locale: null == locale
                ? _value.locale
                : locale // ignore: cast_nullable_to_non_nullable
                      as String,
            platform: null == platform
                ? _value.platform
                : platform // ignore: cast_nullable_to_non_nullable
                      as String,
            selectedValues: null == selectedValues
                ? _value.selectedValues
                : selectedValues // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            suggestions: null == suggestions
                ? _value.suggestions
                : suggestions // ignore: cast_nullable_to_non_nullable
                      as Map<String, OptimizationResponse?>,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WizardStateImplCopyWith<$Res>
    implements $WizardStateCopyWith<$Res> {
  factory _$$WizardStateImplCopyWith(
    _$WizardStateImpl value,
    $Res Function(_$WizardStateImpl) then,
  ) = __$$WizardStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    WizardStep currentStep,
    String locale,
    String platform,
    Map<String, String> selectedValues,
    Map<String, OptimizationResponse?> suggestions,
    bool isLoading,
    String? error,
  });
}

/// @nodoc
class __$$WizardStateImplCopyWithImpl<$Res>
    extends _$WizardStateCopyWithImpl<$Res, _$WizardStateImpl>
    implements _$$WizardStateImplCopyWith<$Res> {
  __$$WizardStateImplCopyWithImpl(
    _$WizardStateImpl _value,
    $Res Function(_$WizardStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WizardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? locale = null,
    Object? platform = null,
    Object? selectedValues = null,
    Object? suggestions = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(
      _$WizardStateImpl(
        currentStep: null == currentStep
            ? _value.currentStep
            : currentStep // ignore: cast_nullable_to_non_nullable
                  as WizardStep,
        locale: null == locale
            ? _value.locale
            : locale // ignore: cast_nullable_to_non_nullable
                  as String,
        platform: null == platform
            ? _value.platform
            : platform // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedValues: null == selectedValues
            ? _value._selectedValues
            : selectedValues // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        suggestions: null == suggestions
            ? _value._suggestions
            : suggestions // ignore: cast_nullable_to_non_nullable
                  as Map<String, OptimizationResponse?>,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$WizardStateImpl extends _WizardState {
  const _$WizardStateImpl({
    required this.currentStep,
    required this.locale,
    required this.platform,
    final Map<String, String> selectedValues = const {},
    final Map<String, OptimizationResponse?> suggestions = const {},
    this.isLoading = false,
    this.error,
  }) : _selectedValues = selectedValues,
       _suggestions = suggestions,
       super._();

  @override
  final WizardStep currentStep;
  @override
  final String locale;
  @override
  final String platform;
  final Map<String, String> _selectedValues;
  @override
  @JsonKey()
  Map<String, String> get selectedValues {
    if (_selectedValues is EqualUnmodifiableMapView) return _selectedValues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_selectedValues);
  }

  final Map<String, OptimizationResponse?> _suggestions;
  @override
  @JsonKey()
  Map<String, OptimizationResponse?> get suggestions {
    if (_suggestions is EqualUnmodifiableMapView) return _suggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_suggestions);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'WizardState(currentStep: $currentStep, locale: $locale, platform: $platform, selectedValues: $selectedValues, suggestions: $suggestions, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WizardStateImpl &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            const DeepCollectionEquality().equals(
              other._selectedValues,
              _selectedValues,
            ) &&
            const DeepCollectionEquality().equals(
              other._suggestions,
              _suggestions,
            ) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    currentStep,
    locale,
    platform,
    const DeepCollectionEquality().hash(_selectedValues),
    const DeepCollectionEquality().hash(_suggestions),
    isLoading,
    error,
  );

  /// Create a copy of WizardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WizardStateImplCopyWith<_$WizardStateImpl> get copyWith =>
      __$$WizardStateImplCopyWithImpl<_$WizardStateImpl>(this, _$identity);
}

abstract class _WizardState extends WizardState {
  const factory _WizardState({
    required final WizardStep currentStep,
    required final String locale,
    required final String platform,
    final Map<String, String> selectedValues,
    final Map<String, OptimizationResponse?> suggestions,
    final bool isLoading,
    final String? error,
  }) = _$WizardStateImpl;
  const _WizardState._() : super._();

  @override
  WizardStep get currentStep;
  @override
  String get locale;
  @override
  String get platform;
  @override
  Map<String, String> get selectedValues;
  @override
  Map<String, OptimizationResponse?> get suggestions;
  @override
  bool get isLoading;
  @override
  String? get error;

  /// Create a copy of WizardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WizardStateImplCopyWith<_$WizardStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
