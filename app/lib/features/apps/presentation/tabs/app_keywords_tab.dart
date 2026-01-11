import 'dart:io';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../../../core/providers/country_provider.dart';
import '../../../keywords/providers/keywords_provider.dart';
import '../../../keywords/domain/keyword_model.dart';
import '../../../keywords/domain/ranking_history_point.dart';
import '../../../keywords/data/keywords_repository.dart';
import '../../../keywords/presentation/keyword_suggestions_modal.dart';
import '../../domain/app_model.dart';

/// Provider for fetching keyword ranking history (cached).
/// Now supports aggregated data (daily, weekly, monthly).
final keywordRankingHistoryProvider = FutureProvider.family<
    List<RankingHistoryPoint>,
    ({int appId, int keywordId, DateTime? from})>((ref, params) async {
  final repository = ref.watch(keywordsRepositoryProvider);
  return repository.getRankingHistory(
    params.appId,
    keywordId: params.keywordId,
    from: params.from ?? DateTime.now().subtract(const Duration(days: 90)),
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

  Future<void> _showAddKeywordDialog() async {
    final controller = TextEditingController();
    final country = ref.read(selectedCountryProvider);

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => _AddKeywordDialog(
        controller: controller,
        storefront: country.code.toUpperCase(),
      ),
    );

    if (result != null && result.isNotEmpty && mounted) {
      try {
        await ref.read(keywordsNotifierProvider(widget.appId).notifier)
            .addKeyword(result, storefront: country.code.toUpperCase());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.appDetail_keywordAdded(result, country.code.toUpperCase())),
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

  Future<void> _exportKeywords() async {
    setState(() => _isExporting = true);

    try {
      final csv = await ref.read(keywordsRepositoryProvider).exportRankingsCsv(widget.appId);

      // Save to downloads
      final directory = await getApplicationDocumentsDirectory();
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.glassPanelAlpha,
        border: Border(bottom: BorderSide(color: colors.glassBorder)),
      ),
      child: Row(
        children: [
          // Stats
          if (!keywordsState.isLoading && keywordsState.keywords.isNotEmpty) ...[
            _ToolbarStat(
              label: 'Total',
              value: '${keywordsState.keywords.length}',
              color: colors.accent,
            ),
            const SizedBox(width: 16),
            _ToolbarStat(
              label: 'Ranked',
              value: '${keywordsState.keywords.where((k) => k.isRanked).length}',
              color: colors.green,
            ),
            const SizedBox(width: 16),
          ],
          const Spacer(),
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
          const SizedBox(height: 20),
          // Keywords table
          _buildKeywordsTable(context, ref, keywords),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, int total, int ranked, int improved, int declined, double avgPos) {
    final colors = context.colors;
    return Row(
      children: [
        _StatCard(
          icon: Icons.key_rounded,
          iconColor: colors.accent,
          label: 'Total',
          value: total.toString(),
        ),
        const SizedBox(width: 12),
        _StatCard(
          icon: Icons.visibility_rounded,
          iconColor: colors.green,
          label: 'Ranked',
          value: ranked.toString(),
        ),
        const SizedBox(width: 12),
        _StatCard(
          icon: Icons.trending_up_rounded,
          iconColor: colors.green,
          label: 'Improved',
          value: improved.toString(),
        ),
        const SizedBox(width: 12),
        _StatCard(
          icon: Icons.trending_down_rounded,
          iconColor: colors.red,
          label: 'Declined',
          value: declined.toString(),
        ),
        const SizedBox(width: 12),
        _StatCard(
          icon: Icons.analytics_rounded,
          iconColor: colors.yellow,
          label: 'Avg Position',
          value: avgPos > 0 ? '#${avgPos.toStringAsFixed(0)}' : '-',
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
                Expanded(
                  flex: 3,
                  child: Text(
                    'Keyword',
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
                onToggleFavorite: () {
                  ref.read(keywordsNotifierProvider(widget.appId).notifier).toggleFavorite(keyword);
                },
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
  final String storefront;

  const _AddKeywordDialog({
    required this.controller,
    required this.storefront,
  });

  @override
  State<_AddKeywordDialog> createState() => _AddKeywordDialogState();
}

class _AddKeywordDialogState extends State<_AddKeywordDialog> {
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
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  Navigator.pop(context, value.trim());
                }
              },
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${context.l10n.appDetail_storefront}: ${widget.storefront}',
              style: AppTypography.micro.copyWith(color: colors.textMuted),
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
          onPressed: widget.controller.text.trim().isEmpty
              ? null
              : () => Navigator.pop(context, widget.controller.text.trim()),
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
// Stat Card
// =============================================================================

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.glassPanelAlpha,
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
          border: Border.all(color: colors.glassBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: iconColor),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
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

  const _KeywordRow({
    required this.appId,
    required this.keyword,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder.withAlpha(100))),
      ),
      child: Row(
        children: [
          // Keyword name with favorite
          Expanded(
            flex: 3,
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
                      if (keyword.tags.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          children: keyword.tags.take(2).map((tag) => Container(
                                margin: const EdgeInsets.only(top: 4),
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
                              )).toList(),
                        ),
                    ],
                  ),
                ),
              ],
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
                      '-',
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
                  ? _PopularityBar(popularity: keyword.popularity!)
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

    final historyAsync = ref.watch(
      keywordRankingHistoryProvider((
        appId: appId,
        keywordId: keyword.id,
        from: DateTime.now().subtract(const Duration(days: 90)),
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

class _PopularityBar extends StatelessWidget {
  final int popularity;

  const _PopularityBar({required this.popularity});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final normalizedPopularity = popularity.clamp(0, 100) / 100;

    return Column(
      children: [
        Text(
          popularity.toString(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 50,
          height: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: normalizedPopularity,
              backgroundColor: colors.bgHover,
              color: _getPopularityColor(colors, popularity),
            ),
          ),
        ),
      ],
    );
  }

  Color _getPopularityColor(AppColorsExtension colors, int popularity) {
    if (popularity >= 70) return colors.green;
    if (popularity >= 40) return colors.yellow;
    return colors.red;
  }
}
