import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../shared/widgets/buttons.dart';
import '../../../shared/widgets/states.dart';
import '../../../shared/widgets/sparkline.dart';
import '../../../shared/widgets/change_indicator.dart';
import '../../../shared/widgets/data_table_enhanced.dart';
import '../../../shared/widgets/safe_image.dart';
import '../providers/apps_provider.dart';
import '../domain/app_model.dart';

// Provider for selected category filter (null = all categories)
final _selectedCategoryFilterProvider = StateProvider<String?>((ref) => null);

// Provider to get unique categories from tracked apps
final _availableCategoriesProvider = Provider<List<String>>((ref) {
  final appsAsync = ref.watch(appsNotifierProvider);
  return appsAsync.maybeWhen(
    data: (apps) {
      final categories = <String>{};
      for (final app in apps) {
        if (app.categoryId != null) {
          categories.add(app.categoryId!);
        }
      }
      return categories.toList()..sort();
    },
    orElse: () => [],
  );
});

// Filtered apps based on selected category
final _filteredAppsProvider = Provider<List<AppModel>>((ref) {
  final appsAsync = ref.watch(appsNotifierProvider);
  final selectedCategory = ref.watch(_selectedCategoryFilterProvider);

  return appsAsync.maybeWhen(
    data: (apps) {
      if (selectedCategory == null) return apps;
      return apps.where((app) => app.categoryId == selectedCategory).toList();
    },
    orElse: () => [],
  );
});

class AppsListScreen extends ConsumerWidget {
  const AppsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final appsAsync = ref.watch(appsNotifierProvider);
    final filteredApps = ref.watch(_filteredAppsProvider);
    final availableCategories = ref.watch(_availableCategoriesProvider);
    final selectedCategory = ref.watch(_selectedCategoryFilterProvider);

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanel,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
      ),
      child: Column(
        children: [
          // Toolbar
          _Toolbar(
            onAddApp: () => context.go('/apps/add'),
            onRefresh: () => ref.read(appsNotifierProvider.notifier).load(),
            availableCategories: availableCategories,
            selectedCategory: selectedCategory,
            onCategoryChanged: (category) {
              ref.read(_selectedCategoryFilterProvider.notifier).state =
                  category;
            },
          ),
          // Content
          Expanded(
            child: appsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (e, _) => ErrorView(
                message: e.toString(),
                onRetry: () => ref.read(appsNotifierProvider.notifier).load(),
              ),
              data: (_) => filteredApps.isEmpty
                  ? EmptyStateView(
                      icon: Icons.app_shortcut_outlined,
                      title: context.l10n.apps_noAppsYet,
                      subtitle: context.l10n.apps_addAppToStart,
                      actionLabel: context.l10n.dashboard_addApp,
                      actionIcon: Icons.add_rounded,
                      onAction: () => context.go('/apps/add'),
                    )
                  : _AppsTable(apps: filteredApps),
            ),
          ),
        ],
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  final VoidCallback onAddApp;
  final VoidCallback onRefresh;
  final List<String> availableCategories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategoryChanged;

  const _Toolbar({
    required this.onAddApp,
    required this.onRefresh,
    required this.availableCategories,
    required this.selectedCategory,
    required this.onCategoryChanged,
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
            context.l10n.apps_title,
            style: AppTypography.title.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(width: AppSpacing.md),
          // Category filter dropdown
          if (availableCategories.isNotEmpty)
            _CategoryFilterDropdown(
              availableCategories: availableCategories,
              selectedCategory: selectedCategory,
              onChanged: onCategoryChanged,
            ),
          const Spacer(),
          ToolbarButton(
            icon: Icons.refresh_rounded,
            label: context.l10n.common_refresh,
            onTap: onRefresh,
          ),
          const SizedBox(width: AppSpacing.sm + 2),
          PrimaryButton(
            icon: Icons.add_rounded,
            label: context.l10n.dashboard_addApp,
            onTap: onAddApp,
          ),
        ],
      ),
    );
  }
}

class _CategoryFilterDropdown extends StatelessWidget {
  final List<String> availableCategories;
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  const _CategoryFilterDropdown({
    required this.availableCategories,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colors.bgActive,
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: selectedCategory,
          hint: Text(
            context.l10n.discover_allCategories,
            style: AppTypography.caption.copyWith(color: colors.textSecondary),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: colors.textMuted,
          ),
          dropdownColor: colors.bgBase,
          isDense: true,
          items: [
            DropdownMenuItem<String?>(
              value: null,
              child: Text(
                context.l10n.discover_allCategories,
                style: AppTypography.caption.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ),
            ...availableCategories.map((categoryId) {
              return DropdownMenuItem<String?>(
                value: categoryId,
                child: Text(
                  _getCategoryName(categoryId),
                  style: AppTypography.caption.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              );
            }),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  String _getCategoryName(String categoryId) {
    // Map category IDs to display names
    // iOS categories
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
      '6023': 'Food & Drink',
      '6024': 'Shopping',
    };
    // Android categories
    const androidCategoryNames = {
      'GAME': 'Games',
      'BUSINESS': 'Business',
      'EDUCATION': 'Education',
      'ENTERTAINMENT': 'Entertainment',
      'FINANCE': 'Finance',
      'FOOD_AND_DRINK': 'Food & Drink',
      'HEALTH_AND_FITNESS': 'Health & Fitness',
      'LIFESTYLE': 'Lifestyle',
      'MEDICAL': 'Medical',
      'MUSIC_AND_AUDIO': 'Music & Audio',
      'PRODUCTIVITY': 'Productivity',
      'SHOPPING': 'Shopping',
      'SOCIAL': 'Social',
      'SPORTS': 'Sports',
      'TOOLS': 'Tools',
      'TRAVEL_AND_LOCAL': 'Travel & Local',
      'WEATHER': 'Weather',
    };

    return iosCategoryNames[categoryId] ??
        androidCategoryNames[categoryId] ??
        categoryId;
  }
}

class _AppsTable extends ConsumerWidget {
  final List<AppModel> apps;

  const _AppsTable({required this.apps});

  // Mock trend data for each app
  static const List<List<double>> _mockTrends = [
    [10.0, 12.0, 11.0, 15.0, 14.0, 18.0, 17.0, 20.0],
    [20.0, 18.0, 19.0, 15.0, 16.0, 12.0, 14.0, 10.0],
    [5.0, 8.0, 7.0, 9.0, 11.0, 10.0, 13.0, 15.0],
    [15.0, 14.0, 16.0, 15.0, 17.0, 16.0, 18.0, 19.0],
    [8.0, 10.0, 9.0, 12.0, 11.0, 14.0, 13.0, 16.0],
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    final columns = [
      EnhancedColumn(label: context.l10n.apps_tableApp),
      EnhancedColumn(label: context.l10n.apps_tableDeveloper, width: 120),
      EnhancedColumn(
        label: context.l10n.apps_tableKeywords,
        width: 80,
        align: TextAlign.center,
      ),
      const EnhancedColumn(label: 'Trend', width: 80, align: TextAlign.center),
      EnhancedColumn(label: context.l10n.apps_tablePlatform, width: 110),
      EnhancedColumn(label: context.l10n.apps_tableRating, width: 70),
      const EnhancedColumn(label: '', width: 36), // Arrow column
    ];

    final rows = apps.asMap().entries.map((entry) {
      final index = entry.key;
      final app = entry.value;
      final trendData = _mockTrends[index % _mockTrends.length];

      return [
        EnhancedCell.widget(_AppNameCell(app: app, index: index)),
        EnhancedCell.text(
          app.developer ?? '--',
          style: AppTypography.tableCell.copyWith(color: colors.textMuted),
        ),
        EnhancedCell.widget(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colors.accentMuted,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${app.trackedKeywordsCount ?? 0}',
              style: AppTypography.tableCellBold.copyWith(color: colors.accent),
              textAlign: TextAlign.center,
            ),
          ),
          align: TextAlign.center,
        ),
        EnhancedCell.widget(
          Sparkline(data: trendData, width: 60, height: 20),
          align: TextAlign.center,
        ),
        EnhancedCell.widget(
          Row(
            children: [
              if (app.isIos)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: colors.textMuted.withAlpha(30),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'iOS',
                    style: AppTypography.micro.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              if (app.isAndroid)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colors.green.withAlpha(30),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Android',
                    style: AppTypography.micro.copyWith(
                      color: colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
        EnhancedCell.widget(
          app.rating != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: colors.yellow,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          app.rating!.toStringAsFixed(1),
                          style: AppTypography.tableCellBold.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    ChangeIndicator(
                      value: (index % 3 == 0)
                          ? 0.2
                          : (index % 2 == 0)
                          ? -0.1
                          : 0.0,
                      format: ChangeFormat.number,
                      size: ChangeIndicatorSize.small,
                      showBackground: false,
                    ),
                  ],
                )
              : Text(
                  '--',
                  style: AppTypography.tableCell.copyWith(
                    color: colors.textMuted,
                  ),
                ),
        ),
        EnhancedCell.widget(
          Icon(Icons.chevron_right_rounded, size: 20, color: colors.textMuted),
          align: TextAlign.center,
        ),
      ];
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.cardPadding,
              vertical: AppSpacing.sm + 4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.apps_appCount(apps.length),
                  style: AppTypography.caption.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    SmallButton(
                      label: context.l10n.common_filter,
                      onTap: () {},
                    ),
                    const SizedBox(width: AppSpacing.xs + 2),
                    SmallButton(label: context.l10n.common_sort, onTap: () {}),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: EnhancedDataTable(
              columns: columns,
              rows: rows,
              onRowTap: (index) {
                final app = apps[index];
                context.go('/apps/preview/${app.platform}/${app.storeId}');
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AppNameCell extends StatelessWidget {
  final AppModel app;
  final int index;

  const _AppNameCell({required this.app, required this.index});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: AppColors.getGradient(index),
            borderRadius: BorderRadius.circular(10),
          ),
          child: app.iconUrl != null
              ? SafeImage(
                  imageUrl: app.iconUrl!,
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                app.name,
                style: AppTypography.tableCellBold.copyWith(
                  color: colors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              if (app.bestRank != null)
                Row(
                  children: [
                    Text(
                      'Best: #${app.bestRank}',
                      style: AppTypography.micro.copyWith(color: colors.green),
                    ),
                    if (app.ratingCount > 0) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '${_formatCount(app.ratingCount)} reviews',
                        style: AppTypography.micro.copyWith(
                          color: colors.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
            ],
          ),
        ),
      ],
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
