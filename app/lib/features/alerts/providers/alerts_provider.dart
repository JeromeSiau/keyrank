import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/alerts_repository.dart';
import '../domain/alert_preferences_model.dart';
import '../domain/alert_rule_model.dart';

/// Templates provider - cached, rarely changes
final alertTemplatesProvider = FutureProvider<List<AlertTemplateModel>>((ref) async {
  return ref.watch(alertsRepositoryProvider).getTemplates();
});

/// Alert rules state notifier
class AlertRulesNotifier extends StateNotifier<AsyncValue<List<AlertRuleModel>>> {
  final AlertsRepository _repository;

  AlertRulesNotifier(this._repository) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final rules = await _repository.getRules();
      state = AsyncValue.data(rules);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createFromTemplate(AlertTemplateModel template) async {
    final rule = await _repository.createRule(
      name: template.name,
      type: template.type,
      scopeType: 'global',
      conditions: template.defaultConditions,
    );
    state = state.whenData((rules) => [...rules, rule]);
  }

  Future<void> createCustomRule({
    required String name,
    required String type,
    required String scopeType,
    int? scopeId,
    required Map<String, dynamic> conditions,
  }) async {
    final rule = await _repository.createRule(
      name: name,
      type: type,
      scopeType: scopeType,
      scopeId: scopeId,
      conditions: conditions,
    );
    state = state.whenData((rules) => [...rules, rule]);
  }

  Future<void> toggle(int id) async {
    await _repository.toggleRule(id);
    state = state.whenData((rules) {
      return rules.map((r) {
        if (r.id == id) {
          return r.copyWith(isActive: !r.isActive);
        }
        return r;
      }).toList();
    });
  }

  Future<void> updateConditions(int id, Map<String, dynamic> conditions) async {
    final updated = await _repository.updateRule(id, conditions: conditions);
    state = state.whenData((rules) {
      return rules.map((r) => r.id == id ? updated : r).toList();
    });
  }

  Future<void> delete(int id) async {
    await _repository.deleteRule(id);
    state = state.whenData((rules) => rules.where((r) => r.id != id).toList());
  }
}

final alertRulesNotifierProvider =
    StateNotifierProvider<AlertRulesNotifier, AsyncValue<List<AlertRuleModel>>>((ref) {
  return AlertRulesNotifier(ref.watch(alertsRepositoryProvider));
});

// ============================================
// Alert Preferences (Email/Push/Digest settings)
// ============================================

/// Alert types provider - cached
final alertTypesProvider = FutureProvider<List<AlertTypeInfo>>((ref) async {
  return ref.watch(alertsRepositoryProvider).getAlertTypes();
});

/// Alert preferences state notifier
class AlertPreferencesNotifier extends StateNotifier<AsyncValue<AlertPreferences>> {
  final AlertsRepository _repository;

  AlertPreferencesNotifier(this._repository) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final prefs = await _repository.getPreferences();
      state = AsyncValue.data(prefs);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> setEmailNotificationsEnabled(bool enabled) async {
    final current = state.valueOrNull;
    if (current == null) return;

    // Optimistic update
    state = AsyncValue.data(current.copyWith(emailNotificationsEnabled: enabled));

    try {
      final updated = await _repository.updatePreferences(emailNotificationsEnabled: enabled);
      state = AsyncValue.data(updated);
    } catch (e, st) {
      // Revert on error
      state = AsyncValue.data(current);
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateDeliveryForType(String alertType, AlertDelivery delivery) async {
    final current = state.valueOrNull;
    if (current == null) return;

    // Optimistic update
    final newDeliveryByType = Map<String, AlertDelivery>.from(current.deliveryByType);
    newDeliveryByType[alertType] = delivery;
    state = AsyncValue.data(current.copyWith(deliveryByType: newDeliveryByType));

    try {
      final updated = await _repository.updatePreferences(
        deliveryByType: {alertType: delivery},
      );
      state = AsyncValue.data(updated);
    } catch (e, st) {
      // Revert on error
      state = AsyncValue.data(current);
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> setDigestTime(String time) async {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncValue.data(current.copyWith(digestTime: time));

    try {
      final updated = await _repository.updatePreferences(digestTime: time);
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.data(current);
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> setWeeklyDigestDay(String day) async {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncValue.data(current.copyWith(weeklyDigestDay: day));

    try {
      final updated = await _repository.updatePreferences(weeklyDigestDay: day);
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.data(current);
      state = AsyncValue.error(e, st);
    }
  }
}

final alertPreferencesNotifierProvider =
    StateNotifierProvider<AlertPreferencesNotifier, AsyncValue<AlertPreferences>>((ref) {
  return AlertPreferencesNotifier(ref.watch(alertsRepositoryProvider));
});
