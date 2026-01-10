import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';

const supportedLocales = [
  Locale('en'),
  Locale('fr'),
  Locale('de'),
  Locale('es'),
  Locale('pt'),
  Locale('it'),
  Locale('ja'),
  Locale('ko'),
  Locale('zh'),
  Locale('tr'),
];

const localeNames = {
  'system': 'System',
  'en': 'English',
  'fr': 'Français',
  'de': 'Deutsch',
  'es': 'Español',
  'pt': 'Português',
  'it': 'Italiano',
  'ja': '日本語',
  'ko': '한국어',
  'zh': '中文',
  'tr': 'Türkçe',
};

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier(ref);
});

final localePreferenceProvider = StateProvider<String>((ref) => 'system');

class LocaleNotifier extends StateNotifier<Locale?> {
  final Ref _ref;

  LocaleNotifier(this._ref) : super(null);

  void init(String? savedPreference) {
    final preference = savedPreference ?? 'system';
    _ref.read(localePreferenceProvider.notifier).state = preference;
    _updateLocale(preference);
  }

  /// Load locale preference from backend (call after login)
  Future<void> loadFromBackend() async {
    try {
      final dio = _ref.read(dioProvider);
      final response = await dio.get('/user/preferences');
      final locale = response.data['data']['locale'] as String?;
      if (locale != null) {
        _ref.read(localePreferenceProvider.notifier).state = locale;
        _updateLocale(locale);
      }
    } catch (_) {
      // Silently fail - use local preference
    }
  }

  void _updateLocale(String preference) {
    if (preference == 'system') {
      state = _getSystemLocale();
    } else {
      state = Locale(preference);
    }
  }

  Locale _getSystemLocale() {
    final systemLocale = Platform.localeName.split('_').first;
    final supported = supportedLocales.map((l) => l.languageCode).toList();
    if (supported.contains(systemLocale)) {
      return Locale(systemLocale);
    }
    return const Locale('en');
  }

  Future<void> setLocale(String localeCode) async {
    _ref.read(localePreferenceProvider.notifier).state = localeCode;
    _updateLocale(localeCode);

    // Save to backend (null for system to clear preference)
    try {
      final dio = _ref.read(dioProvider);
      final backendLocale = localeCode == 'system' ? null : localeCode;
      await dio.put('/user/preferences', data: {'locale': backendLocale});
    } catch (_) {
      // Silently fail - locale is already applied locally
    }
  }
}
