import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/competitor_metadata_history_model.dart';
import '../../providers/competitors_provider.dart';
import '../../data/competitors_repository.dart';

class CompetitorMetadataHistoryTab extends ConsumerWidget {
  final int competitorId;

  const CompetitorMetadataHistoryTab({
    super.key,
    required this.competitorId,
  });

  Future<void> _exportHistory(BuildContext context, WidgetRef ref, int competitorId) async {
    final colors = context.colors;
    final locale = ref.read(metadataHistoryLocaleProvider);
    final days = ref.read(metadataHistoryDaysProvider);

    try {
      final repository = ref.read(competitorsRepositoryProvider);
      final csvData = await repository.exportMetadataHistory(
        competitorId: competitorId,
        locale: locale,
        days: days,
      );

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exported ${csvData.length} bytes of CSV data'),
            backgroundColor: colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: colors.red,
          ),
        );
      }
    }
  }

  void _showInsights(BuildContext context, WidgetRef ref, int competitorId) {
    final locale = ref.read(metadataHistoryLocaleProvider);
    final days = ref.read(metadataHistoryDaysProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _InsightsBottomSheet(
        competitorId: competitorId,
        locale: locale,
        days: days,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final locale = ref.watch(metadataHistoryLocaleProvider);
    final days = ref.watch(metadataHistoryDaysProvider);
    final changesOnly = ref.watch(metadataHistoryChangesOnlyProvider);

    final historyAsync = ref.watch(
      competitorMetadataHistoryProvider((
        competitorId: competitorId,
        locale: locale,
        days: days,
        changesOnly: changesOnly,
      )),
    );

    return historyAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (e, _) => _buildErrorState(colors, e.toString()),
      data: (response) => _buildContent(context, ref, response),
    );
  }

  Widget _buildErrorState(AppColorsExtension colors, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: colors.red),
          const SizedBox(height: 16),
          Text(
            'Error loading metadata history',
            style: AppTypography.bodyMedium.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: AppTypography.caption.copyWith(color: colors.textMuted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    CompetitorMetadataHistoryResponse response,
  ) {
    final colors = context.colors;
    final changesOnly = ref.watch(metadataHistoryChangesOnlyProvider);

    return Column(
      children: [
        // Summary Card
        _SummaryCard(summary: response.summary),
        // Filter Bar
        _FilterBar(
          changesOnly: changesOnly,
          onChangesOnlyChanged: (value) =>
              ref.read(metadataHistoryChangesOnlyProvider.notifier).state = value,
          onRefresh: () => ref.invalidate(
            competitorMetadataHistoryProvider((
              competitorId: competitorId,
              locale: ref.read(metadataHistoryLocaleProvider),
              days: ref.read(metadataHistoryDaysProvider),
              changesOnly: ref.read(metadataHistoryChangesOnlyProvider),
            )),
          ),
          onSetupAlert: () => context.push('/alerts/builder'),
          onExportHistory: () => _exportHistory(context, ref, competitorId),
          onGenerateInsights: () => _showInsights(context, ref, competitorId),
        ),
        // Timeline
        Expanded(
          child: response.timeline.isEmpty
              ? _buildEmptyState(colors, changesOnly)
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  itemCount: response.timeline.length,
                  itemBuilder: (context, index) => _TimelineEntry(
                    entry: response.timeline[index],
                    isFirst: index == 0,
                    isLast: index == response.timeline.length - 1,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(AppColorsExtension colors, bool changesOnly) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              changesOnly ? Icons.check_circle_outline : Icons.history,
              size: 64,
              color: changesOnly ? colors.green : colors.textMuted,
            ),
            const SizedBox(height: 24),
            Text(
              changesOnly
                  ? 'No metadata changes detected'
                  : 'No metadata history available',
              style: AppTypography.headline.copyWith(color: colors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              changesOnly
                  ? 'This competitor has not changed their metadata in the selected period.'
                  : 'Metadata snapshots will appear here as they are collected daily.',
              style: AppTypography.bodyMedium.copyWith(color: colors.textMuted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final MetadataHistorySummary summary;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics_outlined, size: 20, color: colors.accent),
              const SizedBox(width: 8),
              Text(
                'Metadata Activity',
                style: AppTypography.titleSmall.copyWith(color: colors.textPrimary),
              ),
              const Spacer(),
              Text(
                'Last ${summary.periodDays} days',
                style: AppTypography.caption.copyWith(color: colors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  label: 'Total Snapshots',
                  value: summary.totalSnapshots.toString(),
                  color: colors.textPrimary,
                  icon: Icons.camera_alt_outlined,
                ),
              ),
              _divider(colors),
              Expanded(
                child: _SummaryItem(
                  label: 'Changes Detected',
                  value: summary.totalChanges.toString(),
                  color: summary.totalChanges > 0 ? colors.yellow : colors.green,
                  icon: summary.totalChanges > 0 ? Icons.edit : Icons.check,
                ),
              ),
            ],
          ),
          if (summary.changesByField.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: summary.changesByField.entries.map((entry) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colors.accent.withAlpha(20),
                    borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                  ),
                  child: Text(
                    '${metadataFieldDisplayName(entry.key)}: ${entry.value}x',
                    style: AppTypography.caption.copyWith(
                      color: colors.accent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _divider(AppColorsExtension colors) {
    return Container(
      width: 1,
      height: 40,
      color: colors.glassBorder,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
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
  final bool changesOnly;
  final ValueChanged<bool> onChangesOnlyChanged;
  final VoidCallback onRefresh;
  final VoidCallback onSetupAlert;
  final VoidCallback onExportHistory;
  final VoidCallback onGenerateInsights;

  const _FilterBar({
    required this.changesOnly,
    required this.onChangesOnlyChanged,
    required this.onRefresh,
    required this.onSetupAlert,
    required this.onExportHistory,
    required this.onGenerateInsights,
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
          // Changes only toggle
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onChangesOnlyChanged(!changesOnly),
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.cardPadding,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: changesOnly ? colors.accent.withAlpha(20) : null,
                  border: Border.all(
                    color: changesOnly ? colors.accent : colors.glassBorder,
                  ),
                  borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                ),
                child: Row(
                  children: [
                    Icon(
                      changesOnly ? Icons.filter_alt : Icons.filter_alt_outlined,
                      size: 16,
                      color: changesOnly ? colors.accent : colors.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      changesOnly ? 'Changes only' : 'All snapshots',
                      style: AppTypography.caption.copyWith(
                        color: changesOnly ? colors.accent : colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          // Set up alert button
          _ActionButton(
            icon: Icons.notifications_outlined,
            label: 'Set up alert',
            onTap: onSetupAlert,
          ),
          const SizedBox(width: 8),
          // Export button
          _ActionButton(
            icon: Icons.download_outlined,
            label: 'Export',
            onTap: onExportHistory,
          ),
          const SizedBox(width: 8),
          // AI Insights button
          _ActionButton(
            icon: Icons.auto_awesome,
            label: 'AI Insights',
            onTap: onGenerateInsights,
          ),
          const SizedBox(width: 8),
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

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        hoverColor: colors.bgHover,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.cardPadding,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: colors.glassBorder),
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: colors.textMuted),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTypography.caption.copyWith(color: colors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  final MetadataTimelineEntry entry;
  final bool isFirst;
  final bool isLast;

  const _TimelineEntry({
    required this.entry,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline line and dot
          SizedBox(
            width: 40,
            child: Column(
              children: [
                // Line above
                if (!isFirst)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: colors.glassBorder,
                    ),
                  ),
                // Dot
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: entry.hasChanges ? colors.accent : colors.glassBorder,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: entry.hasChanges ? colors.accent : colors.textMuted,
                      width: 2,
                    ),
                  ),
                ),
                // Line below
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: colors.glassBorder,
                    ),
                  ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                left: AppSpacing.sm,
                bottom: AppSpacing.md,
              ),
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              decoration: BoxDecoration(
                color: entry.hasChanges
                    ? colors.accent.withAlpha(10)
                    : colors.bgActive.withAlpha(50),
                border: Border.all(
                  color: entry.hasChanges ? colors.accent.withAlpha(50) : colors.glassBorder,
                ),
                borderRadius: BorderRadius.circular(AppColors.radiusMedium),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date and version
                  Row(
                    children: [
                      Icon(
                        entry.hasChanges ? Icons.edit : Icons.camera_alt_outlined,
                        size: 16,
                        color: entry.hasChanges ? colors.accent : colors.textMuted,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formatMetadataDate(entry.date),
                        style: AppTypography.titleSmall.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      if (entry.version != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colors.bgActive,
                            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                          ),
                          child: Text(
                            'v${entry.version}',
                            style: AppTypography.caption.copyWith(
                              color: colors.textMuted,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Summary
                  Text(
                    metadataChangeSummary(entry.hasChanges, entry.changedFields),
                    style: AppTypography.bodyMedium.copyWith(
                      color: entry.hasChanges ? colors.textPrimary : colors.textMuted,
                    ),
                  ),
                  // Changes detail
                  if (entry.hasChanges && entry.changes != null) ...[
                    const SizedBox(height: 12),
                    ...entry.changes!.map((change) => _ChangeDetail(change: change)),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChangeDetail extends StatefulWidget {
  final MetadataChange change;

  const _ChangeDetail({required this.change});

  @override
  State<_ChangeDetail> createState() => _ChangeDetailState();
}

class _ChangeDetailState extends State<_ChangeDetail> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final change = widget.change;

    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      decoration: BoxDecoration(
        color: colors.bgBase,
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _getChangeColor(colors).withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          metadataChangeIcon(change.oldValue, change.newValue),
                          style: TextStyle(
                            color: _getChangeColor(colors),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        metadataFieldDisplayName(change.field),
                        style: AppTypography.titleSmall.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    if (change.charDiff != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: change.charDiff! > 0
                              ? colors.green.withAlpha(20)
                              : colors.red.withAlpha(20),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${change.charDiff! > 0 ? '+' : ''}${change.charDiff} chars',
                          style: AppTypography.caption.copyWith(
                            color: change.charDiff! > 0 ? colors.green : colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      size: 20,
                      color: colors.textMuted,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Expanded content
          if (_isExpanded) ...[
            Divider(height: 1, color: colors.glassBorder),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (change.oldValue != null) ...[
                    _ValueSection(
                      label: 'Before',
                      value: change.oldValue!,
                      color: colors.red,
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (change.newValue != null)
                    _ValueSection(
                      label: 'After',
                      value: change.newValue!,
                      color: colors.green,
                    ),
                  if (change.keywordAnalysis != null) ...[
                    const SizedBox(height: 12),
                    _KeywordAnalysisSection(analysis: change.keywordAnalysis!),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getChangeColor(AppColorsExtension colors) {
    if (widget.change.oldValue == null) return colors.green;
    if (widget.change.newValue == null) return colors.red;
    return colors.yellow;
  }
}

class _ValueSection extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ValueSection({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: color.withAlpha(10),
            border: Border.all(color: color.withAlpha(30)),
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
          ),
          child: Text(
            value.length > 300 ? '${value.substring(0, 300)}...' : value,
            style: AppTypography.bodySmall.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _KeywordAnalysisSection extends StatelessWidget {
  final KeywordAnalysis analysis;

  const _KeywordAnalysisSection({required this.analysis});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Keyword Changes',
          style: AppTypography.caption.copyWith(
            color: colors.textMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        if (analysis.added.isNotEmpty) ...[
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              Icon(Icons.add_circle, size: 14, color: colors.green),
              const SizedBox(width: 2),
              ...analysis.added.map((kw) => _KeywordChip(
                    keyword: kw,
                    color: colors.green,
                  )),
            ],
          ),
          const SizedBox(height: 6),
        ],
        if (analysis.removed.isNotEmpty)
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              Icon(Icons.remove_circle, size: 14, color: colors.red),
              const SizedBox(width: 2),
              ...analysis.removed.map((kw) => _KeywordChip(
                    keyword: kw,
                    color: colors.red,
                  )),
            ],
          ),
      ],
    );
  }
}

class _KeywordChip extends StatelessWidget {
  final String keyword;
  final Color color;

  const _KeywordChip({
    required this.keyword,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        keyword,
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _InsightsBottomSheet extends ConsumerWidget {
  final int competitorId;
  final String locale;
  final int days;

  const _InsightsBottomSheet({
    required this.competitorId,
    required this.locale,
    required this.days,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final insightsAsync = ref.watch(
      competitorMetadataInsightsProvider((
        competitorId: competitorId,
        locale: locale,
        days: days,
      )),
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: colors.bgBase,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.glassBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, color: colors.accent, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'AI Strategy Insights',
                    style: AppTypography.headline.copyWith(color: colors.textPrimary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Content
            Expanded(
              child: insightsAsync.when(
                loading: () => const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(strokeWidth: 2),
                      SizedBox(height: 16),
                      Text('Analyzing competitor strategy...'),
                    ],
                  ),
                ),
                error: (e, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.screenPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to generate insights',
                          style: AppTypography.titleSmall.copyWith(color: colors.textPrimary),
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
                ),
                data: (response) {
                  if (response.insights == null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.screenPadding),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.info_outline, size: 48, color: colors.textMuted),
                            const SizedBox(height: 16),
                            Text(
                              response.message ?? 'No insights available',
                              style: AppTypography.bodyMedium.copyWith(color: colors.textMuted),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final insights = response.insights!;
                  return ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(AppSpacing.screenPadding),
                    children: [
                      // Strategy Summary
                      _InsightSection(
                        icon: Icons.lightbulb_outline,
                        title: 'Strategy Summary',
                        color: colors.accent,
                        child: Text(
                          insights.strategySummary,
                          style: AppTypography.bodyMedium.copyWith(color: colors.textPrimary),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Trend indicator
                      _InsightSection(
                        icon: _trendIcon(insights.trend),
                        title: 'Activity Trend',
                        color: _trendColor(insights.trend, colors),
                        child: Text(
                          _trendDescription(insights.trend),
                          style: AppTypography.bodyMedium.copyWith(
                            color: _trendColor(insights.trend, colors),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Key Findings
                      _InsightSection(
                        icon: Icons.search,
                        title: 'Key Findings',
                        color: colors.yellow,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: insights.keyFindings
                              .map((finding) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('• ', style: TextStyle(color: colors.yellow)),
                                        Expanded(
                                          child: Text(
                                            finding,
                                            style: AppTypography.bodySmall.copyWith(color: colors.textSecondary),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Keyword Focus
                      if (insights.keywordFocus.isNotEmpty) ...[
                        _InsightSection(
                          icon: Icons.key,
                          title: 'Keyword Focus',
                          color: colors.accent,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: insights.keywordFocus
                                .map((kw) => Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: colors.accent.withAlpha(20),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        kw,
                                        style: AppTypography.caption.copyWith(color: colors.accent),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      // Recommendations
                      _InsightSection(
                        icon: Icons.tips_and_updates_outlined,
                        title: 'Recommendations',
                        color: colors.green,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: insights.recommendations
                              .asMap()
                              .entries
                              .map((entry) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: colors.green.withAlpha(20),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${entry.key + 1}',
                                              style: AppTypography.caption.copyWith(
                                                color: colors.green,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            entry.value,
                                            style: AppTypography.bodySmall.copyWith(color: colors.textSecondary),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Footer
                      Text(
                        'Based on ${response.analyzedChanges} metadata changes over the last ${response.periodDays} days',
                        style: AppTypography.caption.copyWith(color: colors.textMuted),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _trendIcon(String trend) {
    switch (trend) {
      case 'increasing':
        return Icons.trending_up;
      case 'decreasing':
        return Icons.trending_down;
      default:
        return Icons.trending_flat;
    }
  }

  Color _trendColor(String trend, AppColorsExtension colors) {
    switch (trend) {
      case 'increasing':
        return colors.green;
      case 'decreasing':
        return colors.red;
      default:
        return colors.textMuted;
    }
  }

  String _trendDescription(String trend) {
    switch (trend) {
      case 'increasing':
        return 'High activity - competitor is actively optimizing';
      case 'decreasing':
        return 'Low activity - competitor optimization has slowed';
      default:
        return 'Stable - consistent optimization patterns';
    }
  }
}

class _InsightSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Widget child;

  const _InsightSection({
    required this.icon,
    required this.title,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: color.withAlpha(10),
        border: Border.all(color: color.withAlpha(30)),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTypography.titleSmall.copyWith(color: colors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
