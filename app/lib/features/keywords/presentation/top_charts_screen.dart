import 'dart:math';
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
import '../../../shared/widgets/sparkline.dart';
import '../../../shared/widgets/states.dart';
import '../../../core/providers/country_provider.dart'
    show Country, availableCountries, countriesProvider, selectedCountryProvider;
import '../../apps/providers/apps_provider.dart';
import '../../categories/data/categories_repository.dart';
import '../../categories/domain/category_model.dart';
import '../../../shared/widgets/safe_image.dart';

// Top Charts specific providers
final _topChartsPlatformProvider = StateProvider<String>((ref) => 'ios');
final _topChartsCategoryProvider = StateProvider<AppCategory?>((ref) => null);
final _topChartsCollectionProvider = StateProvider<String>((ref) => 'top_free');

final _topChartsCategoriesProvider = FutureProvider<CategoriesResponse>((ref) async {
  final repository = ref.watch(categoriesRepositoryProvider);
  return repository.getCategories();
});

final _topChartsAppsProvider = FutureProvider<List<TopApp>>((ref) async {
  final category = ref.watch(_topChartsCategoryProvider);
  final platform = ref.watch(_topChartsPlatformProvider);
  final country = ref.watch(selectedCountryProvider);
  final collection = ref.watch(_topChartsCollectionProvider);

  if (category == null) return [];

  final repository = ref.watch(categoriesRepositoryProvider);
  return repository.getTopApps(
    categoryId: category.id,
    platform: platform,
    country: country.code,
    collection: collection,
  );
});

class TopChartsScreen extends ConsumerStatefulWidget {
  const TopChartsScreen({super.key});

  @override
  ConsumerState<TopChartsScreen> createState() => _TopChartsScreenState();
}

class _TopChartsScreenState extends ConsumerState<TopChartsScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final selectedPlatform = ref.watch(_topChartsPlatformProvider);
    final selectedCountry = ref.watch(selectedCountryProvider);
    final countries = ref.watch(countriesProvider).valueOrNull ?? availableCountries;
    final categoriesAsync = ref.watch(_topChartsCategoriesProvider);
    final selectedCategory = ref.watch(_topChartsCategoryProvider);
    final selectedCollection = ref.watch(_topChartsCollectionProvider);
    final topAppsAsync = ref.watch(_topChartsAppsProvider);

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanel,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
      ),
      child: Column(
        children: [
          // Main toolbar
          _MainToolbar(
            selectedPlatform: selectedPlatform,
            onPlatformChanged: (platform) {
              ref.read(_topChartsPlatformProvider.notifier).state = platform;
              // Reset category when platform changes
              ref.read(_topChartsCategoryProvider.notifier).state = null;
            },
            selectedCountry: selectedCountry,
            onCountryChanged: (country) {
              ref.read(selectedCountryProvider.notifier).state = country;
            },
            countries: countries,
            onRefresh: () {
              ref.invalidate(_topChartsAppsProvider);
            },
          ),
          // Filter bar
          _FilterBar(
            categoriesAsync: categoriesAsync,
            selectedCategory: selectedCategory,
            selectedCollection: selectedCollection,
            platform: selectedPlatform,
            onCategoryChanged: (category) {
              ref.read(_topChartsCategoryProvider.notifier).state = category;
            },
            onCollectionChanged: (collection) {
              ref.read(_topChartsCollectionProvider.notifier).state = collection;
            },
          ),
          // Results
          Expanded(
            child: selectedCategory == null
                ? _EmptyState(colors: colors)
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
                      return _TopChartsTable(apps: apps);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _MainToolbar extends StatelessWidget {
  final String selectedPlatform;
  final ValueChanged<String> onPlatformChanged;
  final Country selectedCountry;
  final ValueChanged<Country> onCountryChanged;
  final List<Country> countries;
  final VoidCallback onRefresh;

  const _MainToolbar({
    required this.selectedPlatform,
    required this.onPlatformChanged,
    required this.selectedCountry,
    required this.onCountryChanged,
    required this.countries,
    required this.onRefresh,
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
          // Trophy icon
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: colors.yellow.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.emoji_events_rounded,
              size: 20,
              color: colors.yellow,
            ),
          ),
          const SizedBox(width: AppSpacing.sm + 4),
          // Title
          Text(
            context.l10n.nav_topCharts,
            style: AppTypography.headline.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(width: AppSpacing.lg),
          // Platform tabs
          SizedBox(
            width: 240,
            child: PlatformTabs(
              selectedPlatform: selectedPlatform,
              availablePlatforms: const ['ios', 'android'],
              onPlatformChanged: onPlatformChanged,
            ),
          ),
          const Spacer(),
          // Country picker
          CountryPickerButton(
            selectedCountry: selectedCountry,
            countries: countries,
            onCountryChanged: onCountryChanged,
          ),
          const SizedBox(width: AppSpacing.sm + 4),
          // Refresh button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onRefresh,
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              hoverColor: colors.bgHover,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  border: Border.all(color: colors.glassBorder),
                  borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                ),
                child: Icon(
                  Icons.refresh_rounded,
                  size: 20,
                  color: colors.textMuted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final AsyncValue<CategoriesResponse> categoriesAsync;
  final AppCategory? selectedCategory;
  final String selectedCollection;
  final String platform;
  final ValueChanged<AppCategory?> onCategoryChanged;
  final ValueChanged<String> onCollectionChanged;

  const _FilterBar({
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
          // Category dropdown (half width)
          Expanded(
            child: categoriesAsync.when(
              loading: () => _CategoryDropdownPlaceholder(),
              error: (e, s) => _CategoryDropdownPlaceholder(),
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
          // Collection toggle
          _CollectionToggle(
            selectedCollection: selectedCollection,
            onChanged: onCollectionChanged,
          ),
        ],
      ),
    );
  }
}

class _CategoryDropdownPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: colors.bgBase,
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
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
          _CollectionTab(
            label: context.l10n.discover_topFree,
            icon: Icons.download_rounded,
            isSelected: selectedCollection == 'top_free',
            onTap: () => onChanged('top_free'),
          ),
          _CollectionTab(
            label: context.l10n.discover_topPaid,
            icon: Icons.paid_rounded,
            isSelected: selectedCollection == 'top_paid',
            onTap: () => onChanged('top_paid'),
          ),
          _CollectionTab(
            label: context.l10n.discover_topGrossing,
            icon: Icons.trending_up_rounded,
            isSelected: selectedCollection == 'top_grossing',
            onTap: () => onChanged('top_grossing'),
          ),
        ],
      ),
    );
  }
}

class _CollectionTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CollectionTab({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm + 4, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? colors.glassPanel : Colors.transparent,
          borderRadius: BorderRadius.circular(AppColors.radiusSmall - 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? colors.accent : colors.textMuted,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.body.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? colors.textPrimary : colors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final AppColorsExtension colors;

  const _EmptyState({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            decoration: BoxDecoration(
              color: colors.yellow.withAlpha(15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emoji_events_rounded,
              size: 48,
              color: colors.yellow.withAlpha(150),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            context.l10n.discover_selectCategory,
            style: AppTypography.titleSmall.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Browse top apps in each category',
            style: AppTypography.body.copyWith(color: colors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _TopChartsTable extends ConsumerWidget {
  final List<TopApp> apps;

  const _TopChartsTable({required this.apps});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

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
            // Results count header
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
            // Table header
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
                  // Rank
                  SizedBox(
                    width: 60,
                    child: Text(
                      context.l10n.keywordSearch_headerRank,
                      style: AppTypography.tableHeader.copyWith(color: colors.textMuted),
                    ),
                  ),
                  const SizedBox(width: 52), // Icon space
                  // App
                  Expanded(
                    flex: 3,
                    child: Text(
                      context.l10n.keywordSearch_headerApp,
                      style: AppTypography.tableHeader.copyWith(color: colors.textMuted),
                    ),
                  ),
                  // Rating
                  SizedBox(
                    width: 70,
                    child: Text(
                      context.l10n.keywordSearch_headerRating,
                      style: AppTypography.tableHeader.copyWith(color: colors.textMuted),
                    ),
                  ),
                  // Change
                  SizedBox(
                    width: 60,
                    child: Text(
                      'CHANGE',
                      style: AppTypography.tableHeader.copyWith(color: colors.textMuted),
                    ),
                  ),
                  // Trend
                  SizedBox(
                    width: 90,
                    child: Text(
                      'TREND',
                      style: AppTypography.tableHeader.copyWith(color: colors.textMuted),
                    ),
                  ),
                  // Track
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
            // Table rows
            ...apps.map((app) => _TopChartRow(app: app)),
          ],
        ),
      ),
    );
  }
}

class _TopChartRow extends ConsumerStatefulWidget {
  final TopApp app;

  const _TopChartRow({required this.app});

  @override
  ConsumerState<_TopChartRow> createState() => _TopChartRowState();
}

class _TopChartRowState extends ConsumerState<_TopChartRow> {
  bool _isLoading = false;
  bool _isAdded = false;
  String? _error;

  // Mock data for change and trend
  late final int _change;
  late final List<double> _trendData;

  @override
  void initState() {
    super.initState();
    // Generate mock change data (-5 to +5)
    final random = Random(widget.app.storeId.hashCode);
    _change = random.nextInt(11) - 5;

    // Generate mock trend data (7 points for weekly sparkline)
    _trendData = List.generate(7, (i) {
      final baseValue = 100 - widget.app.position.toDouble();
      return baseValue + random.nextDouble() * 10 - 5;
    });
  }

  Future<void> _trackApp() async {
    if (_isLoading || _isAdded) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final notifier = ref.read(appsNotifierProvider.notifier);
      final platform = ref.read(_topChartsPlatformProvider);
      final country = ref.read(selectedCountryProvider);
      await notifier.addApp(
        platform: platform,
        storeId: widget.app.storeId,
        country: country.code,
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
    final platform = ref.read(_topChartsPlatformProvider);
    final country = ref.read(selectedCountryProvider);
    context.push(
      '/apps/preview/$platform/${widget.app.storeId}?country=${country.code}',
    );
  }

  Color _getMedalColor(int position, AppColorsExtension colors) {
    switch (position) {
      case 1:
        return colors.yellow; // Gold
      case 2:
        return Colors.grey.shade400; // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return colors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isTopRank = widget.app.position <= 3;
    final medalColor = _getMedalColor(widget.app.position, colors);

    return InkWell(
      onTap: _openPreview,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.cardPadding, vertical: AppSpacing.sm + 4),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colors.glassBorder)),
        ),
        child: Row(
          children: [
            // Rank with medal styling for top 3
            SizedBox(
              width: 60,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: isTopRank
                      ? medalColor.withAlpha(25)
                      : colors.bgActive,
                  borderRadius: BorderRadius.circular(8),
                  border: isTopRank
                      ? Border.all(color: medalColor.withAlpha(50))
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isTopRank) ...[
                      Icon(
                        Icons.emoji_events_rounded,
                        size: 12,
                        color: medalColor,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                    ],
                    Text(
                      '${widget.app.position}',
                      style: AppTypography.tableCell.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isTopRank ? medalColor : colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm + 4),
            // App icon
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
            // App name and developer
            Expanded(
              flex: 3,
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
            // Change (mock data)
            SizedBox(
              width: 60,
              child: _buildChangeIndicator(colors),
            ),
            // Trend sparkline (mock data)
            SizedBox(
              width: 90,
              child: Sparkline(
                data: _trendData,
                width: 80,
                height: 24,
                strokeWidth: 1.5,
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

  Widget _buildChangeIndicator(AppColorsExtension colors) {
    if (_change == 0) {
      return Row(
        children: [
          Icon(
            Icons.remove_rounded,
            size: 14,
            color: colors.textMuted,
          ),
          const SizedBox(width: 2),
          Text(
            '0',
            style: AppTypography.caption.copyWith(color: colors.textMuted),
          ),
        ],
      );
    }

    final isPositive = _change > 0;
    final color = isPositive ? colors.green : colors.red;
    final icon = isPositive
        ? Icons.arrow_upward_rounded
        : Icons.arrow_downward_rounded;

    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 2),
        Text(
          '${_change.abs()}',
          style: AppTypography.caption.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
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
