import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/billing_repository.dart';
import '../domain/billing_models.dart';

/// Current subscription status
final subscriptionStatusProvider = FutureProvider<SubscriptionStatus>((ref) async {
  final repository = ref.watch(billingRepositoryProvider);
  return repository.getStatus();
});

/// Available plans
final availablePlansProvider = FutureProvider<List<SubscriptionPlan>>((ref) async {
  final repository = ref.watch(billingRepositoryProvider);
  return repository.getPlans();
});

/// Billing state notifier for actions
final billingActionsProvider = StateNotifierProvider<BillingActionsNotifier, AsyncValue<void>>((ref) {
  return BillingActionsNotifier(ref);
});

class BillingActionsNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  BillingActionsNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<String?> checkout({
    required String plan,
    required String billingPeriod,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(billingRepositoryProvider);
      final response = await repository.checkout(
        plan: plan,
        billingPeriod: billingPeriod,
      );
      state = const AsyncValue.data(null);
      return response.checkoutUrl;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<String?> getPortalUrl() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(billingRepositoryProvider);
      final response = await repository.getPortalUrl();
      state = const AsyncValue.data(null);
      return response.portalUrl;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<bool> cancel() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(billingRepositoryProvider);
      await repository.cancel();
      ref.invalidate(subscriptionStatusProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> resume() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(billingRepositoryProvider);
      await repository.resume();
      ref.invalidate(subscriptionStatusProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  void refresh() {
    ref.invalidate(subscriptionStatusProvider);
  }
}
