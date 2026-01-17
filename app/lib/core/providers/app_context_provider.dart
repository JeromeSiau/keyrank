import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/apps/domain/app_model.dart';
import 'theme_provider.dart';

const _kRememberAppContextKey = 'remember_app_context';
const _kSelectedAppIdKey = 'selected_app_id';

/// Whether to remember the selected app context across sessions.
final rememberAppContextProvider = StateNotifierProvider<RememberAppContextNotifier, bool>((ref) {
  SharedPreferences? prefs;
  try {
    prefs = ref.watch(sharedPreferencesProvider);
  } catch (_) {
    // SharedPreferences not initialized (e.g., in tests)
  }
  return RememberAppContextNotifier(prefs);
});

class RememberAppContextNotifier extends StateNotifier<bool> {
  final SharedPreferences? _prefs;

  RememberAppContextNotifier(this._prefs)
      : super(_prefs?.getBool(_kRememberAppContextKey) ?? false);

  Future<void> setRemember(bool value) async {
    state = value;
    await _prefs?.setBool(_kRememberAppContextKey, value);
  }
}

/// The currently selected app context. When null, shows data for all apps.
final appContextProvider = StateNotifierProvider<AppContextNotifier, AppModel?>((ref) {
  SharedPreferences? prefs;
  try {
    prefs = ref.watch(sharedPreferencesProvider);
  } catch (_) {
    // SharedPreferences not initialized (e.g., in tests)
  }
  final rememberContext = ref.watch(rememberAppContextProvider);
  return AppContextNotifier(prefs, rememberContext);
});

class AppContextNotifier extends StateNotifier<AppModel?> {
  final SharedPreferences? _prefs;
  final bool _rememberContext;
  bool _hasRestored = false;

  AppContextNotifier(this._prefs, this._rememberContext) : super(null);

  /// Get the persisted app ID (if remember is enabled).
  int? get persistedAppId {
    if (!_rememberContext || _prefs == null) return null;
    return _prefs!.getInt(_kSelectedAppIdKey);
  }

  /// Whether the context has already been restored from persistence.
  bool get hasRestored => _hasRestored;

  void select(AppModel? app) {
    state = app;
    _persistIfEnabled(app);
  }

  void clear() {
    state = null;
    _persistIfEnabled(null);
  }

  /// Restore the app context from a list of loaded apps.
  /// Should be called once when apps are first loaded.
  void restoreFromApps(List<AppModel> apps) {
    if (_hasRestored || !_rememberContext) return;
    _hasRestored = true;

    final persistedId = persistedAppId;
    if (persistedId == null) return;

    final app = apps.where((a) => a.id == persistedId).firstOrNull;
    if (app != null) {
      state = app;
    }
  }

  Future<void> _persistIfEnabled(AppModel? app) async {
    if (!_rememberContext || _prefs == null) return;

    if (app != null) {
      await _prefs!.setInt(_kSelectedAppIdKey, app.id);
    } else {
      await _prefs!.remove(_kSelectedAppIdKey);
    }
  }
}
