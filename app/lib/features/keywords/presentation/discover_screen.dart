import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/api/api_client.dart';
import '../../../core/widgets/platform_tabs.dart';
import '../../../shared/widgets/country_picker.dart';
import '../../../core/providers/country_provider.dart'
    show Country, availableCountries, countriesProvider, selectedCountryProvider;
import '../../../shared/widgets/states.dart';
import '../../../shared/widgets/safe_image.dart';
import '../../apps/providers/apps_provider.dart';
import '../domain/keyword_model.dart';
import '../../categories/domain/category_model.dart';
import '../providers/discover_providers.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final selectedTab = ref.watch(discoverTabProvider);
    final selectedCountry = ref.watch(selectedCountryProvider);
    final selectedPlatform = ref.watch(discoverPlatformProvider);
    final countries = ref.watch(countriesProvider).valueOrNull ?? availableCountries;

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanel,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
      ),
      child: Column(
        children: [
          // Toolbar with tabs
          _Toolbar(
            selectedTab: selectedTab,
            onTabChanged: (tab) => ref.read(discoverTabProvider.notifier).state = tab,
            selectedCountry: selectedCountry,
            onCountrySelected: (country) {
              ref.read(selectedCountryProvider.notifier).state = country;
            },
            selectedPlatform: selectedPlatform,
            onPlatformSelected: (platform) {
              ref.read(discoverPlatformProvider.notifier).state = platform;
              // Reset category when platform changes (categories differ between platforms)
              ref.read(discoverCategoryProvider.notifier).state = null;
            },
            countries: countries,
          ),
          // Tab content
          Expanded(
            child: selectedTab == 0
                ? _KeywordsTabContent(
                    searchController: _searchController,
                    onSearchChanged: (value) {
                      ref.read(discoverSearchQueryProvider.notifier).state = value;
                    },
                    onClearSearch: () {
                      _searchController.clear();
                      ref.read(discoverSearchQueryProvider.notifier).state = '';
                    },
                  )
                : const _CategoriesTabContent(),
          ),
        ],
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onTabChanged;
  final Country selectedCountry;
  final ValueChanged<Country> onCountrySelected;
  final String selectedPlatform;
  final ValueChanged<String> onPlatformSelected;
  final List<Country> countries;

  const _Toolbar({
    required this.selectedTab,
    required this.onTabChanged,
    required this.selectedCountry,
    required this.onCountrySelected,
    required this.selectedPlatform,
    required this.onPlatformSelected,
    required this.countries,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      height: AppSpacing.toolbarHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder)),
      ),
      child: Row(
        children: [
          Text(
            context.l10n.discover_title,
            style: AppTypography.headline.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(width: AppSpacing.md),
          // Tab selector
          _TabSelector(
            selectedTab: selectedTab,
            onTabChanged: onTabChanged,
          ),
          const SizedBox(width: AppSpacing.md),
          // Platform toggle
          SizedBox(
            width: 240,
            child: PlatformTabs(
              selectedPlatform: selectedPlatform,
              availablePlatforms: const ['ios', 'android'],
              onPlatformChanged: onPlatformSelected,
            ),
          ),
          const SizedBox(width: AppSpacing.sm + 4),
          // Country selector
          CountryPickerButton(
            selectedCountry: selectedCountry,
            countries: countries,
            onCountryChanged: onCountrySelected,
          ),
        ],
      ),
    );
  }
}

class _TabSelector extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  const _TabSelector({
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.bgActive,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        border: Border.all(color: colors.glassBorder),
      ),
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TabButton(
            label: context.l10n.discover_tabKeywords,
            isSelected: selectedTab == 0,
            onTap: () => onTabChanged(0),
          ),
          _TabButton(
            label: context.l10n.discover_tabCategories,
            isSelected: selectedTab == 1,
            onTap: () => onTabChanged(1),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
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
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? colors.glassPanel : Colors.transparent,
          borderRadius: BorderRadius.circular(AppColors.radiusSmall - 2),
        ),
        child: Text(
          label,
          style: AppTypography.body.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? colors.textPrimary : colors.textMuted,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Keywords Tab
// ============================================================================

class _KeywordsTabContent extends ConsumerWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;

  const _KeywordsTabContent({
    required this.searchController,
    required this.onSearchChanged,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResults = ref.watch(discoverSearchResultsProvider);

    return Column(
      children: [
        _SearchBar(
          controller: searchController,
          onChanged: onSearchChanged,
          onClear: onClearSearch,
        ),
        Expanded(
          child: searchResults.when(
            loading: () => const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            error: (e, _) => ErrorView(message: e.toString()),
            data: (response) {
              if (response == null) {
                return EmptyStateView(
                  icon: Icons.search_rounded,
                  title: context.l10n.keywordSearch_searchTitle,
                  subtitle: context.l10n.keywordSearch_searchSubtitle,
                );
              }
              return _KeywordResultsView(response: response);
            },
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder)),
      ),
      child: Row(
        children: [
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
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm + 6),
                    child: Icon(Icons.search_rounded, size: 20, color: colors.textMuted),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: onChanged,
                      style: AppTypography.body.copyWith(color: colors.textPrimary),
                      decoration: InputDecoration(
                        hintText: context.l10n.keywordSearch_searchPlaceholder,
                        hintStyle: AppTypography.body.copyWith(color: colors.textMuted),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 4),
                      ),
                    ),
                  ),
                  if (controller.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      color: colors.textMuted,
                      onPressed: onClear,
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      constraints: const BoxConstraints(),
                    ),
                  const SizedBox(width: AppSpacing.sm),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KeywordResultsView extends StatelessWidget {
  final KeywordSearchResponse response;

  const _KeywordResultsView({required this.response});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _KeywordInsightsPanel(
            keyword: response.keyword.keyword,
            popularity: response.keyword.popularity,
            totalResults: response.totalResults,
            results: response.results,
          ),
          const SizedBox(height: AppSpacing.md),
          _KeywordResultsTable(results: response.results),
        ],
      ),
    );
  }
}

/// Two-column insights panel showing keyword metrics and top 10 performance
class _KeywordInsightsPanel extends StatelessWidget {
  final String keyword;
  final int? popularity;
  final int totalResults;
  final List<KeywordSearchResult> results;

  const _KeywordInsightsPanel({
    required this.keyword,
    required this.popularity,
    required this.totalResults,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Keyword header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        keyword,
                        style: AppTypography.title.copyWith(color: colors.textPrimary),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        context.l10n.keywordSearch_appsRanked(totalResults),
                        style: AppTypography.caption.copyWith(color: colors.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Divider
          Container(
            height: 1,
            color: colors.glassBorder,
          ),
          // Two-column layout
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left: Insights panel
                Expanded(
                  child: _InsightsSection(
                    popularity: popularity,
                    totalResults: totalResults,
                  ),
                ),
                // Vertical divider
                Container(
                  width: 1,
                  color: colors.glassBorder,
                ),
                // Right: Top 10 Performance panel
                Expanded(
                  child: _Top10PerformanceSection(
                    results: results,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Left section: Insights with popularity and competitiveness
class _InsightsSection extends StatelessWidget {
  final int? popularity;
  final int totalResults;

  const _InsightsSection({
    required this.popularity,
    required this.totalResults,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final competitiveness = _calculateCompetitiveness(totalResults);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INSIGHTS',
            style: AppTypography.tableHeader.copyWith(color: colors.textMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          // Popularity
          _MetricRow(
            label: context.l10n.keywordSearch_popularity,
            value: popularity ?? 0,
            maxValue: 100,
            colorMode: _ColorMode.higherIsBetter,
          ),
          const SizedBox(height: AppSpacing.md),
          // Competitiveness
          _MetricRow(
            label: 'Competitiveness',
            value: competitiveness,
            maxValue: 100,
            colorMode: _ColorMode.lowerIsBetter,
          ),
        ],
      ),
    );
  }

  /// Calculate competitiveness based on number of results
  /// More results = more competitive
  int _calculateCompetitiveness(int results) {
    if (results <= 10) return 20;
    if (results <= 25) return 40;
    if (results <= 50) return 60;
    if (results <= 100) return 80;
    return 100;
  }
}

/// Right section: Top 10 Performance metrics
class _Top10PerformanceSection extends StatelessWidget {
  final List<KeywordSearchResult> results;

  const _Top10PerformanceSection({
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final top10 = results.take(10).toList();
    final metrics = _calculateTop10Metrics(top10);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOP 10 PERFORMANCE',
            style: AppTypography.tableHeader.copyWith(color: colors.textMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          // Metrics grid
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Avg Rating',
                  value: metrics.avgRating != null
                      ? metrics.avgRating!.toStringAsFixed(1)
                      : '--',
                  icon: Icons.star_rounded,
                  iconColor: colors.yellow,
                ),
              ),
              const SizedBox(width: AppSpacing.sm + 4),
              Expanded(
                child: _StatCard(
                  label: 'Est. Engagement',
                  value: _formatNumber(metrics.totalRatingCount),
                  icon: Icons.people_rounded,
                  iconColor: colors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm + 4),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'DPR',
                  value: 'N/A',
                  icon: Icons.download_rounded,
                  iconColor: colors.green,
                  tooltip: 'Downloads per rating - requires App Store Connect',
                ),
              ),
              const SizedBox(width: AppSpacing.sm + 4),
              Expanded(
                child: _StatCard(
                  label: 'Apps Rated',
                  value: '${metrics.appsWithRating}/${top10.length}',
                  icon: Icons.apps_rounded,
                  iconColor: colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _Top10Metrics _calculateTop10Metrics(List<KeywordSearchResult> top10) {
    if (top10.isEmpty) {
      return _Top10Metrics(
        avgRating: null,
        totalRatingCount: 0,
        appsWithRating: 0,
      );
    }

    final ratingsWithValue = top10.where((r) => r.rating != null).toList();
    final avgRating = ratingsWithValue.isNotEmpty
        ? ratingsWithValue.map((r) => r.rating!).reduce((a, b) => a + b) /
            ratingsWithValue.length
        : null;

    final totalRatingCount =
        top10.fold<int>(0, (sum, r) => sum + r.ratingCount);

    return _Top10Metrics(
      avgRating: avgRating,
      totalRatingCount: totalRatingCount,
      appsWithRating: ratingsWithValue.length,
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}

class _Top10Metrics {
  final double? avgRating;
  final int totalRatingCount;
  final int appsWithRating;

  _Top10Metrics({
    required this.avgRating,
    required this.totalRatingCount,
    required this.appsWithRating,
  });
}

enum _ColorMode { higherIsBetter, lowerIsBetter }

/// A metric row with label, value, and progress bar
class _MetricRow extends StatelessWidget {
  final String label;
  final int value;
  final int maxValue;
  final _ColorMode colorMode;

  const _MetricRow({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.colorMode,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = _getColor(colors);
    final percentage = (value / maxValue).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTypography.body.copyWith(color: colors.textSecondary),
            ),
            Text(
              '$value',
              style: AppTypography.bodyMedium.copyWith(color: color),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        _ProgressBar(
          value: percentage,
          color: color,
          backgroundColor: colors.bgActive,
        ),
      ],
    );
  }

  Color _getColor(AppColorsExtension colors) {
    if (colorMode == _ColorMode.higherIsBetter) {
      // Green >= 70, Yellow >= 40, Red < 40
      if (value >= 70) return colors.green;
      if (value >= 40) return colors.yellow;
      return colors.red;
    } else {
      // Inverse: Green <= 30, Yellow <= 60, Red > 60
      if (value <= 30) return colors.green;
      if (value <= 60) return colors.yellow;
      return colors.red;
    }
  }
}

/// Custom progress bar widget
class _ProgressBar extends StatelessWidget {
  final double value;
  final Color color;
  final Color backgroundColor;

  const _ProgressBar({
    required this.value,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(3),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: value,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            boxShadow: [
              BoxShadow(
                color: color.withAlpha(100),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small stat card for displaying metrics
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final String? tooltip;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    Widget card = Container(
      padding: const EdgeInsets.all(AppSpacing.sm + 4),
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(80),
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        border: Border.all(color: colors.glassBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(25),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 14, color: iconColor),
          ),
          const SizedBox(width: AppSpacing.sm + 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTypography.bodyMedium.copyWith(color: colors.textPrimary),
                ),
                Text(
                  label,
                  style: AppTypography.micro.copyWith(color: colors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: card,
      );
    }

    return card;
  }
}

class _KeywordResultsTable extends ConsumerWidget {
  final List<KeywordSearchResult> results;

  const _KeywordResultsTable({required this.results});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final selectedPlatform = ref.watch(discoverPlatformProvider);
    final selectedCountry = ref.watch(selectedCountryProvider);

    return Container(
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.cardPadding, vertical: AppSpacing.sm + 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.keywordSearch_results(results.length),
                  style: AppTypography.body.copyWith(color: colors.textSecondary),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.cardPadding, vertical: AppSpacing.sm + 2),
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
                  width: 60,
                  child: Text(
                    context.l10n.keywordSearch_headerRank,
                    style: AppTypography.tableHeader.copyWith(color: colors.textMuted),
                  ),
                ),
                const SizedBox(width: 52),
                Expanded(
                  child: Text(
                    context.l10n.keywordSearch_headerApp,
                    style: AppTypography.tableHeader.copyWith(color: colors.textMuted),
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: Text(
                    context.l10n.keywordSearch_headerRating,
                    style: AppTypography.tableHeader.copyWith(color: colors.textMuted),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm + 4),
                SizedBox(
                  width: 48,
                  child: Text(
                    context.l10n.keywordSearch_headerTrack,
                    style: AppTypography.tableHeader.copyWith(color: colors.textMuted),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          ...results.map((app) => _AppResultRow(
                app: app,
                platform: selectedPlatform,
                country: selectedCountry.code,
              )),
        ],
      ),
    );
  }
}

// ============================================================================
// Categories Tab
// ============================================================================

class _CategoriesTabContent extends ConsumerWidget {
  const _CategoriesTabContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(discoverCategoriesProvider);
    final selectedCategory = ref.watch(discoverCategoryProvider);
    final selectedCollection = ref.watch(discoverCollectionProvider);
    final platform = ref.watch(discoverPlatformProvider);
    final topAppsAsync = ref.watch(discoverTopAppsProvider);

    return Column(
      children: [
        // Category and collection selectors
        _CategoryToolbar(
          categoriesAsync: categoriesAsync,
          selectedCategory: selectedCategory,
          selectedCollection: selectedCollection,
          platform: platform,
          onCategoryChanged: (category) {
            ref.read(discoverCategoryProvider.notifier).state = category;
          },
          onCollectionChanged: (collection) {
            ref.read(discoverCollectionProvider.notifier).state = collection;
          },
        ),
        // Results
        Expanded(
          child: selectedCategory == null
              ? EmptyStateView(
                  icon: Icons.category_rounded,
                  title: context.l10n.discover_selectCategory,
                  subtitle: '',
                )
              : topAppsAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  error: (e, _) => ErrorView(message: e.toString()),
                  data: (apps) {
                    if (apps.isEmpty) {
                      return EmptyStateView(
                        icon: Icons.apps_rounded,
                        title: context.l10n.discover_noResults,
                        subtitle: '',
                      );
                    }
                    return _TopAppsResultsView(apps: apps);
                  },
                ),
        ),
      ],
    );
  }
}

class _CategoryToolbar extends StatelessWidget {
  final AsyncValue<CategoriesResponse> categoriesAsync;
  final AppCategory? selectedCategory;
  final String selectedCollection;
  final String platform;
  final ValueChanged<AppCategory?> onCategoryChanged;
  final ValueChanged<String> onCollectionChanged;

  const _CategoryToolbar({
    required this.categoriesAsync,
    required this.selectedCategory,
    required this.selectedCollection,
    required this.platform,
    required this.onCategoryChanged,
    required this.onCollectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder)),
      ),
      child: Row(
        children: [
          // Category picker
          Expanded(
            child: categoriesAsync.when(
              loading: () => const SizedBox(height: 40),
              error: (e, s) => const SizedBox(height: 40),
              data: (categories) {
                final categoryList = platform == 'ios' ? categories.ios : categories.android;
                return _CategoryDropdown(
                  categories: categoryList,
                  selectedCategory: selectedCategory,
                  onChanged: onCategoryChanged,
                );
              },
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Collection toggle (Top Free / Top Paid)
          _CollectionToggle(
            selectedCollection: selectedCollection,
            onChanged: onCollectionChanged,
          ),
        ],
      ),
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  final List<AppCategory> categories;
  final AppCategory? selectedCategory;
  final ValueChanged<AppCategory?> onChanged;

  const _CategoryDropdown({
    required this.categories,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm + 4),
      decoration: BoxDecoration(
        color: colors.bgBase,
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<AppCategory>(
          value: selectedCategory,
          hint: Text(
            context.l10n.discover_selectCategory,
            style: AppTypography.body.copyWith(color: colors.textMuted),
          ),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: colors.textMuted),
          dropdownColor: colors.bgBase,
          items: categories.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(
                category.name,
                style: AppTypography.body.copyWith(color: colors.textPrimary),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _CollectionToggle extends StatelessWidget {
  final String selectedCollection;
  final ValueChanged<String> onChanged;

  const _CollectionToggle({
    required this.selectedCollection,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.bgActive,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        border: Border.all(color: colors.glassBorder),
      ),
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TabButton(
            label: context.l10n.discover_topFree,
            isSelected: selectedCollection == 'top_free',
            onTap: () => onChanged('top_free'),
          ),
          _TabButton(
            label: context.l10n.discover_topPaid,
            isSelected: selectedCollection == 'top_paid',
            onTap: () => onChanged('top_paid'),
          ),
          _TabButton(
            label: context.l10n.discover_topGrossing,
            isSelected: selectedCollection == 'top_grossing',
            onTap: () => onChanged('top_grossing'),
          ),
        ],
      ),
    );
  }
}

class _TopAppsResultsView extends ConsumerWidget {
  final List<TopApp> apps;

  const _TopAppsResultsView({required this.apps});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final selectedPlatform = ref.watch(discoverPlatformProvider);
    final selectedCountry = ref.watch(selectedCountryProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Container(
        decoration: BoxDecoration(
          color: colors.bgActive.withAlpha(50),
          border: Border.all(color: colors.glassBorder),
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.cardPadding, vertical: AppSpacing.sm + 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.discover_appsCount(apps.length),
                    style: AppTypography.body.copyWith(color: colors.textSecondary),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.cardPadding, vertical: AppSpacing.sm + 2),
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
                    width: 60,
                    child: Text(
                      context.l10n.keywordSearch_headerRank,
                      style: AppTypography.tableHeader.copyWith(color: colors.textMuted),
                    ),
                  ),
                  const SizedBox(width: 52),
                  Expanded(
                    child: Text(
                      context.l10n.keywordSearch_headerApp,
                      style: AppTypography.tableHeader.copyWith(color: colors.textMuted),
                    ),
                  ),
                  SizedBox(
                    width: 48,
                    child: Text(
                      context.l10n.keywordSearch_headerTrack,
                      style: AppTypography.tableHeader.copyWith(color: colors.textMuted),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            ...apps.map((app) => _TopAppRow(
                  app: app,
                  platform: selectedPlatform,
                  country: selectedCountry.code,
                )),
          ],
        ),
      ),
    );
  }
}

class _TopAppRow extends ConsumerStatefulWidget {
  final TopApp app;
  final String platform;
  final String country;

  const _TopAppRow({
    required this.app,
    required this.platform,
    required this.country,
  });

  @override
  ConsumerState<_TopAppRow> createState() => _TopAppRowState();
}

class _TopAppRowState extends ConsumerState<_TopAppRow> {
  bool _isLoading = false;
  bool _isAdded = false;
  String? _error;

  Future<void> _trackApp() async {
    if (_isLoading || _isAdded) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final notifier = ref.read(appsNotifierProvider.notifier);
      await notifier.addApp(
        platform: widget.platform,
        storeId: widget.app.storeId,
        country: widget.country,
      );
      setState(() {
        _isAdded = true;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      setState(() {
        _error = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _openPreview() {
    context.push(
      '/discover/preview/${widget.platform}/${widget.app.storeId}?country=${widget.country}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isTopRank = widget.app.position <= 3;

    return InkWell(
      onTap: _openPreview,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.cardPadding, vertical: AppSpacing.sm + 4),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colors.glassBorder)),
        ),
        child: Row(
          children: [
            // Position
            SizedBox(
              width: 60,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: isTopRank ? colors.greenMuted : colors.bgActive,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '#${widget.app.position}',
                  style: AppTypography.tableCell.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isTopRank ? colors.green : colors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm + 4),
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: AppColors.getGradient(widget.app.position),
                borderRadius: BorderRadius.circular(10),
              ),
              child: widget.app.iconUrl != null
                  ? SafeImage(
                      imageUrl: widget.app.iconUrl!,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(10),
                      errorWidget: const Center(
                        child: Icon(Icons.apps, size: 20, color: Colors.white),
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.apps, size: 20, color: Colors.white),
                    ),
            ),
            const SizedBox(width: AppSpacing.sm + 4),
            // App info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.app.name,
                    style: AppTypography.bodyMedium.copyWith(color: colors.textPrimary),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.app.developer != null)
                    Text(
                      widget.app.developer!,
                      style: AppTypography.caption.copyWith(color: colors.textMuted),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            // Track button
            SizedBox(
              width: 48,
              child: _buildTrackButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackButton() {
    final colors = context.colors;
    if (_isAdded) {
      return Icon(
        Icons.check_circle_rounded,
        size: 22,
        color: colors.green,
      );
    }

    if (_isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: colors.textMuted,
        ),
      );
    }

    if (_error != null) {
      return Tooltip(
        message: _error!,
        child: IconButton(
          icon: const Icon(Icons.error_outline_rounded, size: 22),
          color: colors.red,
          onPressed: _trackApp,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      );
    }

    return IconButton(
      icon: const Icon(Icons.add_circle_outline_rounded, size: 22),
      color: colors.textMuted,
      hoverColor: colors.green.withAlpha(30),
      onPressed: _trackApp,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      tooltip: context.l10n.keywordSearch_trackApp,
    );
  }
}

// ============================================================================
// Shared App Result Row (for keyword search)
// ============================================================================

class _AppResultRow extends ConsumerStatefulWidget {
  final KeywordSearchResult app;
  final String platform;
  final String country;

  const _AppResultRow({
    required this.app,
    required this.platform,
    required this.country,
  });

  @override
  ConsumerState<_AppResultRow> createState() => _AppResultRowState();
}

class _AppResultRowState extends ConsumerState<_AppResultRow> {
  bool _isLoading = false;
  bool _isAdded = false;
  String? _error;

  Future<void> _trackApp() async {
    if (_isLoading || _isAdded) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final notifier = ref.read(appsNotifierProvider.notifier);
      final storeId = widget.platform == 'android'
          ? widget.app.googlePlayId
          : widget.app.appleId;

      if (storeId != null) {
        await notifier.addApp(
          platform: widget.platform,
          storeId: storeId,
          country: widget.country,
        );
      }
      setState(() {
        _isAdded = true;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      setState(() {
        _error = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _openPreview() {
    final storeId = widget.platform == 'android'
        ? widget.app.googlePlayId
        : widget.app.appleId;
    if (storeId == null) return;
    context.push(
      '/discover/preview/${widget.platform}/$storeId?country=${widget.country}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isTopRank = widget.app.position <= 3;

    return InkWell(
      onTap: _openPreview,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.cardPadding, vertical: AppSpacing.sm + 4),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colors.glassBorder)),
        ),
        child: Row(
          children: [
            // Position
            SizedBox(
              width: 60,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: isTopRank ? colors.greenMuted : colors.bgActive,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '#${widget.app.position}',
                  style: AppTypography.tableCell.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isTopRank ? colors.green : colors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm + 4),
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: AppColors.getGradient(widget.app.position),
                borderRadius: BorderRadius.circular(10),
              ),
              child: widget.app.iconUrl != null
                  ? SafeImage(
                      imageUrl: widget.app.iconUrl!,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(10),
                      errorWidget: const Center(
                        child: Icon(Icons.apps, size: 20, color: Colors.white),
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.apps, size: 20, color: Colors.white),
                    ),
            ),
            const SizedBox(width: AppSpacing.sm + 4),
            // App info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.app.name,
                    style: AppTypography.bodyMedium.copyWith(color: colors.textPrimary),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.app.developer != null)
                    Text(
                      widget.app.developer!,
                      style: AppTypography.caption.copyWith(color: colors.textMuted),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            // Rating
            SizedBox(
              width: 70,
              child: widget.app.rating != null
                  ? Row(
                      children: [
                        Icon(Icons.star_rounded, size: 16, color: colors.yellow),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          widget.app.rating!.toStringAsFixed(1),
                          style: AppTypography.tableCell.copyWith(color: colors.textSecondary),
                        ),
                      ],
                    )
                  : Text(
                      '--',
                      style: AppTypography.tableCell.copyWith(color: colors.textMuted),
                    ),
            ),
            const SizedBox(width: AppSpacing.sm + 4),
            // Track button
            SizedBox(
              width: 48,
              child: _buildTrackButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackButton() {
    final colors = context.colors;
    if (_isAdded) {
      return Icon(
        Icons.check_circle_rounded,
        size: 22,
        color: colors.green,
      );
    }

    if (_isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: colors.textMuted,
        ),
      );
    }

    if (_error != null) {
      return Tooltip(
        message: _error!,
        child: IconButton(
          icon: const Icon(Icons.error_outline_rounded, size: 22),
          color: colors.red,
          onPressed: _trackApp,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      );
    }

    return IconButton(
      icon: const Icon(Icons.add_circle_outline_rounded, size: 22),
      color: colors.textMuted,
      hoverColor: colors.green.withAlpha(30),
      onPressed: _trackApp,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      tooltip: context.l10n.keywordSearch_trackApp,
    );
  }
}
