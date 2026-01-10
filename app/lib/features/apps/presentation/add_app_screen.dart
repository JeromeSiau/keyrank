import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/api/api_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/country_provider.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../shared/widgets/country_picker.dart';
import '../data/apps_repository.dart';
import '../domain/app_model.dart';
import '../providers/apps_provider.dart';

enum AppPlatform { ios, android }

final _selectedPlatformProvider = StateProvider<AppPlatform>((ref) => AppPlatform.ios);
final _searchQueryProvider = StateProvider<String>((ref) => '');

final _iosSearchResultsProvider = FutureProvider<List<AppSearchResult>>((ref) async {
  final query = ref.watch(_searchQueryProvider);
  final country = ref.watch(selectedCountryProvider);
  if (query.length < 2) return [];

  final repository = ref.watch(appsRepositoryProvider);
  return repository.searchApps(query: query, country: country.code, limit: 30);
});

final _androidSearchResultsProvider = FutureProvider<List<AndroidSearchResult>>((ref) async {
  final query = ref.watch(_searchQueryProvider);
  final country = ref.watch(selectedCountryProvider);
  if (query.length < 2) return [];

  final repository = ref.watch(appsRepositoryProvider);
  return repository.searchAndroidApps(query: query, country: country.code, limit: 30);
});

class AddAppScreen extends ConsumerStatefulWidget {
  const AddAppScreen({super.key});

  @override
  ConsumerState<AddAppScreen> createState() => _AddAppScreenState();
}

class _AddAppScreenState extends ConsumerState<AddAppScreen> {
  final _searchController = TextEditingController();
  bool _isAdding = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _addIosApp(AppSearchResult app) async {
    setState(() => _isAdding = true);
    final country = ref.read(selectedCountryProvider);

    try {
      await ref.read(appsNotifierProvider.notifier).addApp(
        platform: 'ios',
        storeId: app.appleId,
        country: country.code,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.addApp_addedSuccess(app.name)),
            backgroundColor: AppColors.green,
          ),
        );
        context.go('/apps');
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: AppColors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAdding = false);
      }
    }
  }

  Future<void> _addAndroidApp(AndroidSearchResult app) async {
    setState(() => _isAdding = true);
    final country = ref.read(selectedCountryProvider);

    try {
      await ref.read(appsNotifierProvider.notifier).addApp(
        platform: 'android',
        storeId: app.googlePlayId,
        country: country.code,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.addApp_addedSuccess(app.name)),
            backgroundColor: AppColors.green,
          ),
        );
        context.go('/apps');
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: AppColors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAdding = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final selectedCountry = ref.watch(selectedCountryProvider);
    final selectedPlatform = ref.watch(_selectedPlatformProvider);
    final countries = ref.watch(countriesProvider).valueOrNull ?? availableCountries;

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanel,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
      ),
      child: Column(
        children: [
          // Toolbar
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.glassBorder)),
            ),
            child: Row(
              children: [
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                  child: InkWell(
                    onTap: () => context.go('/apps'),
                    borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                    hoverColor: colors.bgHover,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(Icons.arrow_back_rounded, size: 20, color: colors.textMuted),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  context.l10n.addApp_title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Search bar with platform toggle
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.glassBorder)),
            ),
            child: Row(
              children: [
                // Country selector
                CountryPickerButton(
                  selectedCountry: selectedCountry,
                  countries: countries,
                  onCountryChanged: (country) {
                    ref.read(selectedCountryProvider.notifier).state = country;
                  },
                ),
                const SizedBox(width: 12),
                // Platform toggle
                Container(
                  decoration: BoxDecoration(
                    color: colors.bgActive,
                    borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                    border: Border.all(color: colors.glassBorder),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _PlatformTab(
                        label: '🍎 iOS',
                        isSelected: selectedPlatform == AppPlatform.ios,
                        onTap: () => ref.read(_selectedPlatformProvider.notifier).state = AppPlatform.ios,
                      ),
                      _PlatformTab(
                        label: '🤖 Android',
                        isSelected: selectedPlatform == AppPlatform.android,
                        onTap: () => ref.read(_selectedPlatformProvider.notifier).state = AppPlatform.android,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Search field
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors.bgBase,
                      border: Border.all(color: colors.glassBorder),
                      borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Icon(Icons.search_rounded, size: 20, color: colors.textMuted),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              ref.read(_searchQueryProvider.notifier).state = value;
                            },
                            style: TextStyle(
                              fontSize: 14,
                              color: colors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: selectedPlatform == AppPlatform.ios
                                  ? context.l10n.addApp_searchAppStore
                                  : context.l10n.addApp_searchPlayStore,
                              hintStyle: TextStyle(color: colors.textMuted),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            color: colors.textMuted,
                            onPressed: () {
                              _searchController.clear();
                              ref.read(_searchQueryProvider.notifier).state = '';
                            },
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(),
                          ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Results
          Expanded(
            child: selectedPlatform == AppPlatform.ios
                ? _buildIosResults()
                : _buildAndroidResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildIosResults() {
    final searchResults = ref.watch(_iosSearchResultsProvider);

    return searchResults.when(
      loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      error: (e, _) => _buildError(e.toString()),
      data: (apps) {
        if (_searchController.text.length < 2) {
          return _buildEmptyState();
        }
        if (apps.isEmpty) {
          return _buildNoResults();
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: apps.length,
          itemBuilder: (context, index) {
            final app = apps[index];
            return _IosAppResultRow(
              app: app,
              gradientIndex: index,
              isAdding: _isAdding,
              onAdd: () => _addIosApp(app),
            );
          },
        );
      },
    );
  }

  Widget _buildAndroidResults() {
    final searchResults = ref.watch(_androidSearchResultsProvider);

    return searchResults.when(
      loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      error: (e, _) => _buildError(e.toString()),
      data: (apps) {
        if (_searchController.text.length < 2) {
          return _buildEmptyState();
        }
        if (apps.isEmpty) {
          return _buildNoResults();
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: apps.length,
          itemBuilder: (context, index) {
            final app = apps[index];
            return _AndroidAppResultRow(
              app: app,
              gradientIndex: index,
              isAdding: _isAdding,
              onAdd: () => _addAndroidApp(app),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final colors = context.colors;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colors.bgActive,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.search_rounded, size: 40, color: colors.textMuted),
          ),
          const SizedBox(height: 20),
          Text(
            context.l10n.addApp_searchForApp,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.addApp_enterAtLeast2Chars,
            style: TextStyle(fontSize: 14, color: colors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    final colors = context.colors;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colors.bgActive,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.apps_rounded, size: 32, color: colors.textMuted),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.addApp_noResults,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error) {
    final colors = context.colors;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colors.redMuted,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.error_outline_rounded, size: 32, color: colors.red),
          ),
          const SizedBox(height: 20),
          Text(
            'Error: $error',
            style: TextStyle(fontSize: 14, color: colors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PlatformTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlatformTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? colors.glassPanel : Colors.transparent,
          borderRadius: BorderRadius.circular(AppColors.radiusSmall - 2),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? colors.textPrimary : colors.textMuted,
          ),
        ),
      ),
    );
  }
}

class _IosAppResultRow extends StatelessWidget {
  final AppSearchResult app;
  final int gradientIndex;
  final bool isAdding;
  final VoidCallback onAdd;

  const _IosAppResultRow({
    required this.app,
    required this.gradientIndex,
    required this.isAdding,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return _AppResultRowBase(
      name: app.name,
      iconUrl: app.iconUrl,
      developer: app.developer,
      rating: app.rating,
      ratingCount: app.ratingCount,
      gradientIndex: gradientIndex,
      isAdding: isAdding,
      onAdd: onAdd,
    );
  }
}

class _AndroidAppResultRow extends StatelessWidget {
  final AndroidSearchResult app;
  final int gradientIndex;
  final bool isAdding;
  final VoidCallback onAdd;

  const _AndroidAppResultRow({
    required this.app,
    required this.gradientIndex,
    required this.isAdding,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return _AppResultRowBase(
      name: app.name,
      iconUrl: app.iconUrl,
      developer: app.developer,
      rating: app.rating,
      ratingCount: app.ratingCount,
      gradientIndex: gradientIndex,
      isAdding: isAdding,
      onAdd: onAdd,
    );
  }
}

class _AppResultRowBase extends StatelessWidget {
  final String name;
  final String? iconUrl;
  final String? developer;
  final double? rating;
  final int ratingCount;
  final int gradientIndex;
  final bool isAdding;
  final VoidCallback onAdd;

  const _AppResultRowBase({
    required this.name,
    required this.iconUrl,
    required this.developer,
    required this.rating,
    required this.ratingCount,
    required this.gradientIndex,
    required this.isAdding,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Row(
        children: [
          // App icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: AppColors.getGradient(gradientIndex),
              borderRadius: BorderRadius.circular(12),
            ),
            child: iconUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      iconUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Center(
                        child: Icon(Icons.apps, size: 28, color: Colors.white),
                      ),
                    ),
                  )
                : const Center(
                    child: Icon(Icons.apps, size: 28, color: Colors.white),
                  ),
          ),
          const SizedBox(width: 14),
          // App info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (developer != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    developer!,
                    style: TextStyle(fontSize: 13, color: colors.textMuted),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (rating != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.star_rounded, size: 14, color: colors.yellow),
                      const SizedBox(width: 4),
                      Text(
                        '${rating!.toStringAsFixed(1)} (${_formatCount(ratingCount)})',
                        style: TextStyle(fontSize: 12, color: colors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          // Add button
          Material(
            color: colors.accent,
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
            child: InkWell(
              onTap: isAdding ? null : onAdd,
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: isAdding
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add_rounded, size: 18, color: Colors.white),
                          const SizedBox(width: 6),
                          Text(context.l10n.common_add, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
