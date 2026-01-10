import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/api/api_client.dart';
import '../../../core/widgets/platform_tabs.dart';
import '../../../shared/widgets/country_picker.dart';
import '../../../core/providers/country_provider.dart'
    show Country, availableCountries, countriesProvider, selectedCountryProvider;
import '../../../shared/widgets/states.dart';
import '../../apps/providers/apps_provider.dart';
import '../data/keywords_repository.dart';
import '../domain/keyword_model.dart';
import '../../categories/data/categories_repository.dart';
import '../../categories/domain/category_model.dart';

// Shared providers
final _selectedPlatformProvider = StateProvider<String>((ref) => 'ios');
final _selectedTabProvider = StateProvider<int>((ref) => 0); // 0 = Keywords, 1 = Categories

// Keyword search providers
final _keywordSearchQueryProvider = StateProvider<String>((ref) => '');

final _keywordSearchResultsProvider = FutureProvider<KeywordSearchResponse?>((ref) async {
  final query = ref.watch(_keywordSearchQueryProvider);
  final country = ref.watch(selectedCountryProvider);
  final platform = ref.watch(_selectedPlatformProvider);
  if (query.length < 2) return null;

  final repository = ref.watch(keywordsRepositoryProvider);
  return repository.searchKeyword(query: query, country: country.code, platform: platform);
});

// Category providers
final _selectedCategoryProvider = StateProvider<AppCategory?>((ref) => null);
final _selectedCollectionProvider = StateProvider<String>((ref) => 'top_free');

final _categoriesProvider = FutureProvider<CategoriesResponse>((ref) async {
  final repository = ref.watch(categoriesRepositoryProvider);
  return repository.getCategories();
});

final _topAppsProvider = FutureProvider<List<TopApp>>((ref) async {
  final category = ref.watch(_selectedCategoryProvider);
  final platform = ref.watch(_selectedPlatformProvider);
  final country = ref.watch(selectedCountryProvider);
  final collection = ref.watch(_selectedCollectionProvider);

  if (category == null) return [];

  final repository = ref.watch(categoriesRepositoryProvider);
  return repository.getTopApps(
    categoryId: category.id,
    platform: platform,
    country: country.code,
    collection: collection,
  );
});

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
    final selectedTab = ref.watch(_selectedTabProvider);
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
          // Toolbar with tabs
          _Toolbar(
            selectedTab: selectedTab,
            onTabChanged: (tab) => ref.read(_selectedTabProvider.notifier).state = tab,
            selectedCountry: selectedCountry,
            onCountrySelected: (country) {
              ref.read(selectedCountryProvider.notifier).state = country;
            },
            selectedPlatform: selectedPlatform,
            onPlatformSelected: (platform) {
              ref.read(_selectedPlatformProvider.notifier).state = platform;
              // Reset category when platform changes (categories differ between platforms)
              ref.read(_selectedCategoryProvider.notifier).state = null;
            },
            countries: countries,
          ),
          // Tab content
          Expanded(
            child: selectedTab == 0
                ? _KeywordsTabContent(
                    searchController: _searchController,
                    onSearchChanged: (value) {
                      ref.read(_keywordSearchQueryProvider.notifier).state = value;
                    },
                    onClearSearch: () {
                      _searchController.clear();
                      ref.read(_keywordSearchQueryProvider.notifier).state = '';
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
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder)),
      ),
      child: Row(
        children: [
          Text(
            context.l10n.discover_title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(width: 16),
          // Tab selector
          _TabSelector(
            selectedTab: selectedTab,
            onTabChanged: onTabChanged,
          ),
          const SizedBox(width: 16),
          // Platform toggle
          SizedBox(
            width: 240,
            child: PlatformTabs(
              selectedPlatform: selectedPlatform,
              availablePlatforms: const ['ios', 'android'],
              onPlatformChanged: onPlatformSelected,
            ),
          ),
          const SizedBox(width: 12),
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
      padding: const EdgeInsets.all(4),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colors.glassPanel : Colors.transparent,
          borderRadius: BorderRadius.circular(AppColors.radiusSmall - 2),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
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
    final searchResults = ref.watch(_keywordSearchResultsProvider);

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
      padding: const EdgeInsets.all(16),
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
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Icon(Icons.search_rounded, size: 20, color: colors.textMuted),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: onChanged,
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: context.l10n.keywordSearch_searchPlaceholder,
                        hintStyle: TextStyle(color: colors.textMuted),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  if (controller.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      color: colors.textMuted,
                      onPressed: onClear,
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
    );
  }
}

class _KeywordResultsView extends StatelessWidget {
  final KeywordSearchResponse response;

  const _KeywordResultsView({required this.response});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _KeywordInfoCard(
            keyword: response.keyword.keyword,
            popularity: response.keyword.popularity,
            totalResults: response.totalResults,
          ),
          const SizedBox(height: 16),
          _KeywordResultsTable(results: response.results),
        ],
      ),
    );
  }
}

class _KeywordInfoCard extends StatelessWidget {
  final String keyword;
  final int? popularity;
  final int totalResults;

  const _KeywordInfoCard({
    required this.keyword,
    required this.popularity,
    required this.totalResults,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  keyword,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  context.l10n.keywordSearch_appsRanked(totalResults),
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          if (popularity != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: _getPopularityColor(context, popularity!).withAlpha(25),
                borderRadius: BorderRadius.circular(AppColors.radiusMedium),
              ),
              child: Column(
                children: [
                  Text(
                    '$popularity',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: _getPopularityColor(context, popularity!),
                    ),
                  ),
                  Text(
                    context.l10n.keywordSearch_popularity,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: _getPopularityColor(context, popularity!),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _getPopularityColor(BuildContext context, int popularity) {
    final colors = context.colors;
    if (popularity >= 70) return colors.green;
    if (popularity >= 40) return colors.yellow;
    return colors.red;
  }
}

class _KeywordResultsTable extends ConsumerWidget {
  final List<KeywordSearchResult> results;

  const _KeywordResultsTable({required this.results});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final selectedPlatform = ref.watch(_selectedPlatformProvider);
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.keywordSearch_results(results.length),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
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
                  width: 60,
                  child: Text(
                    context.l10n.keywordSearch_headerRank,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                const SizedBox(width: 52),
                Expanded(
                  child: Text(
                    context.l10n.keywordSearch_headerApp,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: Text(
                    context.l10n.keywordSearch_headerRating,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 48,
                  child: Text(
                    context.l10n.keywordSearch_headerTrack,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: colors.textMuted,
                    ),
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
    final categoriesAsync = ref.watch(_categoriesProvider);
    final selectedCategory = ref.watch(_selectedCategoryProvider);
    final selectedCollection = ref.watch(_selectedCollectionProvider);
    final platform = ref.watch(_selectedPlatformProvider);
    final topAppsAsync = ref.watch(_topAppsProvider);

    return Column(
      children: [
        // Category and collection selectors
        _CategoryToolbar(
          categoriesAsync: categoriesAsync,
          selectedCategory: selectedCategory,
          selectedCollection: selectedCollection,
          platform: platform,
          onCategoryChanged: (category) {
            ref.read(_selectedCategoryProvider.notifier).state = category;
          },
          onCollectionChanged: (collection) {
            ref.read(_selectedCollectionProvider.notifier).state = collection;
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder)),
      ),
      child: Row(
        children: [
          // Category picker
          Expanded(
            child: categoriesAsync.when(
              loading: () => const SizedBox(height: 40),
              error: (_, __) => const SizedBox(height: 40),
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
          const SizedBox(width: 16),
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
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
            style: TextStyle(color: colors.textMuted),
          ),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: colors.textMuted),
          dropdownColor: colors.bgBase,
          items: categories.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(
                category.name,
                style: TextStyle(color: colors.textPrimary),
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
      padding: const EdgeInsets.all(4),
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
    final selectedPlatform = ref.watch(_selectedPlatformProvider);
    final selectedCountry = ref.watch(selectedCountryProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: colors.bgActive.withAlpha(50),
          border: Border.all(color: colors.glassBorder),
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.discover_appsCount(apps.length),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
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
                    width: 60,
                    child: Text(
                      context.l10n.keywordSearch_headerRank,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: colors.textMuted,
                      ),
                    ),
                  ),
                  const SizedBox(width: 52),
                  Expanded(
                    child: Text(
                      context.l10n.keywordSearch_headerApp,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: colors.textMuted,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 48,
                    child: Text(
                      context.l10n.keywordSearch_headerTrack,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: colors.textMuted,
                      ),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colors.glassBorder)),
        ),
        child: Row(
          children: [
            // Position
            SizedBox(
              width: 60,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isTopRank ? colors.greenMuted : colors.bgActive,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '#${widget.app.position}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isTopRank ? colors.green : colors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: AppColors.getGradient(widget.app.position),
                borderRadius: BorderRadius.circular(10),
              ),
              child: widget.app.iconUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.app.iconUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.apps, size: 20, color: Colors.white),
                        ),
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.apps, size: 20, color: Colors.white),
                    ),
            ),
            const SizedBox(width: 12),
            // App info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.app.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.app.developer != null)
                    Text(
                      widget.app.developer!,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textMuted,
                      ),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colors.glassBorder)),
        ),
        child: Row(
          children: [
            // Position
            SizedBox(
              width: 60,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isTopRank ? colors.greenMuted : colors.bgActive,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '#${widget.app.position}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isTopRank ? colors.green : colors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: AppColors.getGradient(widget.app.position),
                borderRadius: BorderRadius.circular(10),
              ),
              child: widget.app.iconUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.app.iconUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.apps, size: 20, color: Colors.white),
                        ),
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.apps, size: 20, color: Colors.white),
                    ),
            ),
            const SizedBox(width: 12),
            // App info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.app.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.app.developer != null)
                    Text(
                      widget.app.developer!,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textMuted,
                      ),
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
                        const SizedBox(width: 4),
                        Text(
                          widget.app.rating!.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      '--',
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.textMuted,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
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
