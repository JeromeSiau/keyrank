import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../domain/metadata_model.dart';
import '../domain/optimization_model.dart';

final metadataRepositoryProvider = Provider<MetadataRepository>((ref) {
  return MetadataRepository(dio: ref.watch(dioProvider));
});

class MetadataRepository {
  final Dio dio;

  MetadataRepository({required this.dio});

  /// Get metadata for all locales of an app
  Future<AppMetadataResponse> getMetadata(int appId) async {
    try {
      final response = await dio.get('${ApiConstants.apps}/$appId/metadata');
      return AppMetadataResponse.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get metadata for a specific locale with keyword analysis
  Future<MetadataLocaleDetail> getLocaleMetadata(
      int appId, String locale) async {
    try {
      final response =
          await dio.get('${ApiConstants.apps}/$appId/metadata/$locale');
      return MetadataLocaleDetail.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Save draft metadata for a locale
  Future<MetadataDraft> saveDraft({
    required int appId,
    required String locale,
    String? title,
    String? subtitle,
    String? keywords,
    String? description,
    String? promotionalText,
    String? whatsNew,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (title != null) data['title'] = title;
      if (subtitle != null) data['subtitle'] = subtitle;
      if (keywords != null) data['keywords'] = keywords;
      if (description != null) data['description'] = description;
      if (promotionalText != null) data['promotional_text'] = promotionalText;
      if (whatsNew != null) data['whats_new'] = whatsNew;

      final response = await dio.put(
        '${ApiConstants.apps}/$appId/metadata/$locale',
        data: data,
      );
      return MetadataDraft.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Publish metadata drafts to the store
  Future<PublishResult> publishMetadata({
    required int appId,
    required List<String> locales,
  }) async {
    try {
      final response = await dio.post(
        '${ApiConstants.apps}/$appId/metadata/publish',
        data: {'locales': locales},
      );
      return PublishResult.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Refresh metadata from App Store Connect
  Future<RefreshResult> refreshMetadata(int appId) async {
    try {
      final response =
          await dio.post('${ApiConstants.apps}/$appId/metadata/refresh');
      return RefreshResult.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Get metadata change history
  Future<List<MetadataHistoryEntry>> getHistory(int appId) async {
    try {
      final response =
          await dio.get('${ApiConstants.apps}/$appId/metadata/history');
      final data = response.data['data'] as List;
      return data
          .map((e) => MetadataHistoryEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Delete a draft for a locale
  Future<void> deleteDraft(int appId, String locale) async {
    try {
      await dio.delete('${ApiConstants.apps}/$appId/metadata/$locale/draft');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Copy locale content to other locales
  Future<CopyLocaleResult> copyLocale({
    required int appId,
    required String sourceLocale,
    required List<String> targetLocales,
    List<String>? fields,
  }) async {
    try {
      final data = <String, dynamic>{
        'source_locale': sourceLocale,
        'target_locales': targetLocales,
      };
      if (fields != null) {
        data['fields'] = fields;
      }

      final response = await dio.post(
        '${ApiConstants.apps}/$appId/metadata/copy',
        data: data,
      );
      return CopyLocaleResult.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Translate locale content to other locales using AI
  Future<TranslateLocaleResult> translateLocale({
    required int appId,
    required String sourceLocale,
    required List<String> targetLocales,
    List<String>? fields,
  }) async {
    try {
      final data = <String, dynamic>{
        'source_locale': sourceLocale,
        'target_locales': targetLocales,
      };
      if (fields != null) {
        data['fields'] = fields;
      }

      final response = await dio.post(
        '${ApiConstants.apps}/$appId/metadata/translate',
        data: data,
      );
      return TranslateLocaleResult.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}

class PublishResult {
  final Map<String, LocalePublishResult> results;
  final List<String> errors;
  final String message;

  PublishResult({
    required this.results,
    required this.errors,
    required this.message,
  });

  factory PublishResult.fromJson(Map<String, dynamic> json) {
    final resultsMap = <String, LocalePublishResult>{};
    final dataResults = json['data']?['results'] as Map<String, dynamic>? ?? {};
    for (final entry in dataResults.entries) {
      resultsMap[entry.key] = LocalePublishResult.fromJson(
          entry.value as Map<String, dynamic>);
    }

    return PublishResult(
      results: resultsMap,
      errors: (json['data']?['errors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      message: json['message'] as String? ?? '',
    );
  }

  bool get isSuccess => errors.isEmpty;
  int get successCount => results.values.where((r) => r.success).length;
  int get failureCount => results.values.where((r) => !r.success).length;
}

class LocalePublishResult {
  final bool success;
  final List<String> errors;

  LocalePublishResult({
    required this.success,
    this.errors = const [],
  });

  factory LocalePublishResult.fromJson(Map<String, dynamic> json) {
    return LocalePublishResult(
      success: json['success'] as bool? ?? false,
      errors: (json['errors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}

class RefreshResult {
  final int localesUpdated;
  final List<String> locales;

  RefreshResult({
    required this.localesUpdated,
    required this.locales,
  });

  factory RefreshResult.fromJson(Map<String, dynamic> json) {
    return RefreshResult(
      localesUpdated: json['locales_updated'] as int? ?? 0,
      locales: (json['locales'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}

class CopyLocaleResult {
  final String sourceLocale;
  final Map<String, LocaleCopyResult> results;
  final List<String> copiedFields;
  final String message;

  CopyLocaleResult({
    required this.sourceLocale,
    required this.results,
    required this.copiedFields,
    required this.message,
  });

  factory CopyLocaleResult.fromJson(Map<String, dynamic> json) {
    final resultsMap = <String, LocaleCopyResult>{};
    final dataResults =
        json['data']?['results'] as Map<String, dynamic>? ?? {};
    for (final entry in dataResults.entries) {
      resultsMap[entry.key] =
          LocaleCopyResult.fromJson(entry.value as Map<String, dynamic>);
    }

    return CopyLocaleResult(
      sourceLocale: json['data']?['source_locale'] as String? ?? '',
      results: resultsMap,
      copiedFields: (json['data']?['copied_fields'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      message: json['message'] as String? ?? '',
    );
  }

  int get successCount => results.values.where((r) => r.success).length;
}

class LocaleCopyResult {
  final bool success;
  final int? draftId;

  LocaleCopyResult({
    required this.success,
    this.draftId,
  });

  factory LocaleCopyResult.fromJson(Map<String, dynamic> json) {
    return LocaleCopyResult(
      success: json['success'] as bool? ?? false,
      draftId: json['draft_id'] as int?,
    );
  }
}

class TranslateLocaleResult {
  final String sourceLocale;
  final Map<String, LocaleTranslateResult> results;
  final List<String> errors;
  final String message;

  TranslateLocaleResult({
    required this.sourceLocale,
    required this.results,
    required this.errors,
    required this.message,
  });

  factory TranslateLocaleResult.fromJson(Map<String, dynamic> json) {
    final resultsMap = <String, LocaleTranslateResult>{};
    final dataResults =
        json['data']?['results'] as Map<String, dynamic>? ?? {};
    for (final entry in dataResults.entries) {
      resultsMap[entry.key] =
          LocaleTranslateResult.fromJson(entry.value as Map<String, dynamic>);
    }

    return TranslateLocaleResult(
      sourceLocale: json['data']?['source_locale'] as String? ?? '',
      results: resultsMap,
      errors: (json['data']?['errors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      message: json['message'] as String? ?? '',
    );
  }

  bool get hasErrors => errors.isNotEmpty;
  int get successCount => results.values.where((r) => r.success).length;
}

class LocaleTranslateResult {
  final bool success;
  final int? draftId;
  final List<String> translatedFields;
  final String? error;

  LocaleTranslateResult({
    required this.success,
    this.draftId,
    this.translatedFields = const [],
    this.error,
  });

  factory LocaleTranslateResult.fromJson(Map<String, dynamic> json) {
    return LocaleTranslateResult(
      success: json['success'] as bool? ?? false,
      draftId: json['draft_id'] as int?,
      translatedFields: (json['translated_fields'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      error: json['error'] as String?,
    );
  }
}

extension MetadataRepositoryOptimization on MetadataRepository {
  /// Get AI-generated optimization suggestions for a metadata field
  Future<OptimizationResponse> getOptimizationSuggestions({
    required int appId,
    required String locale,
    required String field,
  }) async {
    try {
      final response = await dio.post(
        '${ApiConstants.apps}/$appId/metadata/optimize',
        data: {
          'locale': locale,
          'field': field,
        },
      );
      return OptimizationResponse.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
