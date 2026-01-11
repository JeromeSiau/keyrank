import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../apps/providers/apps_provider.dart';
import '../../apps/domain/app_model.dart';

// Competitors screen local state providers
final _selectedAppIdsProvider = StateProvider<Set<int>>((ref) => {});
final _selectedPeriodProvider = StateProvider<String>((ref) => '30d');

class CompetitorsScreen extends ConsumerStatefulWidget {
  const CompetitorsScreen({super.key});

  @override
  ConsumerState<CompetitorsScreen> createState() => _CompetitorsScreenState();
}

class _CompetitorsScreenState extends ConsumerState<CompetitorsScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final appsAsync = ref.watch(appsNotifierProvider);
    final selectedIds = ref.watch(_selectedAppIdsProvider);

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanel,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
      ),
      child: Column(
        children: [
          // Main toolbar
          _MainToolbar(
            onAddApps: () => _showAppSelectionDialog(appsAsync),
            onRefresh: () {
              ref.invalidate(appsNotifierProvider);
            },
          ),
          // Content
          Expanded(
            child: appsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (e, _) => Center(
                child: Text(
                  'Error: $e',
                  style: TextStyle(color: colors.red),
                ),
              ),
              data: (apps) {
                // Filter selected apps
                final selectedApps = apps
                    .where((app) => selectedIds.contains(app.id))
                    .toList();

                if (selectedApps.isEmpty) {
                  return _EmptyState(
                    colors: colors,
                    onAddApps: () => _showAppSelectionDialog(appsAsync),
                  );
                }

                return _ComparisonView(selectedApps: selectedApps);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAppSelectionDialog(AsyncValue<List<AppModel>> appsAsync) {
    final apps = appsAsync.valueOrNull ?? [];
    if (apps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.compare_noOtherApps),
          backgroundColor: context.colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => _AppSelectionDialog(
        apps: apps,
        initialSelectedIds: ref.read(_selectedAppIdsProvider),
        onConfirm: (selectedIds) {
          ref.read(_selectedAppIdsProvider.notifier).state = selectedIds;
        },
      ),
    );
  }
}

class _MainToolbar extends StatelessWidget {
  final VoidCallback onAddApps;
  final VoidCallback onRefresh;

  const _MainToolbar({
    required this.onAddApps,
    required this.onRefresh,
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
          // Groups icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.accent.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.groups_rounded,
              size: 20,
              color: colors.accent,
            ),
          ),
          const SizedBox(width: 12),
          // Title
          Text(
            context.l10n.nav_competitors,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const Spacer(),
          // Add apps button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onAddApps,
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              hoverColor: colors.bgHover,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: colors.accent,
                  borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.add_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Add Apps',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Refresh button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onRefresh,
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              hoverColor: colors.bgHover,
              child: Container(
                padding: const EdgeInsets.all(8),
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

class _EmptyState extends StatelessWidget {
  final AppColorsExtension colors;
  final VoidCallback onAddApps;

  const _EmptyState({
    required this.colors,
    required this.onAddApps,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colors.accent.withAlpha(15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.groups_rounded,
              size: 56,
              color: colors.accent.withAlpha(150),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Select apps to compare',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Compare metrics and rankings across your tracked apps',
            style: TextStyle(
              fontSize: 14,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: 24),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onAddApps,
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: colors.accent,
                  borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.add_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Add Apps to Compare',
                      style: TextStyle(
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
      ),
    );
  }
}

class _AppSelectionDialog extends ConsumerStatefulWidget {
  final List<AppModel> apps;
  final Set<int> initialSelectedIds;
  final ValueChanged<Set<int>> onConfirm;

  const _AppSelectionDialog({
    required this.apps,
    required this.initialSelectedIds,
    required this.onConfirm,
  });

  @override
  ConsumerState<_AppSelectionDialog> createState() => _AppSelectionDialogState();
}

class _AppSelectionDialogState extends ConsumerState<_AppSelectionDialog> {
  late Set<int> _selectedIds;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedIds = Set.from(widget.initialSelectedIds);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final filteredApps = widget.apps.where((app) {
      if (_searchQuery.isEmpty) return true;
      return app.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Dialog(
      backgroundColor: colors.bgBase,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Container(
        width: 480,
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: colors.glassBorder)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.groups_rounded,
                        size: 24,
                        color: colors.accent,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Select Apps to Compare',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close_rounded,
                          color: colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select 2-4 apps from your tracked apps',
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: colors.bgActive,
                  borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                  border: Border.all(color: colors.glassBorder),
                ),
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  style: TextStyle(color: colors.textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: context.l10n.compare_searchApps,
                    hintStyle: TextStyle(color: colors.textMuted),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: colors.textMuted,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
            // Selection count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    '${_selectedIds.length} of 4 apps selected',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: _selectedIds.length >= 2 ? colors.green : colors.textMuted,
                    ),
                  ),
                  const Spacer(),
                  if (_selectedIds.isNotEmpty)
                    TextButton(
                      onPressed: () => setState(() => _selectedIds.clear()),
                      child: Text(
                        context.l10n.keywordSuggestions_clear,
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.textMuted,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // App list
            Flexible(
              child: filteredApps.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          context.l10n.compare_noMatchingApps,
                          style: TextStyle(color: colors.textMuted),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredApps.length,
                      itemBuilder: (context, index) {
                        final app = filteredApps[index];
                        final isSelected = _selectedIds.contains(app.id);
                        final canSelect = _selectedIds.length < 4 || isSelected;

                        return _AppSelectionTile(
                          app: app,
                          isSelected: isSelected,
                          canSelect: canSelect,
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedIds.remove(app.id);
                              } else if (canSelect) {
                                _selectedIds.add(app.id);
                              }
                            });
                          },
                        );
                      },
                    ),
            ),
            // Footer buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: colors.glassBorder)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      context.l10n.compare_cancel,
                      style: TextStyle(color: colors.textMuted),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _selectedIds.length >= 2
                          ? () {
                              widget.onConfirm(_selectedIds);
                              Navigator.of(context).pop();
                            }
                          : null,
                      borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedIds.length >= 2
                              ? colors.accent
                              : colors.bgActive,
                          borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                        ),
                        child: Text(
                          context.l10n.compare_button(_selectedIds.length),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _selectedIds.length >= 2
                                ? Colors.white
                                : colors.textMuted,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppSelectionTile extends StatelessWidget {
  final AppModel app;
  final bool isSelected;
  final bool canSelect;
  final VoidCallback onTap;

  const _AppSelectionTile({
    required this.app,
    required this.isSelected,
    required this.canSelect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: canSelect ? onTap : null,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          margin: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            color: isSelected ? colors.accent.withAlpha(15) : Colors.transparent,
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
            border: isSelected
                ? Border.all(color: colors.accent.withAlpha(50))
                : null,
          ),
          child: Row(
            children: [
              // Checkbox
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isSelected ? colors.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isSelected ? colors.accent : colors.glassBorder,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              // App icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: colors.bgActive,
                ),
                clipBehavior: Clip.antiAlias,
                child: app.iconUrl != null
                    ? Image.network(
                        app.iconUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Icon(
                          app.isIos ? Icons.apple : Icons.android,
                          size: 18,
                          color: colors.textMuted,
                        ),
                      )
                    : Icon(
                        app.isIos ? Icons.apple : Icons.android,
                        size: 18,
                        color: colors.textMuted,
                      ),
              ),
              const SizedBox(width: 12),
              // App name and platform
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: canSelect ? colors.textPrimary : colors.textMuted,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          app.isIos ? Icons.apple : Icons.android,
                          size: 12,
                          color: colors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          app.isIos ? 'iOS' : 'Android',
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Rating
              if (app.rating != null)
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: colors.yellow,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      app.rating!.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ComparisonView extends ConsumerWidget {
  final List<AppModel> selectedApps;

  const _ComparisonView({required this.selectedApps});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Selected apps chips
          _SelectedAppsChips(
            apps: selectedApps,
            onRemove: (appId) {
              final currentIds = ref.read(_selectedAppIdsProvider);
              ref.read(_selectedAppIdsProvider.notifier).state =
                  Set.from(currentIds)..remove(appId);
            },
          ),
          const SizedBox(height: 20),
          // Metrics comparison table
          _MetricsComparisonCard(apps: selectedApps),
          const SizedBox(height: 20),
          // Ranking trend chart
          _RankingTrendCard(apps: selectedApps),
        ],
      ),
    );
  }
}

class _SelectedAppsChips extends StatelessWidget {
  final List<AppModel> apps;
  final ValueChanged<int> onRemove;

  const _SelectedAppsChips({
    required this.apps,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: apps.map((app) {
        final chipColor = _getAppColor(apps.indexOf(app));
        return Container(
          padding: const EdgeInsets.only(left: 4, right: 8, top: 4, bottom: 4),
          decoration: BoxDecoration(
            color: chipColor.withAlpha(20),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: chipColor.withAlpha(50)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // App icon
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: colors.bgActive,
                ),
                clipBehavior: Clip.antiAlias,
                child: app.iconUrl != null
                    ? Image.network(
                        app.iconUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Icon(
                          app.isIos ? Icons.apple : Icons.android,
                          size: 14,
                          color: colors.textMuted,
                        ),
                      )
                    : Icon(
                        app.isIos ? Icons.apple : Icons.android,
                        size: 14,
                        color: colors.textMuted,
                      ),
              ),
              const SizedBox(width: 8),
              // App name
              Text(
                app.name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              // Remove button
              GestureDetector(
                onTap: () => onRemove(app.id),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: colors.textMuted.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 14,
                    color: colors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _MetricsComparisonCard extends StatelessWidget {
  final List<AppModel> apps;

  const _MetricsComparisonCard({required this.apps});

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
          // Section header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.analytics_rounded,
                  size: 20,
                  color: colors.accent,
                ),
                const SizedBox(width: 10),
                Text(
                  'Metrics Comparison',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.glassBorder),
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: colors.bgActive.withAlpha(80),
            child: Row(
              children: [
                SizedBox(
                  width: 140,
                  child: Text(
                    'METRIC',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                ...apps.map((app) => Expanded(
                      child: Text(
                        app.name,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: colors.textMuted,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    )),
              ],
            ),
          ),
          // Metric rows
          _MetricRow(
            label: 'Rating',
            icon: Icons.star_rounded,
            iconColor: colors.yellow,
            values: apps.map((app) => _RatingValue(rating: app.rating)).toList(),
          ),
          _MetricRow(
            label: 'Total Reviews',
            icon: Icons.reviews_rounded,
            iconColor: colors.accent,
            values: apps
                .map((app) => _NumberValue(value: app.ratingCount))
                .toList(),
          ),
          _MetricRow(
            label: 'Recent Reviews',
            icon: Icons.new_releases_rounded,
            iconColor: colors.green,
            values: apps.map((app) {
              // Mock: random 10-100 for recent reviews
              final random = Random(app.id);
              final recentCount = 10 + random.nextInt(91);
              return _NumberValue(value: recentCount, suffix: ' (30d)');
            }).toList(),
          ),
          _MetricRow(
            label: 'Keywords Tracked',
            icon: Icons.key_rounded,
            iconColor: colors.purple,
            values: apps.map((app) {
              final count = app.trackedKeywordsCount ?? 0;
              return _TextValue(text: 'Tracking $count keywords');
            }).toList(),
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final List<Widget> values;
  final bool isLast;

  const _MetricRow({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.values,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: colors.glassBorder)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Row(
              children: [
                Icon(icon, size: 16, color: iconColor),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          ...values.map((value) => Expanded(child: Center(child: value))),
        ],
      ),
    );
  }
}

class _RatingValue extends StatelessWidget {
  final double? rating;

  const _RatingValue({required this.rating});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    if (rating == null) {
      return Text(
        '--',
        style: TextStyle(
          fontSize: 14,
          color: colors.textMuted,
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: 16, color: colors.yellow),
        const SizedBox(width: 4),
        Text(
          rating!.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _NumberValue extends StatelessWidget {
  final int value;
  final String? suffix;

  const _NumberValue({required this.value, this.suffix});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Text(
      _formatNumber(value) + (suffix ?? ''),
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: colors.textPrimary,
      ),
    );
  }

  String _formatNumber(int num) {
    if (num >= 1000000) {
      return '${(num / 1000000).toStringAsFixed(1)}M';
    } else if (num >= 1000) {
      return '${(num / 1000).toStringAsFixed(1)}K';
    }
    return num.toString();
  }
}

class _TextValue extends StatelessWidget {
  final String text;

  const _TextValue({required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        color: colors.textSecondary,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _RankingTrendCard extends ConsumerWidget {
  final List<AppModel> apps;

  const _RankingTrendCard({required this.apps});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final selectedPeriod = ref.watch(_selectedPeriodProvider);

    return Container(
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header with period selector
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.trending_up_rounded,
                  size: 20,
                  color: colors.green,
                ),
                const SizedBox(width: 10),
                Text(
                  'Ranking Trends',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                const Spacer(),
                // Period selector
                _PeriodSelector(
                  selectedPeriod: selectedPeriod,
                  onChanged: (period) {
                    ref.read(_selectedPeriodProvider.notifier).state = period;
                  },
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.glassBorder),
          // Chart area
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Multi-line chart placeholder
                _MultiLineChart(apps: apps, period: selectedPeriod),
                const SizedBox(height: 20),
                // Legend
                _ChartLegend(apps: apps),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  final String selectedPeriod;
  final ValueChanged<String> onChanged;

  const _PeriodSelector({
    required this.selectedPeriod,
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
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ['7d', '30d', '90d'].map((period) {
          final isSelected = selectedPeriod == period;
          return GestureDetector(
            onTap: () => onChanged(period),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? colors.glassPanel : Colors.transparent,
                borderRadius: BorderRadius.circular(AppColors.radiusSmall - 2),
              ),
              child: Text(
                period.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? colors.textPrimary : colors.textMuted,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _MultiLineChart extends StatelessWidget {
  final List<AppModel> apps;
  final String period;

  const _MultiLineChart({
    required this.apps,
    required this.period,
  });

  int _getDataPoints() {
    switch (period) {
      case '7d':
        return 7;
      case '30d':
        return 30;
      case '90d':
        return 90;
      default:
        return 30;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dataPoints = _getDataPoints();

    // Generate mock ranking data for each app
    final mockData = <int, List<double>>{};
    for (final app in apps) {
      final random = Random(app.id + period.hashCode);
      final baseRank = 10 + random.nextInt(40);
      mockData[app.id] = List.generate(dataPoints, (i) {
        return baseRank + (random.nextDouble() * 20 - 10);
      });
    }

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: colors.bgBase.withAlpha(50),
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
      ),
      child: CustomPaint(
        size: const Size(double.infinity, 200),
        painter: _MultiLinePainter(
          data: mockData,
          apps: apps,
          colors: colors,
        ),
      ),
    );
  }
}

class _MultiLinePainter extends CustomPainter {
  final Map<int, List<double>> data;
  final List<AppModel> apps;
  final AppColorsExtension colors;

  _MultiLinePainter({
    required this.data,
    required this.apps,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final padding = const EdgeInsets.fromLTRB(40, 20, 20, 30);
    final chartWidth = size.width - padding.left - padding.right;
    final chartHeight = size.height - padding.top - padding.bottom;

    // Find min/max across all data
    double minValue = double.infinity;
    double maxValue = double.negativeInfinity;
    int maxPoints = 0;

    for (final values in data.values) {
      for (final value in values) {
        minValue = min(minValue, value);
        maxValue = max(maxValue, value);
      }
      maxPoints = max(maxPoints, values.length);
    }

    final range = maxValue - minValue;
    final effectiveRange = range == 0 ? 1.0 : range;

    // Draw grid lines
    final gridPaint = Paint()
      ..color = colors.glassBorder
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = padding.top + (chartHeight * i / 4);
      canvas.drawLine(
        Offset(padding.left, y),
        Offset(size.width - padding.right, y),
        gridPaint,
      );
    }

    // Draw lines for each app
    for (int appIndex = 0; appIndex < apps.length; appIndex++) {
      final app = apps[appIndex];
      final values = data[app.id] ?? [];
      if (values.isEmpty) continue;

      final lineColor = _getAppColor(appIndex);
      final linePaint = Paint()
        ..color = lineColor
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final path = Path();
      for (int i = 0; i < values.length; i++) {
        final x = padding.left + (i / (values.length - 1)) * chartWidth;
        // Invert Y because lower rank is better (should be higher on chart)
        final normalizedY = 1 - ((values[i] - minValue) / effectiveRange);
        final y = padding.top + normalizedY * chartHeight;

        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, linePaint);
    }

    // Draw Y-axis labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    for (int i = 0; i <= 4; i++) {
      final value = maxValue - (range * i / 4);
      textPainter.text = TextSpan(
        text: '#${value.round()}',
        style: TextStyle(
          fontSize: 10,
          color: colors.textMuted,
        ),
      );
      textPainter.layout();
      final y = padding.top + (chartHeight * i / 4) - textPainter.height / 2;
      textPainter.paint(canvas, Offset(4, y));
    }
  }

  @override
  bool shouldRepaint(covariant _MultiLinePainter oldDelegate) {
    return oldDelegate.data != data;
  }
}

class _ChartLegend extends StatelessWidget {
  final List<AppModel> apps;

  const _ChartLegend({required this.apps});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Wrap(
      spacing: 20,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: apps.asMap().entries.map((entry) {
        final index = entry.key;
        final app = entry.value;
        final lineColor = _getAppColor(index);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 3,
              decoration: BoxDecoration(
                color: lineColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              app.name,
              style: TextStyle(
                fontSize: 12,
                color: colors.textSecondary,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

// Helper function to get consistent colors for apps
Color _getAppColor(int index) {
  const chartColors = [
    Color(0xFF6366F1), // Indigo
    Color(0xFF10B981), // Emerald
    Color(0xFFF59E0B), // Amber
    Color(0xFFEF4444), // Red
  ];
  return chartColors[index % chartColors.length];
}
