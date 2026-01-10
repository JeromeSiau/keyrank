import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../shared/widgets/buttons.dart';
import '../../../shared/widgets/states.dart';
import '../../apps/domain/app_model.dart';
import '../../apps/providers/apps_provider.dart';

enum AppFilter { all, ios, android, favorites }
enum AppSort { nameAsc, nameDesc, keywordsDesc, bestRank, recentlyAdded }

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final appsAsync = ref.watch(appsNotifierProvider);

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
              data: (apps) => _DashboardContent(apps: apps),
            ),
          ),
        ],
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  final VoidCallback onAddApp;

  const _Toolbar({required this.onAddApp});

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
            context.l10n.dashboard_title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const Spacer(),
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

class _DashboardContent extends StatelessWidget {
  final List<AppModel> apps;

  const _DashboardContent({required this.apps});

  @override
  Widget build(BuildContext context) {
    final totalKeywords = apps.fold<int>(
      0,
      (sum, app) => sum + (app.trackedKeywordsCount ?? 0),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats bar
          _StatsBar(
            appsCount: apps.length,
            keywordsCount: totalKeywords,
          ),
          const SizedBox(height: 16),
          // Main content
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Apps panel
              Expanded(
                flex: 2,
                child: _AppsPanel(apps: apps),
              ),
              const SizedBox(width: 16),
              // Quick actions panel
              SizedBox(
                width: 300,
                child: _QuickActionsPanel(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsBar extends StatelessWidget {
  final int appsCount;
  final int keywordsCount;

  const _StatsBar({
    required this.appsCount,
    required this.keywordsCount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(color: colors.glassBorder),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _StatItem(
                label: context.l10n.dashboard_appsTracked,
                value: appsCount.toString(),
                icon: Icons.apps_rounded,
                color: colors.accent,
                trend: appsCount > 0 ? '+1' : '',
                isPositive: true,
              ),
            ),
            Container(width: 1, color: colors.glassBorder),
            Expanded(
              child: _StatItem(
                label: context.l10n.dashboard_keywords,
                value: keywordsCount.toString(),
                icon: Icons.key_rounded,
                color: colors.purple,
                trend: keywordsCount > 0 ? '+5' : '',
                isPositive: true,
              ),
            ),
            Container(width: 1, color: colors.glassBorder),
            Expanded(
              child: _StatItem(
                label: context.l10n.dashboard_avgPosition,
                value: '--',
                icon: Icons.trending_up_rounded,
                color: colors.green,
                trend: '',
                isPositive: true,
              ),
            ),
            Container(width: 1, color: colors.glassBorder),
            Expanded(
              child: _StatItem(
                label: context.l10n.dashboard_top10,
                value: '--',
                icon: Icons.emoji_events_rounded,
                color: colors.yellow,
                trend: '',
                isPositive: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;
  final bool isPositive;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.trend,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const Spacer(),
              if (trend.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (isPositive ? colors.green : colors.red).withAlpha(20),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    trend,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isPositive ? colors.green : colors.red,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppsPanel extends StatefulWidget {
  final List<AppModel> apps;

  const _AppsPanel({required this.apps});

  @override
  State<_AppsPanel> createState() => _AppsPanelState();
}

class _AppsPanelState extends State<_AppsPanel> {
  AppFilter _filter = AppFilter.all;
  AppSort _sort = AppSort.recentlyAdded;

  List<AppModel> get _filteredAndSortedApps {
    // Apply filter
    var filtered = widget.apps.where((app) {
      switch (_filter) {
        case AppFilter.all:
          return true;
        case AppFilter.ios:
          return app.isIos;
        case AppFilter.android:
          return app.isAndroid;
        case AppFilter.favorites:
          return app.isFavorite;
      }
    }).toList();

    // Apply sort
    filtered.sort((a, b) {
      switch (_sort) {
        case AppSort.nameAsc:
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        case AppSort.nameDesc:
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        case AppSort.keywordsDesc:
          return (b.trackedKeywordsCount ?? 0).compareTo(a.trackedKeywordsCount ?? 0);
        case AppSort.bestRank:
          // Apps with rank come first, sorted ascending (1 is best)
          if (a.bestRank == null && b.bestRank == null) return 0;
          if (a.bestRank == null) return 1;
          if (b.bestRank == null) return -1;
          return a.bestRank!.compareTo(b.bestRank!);
        case AppSort.recentlyAdded:
          return b.createdAt.compareTo(a.createdAt);
      }
    });

    return filtered;
  }

  String _getFilterLabel(BuildContext context) {
    switch (_filter) {
      case AppFilter.all:
        return context.l10n.filter_all;
      case AppFilter.ios:
        return context.l10n.filter_ios;
      case AppFilter.android:
        return context.l10n.filter_android;
      case AppFilter.favorites:
        return context.l10n.filter_favorites;
    }
  }

  String _getSortLabel(BuildContext context) {
    switch (_sort) {
      case AppSort.nameAsc:
        return context.l10n.sort_nameAZ;
      case AppSort.nameDesc:
        return context.l10n.sort_nameZA;
      case AppSort.keywordsDesc:
        return context.l10n.sort_keywords;
      case AppSort.bestRank:
        return context.l10n.sort_bestRank;
      case AppSort.recentlyAdded:
        return context.l10n.sort_recent;
    }
  }

  void _showFilterMenu(BuildContext context) {
    final colors = context.colors;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final offset = button.localToGlobal(Offset.zero);

    showMenu<AppFilter>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + button.size.height,
        offset.dx + button.size.width,
        offset.dy + button.size.height + 200,
      ),
      items: [
        _buildFilterMenuItem(AppFilter.all, context.l10n.filter_allApps, colors),
        _buildFilterMenuItem(AppFilter.ios, context.l10n.filter_iosOnly, colors),
        _buildFilterMenuItem(AppFilter.android, context.l10n.filter_androidOnly, colors),
        _buildFilterMenuItem(AppFilter.favorites, context.l10n.filter_favorites, colors),
      ],
    ).then((value) {
      if (value != null) {
        setState(() => _filter = value);
      }
    });
  }

  PopupMenuItem<AppFilter> _buildFilterMenuItem(AppFilter filter, String label, AppColorsExtension colors) {
    return PopupMenuItem<AppFilter>(
      value: filter,
      child: Row(
        children: [
          if (_filter == filter)
            Icon(Icons.check, size: 16, color: colors.accent)
          else
            const SizedBox(width: 16),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  void _showSortMenu(BuildContext context) {
    final colors = context.colors;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final offset = button.localToGlobal(Offset.zero);

    showMenu<AppSort>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + button.size.height,
        offset.dx + button.size.width,
        offset.dy + button.size.height + 250,
      ),
      items: [
        _buildSortMenuItem(AppSort.recentlyAdded, context.l10n.sort_recentlyAdded, colors),
        _buildSortMenuItem(AppSort.nameAsc, context.l10n.sort_nameAZ, colors),
        _buildSortMenuItem(AppSort.nameDesc, context.l10n.sort_nameZA, colors),
        _buildSortMenuItem(AppSort.keywordsDesc, context.l10n.sort_mostKeywords, colors),
        _buildSortMenuItem(AppSort.bestRank, context.l10n.sort_bestRank, colors),
      ],
    ).then((value) {
      if (value != null) {
        setState(() => _sort = value);
      }
    });
  }

  PopupMenuItem<AppSort> _buildSortMenuItem(AppSort sort, String label, AppColorsExtension colors) {
    return PopupMenuItem<AppSort>(
      value: sort,
      child: Row(
        children: [
          if (_sort == sort)
            Icon(Icons.check, size: 16, color: colors.accent)
          else
            const SizedBox(width: 16),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final displayedApps = _filteredAndSortedApps;
    final filterLabel = _getFilterLabel(context);

    return Container(
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
                  '${context.l10n.dashboard_trackedApps}${_filter != AppFilter.all ? ' ($filterLabel)' : ''}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    Builder(
                      builder: (context) => _FilterSortButton(
                        label: _getFilterLabel(context),
                        icon: Icons.filter_list_rounded,
                        isActive: _filter != AppFilter.all,
                        onTap: () => _showFilterMenu(context),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Builder(
                      builder: (context) => _FilterSortButton(
                        label: _getSortLabel(context),
                        icon: Icons.sort_rounded,
                        isActive: _sort != AppSort.recentlyAdded,
                        onTap: () => _showSortMenu(context),
                      ),
                    ),
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
                  width: 80,
                  child: Text(
                    context.l10n.apps_tableBestRank,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: colors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Apps list
          if (displayedApps.isEmpty)
            _EmptyAppsState(hasFilter: _filter != AppFilter.all)
          else
            ...displayedApps.asMap().entries.map((entry) => _AppRow(
                  app: entry.value,
                  gradientIndex: entry.key,
                  onTap: () => context.go('/apps/${entry.value.id}'),
                )),
        ],
      ),
    );
  }
}

class _FilterSortButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterSortButton({
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

class SmallButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const SmallButton({super.key, required this.label, required this.onTap});

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
            border: Border.all(color: colors.glassBorder),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colors.textMuted,
            ),
          ),
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
              // App info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (app.developer != null)
                      Text(
                        app.developer!,
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textMuted,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
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
              // Platform badges
              SizedBox(
                width: 110,
                child: Row(
                  children: [
                    if (app.isIos)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              // Best Rank
              SizedBox(
                width: 80,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: app.bestRank != null ? colors.greenMuted : colors.bgActive,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    app.bestRank?.toString() ?? '--',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: app.bestRank != null ? colors.green : colors.textMuted,
                    ),
                    textAlign: TextAlign.center,
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

class _EmptyAppsState extends StatelessWidget {
  final bool hasFilter;

  const _EmptyAppsState({this.hasFilter = false});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colors.bgActive,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              hasFilter ? Icons.filter_list_off_rounded : Icons.app_shortcut_outlined,
              size: 32,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            hasFilter ? context.l10n.dashboard_noAppsMatchFilter : context.l10n.dashboard_noAppsYet,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hasFilter ? context.l10n.dashboard_changeFilterCriteria : context.l10n.dashboard_addAppToStart,
            style: TextStyle(
              fontSize: 13,
              color: colors.textMuted,
            ),
          ),
          if (!hasFilter) ...[
            const SizedBox(height: 20),
            Material(
              color: colors.accent,
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              child: InkWell(
                onTap: () => context.go('/apps/add'),
                borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add_rounded, size: 18, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        context.l10n.dashboard_addApp,
                        style: const TextStyle(
                          fontSize: 14,
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
        ],
      ),
    );
  }
}

class _QuickActionsPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(color: colors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Text(
              context.l10n.dashboard_quickActions,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ),
          Container(
            height: 1,
            color: colors.glassBorder,
          ),
          _QuickActionItem(
            icon: Icons.add_circle_outline_rounded,
            label: context.l10n.dashboard_addNewApp,
            color: colors.accent,
            onTap: () => context.go('/apps/add'),
          ),
          _QuickActionItem(
            icon: Icons.search_rounded,
            label: context.l10n.dashboard_searchKeywords,
            color: colors.purple,
            onTap: () => context.go('/keywords'),
          ),
          _QuickActionItem(
            icon: Icons.apps_rounded,
            label: context.l10n.dashboard_viewAllApps,
            color: colors.green,
            onTap: () => context.go('/apps'),
          ),
        ],
      ),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.color,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                  ),
                ),
              ),
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
