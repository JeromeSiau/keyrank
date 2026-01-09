import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../domain/tag_model.dart';

final tagsRepositoryProvider = Provider<TagsRepository>((ref) {
  return TagsRepository(dio: ref.watch(dioProvider));
});

class TagsRepository {
  final Dio dio;

  TagsRepository({required this.dio});

  Future<List<TagModel>> getTags() async {
    try {
      final response = await dio.get('/tags');
      final data = response.data['data'] as List;
      return data.map((e) => TagModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<TagModel> createTag({
    required String name,
    required String color,
  }) async {
    try {
      final response = await dio.post('/tags', data: {
        'name': name,
        'color': color,
      });
      return TagModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> deleteTag(int id) async {
    try {
      await dio.delete('/tags/$id');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> addTagToKeyword({
    required int tagId,
    required int trackedKeywordId,
  }) async {
    try {
      await dio.post('/tags/add-to-keyword', data: {
        'tag_id': tagId,
        'tracked_keyword_id': trackedKeywordId,
      });
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> removeTagFromKeyword({
    required int tagId,
    required int trackedKeywordId,
  }) async {
    try {
      await dio.post('/tags/remove-from-keyword', data: {
        'tag_id': tagId,
        'tracked_keyword_id': trackedKeywordId,
      });
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
