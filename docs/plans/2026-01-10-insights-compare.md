# Insights Compare Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Allow users to compare insights across 2-4 apps side by side from the insights screen.

**Architecture:** Add a "Compare" button to AppInsightsScreen that opens a modal for selecting apps. Navigate to a new InsightsCompareScreen that displays columns for each app, auto-generating insights if needed.

**Tech Stack:** Flutter, Riverpod, go_router, existing InsightsRepository

---

## Task 1: Add Compare Button to AppInsightsScreen

**Files:**
- Modify: `app/lib/features/insights/presentation/app_insights_screen.dart:138-194`

**Step 1: Add compare button to toolbar**

In `_buildToolbar()`, add a compare button after the app name section. The button should be disabled if no insight exists yet.

```dart
Widget _buildToolbar() {
  return Container(
    height: 56,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
    ),
    child: Row(
      children: [
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppColors.radiusSmall),
          child: InkWell(
            onTap: () => context.pop(),
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
            hoverColor: AppColors.bgHover,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.arrow_back_rounded, size: 20, color: AppColors.textMuted),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.accent.withAlpha(30),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.insights_rounded, size: 18, color: AppColors.accent),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.appName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const Text(
                'Review Insights',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
        // Compare button
        Tooltip(
          message: _insight == null ? 'Generate insights first' : 'Compare with other apps',
          child: Material(
            color: _insight != null ? AppColors.bgActive : Colors.transparent,
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
            child: InkWell(
              onTap: _insight != null ? _openCompareModal : null,
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              hoverColor: AppColors.bgHover,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.compare_arrows_rounded,
                      size: 18,
                      color: _insight != null ? AppColors.textSecondary : AppColors.textMuted.withAlpha(100),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Compare',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _insight != null ? AppColors.textSecondary : AppColors.textMuted.withAlpha(100),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
```

**Step 2: Add _openCompareModal method**

Add this method to `_AppInsightsScreenState`:

```dart
void _openCompareModal() {
  showDialog(
    context: context,
    builder: (context) => CompareAppSelectorModal(
      currentAppId: widget.appId,
      currentAppName: widget.appName,
      onCompare: (selectedAppIds) {
        final allIds = [widget.appId, ...selectedAppIds];
        context.go('/apps/compare?ids=${allIds.join(',')}');
      },
    ),
  );
}
```

**Step 3: Add import**

Add at top of file:
```dart
import 'widgets/compare_app_selector_modal.dart';
```

**Step 4: Run to verify no compile errors**

Run: `cd app && flutter analyze lib/features/insights/presentation/app_insights_screen.dart`
Expected: No errors (modal doesn't exist yet, will fail - that's ok)

**Step 5: Commit**

```bash
git add app/lib/features/insights/presentation/app_insights_screen.dart
git commit -m "feat(insights): add compare button to toolbar"
```

---

## Task 2: Create CompareAppSelectorModal

**Files:**
- Create: `app/lib/features/insights/presentation/widgets/compare_app_selector_modal.dart`

**Step 1: Create the modal widget**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../apps/domain/app_model.dart';
import '../../../apps/providers/apps_provider.dart';

class CompareAppSelectorModal extends ConsumerStatefulWidget {
  final int currentAppId;
  final String currentAppName;
  final void Function(List<int> selectedAppIds) onCompare;

  const CompareAppSelectorModal({
    super.key,
    required this.currentAppId,
    required this.currentAppName,
    required this.onCompare,
  });

  @override
  ConsumerState<CompareAppSelectorModal> createState() => _CompareAppSelectorModalState();
}

class _CompareAppSelectorModalState extends ConsumerState<CompareAppSelectorModal> {
  final Set<int> _selectedIds = {};
  String _searchQuery = '';

  List<AppModel> _getFilteredApps(List<AppModel> apps) {
    return apps
        .where((app) => app.id != widget.currentAppId)
        .where((app) => _searchQuery.isEmpty ||
            app.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _toggleSelection(int appId) {
    setState(() {
      if (_selectedIds.contains(appId)) {
        _selectedIds.remove(appId);
      } else if (_selectedIds.length < 3) {
        _selectedIds.add(appId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appsAsync = ref.watch(appsNotifierProvider);

    return Dialog(
      backgroundColor: AppColors.glassPanel,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
        side: const BorderSide(color: AppColors.glassBorder),
      ),
      child: Container(
        width: 500,
        height: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(
              child: appsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (apps) => _buildAppsList(_getFilteredApps(apps)),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accent.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.compare_arrows_rounded, size: 20, color: AppColors.accent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Compare Insights',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Select up to 3 apps to compare with ${widget.currentAppName}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded, size: 20),
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgBase,
          border: Border.all(color: AppColors.glassBorder),
          borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        ),
        child: TextField(
          onChanged: (value) => setState(() => _searchQuery = value),
          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          decoration: const InputDecoration(
            hintText: 'Search apps...',
            hintStyle: TextStyle(color: AppColors.textMuted),
            prefixIcon: Icon(Icons.search_rounded, size: 18, color: AppColors.textMuted),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildAppsList(List<AppModel> apps) {
    if (apps.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: AppColors.textMuted.withAlpha(100)),
            const SizedBox(height: 12),
            Text(
              _searchQuery.isEmpty ? 'No other apps to compare' : 'No matching apps',
              style: const TextStyle(color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: apps.length,
      itemBuilder: (context, index) {
        final app = apps[index];
        final isSelected = _selectedIds.contains(app.id);
        final isDisabled = !isSelected && _selectedIds.length >= 3;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : () => _toggleSelection(app.id),
            hoverColor: AppColors.bgHover,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accentMuted : Colors.transparent,
              ),
              child: Row(
                children: [
                  // Checkbox
                  Checkbox(
                    value: isSelected,
                    onChanged: isDisabled ? null : (_) => _toggleSelection(app.id),
                    activeColor: AppColors.accent,
                    side: BorderSide(
                      color: isDisabled ? AppColors.textMuted.withAlpha(50) : AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // App icon
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.bgActive,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: app.iconUrl != null
                        ? Image.network(app.iconUrl!, fit: BoxFit.cover)
                        : Icon(
                            app.isIos ? Icons.apple : Icons.android,
                            size: 20,
                            color: AppColors.textMuted,
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
                            color: isDisabled
                                ? AppColors.textMuted.withAlpha(100)
                                : AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          app.isIos ? 'iOS' : 'Android',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDisabled
                                ? AppColors.textMuted.withAlpha(50)
                                : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Row(
        children: [
          Text(
            '${_selectedIds.length} of 3 apps selected',
            style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
          const Spacer(),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 12),
          FilledButton(
            onPressed: _selectedIds.isEmpty
                ? null
                : () {
                    Navigator.of(context).pop();
                    widget.onCompare(_selectedIds.toList());
                  },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accent,
              disabledBackgroundColor: AppColors.accentMuted,
            ),
            child: Text('Compare ${_selectedIds.length + 1} Apps'),
          ),
        ],
      ),
    );
  }
}
```

**Step 2: Run to verify no compile errors**

Run: `cd app && flutter analyze lib/features/insights/presentation/widgets/compare_app_selector_modal.dart`
Expected: PASS

**Step 3: Commit**

```bash
git add app/lib/features/insights/presentation/widgets/compare_app_selector_modal.dart
git commit -m "feat(insights): add compare app selector modal"
```

---

## Task 3: Add Compare Route

**Files:**
- Modify: `app/lib/core/router/app_router.dart:19` (add import)
- Modify: `app/lib/core/router/app_router.dart:103` (add route)

**Step 1: Add import**

After line 19, add:
```dart
import '../../features/insights/presentation/insights_compare_screen.dart';
```

**Step 2: Add route**

After line 102 (after the `:id/insights` route closing), add:
```dart
              GoRoute(
                path: 'compare',
                builder: (context, state) {
                  final idsParam = state.uri.queryParameters['ids'] ?? '';
                  final ids = idsParam.split(',').map((s) => int.tryParse(s)).whereType<int>().toList();
                  return InsightsCompareScreen(appIds: ids);
                },
              ),
```

**Step 3: Run to verify no compile errors**

Run: `cd app && flutter analyze lib/core/router/app_router.dart`
Expected: Error (InsightsCompareScreen doesn't exist yet - that's ok)

**Step 4: Commit**

```bash
git add app/lib/core/router/app_router.dart
git commit -m "feat(router): add insights compare route"
```

---

## Task 4: Create InsightsCompareScreen

**Files:**
- Create: `app/lib/features/insights/presentation/insights_compare_screen.dart`

**Step 1: Create the screen**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/api/api_client.dart';
import '../../../core/theme/app_colors.dart';
import '../data/insights_repository.dart';
import '../domain/insight_model.dart';

class InsightsCompareScreen extends ConsumerStatefulWidget {
  final List<int> appIds;

  const InsightsCompareScreen({super.key, required this.appIds});

  @override
  ConsumerState<InsightsCompareScreen> createState() => _InsightsCompareScreenState();
}

class _CompareColumn {
  final int appId;
  String appName;
  String? iconUrl;
  String platform;
  AppInsight? insight;
  bool isLoading;
  String? error;

  _CompareColumn({
    required this.appId,
    this.appName = '',
    this.iconUrl,
    this.platform = '',
    this.insight,
    this.isLoading = true,
    this.error,
  });
}

class _InsightsCompareScreenState extends ConsumerState<InsightsCompareScreen> {
  late List<_CompareColumn> _columns;

  @override
  void initState() {
    super.initState();
    _columns = widget.appIds.map((id) => _CompareColumn(appId: id)).toList();
    _loadComparisons();
  }

  Future<void> _loadComparisons() async {
    final repository = ref.read(insightsRepositoryProvider);

    try {
      final comparisons = await repository.compareApps(widget.appIds);

      for (final comparison in comparisons) {
        final index = _columns.indexWhere((c) => c.appId == comparison.appId);
        if (index != -1) {
          setState(() {
            _columns[index].appName = comparison.appName;
            _columns[index].iconUrl = comparison.iconUrl;
            _columns[index].platform = comparison.platform;
            _columns[index].insight = comparison.insight;
            _columns[index].isLoading = comparison.insight == null;
          });

          // Auto-generate if no insight
          if (comparison.insight == null) {
            _generateInsight(index);
          }
        }
      }
    } on ApiException catch (e) {
      for (var i = 0; i < _columns.length; i++) {
        setState(() {
          _columns[i].isLoading = false;
          _columns[i].error = e.message;
        });
      }
    }
  }

  Future<void> _generateInsight(int index) async {
    final repository = ref.read(insightsRepositoryProvider);
    final column = _columns[index];

    try {
      final insight = await repository.generateInsights(
        appId: column.appId,
        countries: ['US'],
        periodMonths: 6,
      );

      if (mounted) {
        setState(() {
          _columns[index].insight = insight;
          _columns[index].isLoading = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _columns[index].isLoading = false;
          _columns[index].error = e.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassPanel,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
      ),
      child: Column(
        children: [
          _buildToolbar(),
          _buildStickyHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _columns.map((column) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: _buildColumn(column),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
            child: InkWell(
              onTap: () => context.pop(),
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              hoverColor: AppColors.bgHover,
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.arrow_back_rounded, size: 20, color: AppColors.textMuted),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.accent.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.compare_arrows_rounded, size: 18, color: AppColors.accent),
          ),
          const SizedBox(width: 12),
          const Text(
            'Compare Insights',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bgActive.withAlpha(50),
        border: const Border(bottom: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Row(
        children: _columns.map((column) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.bgActive,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: column.iconUrl != null
                        ? Image.network(column.iconUrl!, fit: BoxFit.cover)
                        : Icon(
                            column.platform == 'ios' ? Icons.apple : Icons.android,
                            size: 18,
                            color: AppColors.textMuted,
                          ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      column.appName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildColumn(_CompareColumn column) {
    if (column.isLoading) {
      return _buildLoadingColumn();
    }

    if (column.error != null) {
      return _buildErrorColumn(column);
    }

    if (column.insight == null) {
      return _buildNoInsightColumn();
    }

    return _buildInsightColumn(column.insight!);
  }

  Widget _buildLoadingColumn() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgActive.withAlpha(30),
        border: Border.all(color: AppColors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: const Column(
        children: [
          SizedBox(height: 40),
          CircularProgressIndicator(strokeWidth: 2),
          SizedBox(height: 16),
          Text(
            'Analyzing reviews...',
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildErrorColumn(_CompareColumn column) {
    final index = _columns.indexOf(column);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.redMuted.withAlpha(30),
        border: Border.all(color: AppColors.red.withAlpha(50)),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Icon(Icons.error_outline_rounded, size: 32, color: AppColors.red),
          const SizedBox(height: 12),
          Text(
            column.error!,
            style: const TextStyle(color: AppColors.red, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              setState(() {
                _columns[index].isLoading = true;
                _columns[index].error = null;
              });
              _generateInsight(index);
            },
            child: const Text('Retry'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildNoInsightColumn() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgActive.withAlpha(30),
        border: Border.all(color: AppColors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: const Column(
        children: [
          SizedBox(height: 40),
          Icon(Icons.analytics_outlined, size: 32, color: AppColors.textMuted),
          SizedBox(height: 12),
          Text(
            'No insights available',
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildInsightColumn(AppInsight insight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Strengths
        _buildSectionCard(
          title: 'Strengths',
          icon: Icons.thumb_up_rounded,
          iconColor: AppColors.green,
          bgColor: AppColors.greenMuted,
          items: insight.overallStrengths,
        ),
        const SizedBox(height: 12),
        // Weaknesses
        _buildSectionCard(
          title: 'Weaknesses',
          icon: Icons.thumb_down_rounded,
          iconColor: AppColors.red,
          bgColor: AppColors.redMuted,
          items: insight.overallWeaknesses,
        ),
        const SizedBox(height: 12),
        // Category Scores
        _buildCategoryScores(insight),
        const SizedBox(height: 12),
        // Opportunities
        if (insight.opportunities.isNotEmpty)
          _buildSectionCard(
            title: 'Opportunities',
            icon: Icons.lightbulb_rounded,
            iconColor: AppColors.yellow,
            bgColor: AppColors.yellow.withAlpha(30),
            items: insight.opportunities,
          ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required List<String> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor.withAlpha(30),
        border: Border.all(color: bgColor),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('•', style: TextStyle(color: iconColor, fontSize: 12)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCategoryScores(AppInsight insight) {
    final categoryLabels = {
      'ux': 'UX',
      'performance': 'Perf',
      'features': 'Features',
      'pricing': 'Pricing',
      'support': 'Support',
      'onboarding': 'Onboard',
    };

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgActive.withAlpha(50),
        border: Border.all(color: AppColors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Scores',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: insight.categoryScores.entries.map((entry) {
              final score = entry.value.score;
              final color = score >= 4
                  ? AppColors.green
                  : score >= 3
                      ? AppColors.yellow
                      : AppColors.red;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withAlpha(20),
                  border: Border.all(color: color.withAlpha(50)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      categoryLabels[entry.key] ?? entry.key,
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        score.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
```

**Step 2: Run to verify it compiles**

Run: `cd app && flutter analyze lib/features/insights/presentation/insights_compare_screen.dart`
Expected: PASS

**Step 3: Commit**

```bash
git add app/lib/features/insights/presentation/insights_compare_screen.dart
git commit -m "feat(insights): add compare screen with side-by-side columns"
```

---

## Task 5: Test the Full Flow

**Step 1: Run the app**

Run: `cd app && flutter run -d chrome`

**Step 2: Manual test**

1. Navigate to an app's insights screen
2. Generate insights if not already done
3. Click "Compare" button
4. Select 1-3 other apps
5. Click "Compare X Apps"
6. Verify the compare screen shows all apps in columns
7. Verify auto-generation works for apps without insights

**Step 3: Final commit**

```bash
git add -A
git commit -m "feat(insights): complete compare feature implementation"
```

---

## Summary

**Files created:**
- `app/lib/features/insights/presentation/widgets/compare_app_selector_modal.dart`
- `app/lib/features/insights/presentation/insights_compare_screen.dart`

**Files modified:**
- `app/lib/features/insights/presentation/app_insights_screen.dart`
- `app/lib/core/router/app_router.dart`

**Total: 5 tasks, ~400 lines of new code**
