import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/country_provider.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/widgets/platform_tabs.dart';
import '../../../shared/widgets/country_picker.dart';
import '../../apps/data/apps_repository.dart';
import '../../apps/domain/app_model.dart';
import '../../apps/providers/apps_provider.dart';
import '../providers/competitors_provider.dart';

enum _Platform { ios, android }

final _selectedPlatformProvider = StateProvider<_Platform>((ref) => _Platform.ios);
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

class AddCompetitorScreen extends ConsumerStatefulWidget {
  const AddCompetitorScreen({super.key});

  @override
  ConsumerState<AddCompetitorScreen> createState() => _AddCompetitorScreenState();
}

class _AddCompetitorScreenState extends ConsumerState<AddCompetitorScreen> {
  final _searchController = TextEditingController();
  bool _isAdding = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _addIosCompetitor(AppSearchResult app) async {
    setState(() => _isAdding = true);
    final colors = context.colors;
    final country = ref.read(selectedCountryProvider);

    try {
      // First add the app to our system
      final appsRepository = ref.read(appsRepositoryProvider);
      final addedApp = await appsRepository.addApp(
        platform: 'ios',
        storeId: app.appleId,
        country: country.code,
      );

      // Then mark as competitor
      final competitorsRepository = ref.read(competitorsRepositoryProvider);
      await competitorsRepository.addGlobalCompetitor(addedApp.id);

      ref.invalidate(appsNotifierProvider);
      ref.invalidate(competitorsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${app.name} added as competitor'),
            backgroundColor: colors.green,
          ),
        );
        context.go('/competitors');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add competitor: $e'),
            backgroundColor: colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAdding = false);
      }
    }
  }

  Future<void> _addAndroidCompetitor(AndroidSearchResult app) async {
    setState(() => _isAdding = true);
    final colors = context.colors;
    final country = ref.read(selectedCountryProvider);

    try {
      // First add the app to our system
      final appsRepository = ref.read(appsRepositoryProvider);
      final addedApp = await appsRepository.addApp(
        platform: 'android',
        storeId: app.googlePlayId,
        country: country.code,
      );

      // Then mark as competitor
      final competitorsRepository = ref.read(competitorsRepositoryProvider);
      await competitorsRepository.addGlobalCompetitor(addedApp.id);

      ref.invalidate(appsNotifierProvider);
      ref.invalidate(competitorsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${app.name} added as competitor'),
            backgroundColor: colors.green,
          ),
        );
        context.go('/competitors');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add competitor: $e'),
            backgroundColor: colors.red,
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
            height: AppSpacing.toolbarHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.glassBorder)),
            ),
            child: Row(
              children: [
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                  child: InkWell(
                    onTap: () => context.go('/competitors'),
                    borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                    hoverColor: colors.bgHover,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(Icons.arrow_back_rounded, size: 20, color: colors.textMuted),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm + 4),
                // Competitors icon
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: colors.accent.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.person_add_rounded,
                    size: 20,
                    color: colors.accent,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm + 4),
                Text(
                  'Add Competitor',
                  style: AppTypography.headline.copyWith(color: colors.textPrimary),
                ),
              ],
            ),
          ),

          // Search bar with platform toggle
          Container(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
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
                const SizedBox(width: AppSpacing.sm + 4),
                // Platform toggle
                SizedBox(
                  width: 240,
                  child: PlatformTabs(
                    selectedPlatform: selectedPlatform == _Platform.ios ? 'ios' : 'android',
                    availablePlatforms: const ['ios', 'android'],
                    onPlatformChanged: (platform) {
                      ref.read(_selectedPlatformProvider.notifier).state =
                          platform == 'ios' ? _Platform.ios : _Platform.android;
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.sm + 4),
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
                              hintText: selectedPlatform == _Platform.ios
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
            child: selectedPlatform == _Platform.ios
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
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          itemCount: apps.length,
          itemBuilder: (context, index) {
            final app = apps[index];
            return _CompetitorResultRow(
              name: app.name,
              iconUrl: app.iconUrl,
              developer: app.developer,
              rating: app.rating,
              ratingCount: app.ratingCount,
              gradientIndex: index,
              isAdding: _isAdding,
              onAdd: () => _addIosCompetitor(app),
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
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          itemCount: apps.length,
          itemBuilder: (context, index) {
            final app = apps[index];
            return _CompetitorResultRow(
              name: app.name,
              iconUrl: app.iconUrl,
              developer: app.developer,
              rating: app.rating,
              ratingCount: app.ratingCount,
              gradientIndex: index,
              isAdding: _isAdding,
              onAdd: () => _addAndroidCompetitor(app),
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
            'Search for a competitor',
            style: AppTypography.headline.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.addApp_enterAtLeast2Chars,
            style: AppTypography.body.copyWith(color: colors.textMuted),
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
            style: AppTypography.bodyMedium.copyWith(color: colors.textPrimary),
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
            style: AppTypography.body.copyWith(color: colors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CompetitorResultRow extends StatelessWidget {
  final String name;
  final String? iconUrl;
  final String? developer;
  final double? rating;
  final int ratingCount;
  final int gradientIndex;
  final bool isAdding;
  final VoidCallback onAdd;

  const _CompetitorResultRow({
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
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
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
          const SizedBox(width: AppSpacing.cardPadding),
          // App info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.bodyMedium.copyWith(color: colors.textPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
                if (developer != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    developer!,
                    style: AppTypography.caption.copyWith(color: colors.textMuted),
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
                        style: AppTypography.caption.copyWith(color: colors.textSecondary),
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
                          const Icon(Icons.person_add_rounded, size: 18, color: Colors.white),
                          const SizedBox(width: 6),
                          Text(
                            'Add',
                            style: AppTypography.caption.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
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
