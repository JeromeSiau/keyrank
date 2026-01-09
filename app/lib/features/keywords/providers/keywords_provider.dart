import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/keywords_repository.dart';
import '../domain/keyword_model.dart';
import '../../tags/domain/tag_model.dart';

class KeywordsState {
  final List<Keyword> keywords;
  final bool isLoading;
  final String? error;

  const KeywordsState({
    this.keywords = const [],
    this.isLoading = false,
    this.error,
  });

  KeywordsState copyWith({
    List<Keyword>? keywords,
    bool? isLoading,
    String? error,
  }) {
    return KeywordsState(
      keywords: keywords ?? this.keywords,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class KeywordsNotifier extends StateNotifier<KeywordsState> {
  final KeywordsRepository _repository;
  final int appId;

  KeywordsNotifier(this._repository, this.appId) : super(const KeywordsState(isLoading: true)) {
    load();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final keywords = await _repository.getKeywordsForApp(appId);
      state = KeywordsState(keywords: keywords);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> toggleFavorite(Keyword keyword) async {
    final index = state.keywords.indexWhere((k) => k.id == keyword.id);
    if (index == -1) return;

    final oldKeywords = state.keywords;
    final newFavorite = !keyword.isFavorite;

    // Optimistic update
    final updatedKeywords = List<Keyword>.from(oldKeywords);
    updatedKeywords[index] = keyword.copyWith(
      isFavorite: newFavorite,
      favoritedAt: newFavorite ? DateTime.now() : null,
    );
    state = state.copyWith(keywords: updatedKeywords);

    try {
      await _repository.toggleFavorite(appId, keyword.id);
    } catch (e) {
      // Rollback
      state = state.copyWith(keywords: oldKeywords);
      rethrow;
    }
  }

  Future<void> updateNote(Keyword keyword, String content) async {
    if (keyword.trackedKeywordId == null) return;

    final index = state.keywords.indexWhere((k) => k.id == keyword.id);
    if (index == -1) return;

    final oldKeywords = state.keywords;

    // Optimistic update
    final updatedKeywords = List<Keyword>.from(oldKeywords);
    updatedKeywords[index] = keyword.copyWith(note: content.isEmpty ? null : content);
    state = state.copyWith(keywords: updatedKeywords);

    try {
      await _repository.saveNote(keyword.trackedKeywordId!, content);
    } catch (e) {
      // Rollback
      state = state.copyWith(keywords: oldKeywords);
      rethrow;
    }
  }

  void updateKeywordTags(int keywordId, List<TagModel> tags) {
    final index = state.keywords.indexWhere((k) => k.id == keywordId);
    if (index == -1) return;

    final updatedKeywords = List<Keyword>.from(state.keywords);
    updatedKeywords[index] = state.keywords[index].copyWith(tags: tags);
    state = state.copyWith(keywords: updatedKeywords);
  }

  Future<void> deleteKeyword(Keyword keyword) async {
    final oldKeywords = state.keywords;

    // Optimistic update
    final updatedKeywords = state.keywords.where((k) => k.id != keyword.id).toList();
    state = state.copyWith(keywords: updatedKeywords);

    try {
      await _repository.removeKeywordFromApp(appId, keyword.id);
    } catch (e) {
      // Rollback
      state = state.copyWith(keywords: oldKeywords);
      rethrow;
    }
  }

  Future<int> bulkDelete(List<int> trackedKeywordIds) async {
    final oldKeywords = state.keywords;

    // Optimistic update
    final updatedKeywords = state.keywords
        .where((k) => !trackedKeywordIds.contains(k.trackedKeywordId))
        .toList();
    state = state.copyWith(keywords: updatedKeywords);

    try {
      final count = await _repository.bulkDelete(appId, trackedKeywordIds);
      return count;
    } catch (e) {
      // Rollback
      state = state.copyWith(keywords: oldKeywords);
      rethrow;
    }
  }

  Future<int> bulkFavorite(List<int> trackedKeywordIds, bool isFavorite) async {
    final oldKeywords = state.keywords;

    // Optimistic update
    final updatedKeywords = state.keywords.map((k) {
      if (trackedKeywordIds.contains(k.trackedKeywordId)) {
        return k.copyWith(
          isFavorite: isFavorite,
          favoritedAt: isFavorite ? DateTime.now() : null,
        );
      }
      return k;
    }).toList();
    state = state.copyWith(keywords: updatedKeywords);

    try {
      final count = await _repository.bulkFavorite(appId, trackedKeywordIds, isFavorite);
      return count;
    } catch (e) {
      // Rollback
      state = state.copyWith(keywords: oldKeywords);
      rethrow;
    }
  }

  Future<int> bulkAddTags(List<int> trackedKeywordIds, List<int> tagIds) async {
    try {
      final count = await _repository.bulkAddTags(appId, trackedKeywordIds, tagIds);
      // Reload to get updated tags
      await load();
      return count;
    } catch (e) {
      rethrow;
    }
  }
}

final keywordsNotifierProvider = StateNotifierProvider.family<KeywordsNotifier, KeywordsState, int>((ref, appId) {
  final repository = ref.watch(keywordsRepositoryProvider);
  return KeywordsNotifier(repository, appId);
});
