import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../data/competitors_repository.dart';
import '../../domain/competitor_keywords_model.dart';
import '../../providers/competitors_provider.dart';
import '../../../keywords/data/keywords_repository.dart';
import '../../../keywords/providers/keywords_provider.dart';

class CompetitorKeywordsTab extends ConsumerStatefulWidget {
  final CompetitorKeywordsResponse response;
  final int competitorId;
  final int userAppId;
  final String country;

  const CompetitorKeywordsTab({
    super.key,
    required this.response,
    required this.competitorId,
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
          onAddKeyword: () => _showAddKeywordDialog(context),
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

  void _showAddKeywordDialog(BuildContext context) {
    final controller = TextEditingController();
    final colors = context.colors;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.bgBase,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        ),
        title: Text(
          'Add Keyword to Competitor',
          style: AppTypography.headline.copyWith(color: colors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter keywords to track for this competitor (one per line):',
              style: AppTypography.bodyMedium.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              maxLines: 5,
              autofocus: true,
              style: TextStyle(color: colors.textPrimary),
              decoration: InputDecoration(
                hintText: 'budget tracker\nexpense manager\nmoney app',
                hintStyle: TextStyle(color: colors.textMuted),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                  borderSide: BorderSide(color: colors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                  borderSide: BorderSide(color: colors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                  borderSide: BorderSide(color: colors.accent),
                ),
                filled: true,
                fillColor: colors.bgSurface,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: colors.textMuted)),
          ),
          FilledButton(
            onPressed: () {
              final keywords = controller.text
                  .split('\n')
                  .map((k) => k.trim())
                  .where((k) => k.isNotEmpty)
                  .toList();
              Navigator.pop(context, keywords);
            },
            style: FilledButton.styleFrom(backgroundColor: colors.accent),
            child: const Text('Add Keywords'),
          ),
        ],
      ),
    ).then((keywords) {
      if (keywords != null && keywords.isNotEmpty) {
        _addKeywordsToCompetitor(keywords as List<String>);
      }
    });
  }

  Future<void> _addKeywordsToCompetitor(List<String> keywords) async {
    final colors = context.colors;
    try {
      final repository = ref.read(competitorsRepositoryProvider);
      final result = await repository.addKeywordsToCompetitor(
        competitorId: widget.competitorId,
        keywords: keywords,
        storefront: widget.country,
      );

      // Refresh the data
      ref.invalidate(competitorKeywordsProvider((
        competitorId: widget.competitorId,
        appId: widget.userAppId,
        country: widget.country,
      )));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.skipped > 0
                  ? 'Added ${result.added} keywords, ${result.skipped} already tracked'
                  : 'Added ${result.added} keywords to competitor',
            ),
            backgroundColor: colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add keywords: $e'),
            backgroundColor: colors.red,
          ),
        );
      }
    }
  }

  Widget _buildEmptyState(AppColorsExtension colors, CompetitorKeywordFilter filter) {
    // Check if there are any keywords at all (not just filtered)
    final hasAnyKeywords = widget.response.keywords.isNotEmpty;

    if (!hasAnyKeywords) {
      // No keywords tracked for competitor yet
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: colors.textMuted),
              const SizedBox(height: 24),
              Text(
                'No keywords tracked for this competitor',
                style: AppTypography.headline.copyWith(color: colors.textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Add keywords to track which keywords this competitor ranks for, then compare with your app.',
                style: AppTypography.bodyMedium.copyWith(color: colors.textMuted),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => _showAddKeywordDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Keywords'),
                style: FilledButton.styleFrom(
                  backgroundColor: colors.accent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Has keywords but filter shows none
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
      ref.invalidate(keywordsNotifierProvider(widget.userAppId));

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

    ref.invalidate(keywordsNotifierProvider(widget.userAppId));

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
  final VoidCallback onAddKeyword;

  const _FilterBar({
    required this.filter,
    required this.onFilterChanged,
    required this.isSelectionMode,
    required this.selectedCount,
    required this.onToggleSelection,
    required this.onTrackSelected,
    required this.isTracking,
    required this.onAddKeyword,
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
          const SizedBox(width: AppSpacing.sm),
          // Add keyword button
          Material(
            color: colors.accent,
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
            child: InkWell(
              onTap: onAddKeyword,
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.cardPadding,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.add, size: 16, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      'Add Keyword',
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
                // Track button or status (hidden in selection mode)
                if (!isSelectionMode)
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
          position != null ? '#$position' : '+100',
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
