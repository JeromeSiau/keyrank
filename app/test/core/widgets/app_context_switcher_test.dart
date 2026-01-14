import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyrank/core/widgets/app_context_switcher.dart';
import 'package:keyrank/core/theme/app_theme.dart';
import 'package:keyrank/core/providers/app_context_provider.dart';
import 'package:keyrank/features/apps/providers/apps_provider.dart';
import 'package:keyrank/features/apps/domain/app_model.dart';

void main() {
  Widget buildTestWidget({List<Override> overrides = const []}) {
    return ProviderScope(
      overrides: [
        // Override the appsNotifierProvider state directly
        appsNotifierProvider.overrideWith((ref) {
          return _TestAppsNotifier();
        }),
        ...overrides,
      ],
      child: MaterialApp(
        theme: AppTheme.darkTheme,
        home: const Scaffold(body: AppContextSwitcher()),
      ),
    );
  }

  testWidgets('displays "All apps" when no app selected', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('All apps'), findsOneWidget);
  });

  testWidgets('displays dropdown arrow icon', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
  });

  testWidgets('displays selected app name when app is selected', (tester) async {
    final testApp = AppModel(
      id: 1,
      platform: 'ios',
      storeId: '123',
      name: 'Test App',
      iconUrl: 'https://example.com/icon.png',
      developer: 'Test Dev',
      ratingCount: 0,
      createdAt: DateTime.now(),
    );

    await tester.pumpWidget(buildTestWidget(
      overrides: [
        appContextProvider.overrideWith((ref) {
          final notifier = AppContextNotifier(null, false);
          notifier.select(testApp);
          return notifier;
        }),
      ],
    ));
    await tester.pumpAndSettle();

    expect(find.text('Test App'), findsOneWidget);
    expect(find.text('All apps'), findsNothing);
  });
}

/// Test notifier that returns empty list immediately
class _TestAppsNotifier extends StateNotifier<AsyncValue<List<AppModel>>>
    implements AppsNotifier {
  _TestAppsNotifier() : super(const AsyncValue.data([]));

  @override
  Future<void> load() async {
    state = const AsyncValue.data([]);
  }

  @override
  Future<AppModel> addApp({
    required String platform,
    required String storeId,
    String country = 'us',
  }) async =>
      throw UnimplementedError();

  @override
  Future<void> deleteApp(int id) async {}

  @override
  Future<void> toggleFavorite(int appId) async {}
}
