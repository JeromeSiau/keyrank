import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/locale_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/fcm_service.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/domain/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDateFormatting();
  final prefs = await SharedPreferences.getInstance();

  // Create container to initialize FCM after auth
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
  );

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  bool _hasLoadedPreferences = false;
  bool _hasFcmInitialized = false;
  DateTime? _pausedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _pausedAt = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      _checkSessionOnResume();
    }
  }

  void _checkSessionOnResume() {
    if (_pausedAt == null) return;

    final pauseDuration = DateTime.now().difference(_pausedAt!);
    _pausedAt = null;

    // If app was in background for more than 30 minutes, refresh auth state
    if (pauseDuration.inMinutes >= 30) {
      final authState = ref.read(authStateProvider);
      if (authState.valueOrNull != null) {
        // Trigger a re-check of auth state by invalidating the provider
        ref.invalidate(authStateProvider);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    // Load user preferences and initialize FCM when authenticated
    ref.listen<AsyncValue<User?>>(authStateProvider, (previous, next) {
      final wasAuthenticated = previous?.valueOrNull != null;
      final isAuthenticated = next.valueOrNull != null;

      if (!wasAuthenticated && isAuthenticated && !_hasLoadedPreferences) {
        _hasLoadedPreferences = true;
        ref.read(localeProvider.notifier).loadFromBackend();

        // Initialize FCM for push notifications
        if (!_hasFcmInitialized) {
          _hasFcmInitialized = true;
          ref.read(fcmServiceProvider).initialize();
        }
      } else if (wasAuthenticated && !isAuthenticated) {
        _hasLoadedPreferences = false;
      }
    });

    return MaterialApp.router(
      title: 'keyrank.app',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: supportedLocales,
    );
  }
}
