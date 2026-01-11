import 'package:dio/dio.dart';
import '../domain/hero_metrics.dart';
import '../domain/ranking_mover.dart';

class DashboardRepository {
  final Dio _dio;

  DashboardRepository(this._dio);

  Future<HeroMetrics> getHeroMetrics() async {
    final response = await _dio.get('/dashboard/metrics');
    return HeroMetrics.fromJson(response.data['data']);
  }

  Future<RankingMoversData> getRankingMovers({String period = '7d'}) async {
    final response = await _dio.get(
      '/dashboard/movers',
      queryParameters: {'period': period},
    );
    return RankingMoversData.fromJson(response.data['data']);
  }
}
