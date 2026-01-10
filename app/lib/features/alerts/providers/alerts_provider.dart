import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/alerts_repository.dart';
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
