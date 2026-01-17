import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/metadata_repository.dart';
import '../domain/metadata_model.dart';
import '../domain/optimization_model.dart';

/// Provider for app metadata (all locales)
final appMetadataProvider =
    FutureProvider.family<AppMetadataResponse, int>((ref, appId) async {
  final repository = ref.watch(metadataRepositoryProvider);
  return repository.getMetadata(appId);
});

/// Provider for locale-specific metadata with keyword analysis
final localeMetadataProvider =
    FutureProvider.family<MetadataLocaleDetail, LocaleMetadataParams>(
        (ref, params) async {
  final repository = ref.watch(metadataRepositoryProvider);
  return repository.getLocaleMetadata(params.appId, params.locale);
});

class LocaleMetadataParams {
  final int appId;
  final String locale;

  LocaleMetadataParams({required this.appId, required this.locale});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocaleMetadataParams &&
          runtimeType == other.runtimeType &&
          appId == other.appId &&
          locale == other.locale;

  @override
  int get hashCode => appId.hashCode ^ locale.hashCode;
}

/// Provider for metadata history
final metadataHistoryProvider =
    FutureProvider.family<List<MetadataHistoryEntry>, int>((ref, appId) async {
  final repository = ref.watch(metadataRepositoryProvider);
  return repository.getHistory(appId);
});

/// Notifier for editing metadata
class MetadataEditorNotifier extends StateNotifier<MetadataEditorState> {
  final MetadataRepository _repository;
  final int appId;
  final String locale;

  MetadataEditorNotifier({
    required MetadataRepository repository,
    required this.appId,
    required this.locale,
    MetadataContent? initialContent,
    MetadataLimits? limits,
  })  : _repository = repository,
        super(MetadataEditorState(
          content: initialContent ?? MetadataContent(),
          limits: limits ?? MetadataLimits(),
        ));

  void updateTitle(String value) {
    state = state.copyWith(
      content: state.content.copyWith(title: value),
      isDirty: true,
    );
  }

  void updateSubtitle(String value) {
    state = state.copyWith(
      content: state.content.copyWith(subtitle: value),
      isDirty: true,
    );
  }

  void updateKeywords(String value) {
    state = state.copyWith(
      content: state.content.copyWith(keywords: value),
      isDirty: true,
    );
  }

  void updateDescription(String value) {
    state = state.copyWith(
      content: state.content.copyWith(description: value),
      isDirty: true,
    );
  }

  void updatePromotionalText(String value) {
    state = state.copyWith(
      content: state.content.copyWith(promotionalText: value),
      isDirty: true,
    );
  }

  void updateWhatsNew(String value) {
    state = state.copyWith(
      content: state.content.copyWith(whatsNew: value),
      isDirty: true,
    );
  }

  Future<bool> saveDraft() async {
    if (!state.isDirty) return true;

    state = state.copyWith(isSaving: true, error: null);

    try {
      await _repository.saveDraft(
        appId: appId,
        locale: locale,
        title: state.content.title,
        subtitle: state.content.subtitle,
        keywords: state.content.keywords,
        description: state.content.description,
        promotionalText: state.content.promotionalText,
        whatsNew: state.content.whatsNew,
      );

      state = state.copyWith(
        isSaving: false,
        isDirty: false,
        lastSavedAt: DateTime.now(),
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );
      return false;
    }
  }

  void resetToLive(MetadataContent? liveContent) {
    if (liveContent != null) {
      state = state.copyWith(
        content: liveContent,
        isDirty: false,
      );
    }
  }
}

class MetadataEditorState {
  final MetadataContent content;
  final MetadataLimits limits;
  final bool isDirty;
  final bool isSaving;
  final String? error;
  final DateTime? lastSavedAt;

  MetadataEditorState({
    required this.content,
    required this.limits,
    this.isDirty = false,
    this.isSaving = false,
    this.error,
    this.lastSavedAt,
  });

  MetadataEditorState copyWith({
    MetadataContent? content,
    MetadataLimits? limits,
    bool? isDirty,
    bool? isSaving,
    String? error,
    DateTime? lastSavedAt,
  }) {
    return MetadataEditorState(
      content: content ?? this.content,
      limits: limits ?? this.limits,
      isDirty: isDirty ?? this.isDirty,
      isSaving: isSaving ?? this.isSaving,
      error: error,
      lastSavedAt: lastSavedAt ?? this.lastSavedAt,
    );
  }

  /// Validation errors
  Map<String, String> get validationErrors {
    final errors = <String, String>{};

    if ((content.title?.length ?? 0) > limits.title) {
      errors['title'] = 'Title exceeds ${limits.title} characters';
    }
    if ((content.subtitle?.length ?? 0) > limits.subtitle) {
      errors['subtitle'] = 'Subtitle exceeds ${limits.subtitle} characters';
    }
    if ((content.keywords?.length ?? 0) > limits.keywords) {
      errors['keywords'] = 'Keywords exceed ${limits.keywords} characters';
    }
    if ((content.description?.length ?? 0) > limits.description) {
      errors['description'] =
          'Description exceeds ${limits.description} characters';
    }
    if ((content.promotionalText?.length ?? 0) > limits.promotionalText) {
      errors['promotionalText'] =
          'Promotional text exceeds ${limits.promotionalText} characters';
    }
    if ((content.whatsNew?.length ?? 0) > limits.whatsNew) {
      errors['whatsNew'] = 'What\'s New exceeds ${limits.whatsNew} characters';
    }

    return errors;
  }

  bool get isValid => validationErrors.isEmpty;
}

/// Provider family for editor state per locale
final metadataEditorProvider = StateNotifierProvider.family<
    MetadataEditorNotifier, MetadataEditorState, LocaleMetadataParams>(
  (ref, params) {
    final repository = ref.watch(metadataRepositoryProvider);
    return MetadataEditorNotifier(
      repository: repository,
      appId: params.appId,
      locale: params.locale,
    );
  },
);

/// Provider for publishing metadata
final publishMetadataProvider =
    FutureProvider.family<PublishResult, PublishParams>((ref, params) async {
  final repository = ref.watch(metadataRepositoryProvider);
  return repository.publishMetadata(
    appId: params.appId,
    locales: params.locales,
  );
});

class PublishParams {
  final int appId;
  final List<String> locales;

  PublishParams({required this.appId, required this.locales});
}

/// Provider for refreshing metadata from ASC
final refreshMetadataProvider =
    FutureProvider.family<RefreshResult, int>((ref, appId) async {
  final repository = ref.watch(metadataRepositoryProvider);
  return repository.refreshMetadata(appId);
});

/// Selected locale state (for editing)
final selectedLocaleProvider = StateProvider<String?>((ref) => null);

/// Filter state for multi-locale view
enum MetadataFilter { all, live, draft, empty }

final metadataFilterProvider = StateProvider<MetadataFilter>((ref) => MetadataFilter.all);

/// Selected locales for bulk actions
class SelectedLocalesNotifier extends StateNotifier<Set<String>> {
  SelectedLocalesNotifier() : super({});

  void add(String locale) {
    state = {...state, locale};
  }

  void remove(String locale) {
    state = {...state}..remove(locale);
  }

  void addAll(List<String> locales) {
    state = {...state, ...locales};
  }

  void clear() {
    state = {};
  }

  void toggle(String locale) {
    if (state.contains(locale)) {
      remove(locale);
    } else {
      add(locale);
    }
  }
}

final selectedLocalesProvider =
    StateNotifierProvider<SelectedLocalesNotifier, Set<String>>((ref) {
  return SelectedLocalesNotifier();
});

// ============================================================================
// AI Optimization Wizard Providers
// ============================================================================

/// Parameters for optimization suggestions request
class OptimizationParams {
  final int appId;
  final String locale;
  final String field;

  OptimizationParams({
    required this.appId,
    required this.locale,
    required this.field,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OptimizationParams &&
          runtimeType == other.runtimeType &&
          appId == other.appId &&
          locale == other.locale &&
          field == other.field;

  @override
  int get hashCode => appId.hashCode ^ locale.hashCode ^ field.hashCode;
}

/// Provider for fetching optimization suggestions
final optimizationSuggestionsProvider =
    FutureProvider.family<OptimizationResponse, OptimizationParams>(
        (ref, params) async {
  final repository = ref.watch(metadataRepositoryProvider);
  return repository.getOptimizationSuggestions(
    appId: params.appId,
    locale: params.locale,
    field: params.field,
  );
});

/// State notifier for the optimization wizard
class OptimizationWizardNotifier extends StateNotifier<WizardState> {
  final MetadataRepository _repository;
  final int appId;

  OptimizationWizardNotifier({
    required MetadataRepository repository,
    required this.appId,
    required String locale,
    required String platform,
  })  : _repository = repository,
        super(WizardState(
          currentStep: WizardStep.forPlatform(platform).first,
          locale: locale,
          platform: platform,
        ));

  /// Go to next step
  void nextStep() {
    final next = state.nextStep;
    if (next != null) {
      state = state.copyWith(currentStep: next);
    }
  }

  /// Go to previous step
  void previousStep() {
    final prev = state.previousStep;
    if (prev != null) {
      state = state.copyWith(currentStep: prev);
    }
  }

  /// Go to a specific step
  void goToStep(WizardStep step) {
    state = state.copyWith(currentStep: step);
  }

  /// Select a value for the current field
  void selectValue(String field, String value) {
    state = state.copyWith(
      selectedValues: {...state.selectedValues, field: value},
    );
  }

  /// Store suggestions for a field
  void setSuggestions(String field, OptimizationResponse suggestions) {
    state = state.copyWith(
      suggestions: {...state.suggestions, field: suggestions},
    );
  }

  /// Set loading state
  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  /// Set error
  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  /// Load suggestions for the current step
  Future<void> loadSuggestionsForCurrentStep() async {
    if (!state.currentStep.isMetadataField) return;

    final field = state.currentStep.field;

    // Check if we already have suggestions for this field
    if (state.suggestions.containsKey(field)) return;

    setLoading(true);
    setError(null);

    try {
      final suggestions = await _repository.getOptimizationSuggestions(
        appId: appId,
        locale: state.locale,
        field: field,
      );
      setSuggestions(field, suggestions);
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  /// Get the value for a field (selected or current)
  String? getValueForField(String field) {
    return state.selectedValues[field];
  }

  /// Save all selected values as drafts
  Future<bool> saveAllDrafts() async {
    setLoading(true);
    setError(null);

    try {
      // Only save fields that have been modified
      final values = state.selectedValues;
      if (values.isEmpty) return true;

      await _repository.saveDraft(
        appId: appId,
        locale: state.locale,
        title: values['title'],
        subtitle: values['subtitle'],
        keywords: values['keywords'],
        description: values['description'],
      );

      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Reset the wizard to initial state
  void reset() {
    state = WizardState(
      currentStep: WizardStep.forPlatform(state.platform).first,
      locale: state.locale,
      platform: state.platform,
    );
  }
}

/// Parameters for creating the wizard
class WizardParams {
  final int appId;
  final String locale;
  final String platform;

  WizardParams({
    required this.appId,
    required this.locale,
    required this.platform,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WizardParams &&
          runtimeType == other.runtimeType &&
          appId == other.appId &&
          locale == other.locale &&
          platform == other.platform;

  @override
  int get hashCode => appId.hashCode ^ locale.hashCode ^ platform.hashCode;
}

/// Provider for the optimization wizard
final optimizationWizardProvider =
    StateNotifierProvider.family<OptimizationWizardNotifier, WizardState, WizardParams>(
  (ref, params) {
    final repository = ref.watch(metadataRepositoryProvider);
    return OptimizationWizardNotifier(
      repository: repository,
      appId: params.appId,
      locale: params.locale,
      platform: params.platform,
    );
  },
);
