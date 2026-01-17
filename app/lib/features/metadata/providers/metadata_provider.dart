import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/metadata_repository.dart';
import '../domain/metadata_model.dart';

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
