import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../data/metadata_repository.dart';
import '../../domain/metadata_model.dart';
import '../../providers/metadata_provider.dart';
import '../widgets/metadata_bulk_actions_bar.dart';
import '../widgets/metadata_coverage_card.dart';
import '../widgets/metadata_locale_editor.dart';
import '../widgets/metadata_locale_list.dart';
import '../widgets/metadata_multi_locale_table.dart';

class MetadataEditorScreen extends ConsumerStatefulWidget {
  final int appId;
  final String appName;

  const MetadataEditorScreen({
    super.key,
    required this.appId,
    required this.appName,
  });

  @override
  ConsumerState<MetadataEditorScreen> createState() =>
      _MetadataEditorScreenState();
}

class _MetadataEditorScreenState extends ConsumerState<MetadataEditorScreen> {
  String? _selectedLocale;
  bool _isRefreshing = false;
  bool _useTableView = true;

  @override
  Widget build(BuildContext context) {
    final metadataAsync = ref.watch(appMetadataProvider(widget.appId));
    final selectedLocales = ref.watch(selectedLocalesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.metadata_editor),
        actions: [
          // AI Optimize button
          if (_selectedLocale != null)
            IconButton(
              icon: const Icon(Icons.auto_awesome),
              onPressed: () => _openAiWizard(metadataAsync.valueOrNull),
              tooltip: context.l10n.metadata_aiOptimize,
            ),
          // View toggle button
          IconButton(
            icon: Icon(_useTableView ? Icons.view_list : Icons.table_chart),
            onPressed: () => setState(() => _useTableView = !_useTableView),
            tooltip: _useTableView
                ? context.l10n.metadataListView
                : context.l10n.metadataTableView,
          ),
          if (_selectedLocale != null)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(() => _selectedLocale = null),
              tooltip: context.l10n.common_cancel,
            ),
          IconButton(
            icon: _isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _refreshMetadata,
            tooltip: context.l10n.common_refresh,
          ),
        ],
      ),
      body: metadataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildError(error.toString()),
        data: (metadata) => _buildContent(metadata),
      ),
      // Show bulk actions bar when locales are selected
      bottomNavigationBar: metadataAsync.maybeWhen(
        data: (metadata) => selectedLocales.isNotEmpty
            ? MetadataBulkActionsBar(
                appId: widget.appId,
                locales: metadata.locales,
                onActionComplete: () {
                  ref.invalidate(appMetadataProvider(widget.appId));
                },
              )
            : null,
        orElse: () => null,
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.red),
            const SizedBox(height: AppSpacing.md),
            Text(
              error,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: () => ref.invalidate(appMetadataProvider(widget.appId)),
              child: Text(context.l10n.common_retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(AppMetadataResponse metadata) {
    if (!metadata.canEdit) {
      return _buildReadOnlyView(metadata);
    }

    // If user can edit but no locales, they need to connect store first
    if (metadata.locales.isEmpty) {
      return _buildNoLocalesView(metadata);
    }

    // Desktop: side-by-side layout
    // Mobile: show either list or editor
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;

        if (isWide) {
          return Row(
            children: [
              SizedBox(
                width: 380,
                child: Column(
                  children: [
                    // Coverage card at the top
                    MetadataCoverageCard(locales: metadata.locales),
                    // Locale list/table
                    Expanded(
                      child: _useTableView
                          ? MetadataMultiLocaleTable(
                              locales: metadata.locales,
                              selectedLocale: _selectedLocale,
                              onLocaleSelected: (locale) =>
                                  setState(() => _selectedLocale = locale),
                              appId: widget.appId,
                            )
                          : MetadataLocaleList(
                              locales: metadata.locales,
                              selectedLocale: _selectedLocale,
                              onLocaleSelected: (locale) =>
                                  setState(() => _selectedLocale = locale),
                            ),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: _selectedLocale != null
                    ? MetadataLocaleEditor(
                        key: ValueKey(_selectedLocale),
                        appId: widget.appId,
                        locale: _selectedLocale!,
                        platform: metadata.platform,
                        onSaved: _onDraftSaved,
                        onPublish: () => _publishLocale(_selectedLocale!),
                      )
                    : _buildSelectLocalePrompt(),
              ),
            ],
          );
        }

        // Mobile view
        if (_selectedLocale != null) {
          return MetadataLocaleEditor(
            key: ValueKey(_selectedLocale),
            appId: widget.appId,
            locale: _selectedLocale!,
            platform: metadata.platform,
            onSaved: _onDraftSaved,
            onPublish: () => _publishLocale(_selectedLocale!),
            onBack: () => setState(() => _selectedLocale = null),
          );
        }

        // Mobile: show coverage card + list/table
        return Column(
          children: [
            MetadataCoverageCard(locales: metadata.locales),
            Expanded(
              child: _useTableView
                  ? MetadataMultiLocaleTable(
                      locales: metadata.locales,
                      selectedLocale: _selectedLocale,
                      onLocaleSelected: (locale) =>
                          setState(() => _selectedLocale = locale),
                      appId: widget.appId,
                    )
                  : MetadataLocaleList(
                      locales: metadata.locales,
                      selectedLocale: _selectedLocale,
                      onLocaleSelected: (locale) =>
                          setState(() => _selectedLocale = locale),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReadOnlyView(AppMetadataResponse metadata) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 48, color: AppColors.textMuted),
            const SizedBox(height: AppSpacing.md),
            Text(
              context.l10n.metadata_connectRequired,
              textAlign: TextAlign.center,
              style: AppTypography.title,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              context.l10n.metadata_connectDescription,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (!metadata.isOwner)
              ElevatedButton.icon(
                onPressed: () => context.push('/settings/integrations'),
                icon: const Icon(Icons.link),
                label: Text(context.l10n.metadata_connectStore),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoLocalesView(AppMetadataResponse metadata) {
    final storeName = metadata.platform == 'ios'
        ? 'App Store Connect'
        : 'Google Play Console';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.accentMuted,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.link_off,
                size: 40,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              context.l10n.metadata_noStoreConnection,
              textAlign: TextAlign.center,
              style: AppTypography.title,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              context.l10n.metadata_noStoreConnectionDesc(storeName),
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              onPressed: () => context.push('/settings/integrations'),
              icon: const Icon(Icons.link),
              label: Text(context.l10n.metadata_connectStoreButton(storeName)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectLocalePrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.language, size: 48, color: AppColors.textMuted),
          const SizedBox(height: AppSpacing.md),
          Text(
            context.l10n.metadata_selectLocale,
            style: AppTypography.title.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshMetadata() async {
    setState(() => _isRefreshing = true);

    try {
      final repository = ref.read(metadataRepositoryProvider);
      await repository.refreshMetadata(widget.appId);
      ref.invalidate(appMetadataProvider(widget.appId));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.metadata_refreshed),
            backgroundColor: AppColors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  void _onDraftSaved() {
    ref.invalidate(appMetadataProvider(widget.appId));
  }

  void _openAiWizard(AppMetadataResponse? metadata) {
    if (_selectedLocale == null || metadata == null) return;

    context.push(
      '/apps/${widget.appId}/metadata/optimize'
      '?name=${Uri.encodeComponent(widget.appName)}'
      '&locale=$_selectedLocale'
      '&platform=${metadata.platform}',
    );
  }

  Future<void> _publishLocale(String locale) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.metadata_publishTitle),
        content: Text(context.l10n.metadata_publishConfirm(locale)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.l10n.common_cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.l10n.metadata_publish),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final repository = ref.read(metadataRepositoryProvider);
      final result = await repository.publishMetadata(
        appId: widget.appId,
        locales: [locale],
      );

      ref.invalidate(appMetadataProvider(widget.appId));

      if (mounted) {
        if (result.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.metadata_publishSuccess),
              backgroundColor: AppColors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.errors.join(', ')),
              backgroundColor: AppColors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.red,
          ),
        );
      }
    }
  }
}
