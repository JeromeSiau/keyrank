import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../core/api/api_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/country_provider.dart';
import '../../../shared/widgets/buttons.dart';
import '../providers/apps_provider.dart';
import '../../keywords/data/keywords_repository.dart';
import '../../keywords/domain/keyword_model.dart';

final appKeywordsProvider = FutureProvider.family<List<Keyword>, int>((ref, appId) async {
  final repository = ref.watch(keywordsRepositoryProvider);
  return repository.getKeywordsForApp(appId);
});

class AppDetailScreen extends ConsumerStatefulWidget {
  final int appId;

  const AppDetailScreen({super.key, required this.appId});

  @override
  ConsumerState<AppDetailScreen> createState() => _AppDetailScreenState();
}

class _AppDetailScreenState extends ConsumerState<AppDetailScreen> {
  final _keywordController = TextEditingController();
  bool _isAddingKeyword = false;
  Keyword? _selectedKeyword;
  bool _countryInitialized = false;

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
      await repository.addKeywordToApp(widget.appId, keyword, storefront: country.code.toUpperCase());
      _keywordController.clear();
      ref.invalidate(appKeywordsProvider(widget.appId));
      ref.invalidate(appsNotifierProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Keyword "$keyword" added (${country.flag})'),
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

  Future<void> _deleteApp() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.glassPanel,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
          side: const BorderSide(color: AppColors.glassBorder),
        ),
        title: const Text(
          'Delete app?',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'This action cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(appsNotifierProvider.notifier).deleteApp(widget.appId);
      if (mounted) {
        context.go('/apps');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appsAsync = ref.watch(appsNotifierProvider);
    final keywordsAsync = ref.watch(appKeywordsProvider(widget.appId));

    final app = appsAsync.valueOrNull?.firstWhere(
      (a) => a.id == widget.appId,
      orElse: () => throw Exception('App not found'),
    );

    if (app == null) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.glassPanel,
          borderRadius: BorderRadius.circular(AppColors.radiusLarge),
        ),
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    // Initialize country selector from app's storefront
    _initializeCountryFromApp(app.storefront);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassPanel,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
      ),
      child: Stack(
        children: [
          // Main content
          Column(
              children: [
                // Toolbar
                _Toolbar(
                appName: app.name,
                onBack: () => context.go('/apps'),
                onDelete: _deleteApp,
                onViewRatings: () => context.push(
                  '/apps/${widget.appId}/ratings?name=${Uri.encodeComponent(app.name)}',
                ),
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
                        app: app,
                        onViewRatings: () => context.push(
                          '/apps/${widget.appId}/ratings?name=${Uri.encodeComponent(app.name)}',
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Add keyword section
                      _AddKeywordSection(
                        controller: _keywordController,
                        isAdding: _isAddingKeyword,
                        onAdd: _addKeyword,
                      ),
                      const SizedBox(height: 16),
                      // Keywords table
                      _KeywordsTable(
                        keywordsAsync: keywordsAsync,
                        onDelete: (keyword) async {
                          final repository = ref.read(keywordsRepositoryProvider);
                          await repository.removeKeywordFromApp(widget.appId, keyword.id);
                          ref.invalidate(appKeywordsProvider(widget.appId));
                          ref.invalidate(appsNotifierProvider);
                        },
                        onKeywordTap: _showKeywordHistory,
                        hasIos: app.hasIos,
                        hasAndroid: app.hasAndroid,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Backdrop to close panel when tapping outside
          if (_selectedKeyword != null)
            Positioned.fill(
              child: GestureDetector(
                onTap: _hideKeywordHistory,
                behavior: HitTestBehavior.translucent,
                child: Container(color: Colors.transparent),
              ),
            ),
          // Sliding history panel
          _KeywordHistoryPanel(
            keyword: _selectedKeyword,
            appId: widget.appId,
            onClose: _hideKeywordHistory,
          ),
        ],
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  final String appName;
  final VoidCallback onBack;
  final VoidCallback onDelete;
  final VoidCallback onViewRatings;

  const _Toolbar({
    required this.appName,
    required this.onBack,
    required this.onDelete,
    required this.onViewRatings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
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
              hoverColor: AppColors.bgHover,
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.arrow_back_rounded, size: 20, color: AppColors.textMuted),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // App name
          Expanded(
            child: Text(
              appName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Actions
          ToolbarButton(
            icon: Icons.star_outline_rounded,
            label: 'Ratings',
            onTap: onViewRatings,
          ),
          const SizedBox(width: 10),
          ToolbarButton(
            icon: Icons.delete_outline_rounded,
            label: 'Delete',
            isDestructive: true,
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
}

class _AppInfoCard extends StatelessWidget {
  final dynamic app;
  final VoidCallback onViewRatings;

  const _AppInfoCard({required this.app, required this.onViewRatings});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgActive.withAlpha(50),
        border: Border.all(color: AppColors.glassBorder),
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
            child: app.displayIconUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      app.displayIconUrl!,
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
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (app.developer != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    app.developer!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                // Platform badges
                Row(
                  children: [
                    if (app.hasIos)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          color: AppColors.bgActive,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('🍎', style: TextStyle(fontSize: 12)),
                            SizedBox(width: 4),
                            Text(
                              'iOS',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (app.hasAndroid)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.greenMuted,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('🤖', style: TextStyle(fontSize: 12)),
                            SizedBox(width: 4),
                            Text(
                              'Android',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // Stats
          if (app.rating != null)
            _StatBadge(
              icon: Icons.star_rounded,
              iconColor: AppColors.yellow,
              value: app.rating!.toStringAsFixed(1),
              label: '${app.ratingCount ?? 0} reviews',
              onTap: onViewRatings,
            ),
          const SizedBox(width: 12),
          _StatBadge(
            icon: Icons.key_rounded,
            iconColor: AppColors.accent,
            value: '${app.trackedKeywordsCount ?? 0}',
            label: 'keywords',
          ),
        ],
      ),
    );
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
    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bgActive,
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
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textMuted,
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
          hoverColor: AppColors.bgHover,
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
    final selectedCountry = ref.watch(selectedCountryProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgActive.withAlpha(50),
        border: Border.all(color: AppColors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.accent.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.add_rounded, size: 18, color: AppColors.accent),
          ),
          const SizedBox(width: 12),
          const Text(
            'Add keyword',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 16),
          // Country selector
          PopupMenuButton<Country>(
            onSelected: (country) {
              ref.read(selectedCountryProvider.notifier).state = country;
            },
            offset: const Offset(0, 44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppColors.radiusMedium),
              side: const BorderSide(color: AppColors.glassBorder),
            ),
            color: AppColors.glassPanel,
            itemBuilder: (context) => availableCountries
                .map((country) => PopupMenuItem<Country>(
                      value: country,
                      height: 44,
                      child: Row(
                        children: [
                          Text(country.flag, style: const TextStyle(fontSize: 18)),
                          const SizedBox(width: 10),
                          Text(
                            country.name,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.bgActive,
                border: Border.all(color: AppColors.glassBorder),
                borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(selectedCountry.flag, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text(
                    selectedCountry.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.textMuted),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Text field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.bgBase,
                border: Border.all(color: AppColors.glassBorder),
                borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              ),
              child: TextField(
                controller: controller,
                onSubmitted: (_) => onAdd(),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
                decoration: const InputDecoration(
                  hintText: 'e.g., fitness tracker',
                  hintStyle: TextStyle(color: AppColors.textMuted),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Add button
          Material(
            color: AppColors.accent,
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
                    : const Text(
                        'Add',
                        style: TextStyle(
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

class _KeywordsTable extends StatelessWidget {
  final AsyncValue<List<Keyword>> keywordsAsync;
  final Future<void> Function(Keyword) onDelete;
  final void Function(Keyword) onKeywordTap;
  final bool hasIos;
  final bool hasAndroid;

  const _KeywordsTable({
    required this.keywordsAsync,
    required this.onDelete,
    required this.onKeywordTap,
    required this.hasIos,
    required this.hasAndroid,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgActive.withAlpha(50),
        border: Border.all(color: AppColors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Text(
                  'Tracked Keywords',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                if (keywordsAsync.hasValue)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accentMuted,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${keywordsAsync.value!.length}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.bgActive.withAlpha(80),
              border: const Border(
                top: BorderSide(color: AppColors.glassBorder),
                bottom: BorderSide(color: AppColors.glassBorder),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 50,
                  child: Text(
                    'STORE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                const Expanded(
                  child: Text(
                    'KEYWORD',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                if (hasIos)
                  const SizedBox(
                    width: 80,
                    child: Text(
                      'iOS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: AppColors.textMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (hasIos && hasAndroid) const SizedBox(width: 12),
                if (hasAndroid)
                  const SizedBox(
                    width: 80,
                    child: Text(
                      'ANDROID',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: AppColors.textMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          // Content
          keywordsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(40),
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.redMuted,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.error_outline_rounded,
                        size: 28,
                        color: AppColors.red,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: $e',
                      style: const TextStyle(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            data: (keywords) {
              if (keywords.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(40),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.bgActive,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.key_off_rounded, size: 28, color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No keywords tracked',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Add a keyword above to start tracking',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: keywords.map((keyword) => _KeywordRow(
                  keyword: keyword,
                  onDelete: () => onDelete(keyword),
                  onTap: () => onKeywordTap(keyword),
                  hasIos: hasIos,
                  hasAndroid: hasAndroid,
                )).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _KeywordRow extends StatelessWidget {
  final Keyword keyword;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final bool hasIos;
  final bool hasAndroid;

  const _KeywordRow({
    required this.keyword,
    required this.onDelete,
    required this.onTap,
    required this.hasIos,
    required this.hasAndroid,
  });

  @override
  Widget build(BuildContext context) {
    final isIosTopRank = keyword.iosPosition != null && keyword.iosPosition! <= 10;
    final isAndroidTopRank = keyword.androidPosition != null && keyword.androidPosition! <= 10;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: AppColors.bgHover,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
          ),
          child: Row(
            children: [
              // Storefront flag
              SizedBox(
                width: 50,
                child: Text(
                  getFlagForStorefront(keyword.storefront),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              // Keyword
              Expanded(
                child: Text(
                  keyword.keyword,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              // iOS Position
              if (hasIos)
                SizedBox(
                  width: 80,
                  child: keyword.iosPosition != null
                      ? _PositionBadge(
                          position: keyword.iosPosition!,
                          change: keyword.iosChange,
                          isTopRank: isIosTopRank,
                        )
                      : const _NotRankedBadge(),
                ),
              if (hasIos && hasAndroid) const SizedBox(width: 12),
              // Android Position
              if (hasAndroid)
                SizedBox(
                  width: 80,
                  child: keyword.androidPosition != null
                      ? _PositionBadge(
                          position: keyword.androidPosition!,
                          change: keyword.androidChange,
                          isTopRank: isAndroidTopRank,
                        )
                      : const _NotRankedBadge(),
                ),
              // Delete button
              SizedBox(
                width: 48,
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: onDelete,
                    borderRadius: BorderRadius.circular(8),
                    hoverColor: AppColors.redMuted,
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.close_rounded, size: 18, color: AppColors.textMuted),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isTopRank ? AppColors.greenMuted : AppColors.bgActive,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '#$position',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isTopRank ? AppColors.green : AppColors.textSecondary,
            ),
          ),
        ),
        if (change != null && change != 0) ...[
          const SizedBox(width: 4),
          Icon(
            change! > 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
            size: 12,
            color: change! > 0 ? AppColors.green : AppColors.red,
          ),
        ],
      ],
    );
  }
}

class _NotRankedBadge extends StatelessWidget {
  const _NotRankedBadge();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.bgActive.withAlpha(50),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          '250+',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textMuted,
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
          color: AppColors.glassPanel,
          border: const Border(left: BorderSide(color: AppColors.glassBorder)),
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
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.accent.withAlpha(30),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.show_chart_rounded,
                            size: 18,
                            color: AppColors.accent,
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
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Position History',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
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
                            hoverColor: AppColors.bgHover,
                            child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.close_rounded, size: 20, color: AppColors.textMuted),
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
                          label: '7d',
                          isSelected: _selectedDays == 7,
                          onTap: () {
                            setState(() => _selectedDays = 7);
                            _loadHistory();
                          },
                        ),
                        const SizedBox(width: 8),
                        _PeriodChip(
                          label: '30d',
                          isSelected: _selectedDays == 30,
                          onTap: () {
                            setState(() => _selectedDays = 30);
                            _loadHistory();
                          },
                        ),
                        const SizedBox(width: 8),
                        _PeriodChip(
                          label: '90d',
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
                color: AppColors.redMuted,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.error_outline_rounded, size: 28, color: AppColors.red),
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading history',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Material(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              child: InkWell(
                onTap: _loadHistory,
                borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Retry',
                    style: TextStyle(
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
                color: AppColors.bgActive,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.timeline_rounded, size: 28, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),
            const Text(
              'No history data',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Refresh rankings to start tracking',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
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
    final current = _history!.isNotEmpty ? _history!.last.position : null;
    final first = _history!.isNotEmpty ? _history!.first.position : null;
    int? change;
    if (current != null && first != null) {
      change = first - current; // positive = improved
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgActive.withAlpha(50),
        border: Border.all(color: AppColors.glassBorder),
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
                    color: current != null && current <= 10 ? AppColors.green : AppColors.textPrimary,
                  ),
                ),
                const Text(
                  'Current',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 40, color: AppColors.glassBorder),
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
                        color: change > 0 ? AppColors.green : AppColors.red,
                      ),
                    Text(
                      change != null ? change.abs().toString() : '--',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: change != null
                            ? (change > 0 ? AppColors.green : (change < 0 ? AppColors.red : AppColors.textMuted))
                            : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Change ($_selectedDays d)',
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
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
      return const Center(
        child: Text(
          'Not enough data to display chart',
          style: TextStyle(color: AppColors.textMuted),
        ),
      );
    }

    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final padding = ((maxY - minY) * 0.1).clamp(1.0, 10.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgActive.withAlpha(50),
        border: Border.all(color: AppColors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: ((maxY - minY) / 4).clamp(1, 50),
            getDrawingHorizontalLine: (value) => FlLine(
              color: AppColors.glassBorder,
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
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
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
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textMuted,
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
              color: AppColors.accent,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.accent,
                  strokeWidth: 2,
                  strokeColor: AppColors.glassPanel,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.accent.withAlpha(30),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => AppColors.bgPanel,
              tooltipBorder: const BorderSide(color: AppColors.glassBorder),
              tooltipRoundedRadius: 8,
              getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
                final date = dates[spot.x];
                return LineTooltipItem(
                  '#${spot.y.toInt()}\n${date != null ? DateFormat('d MMM').format(date) : ''}',
                  const TextStyle(
                    color: AppColors.textPrimary,
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
    return Material(
      color: isSelected ? AppColors.accent : AppColors.bgActive,
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
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
