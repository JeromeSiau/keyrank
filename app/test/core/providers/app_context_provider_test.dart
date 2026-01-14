import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyrank/core/providers/app_context_provider.dart';
import 'package:keyrank/features/apps/domain/app_model.dart';

void main() {
  group('AppContextNotifier', () {
    test('initial state is null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(appContextProvider);
      expect(state, isNull);
    });

    test('select sets the app', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final app = AppModel(
        id: 1,
        platform: 'ios',
        storeId: '123',
        name: 'Test App',
        iconUrl: 'https://example.com/icon.png',
        developer: 'Test Dev',
        ratingCount: 0,
        createdAt: DateTime.now(),
      );

      container.read(appContextProvider.notifier).select(app);
      expect(container.read(appContextProvider), equals(app));
    });

    test('clear sets state to null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final app = AppModel(
        id: 1,
        platform: 'ios',
        storeId: '123',
        name: 'Test App',
        iconUrl: 'https://example.com/icon.png',
        developer: 'Test Dev',
        ratingCount: 0,
        createdAt: DateTime.now(),
      );

      container.read(appContextProvider.notifier).select(app);
      container.read(appContextProvider.notifier).clear();
      expect(container.read(appContextProvider), isNull);
    });
  });
}
