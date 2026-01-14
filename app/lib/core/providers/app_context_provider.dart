import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/apps/domain/app_model.dart';

final appContextProvider = StateNotifierProvider<AppContextNotifier, AppModel?>((ref) {
  return AppContextNotifier();
});

class AppContextNotifier extends StateNotifier<AppModel?> {
  AppContextNotifier() : super(null);

  void select(AppModel? app) {
    state = app;
  }

  void clear() {
    state = null;
  }
}
