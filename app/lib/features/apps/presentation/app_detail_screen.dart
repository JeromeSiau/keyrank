import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/api/api_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/country_provider.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../shared/widgets/buttons.dart';
import '../../../shared/widgets/country_picker.dart';
import '../data/apps_repository.dart';
import '../domain/app_model.dart';
import '../providers/apps_provider.dart';
import '../../keywords/data/keywords_repository.dart';
import '../../keywords/domain/keyword_model.dart';
import '../../keywords/providers/keywords_provider.dart';
import '../../keywords/presentation/keyword_suggestions_modal.dart';
import '../../tags/domain/tag_model.dart';
import '../../tags/providers/tags_provider.dart';
import '../../tags/data/tags_repository.dart';

enum KeywordFilter { all, favorites, hasTags, hasNotes, ios, android }
enum KeywordSort { nameAsc, nameDesc, positionBest, popularity, recentlyTracked }

class AppDetailScreen extends ConsumerStatefulWidget {
  final int? appId;
  // Preview mode params
  final String? platform;
  final String? storeId;
  final String? country;

  const AppDetailScreen({
    super.key,
    this.appId,
    this.platform,
    this.storeId,
    this.country,
  }) : assert(appId != null || (platform != null && storeId != null),
           'Either appId or (platform + storeId) must be provided');

  bool get isPreviewMode => appId == null;

  @override
  ConsumerState<AppDetailScreen> createState() => _AppDetailScreenState();
}

class _AppDetailScreenState extends ConsumerState<AppDetailScreen> {
  final _keywordController = TextEditingController();
  bool _isAddingKeyword = false;
  Keyword? _selectedKeyword;
  bool _countryInitialized = false;

  // Preview mode state
  AppPreview? _previewData;
  bool _isLoadingPreview = false;
  String? _previewError;
  bool _isAddingApp = false;

  // Helper getter for tracked mode
  int get appId => widget.appId!;

  @override
  void initState() {
    super.initState();
    if (widget.isPreviewMode) {
      _loadPreview();
    }
  }

  Future<void> _loadPreview() async {
    setState(() {
      _isLoadingPreview = true;
      _previewError = null;
    });

    try {
      final repository = ref.read(appsRepositoryProvider);
      final preview = await repository.getAppPreview(
        platform: widget.platform!,
        storeId: widget.storeId!,
        country: widget.country ?? 'us',
      );
      if (mounted) {
        setState(() {
          _previewData = preview;
          _isLoadingPreview = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _previewError = e.toString();
          _isLoadingPreview = false;
        });
      }
    }
  }

  Future<void> _addAppToMyApps() async {
    if (_previewData == null) return;

    setState(() => _isAddingApp = true);

    try {
      final newApp = await ref.read(appsRepositoryProvider).addApp(
        platform: _previewData!.platform,
        storeId: _previewData!.storeId,
        country: widget.country ?? 'us',
      );
      ref.invalidate(appsNotifierProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.appPreview_added),
            backgroundColor: AppColors.green,
          ),
        );
        // Navigate to the newly added app
        context.go('/apps/${newApp.id}');
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: AppColors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAddingApp = false);
      }
    }
  }

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }

  void _initializeCountryFromApp(String? storefront) {
    if (_countryInitialized || storefront == null) return;
    final country = getCountryByCode(storefront);
    if (country != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(selectedCountryProvider.notifier).state = country;
      });
    }
    _countryInitialized = true;
  }

  void _showKeywordHistory(Keyword keyword) {
    setState(() => _selectedKeyword = keyword);
  }

  void _hideKeywordHistory() {
    setState(() => _selectedKeyword = null);
  }

  Future<void> _addKeyword() async {
    final keyword = _keywordController.text.trim();
    if (keyword.isEmpty) return;

    setState(() => _isAddingKeyword = true);

    try {
      final repository = ref.read(keywordsRepositoryProvider);
      final country = ref.read(selectedCountryProvider);
      await repository.addKeywordToApp(appId, keyword, storefront: country.code.toUpperCase());
      _keywordController.clear();
      ref.read(keywordsNotifierProvider(appId).notifier).load();
      ref.invalidate(appsNotifierProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.appDetail_keywordAdded(keyword, country.flag)),
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
    } finally {
      if (mounted) {
        setState(() => _isAddingKeyword = false);
      }
    }
  }

  Future<void> _showTagsModal(Keyword keyword) async {
    if (keyword.trackedKeywordId == null) return;

    final result = await showDialog<List<TagModel>>(
      context: context,
      builder: (context) => _TagsManagementDialog(
        keyword: keyword,
        appId: appId,
      ),
    );

    if (result != null) {
      ref.read(keywordsNotifierProvider(appId).notifier).updateKeywordTags(keyword.id, result);
    }
  }

  Future<void> _showBulkTagsDialog(List<int> trackedKeywordIds) async {
    final tagsAsync = ref.read(tagsProvider);
    final tags = tagsAsync.valueOrNull ?? [];

    if (tags.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.appDetail_noTagsAvailable),
          backgroundColor: AppColors.yellow,
        ),
      );
      return;
    }

    final selectedTagIds = await showDialog<List<int>>(
      context: context,
      builder: (context) => _BulkTagsDialog(tags: tags),
    );

    if (selectedTagIds != null && selectedTagIds.isNotEmpty) {
      try {
        await ref.read(keywordsNotifierProvider(appId).notifier)
            .bulkAddTags(trackedKeywordIds, selectedTagIds);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.appDetail_tagsAdded(trackedKeywordIds.length)),
              backgroundColor: AppColors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.common_error(e.toString())),
              backgroundColor: AppColors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _showSuggestionsModal(dynamic app, List<Keyword> keywords) async {
    final country = ref.read(selectedCountryProvider);
    final existingKeywords = keywords.map((k) => k.keyword.toLowerCase()).toList();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => KeywordSuggestionsModal(
        appId: appId,
        appName: app.name,
        country: country.code.toUpperCase(),
        existingKeywords: existingKeywords,
        onAddKeywords: (selectedKeywords) async {
          final repository = ref.read(keywordsRepositoryProvider);
          for (final keyword in selectedKeywords) {
            await repository.addKeywordToApp(
              appId,
              keyword,
              storefront: country.code.toUpperCase(),
            );
          }
        },
      ),
    );

    if (result == true) {
      ref.read(keywordsNotifierProvider(appId).notifier).load();
      ref.invalidate(appsNotifierProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.appDetail_keywordsAddedSuccess),
            backgroundColor: AppColors.green,
          ),
        );
      }
    }
  }

  Future<void> _deleteApp() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.glassPanel,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
          side: const BorderSide(color: AppColors.glassBorder),
        ),
        title: Text(
          dialogContext.l10n.appDetail_deleteAppTitle,
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          dialogContext.l10n.appDetail_deleteAppConfirm,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(dialogContext.l10n.appDetail_cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            child: Text(dialogContext.l10n.appDetail_delete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(appsNotifierProvider.notifier).deleteApp(appId);
      if (mounted) {
        context.go('/apps');
      }
    }
  }

  Future<void> _exportRankings(String appName) async {
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.appDetail_exporting),
          duration: const Duration(seconds: 1),
        ),
      );

      // Get CSV data from API
      final csvData = await ref.read(keywordsRepositoryProvider).exportRankingsCsv(appId);

      // Use path_provider to get a writable directory
      final fileName = 'rankings-${appName.replaceAll(RegExp(r'[^\w\s-]'), '')}-${DateTime.now().toIso8601String().split('T')[0]}.csv';

      // Try downloads directory, fall back to documents
      Directory? saveDir = await getDownloadsDirectory();
      saveDir ??= await getApplicationDocumentsDirectory();

      final savePath = '${saveDir.path}/$fileName';
      final file = File(savePath);
      await file.writeAsString(csvData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.appDetail_savedFile(fileName)),
            backgroundColor: AppColors.green,
            duration: const Duration(seconds: 4),
            action: Platform.isMacOS ? SnackBarAction(
              label: context.l10n.appDetail_showInFinder,
              textColor: Colors.white,
              onPressed: () {
                Process.run('open', ['-R', savePath]);
              },
            ) : null,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.appDetail_exportFailed(e.toString())),
            backgroundColor: AppColors.red,
          ),
        );
      }
    }
  }

  Future<void> _showImportDialog() async {
    final result = await showDialog<ImportResult>(
      context: context,
      builder: (context) => _ImportKeywordsDialog(
        appId: appId,
        onImport: (keywords, storefront) async {
          return await ref.read(keywordsRepositoryProvider).importKeywords(
            appId,
            keywords,
            storefront: storefront,
          );
        },
      ),
    );

    if (result != null && mounted) {
      // Refresh keywords list
      ref.invalidate(keywordsNotifierProvider(appId));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.appDetail_importedKeywords(result.imported, result.skipped)),
          backgroundColor: AppColors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isPreview = widget.isPreviewMode;

    // Loading state for preview mode
    if (isPreview && _isLoadingPreview) {
      return Container(
        decoration: BoxDecoration(
          color: colors.glassPanel,
          borderRadius: BorderRadius.circular(AppColors.radiusLarge),
        ),
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    // Error state for preview mode
    if (isPreview && (_previewError != null || _previewData == null)) {
      return Container(
        decoration: BoxDecoration(
          color: colors.glassPanel,
          borderRadius: BorderRadius.circular(AppColors.radiusLarge),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: colors.red),
              const SizedBox(height: 16),
              Text(
                context.l10n.appPreview_notFound,
                style: TextStyle(color: colors.textSecondary),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      );
    }

    // Tracked mode: get app from provider
    AppModel? app;
    KeywordsState? keywordsState;
    if (!isPreview) {
      final appsAsync = ref.watch(appsNotifierProvider);
      keywordsState = ref.watch(keywordsNotifierProvider(appId));

      app = appsAsync.valueOrNull?.firstWhere(
        (a) => a.id == appId,
        orElse: () => throw Exception('App not found'),
      );

      if (app == null) {
        return Container(
          decoration: BoxDecoration(
            color: colors.glassPanel,
            borderRadius: BorderRadius.circular(AppColors.radiusLarge),
          ),
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      }

      // Initialize country selector from app's storefront
      _initializeCountryFromApp(app.storefront);
    }

    // For preview mode, create a fake AppModel from preview data
    if (isPreview) {
      final preview = _previewData!;
      app = AppModel(
        id: 0,
        platform: preview.platform,
        storeId: preview.storeId,
        name: preview.name,
        iconUrl: preview.iconUrl,
        developer: preview.developer,
        description: preview.description,
        screenshots: preview.screenshots,
        version: preview.version,
        releaseDate: preview.releaseDate,
        updatedDate: preview.updatedDate,
        sizeBytes: preview.sizeBytes,
        minimumOs: preview.minimumOs,
        storeUrl: preview.storeUrl,
        price: preview.price,
        currency: preview.currency,
        rating: preview.rating,
        ratingCount: preview.ratingCount,
        categoryId: preview.categoryId,
        createdAt: DateTime.now(),
      );
    }

    // At this point app is guaranteed non-null
    final appData = app!;
    final keywords = keywordsState?.keywords ?? [];

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanel,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
      ),
      child: Stack(
        children: [
          // Main content
          Column(
              children: [
                // Toolbar
                _Toolbar(
                appName: appData.name,
                isFavorite: appData.isFavorite,
                isPreview: isPreview,
                onBack: () => isPreview ? context.pop() : context.go('/apps'),
                onToggleFavorite: isPreview ? null : () => ref.read(appsNotifierProvider.notifier).toggleFavorite(appId),
                onDelete: isPreview ? null : _deleteApp,
                onViewRatings: isPreview ? null : () => context.push(
                  '/apps/$appId/ratings?name=${Uri.encodeComponent(appData.name)}',
                ),
                onViewInsights: isPreview ? null : () => context.push(
                  '/apps/$appId/insights?name=${Uri.encodeComponent(appData.name)}',
                ),
                onViewAnalytics: isPreview ? null : () => context.push(
                  '/apps/$appId/analytics?name=${Uri.encodeComponent(appData.name)}',
                ),
                onExport: isPreview ? null : () => _exportRankings(appData.name),
                onImport: isPreview ? null : _showImportDialog,
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // App info card
                      _AppInfoCard(
                        app: appData,
                        isPreview: isPreview,
                        onViewRatings: isPreview ? null : () => context.push(
                          '/apps/$appId/ratings?name=${Uri.encodeComponent(appData.name)}',
                        ),
                      ),
                      // Collapsible app info (description, screenshots, details)
                      const SizedBox(height: 12),
                      _CollapsibleAppInfo(app: appData),
                      const SizedBox(height: 16),
                      // Keywords section or preview message
                      if (isPreview)
                        _PreviewKeywordsPlaceholder(
                          isAdding: _isAddingApp,
                          onAddApp: _addAppToMyApps,
                        )
                      else ...[
                        // Add keyword section
                        _AddKeywordSection(
                          controller: _keywordController,
                          isAdding: _isAddingKeyword,
                          onAdd: _addKeyword,
                        ),
                        const SizedBox(height: 16),
                        // Keywords table
                        _KeywordsTable(
                          keywordsState: keywordsState!,
                          onDelete: (keyword) async {
                            await ref.read(keywordsNotifierProvider(appId).notifier).deleteKeyword(keyword);
                            ref.invalidate(appsNotifierProvider);
                          },
                          onKeywordTap: _showKeywordHistory,
                          onToggleFavorite: (keyword) async {
                            await ref.read(keywordsNotifierProvider(appId).notifier).toggleFavorite(keyword);
                          },
                          onUpdateNote: (keyword, content) async {
                            await ref.read(keywordsNotifierProvider(appId).notifier).updateNote(keyword, content);
                          },
                          onManageTags: (keyword) => _showTagsModal(keyword),
                          onSuggestions: () => _showSuggestionsModal(appData, keywords),
                          hasIos: appData.isIos,
                          hasAndroid: appData.isAndroid,
                          onBulkDelete: (ids) async {
                            await ref.read(keywordsNotifierProvider(appId).notifier).bulkDelete(ids);
                            ref.invalidate(appsNotifierProvider);
                          },
                          onBulkFavorite: (ids, isFavorite) async {
                            await ref.read(keywordsNotifierProvider(appId).notifier).bulkFavorite(ids, isFavorite);
                          },
                          onBulkAddTags: (ids) async {
                            await _showBulkTagsDialog(ids);
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Backdrop to close panel when tapping outside (only for tracked mode)
          if (!isPreview && _selectedKeyword != null)
            Positioned.fill(
              child: GestureDetector(
                onTap: _hideKeywordHistory,
                behavior: HitTestBehavior.translucent,
                child: Container(color: Colors.transparent),
              ),
            ),
          // Sliding history panel (only for tracked mode)
          if (!isPreview)
            _KeywordHistoryPanel(
              keyword: _selectedKeyword,
              appId: appId,
              onClose: _hideKeywordHistory,
            ),
        ],
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  final String appName;
  final bool isFavorite;
  final bool isPreview;
  final VoidCallback onBack;
  final VoidCallback? onToggleFavorite;
  final VoidCallback? onDelete;
  final VoidCallback? onViewRatings;
  final VoidCallback? onViewInsights;
  final VoidCallback? onViewAnalytics;
  final VoidCallback? onExport;
  final VoidCallback? onImport;

  const _Toolbar({
    required this.appName,
    required this.isFavorite,
    this.isPreview = false,
    required this.onBack,
    this.onToggleFavorite,
    this.onDelete,
    this.onViewRatings,
    this.onViewInsights,
    this.onViewAnalytics,
    this.onExport,
    this.onImport,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder)),
      ),
      child: Row(
        children: [
          // Back button
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
            child: InkWell(
              onTap: onBack,
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              hoverColor: colors.bgHover,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(Icons.arrow_back_rounded, size: 20, color: colors.textMuted),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // App name
          Expanded(
            child: Text(
              appName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Actions (hidden in preview mode)
          if (!isPreview) ...[
            ToolbarButton(
              icon: isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
              label: context.l10n.appDetail_favorite,
              iconColor: isFavorite ? colors.yellow : null,
              onTap: onToggleFavorite,
            ),
            const SizedBox(width: 10),
            ToolbarButton(
              icon: Icons.bar_chart_rounded,
              label: context.l10n.appDetail_ratings,
              onTap: onViewRatings,
            ),
            const SizedBox(width: 10),
            ToolbarButton(
              icon: Icons.insights_rounded,
              label: context.l10n.appDetail_insights,
              onTap: onViewInsights,
            ),
            if (onViewAnalytics != null) ...[
              const SizedBox(width: 10),
              ToolbarButton(
                icon: Icons.analytics_rounded,
                label: context.l10n.analytics_title,
                onTap: onViewAnalytics,
              ),
            ],
            const SizedBox(width: 10),
            // Overflow menu for secondary actions
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert_rounded, color: colors.textMuted, size: 20),
              tooltip: '',
              splashRadius: 18,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppColors.radiusMedium),
              ),
              color: colors.glassPanel,
              surfaceTintColor: Colors.transparent,
              offset: const Offset(0, 40),
              onSelected: (value) {
                switch (value) {
                  case 'import':
                    onImport?.call();
                    break;
                  case 'export':
                    onExport?.call();
                    break;
                  case 'delete':
                    onDelete?.call();
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'import',
                  child: Row(
                    children: [
                      Icon(Icons.upload_rounded, size: 18, color: colors.textSecondary),
                      const SizedBox(width: 12),
                      Text(context.l10n.appDetail_import, style: TextStyle(color: colors.textPrimary)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'export',
                  child: Row(
                    children: [
                      Icon(Icons.download_rounded, size: 18, color: colors.textSecondary),
                      const SizedBox(width: 12),
                      Text(context.l10n.appDetail_export, style: TextStyle(color: colors.textPrimary)),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline_rounded, size: 18, color: colors.red),
                      const SizedBox(width: 12),
                      Text(context.l10n.appDetail_delete, style: TextStyle(color: colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _AppInfoCard extends StatelessWidget {
  final dynamic app;
  final bool isPreview;
  final VoidCallback? onViewRatings;

  const _AppInfoCard({
    required this.app,
    this.isPreview = false,
    this.onViewRatings,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Row(
        children: [
          // App icon
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: AppColors.getGradient(0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: app.iconUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      app.iconUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Center(
                        child: Icon(Icons.apps, size: 32, color: Colors.white),
                      ),
                    ),
                  )
                : const Center(
                    child: Icon(Icons.apps, size: 32, color: Colors.white),
                  ),
          ),
          const SizedBox(width: 20),
          // App info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                if (app.developer != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    app.developer!,
                    style: TextStyle(
                      fontSize: 14,
                      color: colors.textMuted,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                // Platform badge
                Row(
                  children: [
                    if (app.isIos)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          color: colors.bgActive,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🍎', style: TextStyle(fontSize: 12)),
                            const SizedBox(width: 4),
                            Text(
                              'iOS',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (app.isAndroid)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.greenMuted,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🤖', style: TextStyle(fontSize: 12)),
                            const SizedBox(width: 4),
                            Text(
                              'Android',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Category badge
                    if (app.categoryId != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.bgActive,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _getCategoryName(app.categoryId!, app.isIos),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Stats
          if (app.rating != null)
            _StatBadge(
              icon: Icons.star_rounded,
              iconColor: colors.yellow,
              value: app.rating!.toStringAsFixed(1),
              label: context.l10n.appDetail_reviewsCount(app.ratingCount ?? 0),
              onTap: onViewRatings,
            ),
          const SizedBox(width: 12),
          _StatBadge(
            icon: Icons.key_rounded,
            iconColor: colors.accent,
            value: '${app.trackedKeywordsCount ?? 0}',
            label: context.l10n.appDetail_keywords,
          ),
        ],
      ),
    );
  }

  String _getCategoryName(String categoryId, bool isIos) {
    const iosCategoryNames = {
      '6000': 'Business',
      '6001': 'Weather',
      '6002': 'Utilities',
      '6003': 'Travel',
      '6004': 'Sports',
      '6005': 'Social Networking',
      '6006': 'Reference',
      '6007': 'Productivity',
      '6008': 'Photo & Video',
      '6009': 'News',
      '6010': 'Navigation',
      '6011': 'Music',
      '6012': 'Lifestyle',
      '6013': 'Health & Fitness',
      '6014': 'Games',
      '6015': 'Finance',
      '6016': 'Entertainment',
      '6017': 'Education',
      '6018': 'Books',
      '6020': 'Medical',
      '6021': 'Magazines & Newspapers',
      '6022': 'Catalogs',
      '6023': 'Food & Drink',
      '6024': 'Shopping',
      '6025': 'Stickers',
      '6026': 'Developer Tools',
      '6027': 'Graphics & Design',
    };
    const androidCategoryNames = {
      'APPLICATION': 'All Apps',
      'ART_AND_DESIGN': 'Art & Design',
      'AUTO_AND_VEHICLES': 'Auto & Vehicles',
      'BEAUTY': 'Beauty',
      'BOOKS_AND_REFERENCE': 'Books & Reference',
      'BUSINESS': 'Business',
      'COMICS': 'Comics',
      'COMMUNICATION': 'Communication',
      'DATING': 'Dating',
      'EDUCATION': 'Education',
      'ENTERTAINMENT': 'Entertainment',
      'EVENTS': 'Events',
      'FINANCE': 'Finance',
      'FOOD_AND_DRINK': 'Food & Drink',
      'GAME': 'Games',
      'HEALTH_AND_FITNESS': 'Health & Fitness',
      'HOUSE_AND_HOME': 'House & Home',
      'LIBRARIES_AND_DEMO': 'Libraries & Demo',
      'LIFESTYLE': 'Lifestyle',
      'MAPS_AND_NAVIGATION': 'Maps & Navigation',
      'MEDICAL': 'Medical',
      'MUSIC_AND_AUDIO': 'Music & Audio',
      'NEWS_AND_MAGAZINES': 'News & Magazines',
      'PARENTING': 'Parenting',
      'PERSONALIZATION': 'Personalization',
      'PHOTOGRAPHY': 'Photography',
      'PRODUCTIVITY': 'Productivity',
      'SHOPPING': 'Shopping',
      'SOCIAL': 'Social',
      'SPORTS': 'Sports',
      'TOOLS': 'Tools',
      'TRAVEL_AND_LOCAL': 'Travel & Local',
      'VIDEO_PLAYERS': 'Video Players & Editors',
      'WEATHER': 'Weather',
    };

    if (isIos) {
      return iosCategoryNames[categoryId] ?? categoryId;
    }
    return androidCategoryNames[categoryId] ?? categoryId;
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final VoidCallback? onTap;

  const _StatBadge({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.bgActive,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: colors.textMuted,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppColors.radiusSmall),
          hoverColor: colors.bgHover,
          child: content,
        ),
      );
    }

    return content;
  }
}

class _AddKeywordSection extends ConsumerWidget {
  final TextEditingController controller;
  final bool isAdding;
  final VoidCallback onAdd;

  const _AddKeywordSection({
    required this.controller,
    required this.isAdding,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final selectedCountry = ref.watch(selectedCountryProvider);
    final countries = ref.watch(countriesProvider).valueOrNull ?? availableCountries;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colors.accent.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.add_rounded, size: 18, color: colors.accent),
          ),
          const SizedBox(width: 12),
          Text(
            context.l10n.appDetail_addKeyword,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(width: 16),
          // Country selector
          CountryPickerButton(
            selectedCountry: selectedCountry,
            countries: countries,
            onCountryChanged: (country) {
              ref.read(selectedCountryProvider.notifier).state = country;
            },
          ),
          const SizedBox(width: 12),
          // Text field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colors.bgBase,
                border: Border.all(color: colors.glassBorder),
                borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              ),
              child: TextField(
                controller: controller,
                onSubmitted: (_) => onAdd(),
                style: TextStyle(
                  fontSize: 14,
                  color: colors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: context.l10n.appDetail_keywordHint,
                  hintStyle: TextStyle(color: colors.textMuted),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Add button
          Material(
            color: colors.accent,
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
            child: InkWell(
              onTap: isAdding ? null : onAdd,
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: isAdding
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        context.l10n.common_add,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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

class _KeywordsTable extends StatefulWidget {
  final KeywordsState keywordsState;
  final Future<void> Function(Keyword) onDelete;
  final void Function(Keyword) onKeywordTap;
  final Future<void> Function(Keyword) onToggleFavorite;
  final Future<void> Function(Keyword, String) onUpdateNote;
  final void Function(Keyword) onManageTags;
  final VoidCallback? onSuggestions;
  final bool hasIos;
  final bool hasAndroid;
  final Future<void> Function(List<int>) onBulkDelete;
  final Future<void> Function(List<int>, bool) onBulkFavorite;
  final Future<void> Function(List<int>) onBulkAddTags;

  const _KeywordsTable({
    required this.keywordsState,
    required this.onDelete,
    required this.onKeywordTap,
    required this.onToggleFavorite,
    required this.onUpdateNote,
    required this.onManageTags,
    this.onSuggestions,
    required this.hasIos,
    required this.hasAndroid,
    required this.onBulkDelete,
    required this.onBulkFavorite,
    required this.onBulkAddTags,
  });

  @override
  State<_KeywordsTable> createState() => _KeywordsTableState();
}

class _KeywordsTableState extends State<_KeywordsTable> {
  KeywordFilter _filter = KeywordFilter.all;
  KeywordSort _sort = KeywordSort.nameAsc;
  bool _isSelectionMode = false;
  final Set<int> _selectedIds = {};

  List<Keyword> get _filteredAndSortedKeywords {
    var filtered = widget.keywordsState.keywords.where((k) {
      switch (_filter) {
        case KeywordFilter.all:
          return true;
        case KeywordFilter.favorites:
          return k.isFavorite;
        case KeywordFilter.hasTags:
          return k.tags.isNotEmpty;
        case KeywordFilter.hasNotes:
          return k.note != null && k.note!.isNotEmpty;
        case KeywordFilter.ios:
          return k.storefront.toLowerCase() != 'android';
        case KeywordFilter.android:
          return k.storefront.toLowerCase() == 'android';
      }
    }).toList();

    filtered.sort((a, b) {
      switch (_sort) {
        case KeywordSort.nameAsc:
          return a.keyword.toLowerCase().compareTo(b.keyword.toLowerCase());
        case KeywordSort.nameDesc:
          return b.keyword.toLowerCase().compareTo(a.keyword.toLowerCase());
        case KeywordSort.positionBest:
          if (a.position == null && b.position == null) return 0;
          if (a.position == null) return 1;
          if (b.position == null) return -1;
          return a.position!.compareTo(b.position!);
        case KeywordSort.popularity:
          return (b.popularity ?? 0).compareTo(a.popularity ?? 0);
        case KeywordSort.recentlyTracked:
          if (a.trackedSince == null && b.trackedSince == null) return 0;
          if (a.trackedSince == null) return 1;
          if (b.trackedSince == null) return -1;
          return b.trackedSince!.compareTo(a.trackedSince!);
      }
    });

    return filtered;
  }

  String _filterLabel(BuildContext context) {
    switch (_filter) {
      case KeywordFilter.all:
        return context.l10n.filter_all;
      case KeywordFilter.favorites:
        return context.l10n.filter_favorites;
      case KeywordFilter.hasTags:
        return context.l10n.appDetail_tagged;
      case KeywordFilter.hasNotes:
        return context.l10n.appDetail_withNotes;
      case KeywordFilter.ios:
        return context.l10n.filter_ios;
      case KeywordFilter.android:
        return context.l10n.filter_androidOnly;
    }
  }

  String _sortLabel(BuildContext context) {
    switch (_sort) {
      case KeywordSort.nameAsc:
        return context.l10n.sort_nameAZ;
      case KeywordSort.nameDesc:
        return context.l10n.sort_nameZA;
      case KeywordSort.positionBest:
        return context.l10n.appDetail_position;
      case KeywordSort.popularity:
        return context.l10n.keywordSearch_popularity;
      case KeywordSort.recentlyTracked:
        return context.l10n.sort_recent;
    }
  }

  void _showFilterMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final offset = button.localToGlobal(Offset.zero);

    showMenu<KeywordFilter>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + button.size.height,
        offset.dx + button.size.width,
        offset.dy + button.size.height + 300,
      ),
      items: [
        _buildFilterItem(context, KeywordFilter.all, context.l10n.appDetail_allKeywords),
        _buildFilterItem(context, KeywordFilter.favorites, context.l10n.filter_favorites),
        _buildFilterItem(context, KeywordFilter.hasTags, context.l10n.appDetail_hasTags),
        _buildFilterItem(context, KeywordFilter.hasNotes, context.l10n.appDetail_hasNotes),
        if (widget.hasIos) _buildFilterItem(context, KeywordFilter.ios, context.l10n.filter_iosOnly),
        if (widget.hasAndroid) _buildFilterItem(context, KeywordFilter.android, context.l10n.filter_androidOnly),
      ],
    ).then((value) {
      if (value != null) setState(() => _filter = value);
    });
  }

  PopupMenuItem<KeywordFilter> _buildFilterItem(BuildContext context, KeywordFilter filter, String label) {
    return PopupMenuItem<KeywordFilter>(
      value: filter,
      child: Row(
        children: [
          if (_filter == filter)
            const Icon(Icons.check, size: 16, color: AppColors.accent)
          else
            const SizedBox(width: 16),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  void _showSortMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final offset = button.localToGlobal(Offset.zero);

    showMenu<KeywordSort>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + button.size.height,
        offset.dx + button.size.width,
        offset.dy + button.size.height + 250,
      ),
      items: [
        _buildSortItem(context, KeywordSort.nameAsc, context.l10n.appDetail_nameAZ),
        _buildSortItem(context, KeywordSort.nameDesc, context.l10n.appDetail_nameZA),
        _buildSortItem(context, KeywordSort.positionBest, context.l10n.appDetail_bestPosition),
        _buildSortItem(context, KeywordSort.popularity, context.l10n.keywordSearch_popularity),
        _buildSortItem(context, KeywordSort.recentlyTracked, context.l10n.appDetail_recentlyTracked),
      ],
    ).then((value) {
      if (value != null) setState(() => _sort = value);
    });
  }

  PopupMenuItem<KeywordSort> _buildSortItem(BuildContext context, KeywordSort sort, String label) {
    return PopupMenuItem<KeywordSort>(
      value: sort,
      child: Row(
        children: [
          if (_sort == sort)
            const Icon(Icons.check, size: 16, color: AppColors.accent)
          else
            const SizedBox(width: 16),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  void _toggleSelection(int trackedKeywordId) {
    setState(() {
      if (_selectedIds.contains(trackedKeywordId)) {
        _selectedIds.remove(trackedKeywordId);
      } else {
        _selectedIds.add(trackedKeywordId);
      }
    });
  }

  void _selectAll() {
    setState(() {
      for (final k in _filteredAndSortedKeywords) {
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
      await widget.onBulkDelete(_selectedIds.toList());
      _clearSelection();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final displayedKeywords = _filteredAndSortedKeywords;

    return Container(
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  // Bulk action buttons
                  _BulkActionButton(
                    icon: Icons.select_all_rounded,
                    label: context.l10n.filter_all,
                    onTap: _selectAll,
                  ),
                  const SizedBox(width: 6),
                  _BulkActionButton(
                    icon: Icons.star_outline_rounded,
                    label: context.l10n.appDetail_favorite,
                    onTap: _selectedIds.isEmpty
                        ? null
                        : () async {
                            await widget.onBulkFavorite(_selectedIds.toList(), true);
                            _clearSelection();
                          },
                  ),
                  const SizedBox(width: 6),
                  _BulkActionButton(
                    icon: Icons.label_outline_rounded,
                    label: context.l10n.appDetail_tag,
                    onTap: _selectedIds.isEmpty
                        ? null
                        : () async {
                            await widget.onBulkAddTags(_selectedIds.toList());
                            _clearSelection();
                          },
                  ),
                  const SizedBox(width: 6),
                  _BulkActionButton(
                    icon: Icons.delete_outline_rounded,
                    label: context.l10n.appDetail_delete,
                    isDestructive: true,
                    onTap: _selectedIds.isEmpty ? null : _handleBulkDelete,
                  ),
                ] else ...[
                  // Normal mode header
                  Text(
                    '${context.l10n.appDetail_trackedKeywords}${_filter != KeywordFilter.all ? ' (${_filterLabel(context)})' : ''}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (!widget.keywordsState.isLoading)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: colors.accentMuted,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${displayedKeywords.length}${_filter != KeywordFilter.all ? '/${widget.keywordsState.keywords.length}' : ''}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colors.accent,
                        ),
                      ),
                    ),
                  const Spacer(),
                  // Select button
                  if (displayedKeywords.isNotEmpty) ...[
                    _KeywordFilterSortButton(
                      label: context.l10n.appDetail_select,
                      icon: Icons.check_box_outline_blank_rounded,
                      isActive: false,
                      onTap: () => setState(() => _isSelectionMode = true),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Builder(
                    builder: (ctx) => _KeywordFilterSortButton(
                      label: _filterLabel(context),
                      icon: Icons.filter_list_rounded,
                      isActive: _filter != KeywordFilter.all,
                      onTap: () => _showFilterMenu(ctx),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Builder(
                    builder: (ctx) => _KeywordFilterSortButton(
                      label: _sortLabel(context),
                      icon: Icons.sort_rounded,
                      isActive: _sort != KeywordSort.nameAsc,
                      onTap: () => _showSortMenu(ctx),
                    ),
                  ),
                  if (widget.onSuggestions != null) ...[
                    const SizedBox(width: 10),
                    Material(
                      color: colors.greenMuted,
                      borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                      child: InkWell(
                        onTap: widget.onSuggestions,
                        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.lightbulb_outline_rounded,
                                size: 16,
                                color: colors.green,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                context.l10n.appDetail_suggestions,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: colors.bgActive.withAlpha(80),
              border: Border(
                top: BorderSide(color: colors.glassBorder),
                bottom: BorderSide(color: colors.glassBorder),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Text(
                    context.l10n.appDetail_store,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    context.l10n.keywordSuggestions_headerKeyword,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                if (widget.hasIos)
                  SizedBox(
                    width: 80,
                    child: Text(
                      context.l10n.filter_ios,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: colors.textMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (widget.hasIos && widget.hasAndroid) const SizedBox(width: 12),
                if (widget.hasAndroid)
                  SizedBox(
                    width: 80,
                    child: Text(
                      'ANDROID',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: colors.textMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          // Content
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final colors = context.colors;
    if (widget.keywordsState.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (widget.keywordsState.error != null) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: colors.redMuted,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 28,
                  color: colors.red,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Error: ${widget.keywordsState.error}',
                style: TextStyle(color: colors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final displayedKeywords = _filteredAndSortedKeywords;

    if (widget.keywordsState.keywords.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: colors.bgActive,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.key_off_rounded, size: 28, color: colors.textMuted),
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.appDetail_noKeywordsTracked,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.appDetail_addKeywordHint,
                style: TextStyle(
                  fontSize: 13,
                  color: colors.textMuted,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (displayedKeywords.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: colors.bgActive,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.filter_list_off_rounded, size: 28, color: colors.textMuted),
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.appDetail_noKeywordsMatchFilter,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.appDetail_tryChangingFilter,
                style: TextStyle(
                  fontSize: 13,
                  color: colors.textMuted,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: displayedKeywords.map((keyword) => _KeywordRow(
        keyword: keyword,
        onDelete: () => widget.onDelete(keyword),
        onTap: () => widget.onKeywordTap(keyword),
        onToggleFavorite: () => widget.onToggleFavorite(keyword),
        onUpdateNote: (content) => widget.onUpdateNote(keyword, content),
        onManageTags: () => widget.onManageTags(keyword),
        isSelectionMode: _isSelectionMode,
        isSelected: keyword.trackedKeywordId != null && _selectedIds.contains(keyword.trackedKeywordId),
        onToggleSelection: keyword.trackedKeywordId != null
            ? () => _toggleSelection(keyword.trackedKeywordId!)
            : null,
      )).toList(),
    );
  }
}

class _KeywordFilterSortButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _KeywordFilterSortButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        hoverColor: colors.bgHover,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isActive ? colors.accentMuted : Colors.transparent,
            border: Border.all(
              color: isActive ? colors.accent.withAlpha(100) : colors.glassBorder,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14,
                color: isActive ? colors.accent : colors.textMuted,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isActive ? colors.accent : colors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BulkActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isDestructive;

  const _BulkActionButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDisabled = onTap == null;
    final color = isDestructive ? colors.red : colors.accent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        hoverColor: isDisabled ? null : colors.bgHover,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isDisabled
                ? Colors.transparent
                : (isDestructive ? colors.redMuted : colors.accentMuted),
            border: Border.all(
              color: isDisabled ? colors.glassBorder : color.withAlpha(100),
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14,
                color: isDisabled ? colors.textMuted : color,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDisabled ? colors.textMuted : color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KeywordRow extends StatefulWidget {
  final Keyword keyword;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final void Function(String) onUpdateNote;
  final VoidCallback onManageTags;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback? onToggleSelection;

  const _KeywordRow({
    required this.keyword,
    required this.onDelete,
    required this.onTap,
    required this.onToggleFavorite,
    required this.onUpdateNote,
    required this.onManageTags,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.onToggleSelection,
  });

  @override
  State<_KeywordRow> createState() => _KeywordRowState();
}

class _KeywordRowState extends State<_KeywordRow> {
  bool _isEditingNote = false;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.keyword.note ?? '');
  }

  @override
  void didUpdateWidget(_KeywordRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.keyword.note != widget.keyword.note && !_isEditingNote) {
      _noteController.text = widget.keyword.note ?? '';
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _saveNote() {
    widget.onUpdateNote(_noteController.text.trim());
    setState(() => _isEditingNote = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final keyword = widget.keyword;
    final isTopRank = keyword.position != null && keyword.position! <= 10;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        hoverColor: colors.bgHover,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: colors.glassBorder)),
          ),
          child: Row(
            children: [
              // Selection checkbox (only in selection mode)
              if (widget.isSelectionMode) ...[
                SizedBox(
                  width: 36,
                  child: Checkbox(
                    value: widget.isSelected,
                    onChanged: widget.onToggleSelection != null
                        ? (_) => widget.onToggleSelection!()
                        : null,
                    activeColor: colors.accent,
                    side: BorderSide(color: colors.textMuted),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
              // Favorite star
              SizedBox(
                width: 32,
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  child: InkWell(
                    onTap: widget.onToggleFavorite,
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        keyword.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                        size: 18,
                        color: keyword.isFavorite ? colors.yellow : colors.textMuted,
                      ),
                    ),
                  ),
                ),
              ),
              // Storefront flag
              SizedBox(
                width: 36,
                child: Text(
                  getFlagForStorefront(keyword.storefront),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              // Keyword
              SizedBox(
                width: 160,
                child: Text(
                  keyword.keyword,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              // Position
              SizedBox(
                width: 70,
                child: keyword.position != null
                    ? _PositionBadge(
                        position: keyword.position!,
                        change: keyword.change,
                        isTopRank: isTopRank,
                      )
                    : const _NotRankedBadge(),
              ),
              const SizedBox(width: 8),
              // Difficulty badge
              SizedBox(
                width: 50,
                child: keyword.difficulty != null
                    ? _DifficultyBadge(score: keyword.difficulty!)
                    : Text('--', style: TextStyle(color: colors.textMuted, fontSize: 12), textAlign: TextAlign.center),
              ),
              const SizedBox(width: 8),
              // Top competitors
              SizedBox(
                width: 90,
                child: keyword.topCompetitors != null && keyword.topCompetitors!.isNotEmpty
                    ? _TopCompetitorsRow(competitors: keyword.topCompetitors!)
                    : Text('--', style: TextStyle(color: colors.textMuted, fontSize: 12)),
              ),
              const SizedBox(width: 8),
              // Tags
              Expanded(
                flex: 2,
                child: _buildTagsSection(context, keyword),
              ),
              const SizedBox(width: 8),
              // Note
              Expanded(
                flex: 3,
                child: _buildNoteSection(context, keyword),
              ),
              // Delete button
              SizedBox(
                width: 36,
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  child: InkWell(
                    onTap: widget.onDelete,
                    borderRadius: BorderRadius.circular(6),
                    hoverColor: colors.redMuted,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(Icons.close_rounded, size: 16, color: colors.textMuted),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagsSection(BuildContext context, Keyword keyword) {
    final colors = context.colors;
    if (keyword.tags.isEmpty) {
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: widget.onManageTags,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_rounded, size: 14, color: colors.textMuted.withAlpha(150)),
                const SizedBox(width: 4),
                Text(
                  context.l10n.appDetail_addTag,
                  style: TextStyle(
                    fontSize: 11,
                    color: colors.textMuted.withAlpha(150),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: widget.onManageTags,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: keyword.tags.map((tag) => Container(
            margin: const EdgeInsets.only(right: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: tag.colorValue.withAlpha(40),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              tag.name,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: tag.colorValue,
              ),
            ),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildNoteSection(BuildContext context, Keyword keyword) {
    final colors = context.colors;
    if (_isEditingNote) {
      return Row(
        children: [
          Expanded(
            child: Container(
              height: 28,
              decoration: BoxDecoration(
                color: colors.bgBase,
                border: Border.all(color: colors.accent),
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextField(
                controller: _noteController,
                autofocus: true,
                style: TextStyle(fontSize: 12, color: colors.textPrimary),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  isDense: true,
                ),
                onSubmitted: (_) => _saveNote(),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Material(
            color: colors.accent,
            borderRadius: BorderRadius.circular(4),
            child: InkWell(
              onTap: _saveNote,
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.check_rounded, size: 14, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 2),
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            child: InkWell(
              onTap: () {
                _noteController.text = keyword.note ?? '';
                setState(() => _isEditingNote = false);
              },
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(Icons.close_rounded, size: 14, color: colors.textMuted),
              ),
            ),
          ),
        ],
      );
    }

    if (keyword.note == null || keyword.note!.isEmpty) {
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: () => setState(() => _isEditingNote = true),
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit_note_rounded, size: 14, color: colors.textMuted.withAlpha(150)),
                const SizedBox(width: 4),
                Text(
                  context.l10n.appDetail_addNote,
                  style: TextStyle(
                    fontSize: 11,
                    color: colors.textMuted.withAlpha(150),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => setState(() => _isEditingNote = true),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: colors.bgActive.withAlpha(80),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          keyword.note!,
          style: TextStyle(
            fontSize: 11,
            color: colors.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class _PositionBadge extends StatelessWidget {
  final int position;
  final int? change;
  final bool isTopRank;

  const _PositionBadge({
    required this.position,
    this.change,
    required this.isTopRank,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isTopRank ? colors.greenMuted : colors.bgActive,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '#$position',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isTopRank ? colors.green : colors.textSecondary,
            ),
          ),
        ),
        if (change != null && change != 0) ...[
          const SizedBox(width: 4),
          Icon(
            change! > 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
            size: 12,
            color: change! > 0 ? colors.green : colors.red,
          ),
        ],
      ],
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final int score;

  const _DifficultyBadge({required this.score});

  Color _getColor(AppColorsExtension colors) {
    if (score <= 25) return colors.green;
    if (score <= 50) return colors.yellow;
    if (score <= 75) return colors.orange;
    return colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = _getColor(colors);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$score',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _TopCompetitorsRow extends StatelessWidget {
  final List<TopCompetitor> competitors;

  const _TopCompetitorsRow({required this.competitors});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        ...competitors.take(3).map((c) => Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Tooltip(
                message: '${c.name} (#${c.position})',
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: colors.bgActive,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: colors.glassBorder),
                  ),
                  child: c.iconUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            c.iconUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.apps, size: 14, color: colors.textMuted),
                          ),
                        )
                      : Icon(Icons.apps, size: 14, color: colors.textMuted),
                ),
              ),
            )),
      ],
    );
  }
}

class _NotRankedBadge extends StatelessWidget {
  const _NotRankedBadge();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: colors.bgActive.withAlpha(50),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          '250+',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: colors.textMuted,
          ),
        ),
      ),
    );
  }
}

class _KeywordHistoryPanel extends ConsumerStatefulWidget {
  final Keyword? keyword;
  final int appId;
  final VoidCallback onClose;

  const _KeywordHistoryPanel({
    required this.keyword,
    required this.appId,
    required this.onClose,
  });

  @override
  ConsumerState<_KeywordHistoryPanel> createState() => _KeywordHistoryPanelState();
}

class _KeywordHistoryPanelState extends ConsumerState<_KeywordHistoryPanel> {
  List<RankingHistoryPoint>? _history;
  bool _isLoading = false;
  String? _error;
  int _selectedDays = 30;

  @override
  void didUpdateWidget(covariant _KeywordHistoryPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.keyword != oldWidget.keyword && widget.keyword != null) {
      _loadHistory();
    }
  }

  Future<void> _loadHistory() async {
    if (widget.keyword == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repository = ref.read(keywordsRepositoryProvider);
      final history = await repository.getRankingHistory(
        widget.appId,
        keywordId: widget.keyword!.id,
        days: _selectedDays,
      );
      if (mounted) {
        setState(() {
          _history = history;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isVisible = widget.keyword != null;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      top: 0,
      bottom: 0,
      right: isVisible ? 0 : -400,
      width: 400,
      child: Container(
        decoration: BoxDecoration(
          color: colors.glassPanel,
          border: Border(left: BorderSide(color: colors.glassBorder)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(40),
              blurRadius: 20,
              offset: const Offset(-4, 0),
            ),
          ],
        ),
        child: widget.keyword == null
            ? const SizedBox.shrink()
            : Column(
                children: [
                  // Header
                  Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: colors.glassBorder)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: colors.accent.withAlpha(30),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.show_chart_rounded,
                            size: 18,
                            color: colors.accent,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.keyword!.keyword,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: colors.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                context.l10n.appDetail_positionHistory,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                          child: InkWell(
                            onTap: widget.onClose,
                            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                            hoverColor: colors.bgHover,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(Icons.close_rounded, size: 20, color: colors.textMuted),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Period selector
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        _PeriodChip(
                          label: context.l10n.appDetail_period7d,
                          isSelected: _selectedDays == 7,
                          onTap: () {
                            setState(() => _selectedDays = 7);
                            _loadHistory();
                          },
                        ),
                        const SizedBox(width: 8),
                        _PeriodChip(
                          label: context.l10n.appDetail_period30d,
                          isSelected: _selectedDays == 30,
                          onTap: () {
                            setState(() => _selectedDays = 30);
                            _loadHistory();
                          },
                        ),
                        const SizedBox(width: 8),
                        _PeriodChip(
                          label: context.l10n.appDetail_period90d,
                          isSelected: _selectedDays == 90,
                          onTap: () {
                            setState(() => _selectedDays = 90);
                            _loadHistory();
                          },
                        ),
                      ],
                    ),
                  ),
                  // Chart
                  Expanded(
                    child: _buildContent(),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildContent() {
    final colors = context.colors;
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: colors.redMuted,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.error_outline_rounded, size: 28, color: colors.red),
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading history',
              style: TextStyle(
                fontSize: 14,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Material(
              color: colors.accent,
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              child: InkWell(
                onTap: _loadHistory,
                borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    context.l10n.common_retry,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_history == null || _history!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: colors.bgActive,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.timeline_rounded, size: 28, color: colors.textMuted),
            ),
            const SizedBox(height: 16),
            Text(
              'No history data',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Refresh rankings to start tracking',
              style: TextStyle(
                fontSize: 13,
                color: colors.textMuted,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          // Current stats
          _buildCurrentStats(),
          const SizedBox(height: 16),
          // Chart
          Expanded(
            child: _buildChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStats() {
    final colors = context.colors;
    final current = _history!.isNotEmpty ? _history!.last.position : null;
    final first = _history!.isNotEmpty ? _history!.first.position : null;
    int? change;
    if (current != null && first != null) {
      change = first - current; // positive = improved
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  current != null ? '#$current' : '--',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: current != null && current <= 10 ? colors.green : colors.textPrimary,
                  ),
                ),
                Text(
                  'Current',
                  style: TextStyle(fontSize: 12, color: colors.textMuted),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 40, color: colors.glassBorder),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (change != null && change != 0)
                      Icon(
                        change > 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                        size: 20,
                        color: change > 0 ? colors.green : colors.red,
                      ),
                    Text(
                      change != null ? change.abs().toString() : '--',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: change != null
                            ? (change > 0 ? colors.green : (change < 0 ? colors.red : colors.textMuted))
                            : colors.textMuted,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Change ($_selectedDays d)',
                  style: TextStyle(fontSize: 12, color: colors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    final colors = context.colors;
    final spots = <FlSpot>[];
    final dates = <double, DateTime>{};

    for (var i = 0; i < _history!.length; i++) {
      final point = _history![i];
      if (point.position != null) {
        spots.add(FlSpot(i.toDouble(), point.position!.toDouble()));
        dates[i.toDouble()] = point.recordedAt;
      }
    }

    if (spots.isEmpty) {
      return Center(
        child: Text(
          'Not enough data to display chart',
          style: TextStyle(color: colors.textMuted),
        ),
      );
    }

    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final padding = ((maxY - minY) * 0.1).clamp(1.0, 10.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: ((maxY - minY) / 4).clamp(1, 50),
            getDrawingHorizontalLine: (value) => FlLine(
              color: colors.glassBorder,
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) => Text(
                  '#${value.toInt()}',
                  style: TextStyle(
                    fontSize: 10,
                    color: colors.textMuted,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: (_history!.length / 4).ceilToDouble().clamp(1, double.infinity),
                getTitlesWidget: (value, meta) {
                  final date = dates[value];
                  if (date == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      DateFormat('d/M').format(date),
                      style: TextStyle(
                        fontSize: 10,
                        color: colors.textMuted,
                      ),
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (_history!.length - 1).toDouble(),
          minY: (minY - padding).clamp(1, double.infinity),
          maxY: maxY + padding,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.3,
              color: colors.accent,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                  radius: 4,
                  color: colors.accent,
                  strokeWidth: 2,
                  strokeColor: colors.glassPanel,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                color: colors.accent.withAlpha(30),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => colors.bgPanel,
              tooltipBorder: BorderSide(color: colors.glassBorder),
              tooltipRoundedRadius: 8,
              getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
                final date = dates[spot.x];
                return LineTooltipItem(
                  '#${spot.y.toInt()}\n${date != null ? DateFormat('d MMM').format(date) : ''}',
                  TextStyle(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PeriodChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: isSelected ? colors.accent : colors.bgActive,
      borderRadius: BorderRadius.circular(AppColors.radiusSmall),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _TagsManagementDialog extends ConsumerStatefulWidget {
  final Keyword keyword;
  final int appId;

  const _TagsManagementDialog({
    required this.keyword,
    required this.appId,
  });

  @override
  ConsumerState<_TagsManagementDialog> createState() => _TagsManagementDialogState();
}

class _TagsManagementDialogState extends ConsumerState<_TagsManagementDialog> {
  late List<TagModel> _selectedTags;
  final _newTagController = TextEditingController();
  bool _isCreatingTag = false;

  @override
  void initState() {
    super.initState();
    _selectedTags = List.from(widget.keyword.tags);
  }

  @override
  void dispose() {
    _newTagController.dispose();
    super.dispose();
  }

  String _generateRandomColor() {
    const colors = [
      '#ef4444', '#f97316', '#f59e0b', '#eab308', '#84cc16',
      '#22c55e', '#10b981', '#14b8a6', '#06b6d4', '#0ea5e9',
      '#3b82f6', '#6366f1', '#8b5cf6', '#a855f7', '#d946ef',
      '#ec4899', '#f43f5e',
    ];
    return colors[(DateTime.now().millisecondsSinceEpoch % colors.length)];
  }

  Future<void> _createTag() async {
    final name = _newTagController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isCreatingTag = true);

    try {
      final repository = ref.read(tagsRepositoryProvider);
      final newTag = await repository.createTag(name: name, color: _generateRandomColor());
      _newTagController.clear();

      // Add to selected tags and refresh tags list
      setState(() {
        _selectedTags.add(newTag);
      });
      ref.invalidate(tagsNotifierProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.common_error(e.toString())), backgroundColor: context.colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCreatingTag = false);
      }
    }
  }

  void _toggleTag(TagModel tag) {
    setState(() {
      final index = _selectedTags.indexWhere((t) => t.id == tag.id);
      if (index >= 0) {
        _selectedTags.removeAt(index);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  Future<void> _save() async {
    final repository = ref.read(tagsRepositoryProvider);

    // Get current tags on keyword
    final currentTagIds = widget.keyword.tags.map((t) => t.id).toSet();
    final selectedTagIds = _selectedTags.map((t) => t.id).toSet();

    // Tags to add
    for (final tagId in selectedTagIds.difference(currentTagIds)) {
      await repository.addTagToKeyword(tagId: tagId, trackedKeywordId: widget.keyword.trackedKeywordId!);
    }

    // Tags to remove
    for (final tagId in currentTagIds.difference(selectedTagIds)) {
      await repository.removeTagFromKeyword(tagId: tagId, trackedKeywordId: widget.keyword.trackedKeywordId!);
    }

    if (mounted) {
      Navigator.pop(context, _selectedTags);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tagsState = ref.watch(tagsNotifierProvider);

    return AlertDialog(
      backgroundColor: colors.glassPanel,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        side: BorderSide(color: colors.glassBorder),
      ),
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colors.accent.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.label_rounded, size: 18, color: colors.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.appDetail_manageTags,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                Text(
                  widget.keyword.keyword,
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Create new tag
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors.bgBase,
                      border: Border.all(color: colors.glassBorder),
                      borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                    ),
                    child: TextField(
                      controller: _newTagController,
                      style: TextStyle(fontSize: 13, color: colors.textPrimary),
                      decoration: InputDecoration(
                        hintText: context.l10n.appDetail_newTagHint,
                        hintStyle: TextStyle(color: colors.textMuted),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      onSubmitted: (_) => _createTag(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  color: colors.accent,
                  borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                  child: InkWell(
                    onTap: _isCreatingTag ? null : _createTag,
                    borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: _isCreatingTag
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.add_rounded, size: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Existing tags
            Text(
              context.l10n.appDetail_availableTags,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colors.textMuted,
              ),
            ),
            const SizedBox(height: 8),
            tagsState.when(
              loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
              error: (e, _) => Text(context.l10n.common_error(e.toString()), style: TextStyle(color: colors.red)),
              data: (tags) {
                if (tags.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        context.l10n.appDetail_noTagsYet,
                        style: TextStyle(color: colors.textMuted, fontSize: 13),
                      ),
                    ),
                  );
                }

                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tags.map((tag) {
                    final isSelected = _selectedTags.any((t) => t.id == tag.id);
                    return Material(
                      color: isSelected ? tag.colorValue.withAlpha(60) : colors.bgActive,
                      borderRadius: BorderRadius.circular(6),
                      child: InkWell(
                        onTap: () => _toggleTag(tag),
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? tag.colorValue : Colors.transparent,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: tag.colorValue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                tag.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected ? tag.colorValue : colors.textSecondary,
                                ),
                              ),
                              if (isSelected) ...[
                                const SizedBox(width: 4),
                                Icon(Icons.check_rounded, size: 14, color: tag.colorValue),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
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
          onPressed: _save,
          child: Text(context.l10n.common_save),
        ),
      ],
    );
  }
}

class _BulkTagsDialog extends StatefulWidget {
  final List<TagModel> tags;

  const _BulkTagsDialog({required this.tags});

  @override
  State<_BulkTagsDialog> createState() => _BulkTagsDialogState();
}

class _BulkTagsDialogState extends State<_BulkTagsDialog> {
  final Set<int> _selectedTagIds = {};

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AlertDialog(
      title: Text(context.l10n.appDetail_addTagsTitle),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.appDetail_selectTagsDescription,
              style: TextStyle(
                fontSize: 13,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.tags.map((tag) {
                final isSelected = _selectedTagIds.contains(tag.id);
                return Material(
                  color: isSelected ? tag.colorValue.withAlpha(60) : colors.bgActive,
                  borderRadius: BorderRadius.circular(6),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedTagIds.remove(tag.id);
                        } else {
                          _selectedTagIds.add(tag.id);
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? tag.colorValue : Colors.transparent,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: tag.colorValue,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            tag.name,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? tag.colorValue : colors.textSecondary,
                            ),
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 4),
                            Icon(Icons.check_rounded, size: 14, color: tag.colorValue),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
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
          onPressed: _selectedTagIds.isEmpty
              ? null
              : () => Navigator.pop(context, _selectedTagIds.toList()),
          child: Text(context.l10n.appDetail_addTagsCount(_selectedTagIds.length)),
        ),
      ],
    );
  }
}

class _ImportKeywordsDialog extends StatefulWidget {
  final int appId;
  final Future<ImportResult> Function(String keywords, String storefront) onImport;

  const _ImportKeywordsDialog({
    required this.appId,
    required this.onImport,
  });

  @override
  State<_ImportKeywordsDialog> createState() => _ImportKeywordsDialogState();
}

class _ImportKeywordsDialogState extends State<_ImportKeywordsDialog> {
  final _controller = TextEditingController();
  String _storefront = 'US';
  bool _isLoading = false;

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
        style: TextStyle(color: colors.textPrimary),
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.appDetail_pasteKeywordsHint,
              style: TextStyle(
                fontSize: 13,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              maxLines: 10,
              style: TextStyle(
                fontSize: 13,
                color: colors.textPrimary,
                fontFamily: 'monospace',
              ),
              decoration: InputDecoration(
                hintText: context.l10n.appDetail_keywordPlaceholder,
                hintStyle: TextStyle(
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
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  context.l10n.appDetail_storefront,
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _storefront,
                  dropdownColor: colors.glassPanel,
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.textPrimary,
                  ),
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
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textMuted,
                  ),
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
// Preview Mode Widgets
// =============================================================================

class _PreviewKeywordsPlaceholder extends StatelessWidget {
  final bool isAdding;
  final VoidCallback onAddApp;

  const _PreviewKeywordsPlaceholder({
    required this.isAdding,
    required this.onAddApp,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colors.accent.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.key_rounded, size: 18, color: colors.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              context.l10n.appPreview_keywordsPlaceholder,
              style: TextStyle(
                fontSize: 13,
                color: colors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: isAdding ? null : onAddApp,
            icon: isAdding
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.add, size: 18),
            label: Text(context.l10n.appPreview_addToMyApps),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailData {
  final IconData icon;
  final String label;
  final String value;

  const _DetailData({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class _DetailChip extends StatelessWidget {
  final _DetailData data;

  const _DetailChip({required this.data});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(data.icon, size: 14, color: colors.textMuted),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.label,
              style: TextStyle(
                fontSize: 10,
                color: colors.textMuted,
              ),
            ),
            Text(
              data.value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Collapsible section that groups Description, Screenshots, and Details
/// Collapsed by default to prioritize keyword visibility
class _CollapsibleAppInfo extends StatefulWidget {
  final AppModel app;

  const _CollapsibleAppInfo({required this.app});

  @override
  State<_CollapsibleAppInfo> createState() => _CollapsibleAppInfoState();
}

class _CollapsibleAppInfoState extends State<_CollapsibleAppInfo>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  late Animation<double> _iconTurns;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeInOut));
    _iconTurns = _controller.drive(
      Tween<double>(begin: 0.0, end: 0.5).chain(CurveTween(curve: Curves.easeIn)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  bool get _hasDescription =>
      widget.app.description != null && widget.app.description!.isNotEmpty;

  bool get _hasScreenshots =>
      widget.app.screenshots != null && widget.app.screenshots!.isNotEmpty;


  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Header - always visible
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _toggleExpanded,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: colors.accent.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.info_outline,
                        size: 16,
                        color: colors.accent,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.appPreview_details,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _buildSummary(context),
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RotationTransition(
                      turns: _iconTurns,
                      child: Icon(
                        Icons.expand_more,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Expandable content
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: _heightFactor.value,
                  child: child,
                ),
              );
            },
            child: Column(
              children: [
                Divider(height: 1, color: colors.glassBorder),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description
                      if (_hasDescription) ...[
                        _CollapsedDescription(description: widget.app.description!),
                        const SizedBox(height: 16),
                      ],
                      // Screenshots
                      if (_hasScreenshots) ...[
                        _CollapsedScreenshots(screenshots: widget.app.screenshots!),
                        const SizedBox(height: 16),
                      ],
                      // Details grid
                      _CollapsedDetails(app: widget.app),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _buildSummary(BuildContext context) {
    final parts = <String>[];
    if (_hasDescription) parts.add(context.l10n.appPreview_description);
    if (_hasScreenshots) {
      parts.add('${widget.app.screenshots!.length} ${context.l10n.appPreview_screenshots}');
    }
    if (widget.app.version != null) parts.add('v${widget.app.version}');
    return parts.join(' · ');
  }
}

class _CollapsedDescription extends StatefulWidget {
  final String description;

  const _CollapsedDescription({required this.description});

  @override
  State<_CollapsedDescription> createState() => _CollapsedDescriptionState();
}

class _CollapsedDescriptionState extends State<_CollapsedDescription> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.description_outlined, size: 14, color: colors.textMuted),
            const SizedBox(width: 8),
            Text(
              context.l10n.appPreview_description,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Text(
                _isExpanded ? context.l10n.appPreview_showLess : context.l10n.appPreview_showMore,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: colors.accent,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedCrossFade(
          firstChild: Text(
            widget.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: colors.textSecondary,
              height: 1.4,
            ),
          ),
          secondChild: Text(
            widget.description,
            style: TextStyle(
              fontSize: 12,
              color: colors.textSecondary,
              height: 1.4,
            ),
          ),
          crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }
}

class _CollapsedScreenshots extends StatelessWidget {
  final List<String> screenshots;

  const _CollapsedScreenshots({required this.screenshots});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.photo_library_outlined, size: 14, color: colors.textMuted),
            const SizedBox(width: 8),
            Text(
              context.l10n.appPreview_screenshots,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: screenshots.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  screenshots[index],
                  height: 140,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => Container(
                    width: 70,
                    height: 140,
                    decoration: BoxDecoration(
                      color: colors.bgActive,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.image_not_supported, size: 20, color: colors.textMuted),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CollapsedDetails extends StatelessWidget {
  final AppModel app;

  const _CollapsedDetails({required this.app});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd();

    final details = <_DetailData>[];

    if (app.version != null) {
      details.add(_DetailData(
        icon: Icons.new_releases_outlined,
        label: context.l10n.appPreview_version,
        value: app.version!,
      ));
    }
    if (app.updatedDate != null) {
      details.add(_DetailData(
        icon: Icons.update,
        label: context.l10n.appPreview_updated,
        value: dateFormat.format(app.updatedDate!),
      ));
    }
    if (app.releaseDate != null) {
      details.add(_DetailData(
        icon: Icons.rocket_launch_outlined,
        label: context.l10n.appPreview_released,
        value: dateFormat.format(app.releaseDate!),
      ));
    }
    if (app.sizeBytes != null) {
      details.add(_DetailData(
        icon: Icons.storage_outlined,
        label: context.l10n.appPreview_size,
        value: _formatSize(app.sizeBytes!),
      ));
    }
    if (app.minimumOs != null) {
      details.add(_DetailData(
        icon: Icons.phone_iphone,
        label: context.l10n.appPreview_minimumOs,
        value: app.minimumOs!,
      ));
    }
    details.add(_DetailData(
      icon: Icons.sell_outlined,
      label: context.l10n.appPreview_price,
      value: app.price == null || app.price == 0
          ? context.l10n.appPreview_free
          : '${app.currency ?? '\$'}${app.price!.toStringAsFixed(2)}',
    ));

    return Wrap(
      spacing: 20,
      runSpacing: 12,
      children: details.map((d) => _DetailChip(data: d)).toList(),
    );
  }

  String _formatSize(int bytes) {
    if (bytes >= 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    } else if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '$bytes B';
  }
}
