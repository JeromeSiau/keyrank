import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:keyrank/l10n/app_localizations.dart';
import 'package:keyrank/core/theme/app_theme.dart';
import 'package:keyrank/features/auth/presentation/login_screen.dart';
import 'package:keyrank/features/auth/providers/auth_provider.dart';
import 'package:keyrank/features/auth/domain/user_model.dart';
import 'package:keyrank/features/auth/data/auth_repository.dart';

/// Fake AuthRepository that returns null user (logged out state)
class FakeAuthRepository extends AuthRepository {
  FakeAuthRepository() : super(dio: Dio(), storage: const FlutterSecureStorage());

  @override
  Future<User?> getCurrentUser() async => null;

  @override
  Future<AuthResponse> login({required String email, required String password}) async {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {}
}

void main() {
  Widget buildTestWidget(Widget child, {List<Override> overrides = const []}) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: AppTheme.darkTheme,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        locale: const Locale('en'),
        home: child,
      ),
    );
  }

  testWidgets('Login screen renders', (WidgetTester tester) async {
    // Set a larger surface size to avoid overflow errors
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(buildTestWidget(
      const LoginScreen(),
      overrides: [
        authStateProvider.overrideWith((ref) => AuthNotifier(FakeAuthRepository())),
      ],
    ));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
  });
}
