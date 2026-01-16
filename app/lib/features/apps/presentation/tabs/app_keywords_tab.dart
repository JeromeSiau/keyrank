import 'dart:io';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../../../core/providers/country_provider.dart';
import '../../../competitors/providers/competitors_provider.dart';
import '../../../keywords/providers/keywords_provider.dart';
import '../../../keywords/providers/global_keywords_provider.dart';
import '../../../keywords/domain/keyword_model.dart';
import '../../../keywords/domain/ranking_history_point.dart';
import '../../../keywords/data/keywords_repository.dart';
import '../../../keywords/presentation/keyword_suggestions_modal.dart';
import '../../../tags/domain/tag_model.dart';
import '../../../tags/providers/tags_provider.dart';
import '../../../tags/data/tags_repository.dart';
import '../../domain/app_model.dart';
import '../../../keywords/presentation/widgets/keyword_widgets.dart';

/// Provider for fetching keyword ranking history (cached).
/// Now supports aggregated data (daily, weekly, monthly).
/// Uses start of day to ensure consistent caching throughout the day.
final keywordRankingHistoryProvider = FutureProvider.family<
    List<RankingHistoryPoint>,
    ({int appId, int keywordId, DateTime? from})>((ref, params) async {
  final repository = ref.watch(keywordsRepositoryProvider);
  final today = DateTime.now();
  final startOfDay = DateTime(today.year, today.month, today.day);
  return repository.getRankingHistory(
    params.appId,
    keywordId: params.keywordId,
    from: params.from ?? startOfDay.subtract(const Duration(days: 90)),
  );
});

class AppKeywordsTab extends ConsumerStatefulWidget {
  final int appId;
  final AppModel app;

  const AppKeywordsTab({
    super.key,
    required this.appId,
    required this.app,
  });

  @override
  ConsumerState<AppKeywordsTab> createState() => _AppKeywordsTabState();
}

class _AppKeywordsTabState extends ConsumerState<AppKeywordsTab> {
  bool _isExporting = false;
  DifficultyFilter _difficultyFilter = DifficultyFilter.all;
  bool _isSelectionMode = false;
  final Set<int> _selectedIds = {};

  Future<void> _showAddKeywordDialog() async {
    final controller = TextEditingController();
    final country = ref.read(selectedCountryProvider);

    final result = await showDialog<({String keyword, String storefront})>(
      context: context,
      builder: (ctx) => _AddKeywordDialog(
        controller: controller,
        initialStorefront: country.code.toUpperCase(),
      ),
    );

    if (result != null && result.keyword.isNotEmpty && mounted) {
      try {
        await ref.read(keywordsNotifierProvider(widget.appId).notifier)
            .addKeyword(result.keyword, storefront: result.storefront);
        ref.invalidate(globalKeywordsProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.appDetail_keywordAdded(result.keyword, result.storefront)),
              backgroundColor: AppColors.green,
            ),
          );
        }
      } on ApiException catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message), backgroundColor: AppColors.red),
          );
        }
      }
    }
  }

  Future<void> _showSuggestionsModal() async {
    final keywordsState = ref.read(keywordsNotifierProvider(widget.appId));
    final country = ref.read(selectedCountryProvider);
    final existingKeywords = keywordsState.keywords.map((k) => k.keyword.toLowerCase()).toList();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => KeywordSuggestionsModal(
        appId: widget.appId,
        appName: widget.app.name,
        country: country.code.toUpperCase(),
        existingKeywords: existingKeywords,
        onAddKeywords: (keywords) async {
          for (final keyword in keywords) {
            await ref.read(keywordsNotifierProvider(widget.appId).notifier)
                .addKeyword(keyword, storefront: country.code.toUpperCase());
          }
          ref.invalidate(globalKeywordsProvider);
        },
      ),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.appDetail_keywordsAddedSuccess),
          backgroundColor: AppColors.green,
        ),
      );
    }
  }

  Future<void> _showImportDialog() async {
    final country = ref.read(selectedCountryProvider);

    final result = await showDialog<ImportResult>(
      context: context,
      builder: (ctx) => _ImportKeywordsDialog(
        appId: widget.appId,
        initialStorefront: country.code.toUpperCase(),
        onImport: (keywords, storefront) async {
          return await ref.read(keywordsRepositoryProvider).importKeywords(
            widget.appId,
            keywords,
            storefront: storefront,
          );
        },
      ),
    );

    if (result != null && mounted) {
      ref.invalidate(keywordsNotifierProvider(widget.appId));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.appDetail_importedKeywords(result.imported, result.skipped)),
          backgroundColor: AppColors.green,
        ),
      );
    }
  }

  Future<void> _showCompareWithCompetitorDialog() async {
    final competitorsAsync = ref.read(competitorsProvider);
    final competitors = competitorsAsync.valueOrNull ?? [];
    final colors = context.colors;

    if (competitors.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No competitors found. Add competitors first.'),
          backgroundColor: colors.yellow,
          action: SnackBarAction(
            label: 'Add',
            textColor: Colors.white,
            onPressed: () => context.go('/competitors'),
          ),
        ),
      );
      return;
    }

    final selectedCompetitorId = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.bgBase,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        ),
        title: Text(
          'Compare with Competitor',
          style: AppTypography.headline.copyWith(color: colors.textPrimary),
        ),
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select a competitor to compare keywords:',
                style: AppTypography.bodyMedium.copyWith(color: colors.textSecondary),
              ),
              const SizedBox(height: 16),
              ...competitors.map((competitor) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: competitor.iconUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          competitor.iconUrl!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: colors.bgActive,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.apps, color: colors.textMuted),
                          ),
                        ),
                      )
                    : Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: colors.bgActive,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.apps, color: colors.textMuted),
                      ),
                title: Text(
                  competitor.name,
                  style: AppTypography.bodyMedium.copyWith(color: colors.textPrimary),
                ),
                subtitle: Text(
                  competitor.developer ?? '',
                  style: AppTypography.caption.copyWith(color: colors.textMuted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => Navigator.pop(ctx, competitor.id),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: colors.textMuted)),
          ),
        ],
      ),
    );

    if (selectedCompetitorId != null && mounted) {
      context.go('/competitors/$selectedCompetitorId');
    }
  }

  Future<void> _exportKeywords() async {
    setState(() => _isExporting = true);

    try {
      final csv = await ref.read(keywordsRepositoryProvider).exportRankingsCsv(widget.appId);

      // Save to downloads folder (more accessible than ApplicationDocuments)
      final directory = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
      final fileName = '${widget.app.name.replaceAll(RegExp(r'[^\w\s-]'), '')}_keywords_${DateTime.now().toIso8601String().split('T').first}.csv';
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(csv);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.appDetail_savedFile(fileName)),
            backgroundColor: AppColors.green,
            action: SnackBarAction(
              label: context.l10n.appDetail_showInFinder,
              textColor: Colors.white,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: file.path));
              },
            ),
          ),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: AppColors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  // =============================================================================
  // Selection Mode Methods
  // =============================================================================

  void _toggleSelection(int trackedKeywordId) {
    setState(() {
      if (_selectedIds.contains(trackedKeywordId)) {
        _selectedIds.remove(trackedKeywordId);
      } else {
        _selectedIds.add(trackedKeywordId);
      }
    });
  }

  void _selectAll(List<Keyword> keywords) {
    setState(() {
      for (final k in keywords) {
        if (k.trackedKeywordId != null) {
          _selectedIds.add(k.trackedKeywordId!);
        }
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedIds.clear();
      _isSelectionMode = false;
    });
  }

  Future<void> _handleBulkAddToCompetitor(List<Keyword> keywords) async {
    // Get competitors for this specific app
    final competitorsAsync = ref.read(competitorsForAppProvider(widget.appId));
    final competitors = competitorsAsync.valueOrNull ?? [];

    if (competitors.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No competitors for this app. Add a competitor first.'),
          backgroundColor: context.colors.yellow,
        ),
      );
      return;
    }

    // Get selected keywords
    final selectedKeywords = keywords
        .where((k) => k.trackedKeywordId != null && _selectedIds.contains(k.trackedKeywordId))
        .map((k) => k.keyword)
        .toSet()
        .toList();

    if (selectedKeywords.isEmpty) return;

    // Show competitor selection dialog
    final selectedCompetitor = await showDialog<dynamic>(
      context: context,
      builder: (ctx) => _CompetitorSelectionDialog(
        competitors: competitors,
        keywordCount: selectedKeywords.length,
      ),
    );

    if (selectedCompetitor == null) return;

    // Add keywords to competitor
    try {
      final repository = ref.read(competitorsRepositoryProvider);
      final country = ref.read(selectedCountryProvider);
      final result = await repository.addKeywordsToCompetitor(
        competitorId: selectedCompetitor.id as int,
        keywords: selectedKeywords,
        storefront: country.code,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.skipped > 0
                  ? 'Added ${result.added} keywords to ${selectedCompetitor.name}, ${result.skipped} already tracked'
                  : 'Added ${result.added} keywords to ${selectedCompetitor.name}',
            ),
            backgroundColor: context.colors.green,
          ),
        );
        _clearSelection();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add keywords: $e'),
            backgroundColor: context.colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleBulkDelete() async {
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
      await ref.read(keywordsNotifierProvider(widget.appId).notifier).bulkDelete(_selectedIds.toList());
      ref.invalidate(globalKeywordsProvider);
      _clearSelection();
    }
  }

  Future<void> _handleBulkFavorite() async {
    await ref.read(keywordsNotifierProvider(widget.appId).notifier).bulkFavorite(_selectedIds.toList(), true);
    ref.invalidate(globalKeywordsProvider);
    _clearSelection();
  }

  Future<void> _handleBulkAddTags() async {
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
      await ref.read(keywordsNotifierProvider(widget.appId).notifier).bulkAddTags(_selectedIds.toList(), selectedTagIds);
      ref.invalidate(globalKeywordsProvider);
      _clearSelection();
    }
  }

  Future<void> _handleBulkExport(List<Keyword> keywords) async {
    final selectedKeywords = keywords.where((k) => k.trackedKeywordId != null && _selectedIds.contains(k.trackedKeywordId)).toList();
    if (selectedKeywords.isEmpty) return;

    setState(() => _isExporting = true);

    try {
      // Build CSV manually for selected keywords
      final csv = StringBuffer();
      csv.writeln('Keyword,Note,Position,Change,Popularity,Difficulty,Country,Tags');
      for (final k in selectedKeywords) {
        csv.writeln([
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
      final fileName = '${widget.app.name.replaceAll(RegExp(r'[^\w\s-]'), '')}_keywords_selected_${DateTime.now().toIso8601String().split('T').first}.csv';
      final directory = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(csv.toString());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.appDetail_savedFile(fileName)),
            backgroundColor: AppColors.green,
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

  Future<void> _showTagsModal(Keyword keyword) async {
    if (keyword.trackedKeywordId == null) return;

    await showDialog(
      context: context,
      builder: (ctx) => KeywordTagsModal(
        appId: widget.appId,
        keyword: keyword,
      ),
    );
  }

  Future<void> _showNoteModal(Keyword keyword) async {
    if (keyword.trackedKeywordId == null) return;

    await showDialog(
      context: context,
      builder: (ctx) => NoteEditModal(
        appId: widget.appId,
        keyword: keyword,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final keywordsState = ref.watch(keywordsNotifierProvider(widget.appId));

    return Column(
      children: [
        // Toolbar
        _buildToolbar(colors, keywordsState),
        // Content
        Expanded(
          child: _buildContent(colors, keywordsState),
        ),
      ],
    );
  }

  Widget _buildToolbar(AppColorsExtension colors, KeywordsState keywordsState) {
    final keywords = keywordsState.keywords;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.glassPanelAlpha,
        border: Border(bottom: BorderSide(color: colors.glassBorder)),
      ),
      child: Row(
        children: [
          if (_isSelectionMode) ...[
            // Selection mode header
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
            // Bulk action buttons
            BulkActionButton(
              icon: Icons.select_all_rounded,
              label: context.l10n.filter_all,
              onTap: () => _selectAll(keywords),
            ),
            const SizedBox(width: 6),
            BulkActionButton(
              icon: Icons.star_outline_rounded,
              label: context.l10n.appDetail_favorite,
              onTap: _selectedIds.isEmpty ? null : _handleBulkFavorite,
            ),
            const SizedBox(width: 6),
            BulkActionButton(
              icon: Icons.label_outline_rounded,
              label: context.l10n.appDetail_tag,
              onTap: _selectedIds.isEmpty ? null : _handleBulkAddTags,
            ),
            const SizedBox(width: 6),
            BulkActionButton(
              icon: Icons.person_add_alt_1_outlined,
              label: 'Competitor',
              onTap: _selectedIds.isEmpty ? null : () => _handleBulkAddToCompetitor(keywords),
            ),
            const SizedBox(width: 6),
            BulkActionButton(
              icon: Icons.file_download_outlined,
              label: context.l10n.appDetail_export,
              onTap: _selectedIds.isEmpty ? null : () => _handleBulkExport(keywords),
            ),
            const SizedBox(width: 6),
            BulkActionButton(
              icon: Icons.delete_outline_rounded,
              label: context.l10n.appDetail_delete,
              isDestructive: true,
              onTap: _selectedIds.isEmpty ? null : _handleBulkDelete,
            ),
          ] else ...[
            // Normal mode - Stats
            if (!keywordsState.isLoading && keywords.isNotEmpty) ...[
              _ToolbarStat(
                label: 'Total',
                value: '${keywords.length}',
                color: colors.accent,
              ),
              const SizedBox(width: 16),
              _ToolbarStat(
                label: 'Ranked',
                value: '${keywords.where((k) => k.isRanked).length}',
                color: colors.green,
              ),
              const SizedBox(width: 16),
            ],
            const Spacer(),
            // Select button
            if (keywords.isNotEmpty) ...[
              _ToolbarButton(
                icon: Icons.check_box_outline_blank_rounded,
                label: context.l10n.appDetail_select,
                color: colors.textSecondary,
                onTap: () => setState(() => _isSelectionMode = true),
              ),
              const SizedBox(width: 8),
            ],
            // Action buttons
            _ToolbarButton(
              icon: Icons.add_rounded,
              label: context.l10n.appDetail_addKeyword,
              color: colors.accent,
              onTap: _showAddKeywordDialog,
            ),
            const SizedBox(width: 8),
            _ToolbarButton(
              icon: Icons.lightbulb_outline_rounded,
              label: context.l10n.appDetail_suggestions,
              color: colors.green,
              onTap: _showSuggestionsModal,
            ),
            const SizedBox(width: 8),
            _ToolbarButton(
              icon: Icons.compare_arrows_rounded,
              label: 'Compare',
              color: colors.purple,
              onTap: _showCompareWithCompetitorDialog,
            ),
            const SizedBox(width: 8),
            _ToolbarButton(
              icon: Icons.file_upload_outlined,
              label: context.l10n.appDetail_import,
              color: colors.yellow,
              onTap: _showImportDialog,
            ),
            const SizedBox(width: 8),
            _ToolbarButton(
              icon: _isExporting ? null : Icons.file_download_outlined,
              label: context.l10n.appDetail_export,
              color: colors.textSecondary,
              isLoading: _isExporting,
              onTap: _isExporting ? null : _exportKeywords,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContent(AppColorsExtension colors, KeywordsState keywordsState) {
    if (keywordsState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (keywordsState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: colors.red),
            const SizedBox(height: 12),
            Text(
              keywordsState.error!,
              style: TextStyle(color: colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => ref.read(keywordsNotifierProvider(widget.appId).notifier).load(),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.l10n.common_retry),
            ),
          ],
        ),
      );
    }

    final keywords = keywordsState.keywords;

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
              context.l10n.appDetail_noKeywordsTracked,
              style: AppTypography.titleSmall.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.appDetail_addKeywordHint,
              style: AppTypography.body.copyWith(color: colors.textMuted),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilledButton.icon(
                  onPressed: _showAddKeywordDialog,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: Text(context.l10n.appDetail_addKeyword),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: _showSuggestionsModal,
                  icon: Icon(Icons.lightbulb_outline_rounded, size: 18, color: colors.green),
                  label: Text(context.l10n.appDetail_suggestions),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // Calculate stats
    final rankedKeywords = keywords.where((k) => k.isRanked).length;
    final improvedKeywords = keywords.where((k) => k.hasImproved).length;
    final declinedKeywords = keywords.where((k) => k.hasDeclined).length;
    final avgPosition = keywords.where((k) => k.isRanked).isEmpty
        ? 0.0
        : keywords.where((k) => k.isRanked).map((k) => k.position!).reduce((a, b) => a + b) /
            keywords.where((k) => k.isRanked).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats row
          _buildStatsRow(context, keywords.length, rankedKeywords, improvedKeywords, declinedKeywords, avgPosition),
          const SizedBox(height: 16),
          // Difficulty filter chips
          _buildDifficultyFilters(context),
          const SizedBox(height: 16),
          // Keywords table
          _buildKeywordsTable(context, ref, _filterKeywordsByDifficulty(keywords)),
        ],
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

  List<Keyword> _filterKeywordsByDifficulty(List<Keyword> keywords) {
    switch (_difficultyFilter) {
      case DifficultyFilter.all:
        return keywords;
      case DifficultyFilter.easy:
        return keywords.where((k) => k.difficulty != null && k.difficulty! < 40).toList();
      case DifficultyFilter.medium:
        return keywords.where((k) => k.difficulty != null && k.difficulty! >= 40 && k.difficulty! <= 70).toList();
      case DifficultyFilter.hard:
        return keywords.where((k) => k.difficulty != null && k.difficulty! > 70).toList();
    }
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

  Widget _buildKeywordsTable(BuildContext context, WidgetRef ref, List<Keyword> keywords) {
    final colors = context.colors;
    // Sort by position (ranked first)
    final sortedKeywords = List<Keyword>.from(keywords)
      ..sort((a, b) {
        if (a.position == null && b.position == null) return 0;
        if (a.position == null) return 1;
        if (b.position == null) return -1;
        return a.position!.compareTo(b.position!);
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
                // Checkbox column header
                SizedBox(
                  width: 36,
                  child: _isSelectionMode
                      ? const SizedBox()
                      : InkWell(
                          onTap: () => setState(() => _isSelectionMode = true),
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
                  width: 80,
                  child: Text(
                    'Trend',
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
          ...sortedKeywords.map((keyword) => _KeywordRow(
                appId: widget.appId,
                keyword: keyword,
                isSelectionMode: _isSelectionMode,
                isSelected: keyword.trackedKeywordId != null && _selectedIds.contains(keyword.trackedKeywordId),
                onToggleSelection: keyword.trackedKeywordId != null
                    ? () => _toggleSelection(keyword.trackedKeywordId!)
                    : null,
                onToggleFavorite: () {
                  ref.read(keywordsNotifierProvider(widget.appId).notifier).toggleFavorite(keyword);
                },
                onOpenTags: () => _showTagsModal(keyword),
                onOpenNote: () => _showNoteModal(keyword),
              )),
        ],
      ),
    );
  }
}

// =============================================================================
// Toolbar Widgets
// =============================================================================

class _ToolbarStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ToolbarStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTypography.caption.copyWith(color: colors.textMuted),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withAlpha(30),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            value,
            style: AppTypography.bodyMedium.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final bool isLoading;

  const _ToolbarButton({
    this.icon,
    required this.label,
    required this.color,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withAlpha(20),
      borderRadius: BorderRadius.circular(AppColors.radiusSmall),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                )
              else if (icon != null)
                Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTypography.bodyMedium.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Dialogs
// =============================================================================

class _AddKeywordDialog extends StatefulWidget {
  final TextEditingController controller;
  final String initialStorefront;

  const _AddKeywordDialog({
    required this.controller,
    required this.initialStorefront,
  });

  @override
  State<_AddKeywordDialog> createState() => _AddKeywordDialogState();
}

class _AddKeywordDialogState extends State<_AddKeywordDialog> {
  late String _storefront;

  @override
  void initState() {
    super.initState();
    _storefront = widget.initialStorefront;
  }

  void _submit() {
    final keyword = widget.controller.text.trim();
    if (keyword.isNotEmpty) {
      Navigator.pop(context, (keyword: keyword, storefront: _storefront));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AlertDialog(
      backgroundColor: colors.glassPanel,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        side: BorderSide(color: colors.glassBorder),
      ),
      title: Text(
        context.l10n.appDetail_addKeyword,
        style: AppTypography.title.copyWith(color: colors.textPrimary),
      ),
      content: SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.appDetail_addKeywordHint,
              style: AppTypography.caption.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.sm + 4),
            TextField(
              controller: widget.controller,
              autofocus: true,
              style: AppTypography.body.copyWith(color: colors.textPrimary),
              decoration: InputDecoration(
                hintText: context.l10n.appDetail_keywordHint,
                hintStyle: AppTypography.body.copyWith(color: colors.textMuted),
                filled: true,
                fillColor: colors.bgActive,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colors.glassBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colors.glassBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colors.accent),
                ),
                prefixIcon: Icon(Icons.search_rounded, color: colors.textMuted),
              ),
              onSubmitted: (_) => _submit(),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.sm + 4),
            Row(
              children: [
                Text(
                  context.l10n.appDetail_storefront,
                  style: AppTypography.caption.copyWith(color: colors.textSecondary),
                ),
                const SizedBox(width: AppSpacing.sm + 4),
                DropdownButton<String>(
                  value: _storefront,
                  dropdownColor: colors.glassPanel,
                  style: AppTypography.caption.copyWith(color: colors.textPrimary),
                  items: const [
                    DropdownMenuItem(value: 'US', child: Text('🇺🇸 US')),
                    DropdownMenuItem(value: 'GB', child: Text('🇬🇧 UK')),
                    DropdownMenuItem(value: 'FR', child: Text('🇫🇷 FR')),
                    DropdownMenuItem(value: 'DE', child: Text('🇩🇪 DE')),
                    DropdownMenuItem(value: 'CA', child: Text('🇨🇦 CA')),
                    DropdownMenuItem(value: 'AU', child: Text('🇦🇺 AU')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _storefront = value);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.appDetail_cancel),
        ),
        FilledButton(
          onPressed: widget.controller.text.trim().isEmpty ? null : _submit,
          child: Text(context.l10n.appDetail_addKeyword),
        ),
      ],
    );
  }
}

class _ImportKeywordsDialog extends StatefulWidget {
  final int appId;
  final String initialStorefront;
  final Future<ImportResult> Function(String keywords, String storefront) onImport;

  const _ImportKeywordsDialog({
    required this.appId,
    required this.initialStorefront,
    required this.onImport,
  });

  @override
  State<_ImportKeywordsDialog> createState() => _ImportKeywordsDialogState();
}

class _ImportKeywordsDialogState extends State<_ImportKeywordsDialog> {
  final _controller = TextEditingController();
  late String _storefront;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _storefront = widget.initialStorefront;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _import() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final result = await widget.onImport(_controller.text, _storefront);
      if (mounted) {
        Navigator.pop(context, result);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.appDetail_importFailed(e.toString())),
            backgroundColor: context.colors.red,
          ),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  int get _keywordCount {
    return _controller.text
        .split('\n')
        .where((line) => line.trim().length >= 2)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AlertDialog(
      backgroundColor: colors.glassPanel,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        side: BorderSide(color: colors.glassBorder),
      ),
      title: Text(
        context.l10n.appDetail_importKeywordsTitle,
        style: AppTypography.title.copyWith(color: colors.textPrimary),
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.appDetail_pasteKeywordsHint,
              style: AppTypography.caption.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.sm + 4),
            TextField(
              controller: _controller,
              maxLines: 10,
              style: AppTypography.caption.copyWith(
                color: colors.textPrimary,
                fontFamily: 'monospace',
              ),
              decoration: InputDecoration(
                hintText: context.l10n.appDetail_keywordPlaceholder,
                hintStyle: AppTypography.caption.copyWith(
                  color: colors.textMuted.withAlpha(100),
                ),
                filled: true,
                fillColor: colors.bgActive,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colors.glassBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colors.glassBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colors.accent),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.sm + 4),
            Row(
              children: [
                Text(
                  context.l10n.appDetail_storefront,
                  style: AppTypography.caption.copyWith(color: colors.textSecondary),
                ),
                const SizedBox(width: AppSpacing.sm + 4),
                DropdownButton<String>(
                  value: _storefront,
                  dropdownColor: colors.glassPanel,
                  style: AppTypography.caption.copyWith(color: colors.textPrimary),
                  items: const [
                    DropdownMenuItem(value: 'US', child: Text('🇺🇸 US')),
                    DropdownMenuItem(value: 'GB', child: Text('🇬🇧 UK')),
                    DropdownMenuItem(value: 'FR', child: Text('🇫🇷 FR')),
                    DropdownMenuItem(value: 'DE', child: Text('🇩🇪 DE')),
                    DropdownMenuItem(value: 'CA', child: Text('🇨🇦 CA')),
                    DropdownMenuItem(value: 'AU', child: Text('🇦🇺 AU')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _storefront = value);
                    }
                  },
                ),
                const Spacer(),
                Text(
                  context.l10n.appDetail_keywordsCount(_keywordCount),
                  style: AppTypography.micro.copyWith(color: colors.textMuted),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: Text(context.l10n.appDetail_cancel),
        ),
        FilledButton(
          onPressed: _isLoading || _keywordCount == 0 ? null : _import,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(context.l10n.appDetail_importKeywordsCount(_keywordCount)),
        ),
      ],
    );
  }
}

// =============================================================================
// Keyword Row
// =============================================================================

class _KeywordRow extends ConsumerWidget {
  final int appId;
  final Keyword keyword;
  final VoidCallback onToggleFavorite;
  final VoidCallback onOpenTags;
  final VoidCallback onOpenNote;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback? onToggleSelection;

  const _KeywordRow({
    required this.appId,
    required this.keyword,
    required this.onToggleFavorite,
    required this.onOpenTags,
    required this.onOpenNote,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.onToggleSelection,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? colors.accentMuted.withAlpha(30) : null,
        border: Border(bottom: BorderSide(color: colors.glassBorder.withAlpha(100))),
      ),
      child: Row(
        children: [
          // Checkbox (only in selection mode)
          if (isSelectionMode) ...[
            SizedBox(
              width: 36,
              child: Checkbox(
                value: isSelected,
                onChanged: onToggleSelection != null ? (_) => onToggleSelection!() : null,
                activeColor: colors.accent,
                side: BorderSide(color: colors.textMuted),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
          // Keyword name with favorite
          Expanded(
            flex: 2,
            child: Row(
              children: [
                InkWell(
                  onTap: onToggleFavorite,
                  borderRadius: BorderRadius.circular(4),
                  child: Icon(
                    keyword.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 18,
                    color: keyword.isFavorite ? colors.yellow : colors.textMuted,
                  ),
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
                        color: _getPositionColor(colors, keyword.position!).withAlpha(30),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '#${keyword.position}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _getPositionColor(colors, keyword.position!),
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
          // Trend Sparkline
          SizedBox(
            width: 80,
            height: 30,
            child: _KeywordSparkline(
              appId: appId,
              keyword: keyword,
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

  Color _getPositionColor(AppColorsExtension colors, int position) {
    if (position <= 3) return colors.green;
    if (position <= 10) return colors.greenBright;
    if (position <= 50) return colors.yellow;
    return colors.textSecondary;
  }
}

// =============================================================================
// Sparkline & Popularity
// =============================================================================

class _KeywordSparkline extends ConsumerWidget {
  final int appId;
  final Keyword keyword;

  const _KeywordSparkline({
    required this.appId,
    required this.keyword,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    // Only show sparkline for ranked keywords
    if (!keyword.isRanked) {
      return Center(
        child: Text(
          '-',
          style: TextStyle(fontSize: 12, color: colors.textMuted),
        ),
      );
    }

    // Use null to let the provider use default (90 days from today at midnight)
    // Avoids creating new provider key on every build due to DateTime.now() changing
    final historyAsync = ref.watch(
      keywordRankingHistoryProvider((
        appId: appId,
        keywordId: keyword.id,
        from: null,
      )),
    );

    return historyAsync.when(
      data: (history) {
        if (history.isEmpty || history.length < 2) {
          return _SimpleTrendIndicator(change: keyword.change, position: keyword.position);
        }

        // Filter out entries without displayable position
        final validHistory = history.where((h) => h.displayPosition != null).toList();
        if (validHistory.isEmpty) {
          return _SimpleTrendIndicator(change: keyword.change, position: keyword.position);
        }

        // Create spots using displayPosition (works for both daily and aggregates)
        final spots = validHistory.asMap().entries.map((entry) {
          // Invert: position 1 -> high value, position 100 -> low value
          final pos = entry.value.displayPosition ?? 100;
          final invertedValue = 101.0 - pos;
          return FlSpot(entry.key.toDouble(), invertedValue.clamp(1, 100));
        }).toList();

        // Determine if trending up (improving = positions getting lower = inverted getting higher)
        final isImproving = spots.length >= 2 && spots.last.y > spots.first.y;
        final lineColor = isImproving ? colors.green : colors.red;

        // Check if we have aggregated data
        final hasAggregates = history.any((h) => h.isAggregate);

        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineTouchData: const LineTouchData(enabled: false),
                  clipData: const FlClipData.all(),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.3,
                      color: lineColor,
                      barWidth: 1.5,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: lineColor.withAlpha(30),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Show indicator if data includes aggregates
            if (hasAggregates)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                  decoration: BoxDecoration(
                    color: colors.yellow.withAlpha(40),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(
                    'avg',
                    style: TextStyle(fontSize: 7, color: colors.yellow),
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => Center(
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            valueColor: AlwaysStoppedAnimation<Color>(colors.textMuted),
          ),
        ),
      ),
      error: (_, _) => _SimpleTrendIndicator(change: keyword.change, position: keyword.position),
    );
  }
}

class _SimpleTrendIndicator extends StatelessWidget {
  final int? change;
  final int? position;

  const _SimpleTrendIndicator({this.change, this.position});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (change == null || change == 0) {
      return Center(
        child: Container(
          width: 40,
          height: 2,
          decoration: BoxDecoration(
            color: colors.textMuted.withAlpha(100),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      );
    }

    final isUp = change! > 0;
    final color = isUp ? colors.green : colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: CustomPaint(
        size: const Size(double.infinity, 20),
        painter: _TrendLinePainter(isUp: isUp, color: color),
      ),
    );
  }
}

class _TrendLinePainter extends CustomPainter {
  final bool isUp;
  final Color color;

  _TrendLinePainter({required this.isUp, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color.withAlpha(30)
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    if (isUp) {
      path.moveTo(0, size.height * 0.8);
      path.quadraticBezierTo(size.width * 0.5, size.height * 0.5, size.width, size.height * 0.2);

      fillPath.moveTo(0, size.height);
      fillPath.lineTo(0, size.height * 0.8);
      fillPath.quadraticBezierTo(size.width * 0.5, size.height * 0.5, size.width, size.height * 0.2);
      fillPath.lineTo(size.width, size.height);
      fillPath.close();
    } else {
      path.moveTo(0, size.height * 0.2);
      path.quadraticBezierTo(size.width * 0.5, size.height * 0.5, size.width, size.height * 0.8);

      fillPath.moveTo(0, size.height);
      fillPath.lineTo(0, size.height * 0.2);
      fillPath.quadraticBezierTo(size.width * 0.5, size.height * 0.5, size.width, size.height * 0.8);
      fillPath.lineTo(size.width, size.height);
      fillPath.close();
    }

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TrendLinePainter oldDelegate) {
    return oldDelegate.isUp != isUp || oldDelegate.color != color;
  }
}

/// Dialog to select a competitor to add keywords to
class _CompetitorSelectionDialog extends StatelessWidget {
  final List<dynamic> competitors;
  final int keywordCount;

  const _CompetitorSelectionDialog({
    required this.competitors,
    required this.keywordCount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AlertDialog(
      backgroundColor: colors.bgBase,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      title: Text(
        'Add to Competitor',
        style: AppTypography.headline.copyWith(color: colors.textPrimary),
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add $keywordCount keyword${keywordCount > 1 ? 's' : ''} to:',
              style: AppTypography.bodyMedium.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: competitors.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final competitor = competitors[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.pop(context, competitor),
                      borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: colors.glassBorder),
                          borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                        ),
                        child: Row(
                          children: [
                            // Icon
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: competitor.iconUrl != null
                                  ? Image.network(
                                      competitor.iconUrl!,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: colors.bgActive,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Icon(Icons.apps, color: colors.textMuted),
                                      ),
                                    )
                                  : Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: colors.bgActive,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(Icons.apps, color: colors.textMuted),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            // Name and developer
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    competitor.name,
                                    style: AppTypography.titleSmall.copyWith(
                                      color: colors.textPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (competitor.developer != null)
                                    Text(
                                      competitor.developer!,
                                      style: AppTypography.caption.copyWith(
                                        color: colors.textMuted,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                            // Arrow
                            Icon(
                              Icons.chevron_right_rounded,
                              color: colors.textMuted,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: colors.textMuted)),
        ),
      ],
    );
  }
}
