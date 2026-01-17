import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/apps_repository.dart';
import '../domain/app_model.dart';

/// Provider for fetching app preview data from store
/// Uses autoDispose to release memory when navigating away from preview screen
final appPreviewProvider = FutureProvider.autoDispose.family<AppPreview, ({String platform, String storeId})>(
  (ref, params) async {
    final repository = ref.watch(appsRepositoryProvider);
    return repository.getAppPreview(
      platform: params.platform,
      storeId: params.storeId,
    );
  },
);
