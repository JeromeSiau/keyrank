# Competitor Keyword Spy Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Allow users to see competitor keywords, compare rankings, and track keyword gaps.

**Architecture:** New CompetitorDetailScreen accessed from competitor list. Backend endpoint returns competitor keywords with comparison data. Flutter uses Freezed models and Riverpod for state.

**Tech Stack:** Flutter/Riverpod, Laravel, Freezed models

---

## Task 1: Backend - Add Competitor Keywords Endpoint

**Files:**
- Modify: `api/routes/api.php`
- Modify: `api/app/Http/Controllers/Api/CompetitorController.php`

**Step 1: Add route**

In `api/routes/api.php`, add inside the `competitors` prefix (around line 183):

```php
Route::get('{competitorId}/keywords', [CompetitorController::class, 'keywords']);
```

**Step 2: Add controller method**

In `CompetitorController.php`, add method:

```php
/**
 * Get keywords for a competitor with comparison to user's app.
 */
public function keywords(Request $request, int $competitorId): JsonResponse
{
    $request->validate([
        'app_id' => 'required|integer|exists:apps,id',
        'country' => 'sometimes|string|size:2',
    ]);

    $user = $request->user();
    $userAppId = $request->query('app_id');
    $country = strtoupper($request->query('country', 'US'));

    // Verify user owns the app
    $userApp = App::ownedBy($user->id)->find($userAppId);
    if (!$userApp) {
        return response()->json(['error' => 'App not found'], 404);
    }

    // Get competitor app
    $competitorApp = App::find($competitorId);
    if (!$competitorApp) {
        return response()->json(['error' => 'Competitor not found'], 404);
    }

    // Get competitor's tracked keywords (from rankings table)
    $competitorKeywords = \DB::table('rankings')
        ->join('keywords', 'rankings.keyword_id', '=', 'keywords.id')
        ->where('rankings.app_id', $competitorId)
        ->where('keywords.storefront', $country)
        ->where('rankings.position', '<=', 100)
        ->select([
            'keywords.id as keyword_id',
            'keywords.keyword',
            'keywords.popularity',
            'rankings.position as competitor_position',
        ])
        ->orderBy('rankings.position')
        ->get();

    // Get user's rankings for same keywords
    $userKeywordIds = $competitorKeywords->pluck('keyword_id')->toArray();
    $userRankings = \DB::table('rankings')
        ->where('app_id', $userAppId)
        ->whereIn('keyword_id', $userKeywordIds)
        ->pluck('position', 'keyword_id');

    // Check which keywords user is tracking
    $trackedKeywords = \DB::table('tracked_keywords')
        ->where('app_id', $userAppId)
        ->whereIn('keyword_id', $userKeywordIds)
        ->pluck('keyword_id')
        ->toArray();

    // Build comparison data
    $keywords = $competitorKeywords->map(function ($kw) use ($userRankings, $trackedKeywords) {
        $yourPosition = $userRankings[$kw->keyword_id] ?? null;
        $competitorPosition = $kw->competitor_position;

        $gap = null;
        if ($yourPosition !== null && $competitorPosition !== null) {
            $gap = $competitorPosition - $yourPosition; // positive = you win
        }

        return [
            'keyword_id' => $kw->keyword_id,
            'keyword' => $kw->keyword,
            'your_position' => $yourPosition,
            'competitor_position' => $competitorPosition,
            'gap' => $gap,
            'popularity' => $kw->popularity,
            'is_tracking' => in_array($kw->keyword_id, $trackedKeywords),
        ];
    });

    // Calculate summary
    $youWin = $keywords->filter(fn($k) => $k['gap'] !== null && $k['gap'] > 0)->count();
    $theyWin = $keywords->filter(fn($k) => $k['gap'] !== null && $k['gap'] < 0)->count();
    $gaps = $keywords->filter(fn($k) => $k['your_position'] === null)->count();
    $tied = $keywords->filter(fn($k) => $k['gap'] === 0)->count();

    return response()->json([
        'competitor' => [
            'id' => $competitorApp->id,
            'name' => $competitorApp->name,
            'icon_url' => $competitorApp->icon_url,
        ],
        'summary' => [
            'total_keywords' => $keywords->count(),
            'you_win' => $youWin,
            'they_win' => $theyWin,
            'tied' => $tied,
            'gaps' => $gaps,
        ],
        'keywords' => $keywords->values(),
    ]);
}
```

**Step 3: Test endpoint manually**

```bash
cd api && php artisan serve
# Test: curl "http://localhost:8000/api/competitors/123/keywords?app_id=1&country=US" -H "Authorization: Bearer {token}"
```

**Step 4: Commit**

```bash
git add api/routes/api.php api/app/Http/Controllers/Api/CompetitorController.php
git commit -m "$(cat <<'EOF'
feat(api): add competitor keywords endpoint

GET /competitors/{id}/keywords returns competitor keywords with
comparison to user's app, including gap analysis and tracking status.
EOF
)"
```

---

## Task 2: Flutter - Create Competitor Keywords Model

**Files:**
- Create: `app/lib/features/competitors/domain/competitor_keywords_model.dart`

**Step 1: Create model file**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'competitor_keywords_model.freezed.dart';
part 'competitor_keywords_model.g.dart';

@freezed
class CompetitorKeywordsResponse with _$CompetitorKeywordsResponse {
  const factory CompetitorKeywordsResponse({
    required CompetitorInfo competitor,
    required KeywordComparisonSummary summary,
    required List<KeywordComparison> keywords,
  }) = _CompetitorKeywordsResponse;

  factory CompetitorKeywordsResponse.fromJson(Map<String, dynamic> json) =>
      _$CompetitorKeywordsResponseFromJson(json);
}

@freezed
class CompetitorInfo with _$CompetitorInfo {
  const factory CompetitorInfo({
    required int id,
    required String name,
    @JsonKey(name: 'icon_url') String? iconUrl,
  }) = _CompetitorInfo;

  factory CompetitorInfo.fromJson(Map<String, dynamic> json) =>
      _$CompetitorInfoFromJson(json);
}

@freezed
class KeywordComparisonSummary with _$KeywordComparisonSummary {
  const factory KeywordComparisonSummary({
    @JsonKey(name: 'total_keywords') required int totalKeywords,
    @JsonKey(name: 'you_win') required int youWin,
    @JsonKey(name: 'they_win') required int theyWin,
    required int tied,
    required int gaps,
  }) = _KeywordComparisonSummary;

  factory KeywordComparisonSummary.fromJson(Map<String, dynamic> json) =>
      _$KeywordComparisonSummaryFromJson(json);
}

@freezed
class KeywordComparison with _$KeywordComparison {
  const factory KeywordComparison({
    @JsonKey(name: 'keyword_id') required int keywordId,
    required String keyword,
    @JsonKey(name: 'your_position') int? yourPosition,
    @JsonKey(name: 'competitor_position') required int competitorPosition,
    int? gap,
    int? popularity,
    @JsonKey(name: 'is_tracking') required bool isTracking,
  }) = _KeywordComparison;

  factory KeywordComparison.fromJson(Map<String, dynamic> json) =>
      _$KeywordComparisonFromJson(json);
}

extension KeywordComparisonX on KeywordComparison {
  bool get isGap => yourPosition == null;
  bool get youWin => gap != null && gap! > 0;
  bool get theyWin => gap != null && gap! < 0;
  bool get isTied => gap == 0;
}
```

**Step 2: Run code generation**

```bash
cd app && dart run build_runner build --delete-conflicting-outputs
```

**Step 3: Verify generated files exist**

```bash
ls app/lib/features/competitors/domain/competitor_keywords_model.*.dart
```

**Step 4: Commit**

```bash
git add app/lib/features/competitors/domain/
git commit -m "$(cat <<'EOF'
feat(flutter): add competitor keywords comparison models

Freezed models for competitor keyword spy feature including
comparison summary and individual keyword comparisons.
EOF
)"
```

---

## Task 3: Flutter - Add Repository Method

**Files:**
- Modify: `app/lib/features/competitors/data/competitors_repository.dart`

**Step 1: Add import and method**

Add import at top:
```dart
import '../domain/competitor_keywords_model.dart';
```

Add method to `CompetitorsRepository` class:

```dart
/// Get competitor keywords with comparison to user's app.
Future<CompetitorKeywordsResponse> getCompetitorKeywords({
  required int competitorId,
  required int appId,
  String country = 'US',
}) async {
  final response = await _dio.get(
    '/competitors/$competitorId/keywords',
    queryParameters: {
      'app_id': appId,
      'country': country,
    },
  );
  return CompetitorKeywordsResponse.fromJson(response.data as Map<String, dynamic>);
}
```

**Step 2: Commit**

```bash
git add app/lib/features/competitors/data/competitors_repository.dart
git commit -m "feat(flutter): add getCompetitorKeywords repository method"
```

---

## Task 4: Flutter - Add Provider

**Files:**
- Modify: `app/lib/features/competitors/providers/competitors_provider.dart`

**Step 1: Add imports**

```dart
import '../domain/competitor_keywords_model.dart';
```

**Step 2: Add filter enum and providers at end of file**

```dart
/// Filter for competitor keywords comparison
enum CompetitorKeywordFilter { all, gaps, youWin, theyWin }

/// Provider for selected competitor keyword filter
final competitorKeywordFilterProvider = StateProvider<CompetitorKeywordFilter>(
  (ref) => CompetitorKeywordFilter.gaps,
);

/// Family provider for competitor keywords
final competitorKeywordsProvider = FutureProvider.family<CompetitorKeywordsResponse, ({int competitorId, int appId, String country})>(
  (ref, params) async {
    final repository = ref.watch(competitorsRepositoryProvider);
    return repository.getCompetitorKeywords(
      competitorId: params.competitorId,
      appId: params.appId,
      country: params.country,
    );
  },
);

/// Filtered competitor keywords based on selected filter
final filteredCompetitorKeywordsProvider = Provider.family<List<KeywordComparison>, List<KeywordComparison>>(
  (ref, keywords) {
    final filter = ref.watch(competitorKeywordFilterProvider);
    switch (filter) {
      case CompetitorKeywordFilter.all:
        return keywords;
      case CompetitorKeywordFilter.gaps:
        return keywords.where((k) => k.isGap).toList();
      case CompetitorKeywordFilter.youWin:
        return keywords.where((k) => k.youWin).toList();
      case CompetitorKeywordFilter.theyWin:
        return keywords.where((k) => k.theyWin).toList();
    }
  },
);
```

**Step 3: Commit**

```bash
git add app/lib/features/competitors/providers/competitors_provider.dart
git commit -m "feat(flutter): add competitor keywords providers"
```

---

## Task 5: Flutter - Create Competitor Detail Screen

**Files:**
- Create: `app/lib/features/competitors/presentation/competitor_detail_screen.dart`

**Step 1: Create screen file**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/country_provider.dart';
import '../../../core/providers/selected_app_provider.dart';
import '../../../core/utils/l10n_extension.dart';
import '../domain/competitor_model.dart';
import '../domain/competitor_keywords_model.dart';
import '../providers/competitors_provider.dart';
import '../../keywords/data/keywords_repository.dart';
import 'widgets/competitor_keywords_tab.dart';

class CompetitorDetailScreen extends ConsumerWidget {
  final int competitorId;

  const CompetitorDetailScreen({super.key, required this.competitorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final selectedApp = ref.watch(selectedAppProvider);
    final country = ref.watch(selectedCountryProvider);

    if (selectedApp == null) {
      return _buildNoAppSelected(colors);
    }

    final keywordsAsync = ref.watch(
      competitorKeywordsProvider((
        competitorId: competitorId,
        appId: selectedApp.id,
        country: country.code,
      )),
    );

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanel,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
      ),
      child: Column(
        children: [
          // Toolbar
          _Toolbar(
            competitorId: competitorId,
            onBack: () => context.go('/competitors'),
            onRefresh: () => ref.invalidate(
              competitorKeywordsProvider((
                competitorId: competitorId,
                appId: selectedApp.id,
                country: country.code,
              )),
            ),
          ),
          // Content
          Expanded(
            child: keywordsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (e, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading keywords',
                      style: AppTypography.bodyMedium.copyWith(color: colors.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      e.toString(),
                      style: AppTypography.caption.copyWith(color: colors.textMuted),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              data: (data) => CompetitorKeywordsTab(
                response: data,
                userAppId: selectedApp.id,
                country: country.code,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoAppSelected(AppColorsExtension colors) {
    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanel,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.app_shortcut, size: 48, color: colors.textMuted),
            const SizedBox(height: 16),
            Text(
              'Select an app first',
              style: AppTypography.bodyMedium.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'Use the app switcher in the sidebar to select your app',
              style: AppTypography.caption.copyWith(color: colors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _Toolbar extends ConsumerWidget {
  final int competitorId;
  final VoidCallback onBack;
  final VoidCallback onRefresh;

  const _Toolbar({
    required this.competitorId,
    required this.onBack,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final selectedApp = ref.watch(selectedAppProvider);
    final country = ref.watch(selectedCountryProvider);

    String title = 'Competitor Keywords';
    String? iconUrl;

    if (selectedApp != null) {
      final keywordsAsync = ref.watch(
        competitorKeywordsProvider((
          competitorId: competitorId,
          appId: selectedApp.id,
          country: country.code,
        )),
      );
      keywordsAsync.whenData((data) {
        title = data.competitor.name;
        iconUrl = data.competitor.iconUrl;
      });
    }

    return Container(
      height: AppSpacing.toolbarHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder)),
      ),
      child: Row(
        children: [
          // Back button
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
            child: InkWell(
              onTap: onBack,
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              hoverColor: colors.bgHover,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(Icons.arrow_back_rounded, size: 20, color: colors.textMuted),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Competitor icon
          if (iconUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                iconUrl!,
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: colors.bgActive,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.apps, size: 18, color: colors.textMuted),
                ),
              ),
            )
          else
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: colors.accent.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.person, size: 18, color: colors.accent),
            ),
          const SizedBox(width: AppSpacing.sm),
          // Title
          Expanded(
            child: Text(
              title,
              style: AppTypography.headline.copyWith(color: colors.textPrimary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
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
                child: Icon(Icons.refresh_rounded, size: 20, color: colors.textMuted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

**Step 2: Commit**

```bash
git add app/lib/features/competitors/presentation/competitor_detail_screen.dart
git commit -m "feat(flutter): add CompetitorDetailScreen shell"
```

---

## Task 6: Flutter - Create Keywords Tab Widget

**Files:**
- Create: `app/lib/features/competitors/presentation/widgets/competitor_keywords_tab.dart`

**Step 1: Create widget file**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../domain/competitor_keywords_model.dart';
import '../../providers/competitors_provider.dart';
import '../../../keywords/data/keywords_repository.dart';
import '../../../keywords/providers/keywords_provider.dart';

class CompetitorKeywordsTab extends ConsumerStatefulWidget {
  final CompetitorKeywordsResponse response;
  final int userAppId;
  final String country;

  const CompetitorKeywordsTab({
    super.key,
    required this.response,
    required this.userAppId,
    required this.country,
  });

  @override
  ConsumerState<CompetitorKeywordsTab> createState() => _CompetitorKeywordsTabState();
}

class _CompetitorKeywordsTabState extends ConsumerState<CompetitorKeywordsTab> {
  final Set<int> _selectedKeywordIds = {};
  bool _isSelectionMode = false;
  bool _isTracking = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final filter = ref.watch(competitorKeywordFilterProvider);
    final filteredKeywords = ref.watch(
      filteredCompetitorKeywordsProvider(widget.response.keywords),
    );

    return Column(
      children: [
        // Summary card
        _SummaryCard(summary: widget.response.summary),
        // Filters
        _FilterBar(
          filter: filter,
          onFilterChanged: (f) =>
              ref.read(competitorKeywordFilterProvider.notifier).state = f,
          isSelectionMode: _isSelectionMode,
          selectedCount: _selectedKeywordIds.length,
          onToggleSelection: () {
            setState(() {
              _isSelectionMode = !_isSelectionMode;
              if (!_isSelectionMode) _selectedKeywordIds.clear();
            });
          },
          onTrackSelected: _trackSelectedKeywords,
          isTracking: _isTracking,
        ),
        // Keywords list
        Expanded(
          child: filteredKeywords.isEmpty
              ? _buildEmptyState(colors, filter)
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  itemCount: filteredKeywords.length,
                  itemBuilder: (context, index) {
                    final keyword = filteredKeywords[index];
                    return _KeywordComparisonRow(
                      keyword: keyword,
                      isSelected: _selectedKeywordIds.contains(keyword.keywordId),
                      isSelectionMode: _isSelectionMode,
                      onToggleSelect: () {
                        setState(() {
                          if (_selectedKeywordIds.contains(keyword.keywordId)) {
                            _selectedKeywordIds.remove(keyword.keywordId);
                          } else {
                            _selectedKeywordIds.add(keyword.keywordId);
                          }
                        });
                      },
                      onTrack: () => _trackKeyword(keyword),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(AppColorsExtension colors, CompetitorKeywordFilter filter) {
    final message = switch (filter) {
      CompetitorKeywordFilter.gaps => 'No keyword gaps found',
      CompetitorKeywordFilter.youWin => 'No keywords where you rank higher',
      CompetitorKeywordFilter.theyWin => 'No keywords where they rank higher',
      CompetitorKeywordFilter.all => 'No keywords found',
    };

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 48, color: colors.green),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTypography.bodyMedium.copyWith(color: colors.textPrimary),
          ),
        ],
      ),
    );
  }

  Future<void> _trackKeyword(KeywordComparison keyword) async {
    final colors = context.colors;
    try {
      final repository = ref.read(keywordsRepositoryProvider);
      await repository.addKeywordToApp(
        widget.userAppId,
        keyword.keyword,
        storefront: widget.country,
      );
      ref.invalidate(keywordsForAppProvider(widget.userAppId));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Now tracking "${keyword.keyword}"'),
            backgroundColor: colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to track keyword: $e'),
            backgroundColor: colors.red,
          ),
        );
      }
    }
  }

  Future<void> _trackSelectedKeywords() async {
    if (_selectedKeywordIds.isEmpty) return;

    setState(() => _isTracking = true);
    final colors = context.colors;
    final repository = ref.read(keywordsRepositoryProvider);

    int tracked = 0;
    int failed = 0;

    for (final keywordId in _selectedKeywordIds) {
      final keyword = widget.response.keywords.firstWhere(
        (k) => k.keywordId == keywordId,
      );
      if (keyword.isTracking) continue;

      try {
        await repository.addKeywordToApp(
          widget.userAppId,
          keyword.keyword,
          storefront: widget.country,
        );
        tracked++;
      } catch (e) {
        failed++;
      }
    }

    ref.invalidate(keywordsForAppProvider(widget.userAppId));

    setState(() {
      _isTracking = false;
      _selectedKeywordIds.clear();
      _isSelectionMode = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            failed > 0
                ? 'Tracked $tracked keywords, $failed failed'
                : 'Now tracking $tracked keywords',
          ),
          backgroundColor: failed > 0 ? colors.yellow : colors.green,
        ),
      );
    }
  }
}

class _SummaryCard extends StatelessWidget {
  final KeywordComparisonSummary summary;

  const _SummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.all(AppSpacing.screenPadding),
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryItem(
              label: 'Total',
              value: summary.totalKeywords.toString(),
              color: colors.textPrimary,
            ),
          ),
          _divider(colors),
          Expanded(
            child: _SummaryItem(
              label: 'You Win',
              value: summary.youWin.toString(),
              color: colors.green,
              icon: Icons.arrow_upward,
            ),
          ),
          _divider(colors),
          Expanded(
            child: _SummaryItem(
              label: 'They Win',
              value: summary.theyWin.toString(),
              color: colors.red,
              icon: Icons.arrow_downward,
            ),
          ),
          _divider(colors),
          Expanded(
            child: _SummaryItem(
              label: 'Gaps',
              value: summary.gaps.toString(),
              color: colors.yellow,
              icon: Icons.warning_amber,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(AppColorsExtension colors) {
    return Container(
      width: 1,
      height: 40,
      color: colors.glassBorder,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData? icon;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
            ],
            Text(
              value,
              style: AppTypography.headline.copyWith(color: color),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.caption.copyWith(color: colors.textMuted),
        ),
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  final CompetitorKeywordFilter filter;
  final ValueChanged<CompetitorKeywordFilter> onFilterChanged;
  final bool isSelectionMode;
  final int selectedCount;
  final VoidCallback onToggleSelection;
  final VoidCallback onTrackSelected;
  final bool isTracking;

  const _FilterBar({
    required this.filter,
    required this.onFilterChanged,
    required this.isSelectionMode,
    required this.selectedCount,
    required this.onToggleSelection,
    required this.onTrackSelected,
    required this.isTracking,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder)),
      ),
      child: Row(
        children: [
          // Filters
          _FilterChip(
            label: 'Gaps',
            isSelected: filter == CompetitorKeywordFilter.gaps,
            onTap: () => onFilterChanged(CompetitorKeywordFilter.gaps),
            color: colors.yellow,
          ),
          const SizedBox(width: AppSpacing.sm),
          _FilterChip(
            label: 'They Win',
            isSelected: filter == CompetitorKeywordFilter.theyWin,
            onTap: () => onFilterChanged(CompetitorKeywordFilter.theyWin),
            color: colors.red,
          ),
          const SizedBox(width: AppSpacing.sm),
          _FilterChip(
            label: 'You Win',
            isSelected: filter == CompetitorKeywordFilter.youWin,
            onTap: () => onFilterChanged(CompetitorKeywordFilter.youWin),
            color: colors.green,
          ),
          const SizedBox(width: AppSpacing.sm),
          _FilterChip(
            label: 'All',
            isSelected: filter == CompetitorKeywordFilter.all,
            onTap: () => onFilterChanged(CompetitorKeywordFilter.all),
          ),
          const Spacer(),
          // Selection mode toggle
          if (isSelectionMode && selectedCount > 0) ...[
            Material(
              color: colors.accent,
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              child: InkWell(
                onTap: isTracking ? null : onTrackSelected,
                borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.cardPadding,
                    vertical: AppSpacing.sm,
                  ),
                  child: isTracking
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Track $selectedCount',
                          style: AppTypography.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onToggleSelection,
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.cardPadding,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isSelectionMode ? colors.accent.withAlpha(20) : null,
                  border: Border.all(
                    color: isSelectionMode ? colors.accent : colors.glassBorder,
                  ),
                  borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelectionMode ? Icons.close : Icons.checklist,
                      size: 16,
                      color: isSelectionMode ? colors.accent : colors.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isSelectionMode ? 'Cancel' : 'Select',
                      style: AppTypography.caption.copyWith(
                        color: isSelectionMode ? colors.accent : colors.textSecondary,
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final chipColor = color ?? colors.accent;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm + 4,
            vertical: AppSpacing.xs + 2,
          ),
          decoration: BoxDecoration(
            color: isSelected ? chipColor : Colors.transparent,
            border: Border.all(
              color: isSelected ? chipColor : colors.glassBorder,
            ),
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
          ),
          child: Text(
            label,
            style: AppTypography.caption.copyWith(
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _KeywordComparisonRow extends StatelessWidget {
  final KeywordComparison keyword;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onToggleSelect;
  final VoidCallback onTrack;

  const _KeywordComparisonRow({
    required this.keyword,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onToggleSelect,
    required this.onTrack,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: isSelected ? colors.accent.withAlpha(15) : colors.bgActive.withAlpha(50),
        border: Border.all(
          color: isSelected ? colors.accent : colors.glassBorder,
        ),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isSelectionMode ? onToggleSelect : null,
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Row(
              children: [
                // Checkbox (selection mode)
                if (isSelectionMode) ...[
                  Checkbox(
                    value: isSelected,
                    onChanged: (_) => onToggleSelect(),
                    activeColor: colors.accent,
                    side: BorderSide(color: colors.glassBorder),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                // Keyword name
                Expanded(
                  flex: 3,
                  child: Text(
                    keyword.keyword,
                    style: AppTypography.bodyMedium.copyWith(
                      color: colors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Your position
                SizedBox(
                  width: 60,
                  child: _PositionCell(
                    position: keyword.yourPosition,
                    label: 'You',
                    colors: colors,
                  ),
                ),
                // Competitor position
                SizedBox(
                  width: 60,
                  child: _PositionCell(
                    position: keyword.competitorPosition,
                    label: 'Them',
                    colors: colors,
                  ),
                ),
                // Gap indicator
                SizedBox(
                  width: 70,
                  child: _GapIndicator(keyword: keyword, colors: colors),
                ),
                // Popularity
                SizedBox(
                  width: 50,
                  child: Column(
                    children: [
                      Text(
                        keyword.popularity?.toString() ?? '-',
                        style: AppTypography.bodyMedium.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                      Text(
                        'Pop',
                        style: AppTypography.caption.copyWith(
                          color: colors.textMuted,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                // Track button or status
                SizedBox(
                  width: 90,
                  child: keyword.isTracking
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: colors.green.withAlpha(20),
                            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check, size: 14, color: colors.green),
                              const SizedBox(width: 4),
                              Text(
                                'Tracking',
                                style: AppTypography.caption.copyWith(
                                  color: colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Material(
                          color: colors.accent,
                          borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                          child: InkWell(
                            onTap: onTrack,
                            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xs,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.add, size: 14, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Track',
                                    style: AppTypography.caption.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
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
          ),
        ),
      ),
    );
  }
}

class _PositionCell extends StatelessWidget {
  final int? position;
  final String label;
  final AppColorsExtension colors;

  const _PositionCell({
    required this.position,
    required this.label,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          position != null ? '#$position' : '-',
          style: AppTypography.bodyMedium.copyWith(
            color: position != null ? colors.textPrimary : colors.textMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: colors.textMuted,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _GapIndicator extends StatelessWidget {
  final KeywordComparison keyword;
  final AppColorsExtension colors;

  const _GapIndicator({
    required this.keyword,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    if (keyword.isGap) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: colors.yellow.withAlpha(20),
          borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        ),
        child: Text(
          'GAP',
          style: AppTypography.caption.copyWith(
            color: colors.yellow,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    final gap = keyword.gap ?? 0;
    final isPositive = gap > 0;
    final color = isPositive ? colors.green : colors.red;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isPositive ? Icons.arrow_upward : Icons.arrow_downward,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 2),
        Text(
          '${gap.abs()}',
          style: AppTypography.bodyMedium.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
```

**Step 2: Commit**

```bash
git add app/lib/features/competitors/presentation/widgets/
git commit -m "$(cat <<'EOF'
feat(flutter): add CompetitorKeywordsTab widget

Complete keywords comparison UI with:
- Summary card (total, you win, they win, gaps)
- Filter bar with selection mode
- Keyword comparison rows with track actions
- Bulk track selected keywords
EOF
)"
```

---

## Task 7: Flutter - Add Route

**Files:**
- Modify: `app/lib/core/router/app_router.dart`

**Step 1: Add import**

```dart
import '../../features/competitors/presentation/competitor_detail_screen.dart';
```

**Step 2: Add route inside `/competitors` routes (around line 254)**

Find this block:
```dart
GoRoute(
  path: '/competitors',
  builder: (context, state) => const CompetitorsScreen(),
  routes: [
    GoRoute(
      path: 'add',
      builder: (context, state) => const AddCompetitorScreen(),
    ),
  ],
),
```

Change to:
```dart
GoRoute(
  path: '/competitors',
  builder: (context, state) => const CompetitorsScreen(),
  routes: [
    GoRoute(
      path: 'add',
      builder: (context, state) => const AddCompetitorScreen(),
    ),
    GoRoute(
      path: ':id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return CompetitorDetailScreen(competitorId: id);
      },
    ),
  ],
),
```

**Step 3: Commit**

```bash
git add app/lib/core/router/app_router.dart
git commit -m "feat(flutter): add competitor detail route"
```

---

## Task 8: Flutter - Add Navigation from Competitor List

**Files:**
- Modify: `app/lib/features/keywords/presentation/competitors_screen.dart`

**Step 1: Update _CompetitorTile onTap**

Find the `_CompetitorTile` usage in `ListView.builder` (around line 63-68):

```dart
return _CompetitorTile(
  competitor: competitors[index],
  onView: () => context.push(
    '/apps/preview/${competitors[index].platform}/${competitors[index].storeId}',
  ),
  onRemove: () => _removeCompetitor(context, ref, competitors[index]),
);
```

Change to:
```dart
return _CompetitorTile(
  competitor: competitors[index],
  onView: () => context.push('/competitors/${competitors[index].id}'),
  onRemove: () => _removeCompetitor(context, ref, competitors[index]),
);
```

**Step 2: Update _CompetitorTile view button tooltip**

In `_ActionButton` for view (around line 595-600), change the tooltip from `'View App'` to `'View Keywords'`.

**Step 3: Commit**

```bash
git add app/lib/features/keywords/presentation/competitors_screen.dart
git commit -m "feat(flutter): navigate to competitor detail from list"
```

---

## Task 9: Update Tracker

**Files:**
- Modify: `docs/plans/implementation-tracker.md`

**Step 1: Update tracker**

Update the Quick Stats and the 5.4 row:

In Phase 2 table, change 5.4 row:
```markdown
| 5.4 | Competitor Keyword Spy | ✅ Done | main | 2026-01-16 | Detail page + comparison |
```

Update Quick Stats counts.

Add session log:
```markdown
### Session 2026-01-16 - 5.4 Competitor Keyword Spy
- **Branch**: main
- **Status**: ✅ Done
- **Notes**:
  - Backend: Added `GET /competitors/{id}/keywords` endpoint with comparison data
  - Flutter: Created Freezed models for keyword comparison
  - Flutter: Added CompetitorDetailScreen with keywords tab
  - UI: Summary card, filter bar, keyword rows, bulk track
  - Navigation: From competitor list and via route
- **Files created**:
  - `api/app/Http/Controllers/Api/CompetitorController.php` (keywords method)
  - `app/lib/features/competitors/domain/competitor_keywords_model.dart`
  - `app/lib/features/competitors/presentation/competitor_detail_screen.dart`
  - `app/lib/features/competitors/presentation/widgets/competitor_keywords_tab.dart`
- **Files modified**:
  - `api/routes/api.php`
  - `app/lib/features/competitors/data/competitors_repository.dart`
  - `app/lib/features/competitors/providers/competitors_provider.dart`
  - `app/lib/core/router/app_router.dart`
  - `app/lib/features/keywords/presentation/competitors_screen.dart`
```

**Step 2: Commit**

```bash
git add docs/plans/implementation-tracker.md
git commit -m "docs: update tracker for 5.4 Competitor Keyword Spy"
```

---

## Summary

**Total tasks:** 9
**Estimated commits:** 9

**Files to create:**
- `app/lib/features/competitors/domain/competitor_keywords_model.dart`
- `app/lib/features/competitors/presentation/competitor_detail_screen.dart`
- `app/lib/features/competitors/presentation/widgets/competitor_keywords_tab.dart`

**Files to modify:**
- `api/routes/api.php`
- `api/app/Http/Controllers/Api/CompetitorController.php`
- `app/lib/features/competitors/data/competitors_repository.dart`
- `app/lib/features/competitors/providers/competitors_provider.dart`
- `app/lib/core/router/app_router.dart`
- `app/lib/features/keywords/presentation/competitors_screen.dart`
- `docs/plans/implementation-tracker.md`
