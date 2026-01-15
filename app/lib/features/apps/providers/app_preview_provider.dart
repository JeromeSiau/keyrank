import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/apps_repository.dart';
import '../domain/app_model.dart';

/// Provider for fetching app preview data from store
final appPreviewProvider = FutureProvider.family<AppPreview, ({String platform, String storeId})>(
  (ref, params) async {
    final repository = ref.watch(appsRepositoryProvider);
    return repository.getAppPreview(
      platform: params.platform,
      storeId: params.storeId,
    );
  },
);
