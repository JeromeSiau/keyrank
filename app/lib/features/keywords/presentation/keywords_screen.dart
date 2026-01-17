import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_context_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/csv_exporter.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../shared/widgets/export_dialog.dart';
import '../../apps/presentation/tabs/app_keywords_tab.dart' hide DifficultyFilter;
import '../../tags/domain/tag_model.dart';
import '../../tags/data/tags_repository.dart';
import '../../tags/providers/tags_provider.dart';
import '../domain/keyword_model.dart';
import '../providers/global_keywords_provider.dart';
import '../providers/keywords_provider.dart';
import 'widgets/keyword_widgets.dart';
import '../../../shared/widgets/safe_image.dart';

/// Keywords screen that uses the global app context.
/// - Global mode (no app selected): Shows all keywords from all apps with App column
/// - App mode (app selected): Shows keywords for that app
class KeywordsScreen extends ConsumerWidget {
  const KeywordsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedApp = ref.watch(appContextProvider);

    if (selectedApp == null) {
      return const _GlobalKeywordsView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Keywords - ${selectedApp.name}'),
      ),
      body: AppKeywordsTab(
        appId: selectedApp.id,
        app: selectedApp,
      ),
    );
  }
}

/// Global view showing keywords from all apps
class _GlobalKeywordsView extends ConsumerStatefulWidget {
  const _GlobalKeywordsView();

  @override
  ConsumerState<_GlobalKeywordsView> createState() => _GlobalKeywordsViewState();
}

class _GlobalKeywordsViewState extends ConsumerState<_GlobalKeywordsView> {
  DifficultyFilter _difficultyFilter = DifficultyFilter.all;
  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {}; // Use "appId:keywordId" as unique key
  bool _isExporting = false;

  String _getSelectionKey(KeywordWithApp kwa) {
    return '${kwa.app.id}:${kwa.keyword.trackedKeywordId ?? kwa.keyword.id}';
  }

  void _toggleSelection(KeywordWithApp kwa) {
    final key = _getSelectionKey(kwa);
    setState(() {
      if (_selectedIds.contains(key)) {
        _selectedIds.remove(key);
      } else {
        _selectedIds.add(key);
      }
    });
  }

  void _selectAll(List<KeywordWithApp> keywords) {
    setState(() {
      for (final kwa in keywords) {
        _selectedIds.add(_getSelectionKey(kwa));
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedIds.clear();
      _isSelectionMode = false;
    });
  }

  /// Groups selected keywords by appId for bulk operations
  Map<int, List<int>> _groupSelectedByApp(List<KeywordWithApp> allKeywords) {
    final selectedKeywords = allKeywords.where((kwa) => _selectedIds.contains(_getSelectionKey(kwa))).toList();
    final grouped = <int, List<int>>{};
    for (final kwa in selectedKeywords) {
      final trackedId = kwa.keyword.trackedKeywordId;
      if (trackedId != null) {
        grouped.putIfAbsent(kwa.app.id, () => []).add(trackedId);
      }
    }
    return grouped;
  }

  Future<void> _handleBulkDelete(List<KeywordWithApp> allKeywords) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.l10n.appDetail_deleteKeywordsTitle),
        content: Text(dialogContext.l10n.appDetail_deleteKeywordsConfirm(_selectedIds.length)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(dialogContext.l10n.appDetail_cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(dialogContext.l10n.appDetail_delete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final grouped = _groupSelectedByApp(allKeywords);
      for (final entry in grouped.entries) {
        await ref.read(keywordsNotifierProvider(entry.key).notifier).bulkDelete(entry.value);
      }
      ref.invalidate(globalKeywordsProvider);
      _clearSelection();
    }
  }

  Future<void> _handleBulkFavorite(List<KeywordWithApp> allKeywords) async {
    final grouped = _groupSelectedByApp(allKeywords);
    for (final entry in grouped.entries) {
      await ref.read(keywordsNotifierProvider(entry.key).notifier).bulkFavorite(entry.value, true);
    }
    ref.invalidate(globalKeywordsProvider);
    _clearSelection();
  }

  Future<void> _handleBulkAddTags(List<KeywordWithApp> allKeywords) async {
    final tagsAsync = ref.read(tagsNotifierProvider);
    final tags = tagsAsync.valueOrNull ?? [];

    if (tags.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.appDetail_noTagsAvailable),
          backgroundColor: context.colors.yellow,
        ),
      );
      return;
    }

    final selectedTagIds = await showDialog<List<int>>(
      context: context,
      builder: (ctx) => TagSelectionDialog(tags: tags),
    );

    if (selectedTagIds != null && selectedTagIds.isNotEmpty) {
      final grouped = _groupSelectedByApp(allKeywords);
      for (final entry in grouped.entries) {
        await ref.read(keywordsNotifierProvider(entry.key).notifier).bulkAddTags(entry.value, selectedTagIds);
      }
      ref.invalidate(globalKeywordsProvider);
      _clearSelection();
    }
  }

  Future<void> _handleBulkExport(List<KeywordWithApp> allKeywords) async {
    final selectedKeywords = allKeywords.where((kwa) => _selectedIds.contains(_getSelectionKey(kwa))).toList();
    if (selectedKeywords.isEmpty) return;

    setState(() => _isExporting = true);

    try {
      final csv = StringBuffer();
      csv.writeln('App,Keyword,Note,Position,Change,Popularity,Difficulty,Country,Tags');
      for (final kwa in selectedKeywords) {
        final k = kwa.keyword;
        csv.writeln([
          _escapeCsv(kwa.app.name),
          _escapeCsv(k.keyword),
          _escapeCsv(k.note ?? ''),
          k.position ?? '',
          k.change ?? '',
          k.popularity ?? '',
          k.difficulty ?? '',
          k.storefront,
          _escapeCsv(k.tags.map((t) => t.name).join(';')),
        ].join(','));
      }

      // Save to Downloads directory
      final fileName = 'All_Apps_keywords_selected_${DateTime.now().toIso8601String().split('T').first}.csv';
      final directory = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(csv.toString());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.export_success(fileName)),
            backgroundColor: AppColors.green,
            duration: const Duration(seconds: 5),
          ),
        );
        _clearSelection();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  List<KeywordWithApp> _filterByDifficulty(List<KeywordWithApp> keywords) {
    switch (_difficultyFilter) {
      case DifficultyFilter.all:
        return keywords;
      case DifficultyFilter.easy:
        return keywords.where((k) => k.keyword.difficulty != null && k.keyword.difficulty! < 40).toList();
      case DifficultyFilter.medium:
        return keywords.where((k) => k.keyword.difficulty != null && k.keyword.difficulty! >= 40 && k.keyword.difficulty! <= 70).toList();
      case DifficultyFilter.hard:
        return keywords.where((k) => k.keyword.difficulty != null && k.keyword.difficulty! > 70).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final keywordsAsync = ref.watch(globalKeywordsProvider);
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keywords (All Apps)'),
        actions: [
          if (keywordsAsync.hasValue && keywordsAsync.value!.isNotEmpty)
            IconButton(
              onPressed: () => _showExportDialog(context, ref),
              icon: Icon(Icons.download_rounded, size: 20, color: colors.textSecondary),
              tooltip: context.l10n.export_button,
            ),
        ],
      ),
      body: keywordsAsync.when(
        data: (keywords) {
          if (keywords.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: colors.accentMuted,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.key_off_rounded, size: 32, color: colors.accent),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No keywords tracked yet',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select an app to add keywords',
                    style: TextStyle(fontSize: 14, color: colors.textMuted),
                  ),
                ],
              ),
            );
          }

          // Calculate stats
          final allKeywords = keywords.map((k) => k.keyword).toList();
          final rankedKeywords = allKeywords.where((k) => k.isRanked).length;
          final improvedKeywords = allKeywords.where((k) => k.hasImproved).length;
          final declinedKeywords = allKeywords.where((k) => k.hasDeclined).length;
          final avgPosition = allKeywords.where((k) => k.isRanked).isEmpty
              ? 0.0
              : allKeywords.where((k) => k.isRanked).map((k) => k.position!).reduce((a, b) => a + b) /
                  allKeywords.where((k) => k.isRanked).length;

          final filteredKeywords = _filterByDifficulty(keywords);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats row
                _buildStatsRow(context, allKeywords.length, rankedKeywords, improvedKeywords, declinedKeywords, avgPosition),
                const SizedBox(height: 16),
                // Difficulty filter chips + Selection toolbar
                if (_isSelectionMode)
                  _buildSelectionToolbar(context, filteredKeywords)
                else
                  _buildDifficultyFilters(context),
                const SizedBox(height: 16),
                // Keywords table
                _GlobalKeywordsTable(
                  keywords: filteredKeywords,
                  isSelectionMode: _isSelectionMode,
                  selectedIds: _selectedIds,
                  getSelectionKey: _getSelectionKey,
                  onToggleSelection: _toggleSelection,
                  onEnterSelectionMode: () => setState(() => _isSelectionMode = true),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: colors.red),
              const SizedBox(height: 16),
              Text('Error loading keywords', style: TextStyle(color: colors.textSecondary)),
              const SizedBox(height: 8),
              Text(error.toString(), style: TextStyle(color: colors.textMuted, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, int total, int ranked, int improved, int declined, double avgPos) {
    final colors = context.colors;
    return Row(
      children: [
        KeywordStatCard(
          icon: Icons.key_rounded,
          iconColor: colors.accent,
          label: 'Total',
          value: total.toString(),
        ),
        const SizedBox(width: 12),
        KeywordStatCard(
          icon: Icons.visibility_rounded,
          iconColor: colors.green,
          label: 'Ranked',
          value: ranked.toString(),
        ),
        const SizedBox(width: 12),
        KeywordStatCard(
          icon: Icons.trending_up_rounded,
          iconColor: colors.green,
          label: 'Improved',
          value: improved.toString(),
        ),
        const SizedBox(width: 12),
        KeywordStatCard(
          icon: Icons.trending_down_rounded,
          iconColor: colors.red,
          label: 'Declined',
          value: declined.toString(),
        ),
        const SizedBox(width: 12),
        KeywordStatCard(
          icon: Icons.analytics_rounded,
          iconColor: colors.yellow,
          label: 'Avg Position',
          value: avgPos > 0 ? '#${avgPos.toStringAsFixed(0)}' : '-',
        ),
      ],
    );
  }

  Widget _buildSelectionToolbar(BuildContext context, List<KeywordWithApp> keywords) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.accentMuted.withAlpha(30),
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        border: Border.all(color: colors.accent.withAlpha(50)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: _clearSelection,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            color: colors.textSecondary,
          ),
          const SizedBox(width: 8),
          Text(
            context.l10n.appDetail_selectedCount(_selectedIds.length),
            style: AppTypography.titleSmall.copyWith(color: colors.textPrimary),
          ),
          const Spacer(),
          // Select All
          BulkActionButton(
            icon: Icons.select_all_rounded,
            label: context.l10n.filter_all,
            onTap: () => _selectAll(keywords),
          ),
          const SizedBox(width: 6),
          // Favorite
          BulkActionButton(
            icon: Icons.star_outline_rounded,
            label: context.l10n.appDetail_favorite,
            onTap: _selectedIds.isEmpty ? null : () => _handleBulkFavorite(keywords),
          ),
          const SizedBox(width: 6),
          // Tag
          BulkActionButton(
            icon: Icons.label_outline_rounded,
            label: context.l10n.appDetail_tag,
            onTap: _selectedIds.isEmpty ? null : () => _handleBulkAddTags(keywords),
          ),
          const SizedBox(width: 6),
          // Export
          BulkActionButton(
            icon: _isExporting ? Icons.hourglass_empty : Icons.file_download_outlined,
            label: context.l10n.appDetail_export,
            onTap: _selectedIds.isEmpty || _isExporting ? null : () => _handleBulkExport(keywords),
          ),
          const SizedBox(width: 6),
          // Delete
          BulkActionButton(
            icon: Icons.delete_outline_rounded,
            label: context.l10n.appDetail_delete,
            isDestructive: true,
            onTap: _selectedIds.isEmpty ? null : () => _handleBulkDelete(keywords),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyFilters(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Row(
      children: [
        Text(
          l10n.keywords_difficultyFilter,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: colors.textMuted,
          ),
        ),
        const SizedBox(width: 12),
        DifficultyFilterChip(
          label: l10n.keywords_difficultyAll,
          isSelected: _difficultyFilter == DifficultyFilter.all,
          onTap: () => setState(() => _difficultyFilter = DifficultyFilter.all),
        ),
        const SizedBox(width: 8),
        DifficultyFilterChip(
          label: l10n.keywords_difficultyEasy,
          color: colors.green,
          isSelected: _difficultyFilter == DifficultyFilter.easy,
          onTap: () => setState(() => _difficultyFilter = DifficultyFilter.easy),
        ),
        const SizedBox(width: 8),
        DifficultyFilterChip(
          label: l10n.keywords_difficultyMedium,
          color: colors.yellow,
          isSelected: _difficultyFilter == DifficultyFilter.medium,
          onTap: () => setState(() => _difficultyFilter = DifficultyFilter.medium),
        ),
        const SizedBox(width: 8),
        DifficultyFilterChip(
          label: l10n.keywords_difficultyHard,
          color: colors.red,
          isSelected: _difficultyFilter == DifficultyFilter.hard,
          onTap: () => setState(() => _difficultyFilter = DifficultyFilter.hard),
        ),
      ],
    );
  }

  void _showExportDialog(BuildContext context, WidgetRef ref) {
    final keywords = ref.read(globalKeywordsProvider).value ?? [];
    final allKeywords = keywords.map((k) => k.keyword).toList();

    showDialog(
      context: context,
      builder: (context) => ExportKeywordsDialog(
        keywordCount: allKeywords.length,
        onExport: (options) async {
          final result = await CsvExporter.exportKeywords(
            keywords: allKeywords,
            appName: 'All_Apps',
            options: options,
          );
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  result.success
                      ? context.l10n.export_success(result.filename)
                      : context.l10n.export_error(result.error ?? 'Unknown error'),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

/// Table showing keywords with app column - styled like app_keywords_tab
class _GlobalKeywordsTable extends ConsumerWidget {
  final List<KeywordWithApp> keywords;
  final bool isSelectionMode;
  final Set<String> selectedIds;
  final String Function(KeywordWithApp) getSelectionKey;
  final void Function(KeywordWithApp) onToggleSelection;
  final VoidCallback onEnterSelectionMode;

  const _GlobalKeywordsTable({
    required this.keywords,
    required this.isSelectionMode,
    required this.selectedIds,
    required this.getSelectionKey,
    required this.onToggleSelection,
    required this.onEnterSelectionMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    // Sort by position (ranked first)
    final sortedKeywords = List<KeywordWithApp>.from(keywords)
      ..sort((a, b) {
        if (a.keyword.position == null && b.keyword.position == null) return 0;
        if (a.keyword.position == null) return 1;
        if (b.keyword.position == null) return -1;
        return a.keyword.position!.compareTo(b.keyword.position!);
      });

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(color: colors.glassBorder),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.glassBorder)),
            ),
            child: Row(
              children: [
                // Checkbox column / Select button
                SizedBox(
                  width: 40,
                  child: isSelectionMode
                      ? const SizedBox()
                      : InkWell(
                          onTap: onEnterSelectionMode,
                          borderRadius: BorderRadius.circular(4),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              Icons.check_box_outline_blank_rounded,
                              size: 18,
                              color: colors.textMuted,
                            ),
                          ),
                        ),
                ),
                SizedBox(
                  width: 140,
                  child: Text(
                    'App',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Keyword',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Note',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    'Position',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: Text(
                    'Change',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: Text(
                    'Popularity',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: Text(
                    'Difficulty',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    'Country',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Rows
          ...sortedKeywords.map((kwa) => _GlobalKeywordRow(
                data: kwa,
                isSelectionMode: isSelectionMode,
                isSelected: selectedIds.contains(getSelectionKey(kwa)),
                onToggleSelection: () => onToggleSelection(kwa),
                onTapApp: () {
                  ref.read(appContextProvider.notifier).select(kwa.app);
                },
                onOpenTags: () => _showTagsModal(context, ref, kwa),
                onOpenNote: () => _showNoteModal(context, ref, kwa),
              )),
        ],
      ),
    );
  }

  void _showTagsModal(BuildContext context, WidgetRef ref, KeywordWithApp kwa) {
    if (kwa.keyword.trackedKeywordId == null) return;

    showDialog(
      context: context,
      builder: (ctx) => KeywordTagsModal(
        appId: kwa.app.id,
        keyword: kwa.keyword,
        onTagsChanged: () => ref.invalidate(globalKeywordsProvider),
      ),
    );
  }

  void _showNoteModal(BuildContext context, WidgetRef ref, KeywordWithApp kwa) {
    if (kwa.keyword.trackedKeywordId == null) return;

    showDialog(
      context: context,
      builder: (ctx) => NoteEditModal(
        appId: kwa.app.id,
        keyword: kwa.keyword,
        onNoteSaved: () => ref.invalidate(globalKeywordsProvider),
      ),
    );
  }
}

class _GlobalKeywordRow extends StatelessWidget {
  final KeywordWithApp data;
  final VoidCallback onTapApp;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onToggleSelection;
  final VoidCallback onOpenTags;
  final VoidCallback onOpenNote;

  const _GlobalKeywordRow({
    required this.data,
    required this.onTapApp,
    this.isSelectionMode = false,
    this.isSelected = false,
    required this.onToggleSelection,
    required this.onOpenTags,
    required this.onOpenNote,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final keyword = data.keyword;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? colors.accentMuted.withAlpha(30) : null,
        border: Border(bottom: BorderSide(color: colors.glassBorder.withAlpha(100))),
      ),
      child: Row(
        children: [
          // Checkbox
          SizedBox(
            width: 40,
            child: isSelectionMode
                ? Checkbox(
                    value: isSelected,
                    onChanged: (_) => onToggleSelection(),
                    activeColor: colors.accent,
                    side: BorderSide(color: colors.textMuted),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  )
                : const SizedBox(),
          ),
          // App
          SizedBox(
            width: 140,
            child: InkWell(
              onTap: onTapApp,
              borderRadius: BorderRadius.circular(4),
              child: Row(
                children: [
                  if (data.app.iconUrl != null)
                    SafeImage(
                      imageUrl: data.app.iconUrl!,
                      width: 20,
                      height: 20,
                      borderRadius: BorderRadius.circular(4),
                      errorWidget: Icon(Icons.apps, size: 20, color: colors.textMuted),
                    )
                  else
                    Icon(Icons.apps, size: 20, color: colors.textMuted),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      data.app.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Keyword name with favorite
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Icon(
                  keyword.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 18,
                  color: keyword.isFavorite ? colors.yellow : colors.textMuted,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        keyword.keyword,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: colors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      // Tags row - clickable
                      InkWell(
                        onTap: onOpenTags,
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: keyword.tags.isNotEmpty
                              ? Wrap(
                                  spacing: 4,
                                  children: [
                                    ...keyword.tags.take(2).map((tag) => Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: tag.colorValue.withAlpha(30),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            tag.name,
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: tag.colorValue,
                                            ),
                                          ),
                                        )),
                                    if (keyword.tags.length > 2)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: colors.bgActive,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          '+${keyword.tags.length - 2}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: colors.textMuted,
                                          ),
                                        ),
                                      ),
                                  ],
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.add, size: 12, color: colors.textMuted),
                                    const SizedBox(width: 2),
                                    Text(
                                      'Tags',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: colors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Note
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: onOpenNote,
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: keyword.note != null && keyword.note!.isNotEmpty
                    ? Text(
                        keyword.note!,
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, size: 12, color: colors.textMuted),
                          const SizedBox(width: 2),
                          Text(
                            'Note',
                            style: TextStyle(
                              fontSize: 11,
                              color: colors.textMuted,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          // Position
          SizedBox(
            width: 80,
            child: Center(
              child: keyword.isRanked
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: getPositionColor(colors, keyword.position!).withAlpha(30),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '#${keyword.position}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: getPositionColor(colors, keyword.position!),
                        ),
                      ),
                    )
                  : Text(
                      '+100',
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.textMuted,
                      ),
                    ),
            ),
          ),
          // Change
          SizedBox(
            width: 70,
            child: Center(
              child: keyword.change != null && keyword.change != 0
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          keyword.change! > 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                          size: 14,
                          color: keyword.change! > 0 ? colors.green : colors.red,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${keyword.change!.abs()}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: keyword.change! > 0 ? colors.green : colors.red,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      '-',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textMuted,
                      ),
                    ),
            ),
          ),
          // Popularity
          SizedBox(
            width: 70,
            child: Center(
              child: keyword.popularity != null
                  ? PopularityBar(popularity: keyword.popularity!)
                  : Text(
                      '-',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textMuted,
                      ),
                    ),
            ),
          ),
          // Difficulty
          SizedBox(
            width: 70,
            child: Center(
              child: keyword.difficulty != null
                  ? DifficultyBadge(
                      difficulty: keyword.difficulty!,
                      label: keyword.difficultyLabel,
                    )
                  : Text(
                      '-',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textMuted,
                      ),
                    ),
            ),
          ),
          // Country
          SizedBox(
            width: 60,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: colors.bgActive,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  keyword.storefront.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
