import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../domain/category_model.dart';

final categoriesRepositoryProvider = Provider<CategoriesRepository>((ref) {
  return CategoriesRepository(dio: ref.watch(dioProvider));
});

class CategoriesRepository {
  final Dio dio;

  CategoriesRepository({required this.dio});

  Future<CategoriesResponse> getCategories() async {
    final response = await dio.get('/categories');
    final data = response.data['data'] as Map<String, dynamic>;
    return CategoriesResponse.fromJson(data);
  }

  Future<List<TopApp>> getTopApps({
    required String categoryId,
    required String platform,
    required String country,
    required String collection,
    int limit = 100,
  }) async {
    final response = await dio.get(
      '/categories/$categoryId/top',
      queryParameters: {
        'platform': platform,
        'country': country,
        'collection': collection,
        'limit': limit,
      },
    );
    final data = response.data['data'] as Map<String, dynamic>;
    final results = data['results'] as List;
    return results
        .map((e) => TopApp.fromJson(e as Map<String, dynamic>, platform))
        .toList();
  }
}
