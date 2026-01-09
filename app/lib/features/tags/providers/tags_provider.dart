import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/tags_repository.dart';
import '../domain/tag_model.dart';

final tagsProvider = FutureProvider<List<TagModel>>((ref) async {
  return ref.watch(tagsRepositoryProvider).getTags();
});

class TagsNotifier extends StateNotifier<AsyncValue<List<TagModel>>> {
  final TagsRepository _repository;

  TagsNotifier(this._repository) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final tags = await _repository.getTags();
      state = AsyncValue.data(tags);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<TagModel> createTag({
    required String name,
    required String color,
  }) async {
    final tag = await _repository.createTag(name: name, color: color);

    final currentTags = state.valueOrNull ?? [];
    state = AsyncValue.data([...currentTags, tag]);

    return tag;
  }

  Future<void> deleteTag(int id) async {
    final currentTags = state.valueOrNull ?? [];

    // Optimistic update
    state = AsyncValue.data(
      currentTags.where((t) => t.id != id).toList(),
    );

    try {
      await _repository.deleteTag(id);
    } catch (e) {
      // Rollback
      state = AsyncValue.data(currentTags);
      rethrow;
    }
  }
}

final tagsNotifierProvider = StateNotifierProvider<TagsNotifier, AsyncValue<List<TagModel>>>((ref) {
  return TagsNotifier(
    ref.watch(tagsRepositoryProvider),
  );
});
