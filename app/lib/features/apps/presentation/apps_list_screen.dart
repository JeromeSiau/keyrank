import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../shared/widgets/buttons.dart';
import '../../../shared/widgets/states.dart';
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
              ref.read(_selectedCategoryFilterProvider.notifier).state = category;
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
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder)),
      ),
      child: Row(
        children: [
          Text(
            context.l10n.apps_title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(width: 16),
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
          const SizedBox(width: 10),
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
            style: TextStyle(
              fontSize: 13,
              color: colors.textSecondary,
            ),
          ),
          icon: Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: colors.textMuted),
          dropdownColor: colors.bgBase,
          isDense: true,
          items: [
            DropdownMenuItem<String?>(
              value: null,
              child: Text(
                context.l10n.discover_allCategories,
                style: TextStyle(
                  fontSize: 13,
                  color: colors.textPrimary,
                ),
              ),
            ),
            ...availableCategories.map((categoryId) {
              return DropdownMenuItem<String?>(
                value: categoryId,
                child: Text(
                  _getCategoryName(categoryId),
                  style: TextStyle(
                    fontSize: 13,
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

class _AppsTable extends StatelessWidget {
  final List apps;

  const _AppsTable({required this.apps});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: colors.bgActive.withAlpha(50),
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
          border: Border.all(color: colors.glassBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.apps_appCount(apps.length),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: colors.textSecondary,
                    ),
                  ),
                  Row(
                    children: [
                      SmallButton(label: context.l10n.common_filter, onTap: () {}),
                      const SizedBox(width: 6),
                      SmallButton(label: context.l10n.common_sort, onTap: () {}),
                    ],
                  ),
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
                  const SizedBox(width: 52),
                  Expanded(
                    child: Text(
                      context.l10n.apps_tableApp,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: colors.textMuted,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: Text(
                      context.l10n.apps_tableDeveloper,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: colors.textMuted,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 80,
                    child: Text(
                      context.l10n.apps_tableKeywords,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: colors.textMuted,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 110,
                    child: Text(
                      context.l10n.apps_tablePlatform,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: colors.textMuted,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 70,
                    child: Text(
                      context.l10n.apps_tableRating,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: colors.textMuted,
                      ),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
            ),
            // Apps list
            Expanded(
              child: ListView.builder(
                itemCount: apps.length,
                itemBuilder: (context, index) {
                  final app = apps[index];
                  return _AppRow(
                    app: app,
                    gradientIndex: index,
                    onTap: () => context.go('/apps/${app.id}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppRow extends StatelessWidget {
  final dynamic app;
  final int gradientIndex;
  final VoidCallback onTap;

  const _AppRow({
    required this.app,
    required this.gradientIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: colors.bgHover,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: colors.glassBorder)),
          ),
          child: Row(
            children: [
              // App icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppColors.getGradient(gradientIndex),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: app.iconUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          app.iconUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const Center(
                            child: Icon(Icons.apps, size: 20, color: Colors.white),
                          ),
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.apps, size: 20, color: Colors.white),
                      ),
              ),
              const SizedBox(width: 12),
              // App name
              Expanded(
                child: Text(
                  app.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Developer
              SizedBox(
                width: 120,
                child: Text(
                  app.developer ?? '--',
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.textMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 16),
              // Keywords count
              SizedBox(
                width: 80,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.accentMuted,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${app.trackedKeywordsCount ?? 0}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.accent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Platform badge
              SizedBox(
                width: 110,
                child: Row(
                  children: [
                    if (app.isIos)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          color: colors.textMuted.withAlpha(30),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'iOS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                    if (app.isAndroid)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.green.withAlpha(30),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Android',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: colors.green,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Rating
              SizedBox(
                width: 70,
                child: Row(
                  children: [
                    if (app.rating != null) ...[
                      Icon(Icons.star_rounded, size: 16, color: colors.yellow),
                      const SizedBox(width: 4),
                      Text(
                        app.rating!.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colors.textSecondary,
                        ),
                      ),
                    ] else
                      Text(
                        '--',
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.textMuted,
                        ),
                      ),
                  ],
                ),
              ),
              // Arrow
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: colors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

