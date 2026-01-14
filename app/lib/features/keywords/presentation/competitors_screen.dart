import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../competitors/providers/competitors_provider.dart';
import '../../competitors/domain/competitor_model.dart';

class CompetitorsScreen extends ConsumerWidget {
  const CompetitorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final competitorsAsync = ref.watch(filteredCompetitorsProvider);
    final currentFilter = ref.watch(competitorFilterProvider);

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanel,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
      ),
      child: Column(
        children: [
          // Toolbar with title and actions
          _Toolbar(onRefresh: () => ref.invalidate(competitorsProvider)),

          // Filter chips
          _FilterChips(
            currentFilter: currentFilter,
            onFilterChanged: (filter) =>
                ref.read(competitorFilterProvider.notifier).state = filter,
          ),

          // Competitors list
          Expanded(
            child: competitorsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (e, _) => Center(
                child: Text(
                  'Error: $e',
                  style: TextStyle(color: colors.red),
                ),
              ),
              data: (competitors) {
                if (competitors.isEmpty) {
                  return _EmptyState(
                    colors: colors,
                    filter: currentFilter,
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  itemCount: competitors.length,
                  itemBuilder: (context, index) => _CompetitorTile(
                    competitor: competitors[index],
                    onView: () => context.push(
                      '/apps/preview/${competitors[index].platform}/${competitors[index].storeId}',
                    ),
                    onRemove: () => _removeCompetitor(context, ref, competitors[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _removeCompetitor(
    BuildContext context,
    WidgetRef ref,
    CompetitorModel competitor,
  ) async {
    final colors = context.colors;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.bgBase,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        ),
        title: Text(
          'Remove Competitor',
          style: AppTypography.headline.copyWith(color: colors.textPrimary),
        ),
        content: Text(
          'Are you sure you want to remove "${competitor.name}" from your competitors?',
          style: AppTypography.body.copyWith(color: colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: AppTypography.body.copyWith(color: colors.textMuted),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Remove',
              style: AppTypography.body.copyWith(color: colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final repository = ref.read(competitorsRepositoryProvider);
      await repository.removeGlobalCompetitor(competitor.id);
      ref.invalidate(competitorsProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${competitor.name} removed'),
            backgroundColor: colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove competitor: $e'),
            backgroundColor: colors.red,
          ),
        );
      }
    }
  }
}

class _Toolbar extends StatelessWidget {
  final VoidCallback onRefresh;

  const _Toolbar({required this.onRefresh});

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
          // Competitors icon
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
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
          const SizedBox(width: AppSpacing.sm + 4),
          // Title
          Text(
            context.l10n.nav_competitors,
            style: AppTypography.headline.copyWith(color: colors.textPrimary),
          ),
          const Spacer(),
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

class _FilterChips extends StatelessWidget {
  final CompetitorFilter currentFilter;
  final ValueChanged<CompetitorFilter> onFilterChanged;

  const _FilterChips({
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.sm + 4,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder)),
      ),
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            isSelected: currentFilter == CompetitorFilter.all,
            onTap: () => onFilterChanged(CompetitorFilter.all),
          ),
          const SizedBox(width: AppSpacing.sm),
          _FilterChip(
            label: 'Global',
            isSelected: currentFilter == CompetitorFilter.global,
            onTap: () => onFilterChanged(CompetitorFilter.global),
          ),
          const SizedBox(width: AppSpacing.sm),
          _FilterChip(
            label: 'Contextual',
            isSelected: currentFilter == CompetitorFilter.contextual,
            onTap: () => onFilterChanged(CompetitorFilter.contextual),
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

  const _FilterChip({
    required this.label,
    required this.isSelected,
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
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm + 4,
            vertical: AppSpacing.xs + 2,
          ),
          decoration: BoxDecoration(
            color: isSelected ? colors.accent : Colors.transparent,
            border: Border.all(
              color: isSelected ? colors.accent : colors.glassBorder,
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

class _EmptyState extends StatelessWidget {
  final AppColorsExtension colors;
  final CompetitorFilter filter;

  const _EmptyState({
    required this.colors,
    required this.filter,
  });

  String get _message {
    switch (filter) {
      case CompetitorFilter.all:
        return 'No competitors tracked yet';
      case CompetitorFilter.global:
        return 'No global competitors';
      case CompetitorFilter.contextual:
        return 'No contextual competitors';
    }
  }

  String get _subtitle {
    switch (filter) {
      case CompetitorFilter.all:
        return 'Add competitors to track their rankings and performance';
      case CompetitorFilter.global:
        return 'Global competitors appear across all your apps';
      case CompetitorFilter.contextual:
        return 'Contextual competitors are linked to specific apps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
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
          const SizedBox(height: AppSpacing.lg),
          Text(
            _message,
            style: AppTypography.headline.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _subtitle,
            style: AppTypography.body.copyWith(color: colors.textMuted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CompetitorTile extends StatelessWidget {
  final CompetitorModel competitor;
  final VoidCallback onView;
  final VoidCallback onRemove;

  const _CompetitorTile({
    required this.competitor,
    required this.onView,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm + 4),
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onView,
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
          hoverColor: colors.bgHover,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Row(
              children: [
                // App icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: colors.bgActive,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: competitor.iconUrl != null
                      ? Image.network(
                          competitor.iconUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, e, s) => Icon(
                            competitor.isIos ? Icons.apple : Icons.android,
                            size: 24,
                            color: colors.textMuted,
                          ),
                        )
                      : Icon(
                          competitor.isIos ? Icons.apple : Icons.android,
                          size: 24,
                          color: colors.textMuted,
                        ),
                ),
                const SizedBox(width: AppSpacing.cardPadding),
                // Name, developer, badges
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              competitor.name,
                              style: AppTypography.bodyMedium.copyWith(
                                color: colors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          // Type badge
                          _TypeBadge(
                            isGlobal: competitor.isGlobal,
                            colors: colors,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          // Developer
                          if (competitor.developer != null) ...[
                            Expanded(
                              child: Text(
                                competitor.developer!,
                                style: AppTypography.caption.copyWith(
                                  color: colors.textMuted,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                          // Platform icon
                          Icon(
                            competitor.isIos ? Icons.apple : Icons.android,
                            size: 14,
                            color: colors.textMuted,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            competitor.isIos ? 'iOS' : 'Android',
                            style: AppTypography.caption.copyWith(
                              color: colors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.cardPadding),
                // Rating
                if (competitor.rating != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: colors.bgActive,
                      borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: colors.yellow,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          competitor.rating!.toStringAsFixed(1),
                          style: AppTypography.bodyMedium.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm + 4),
                ],
                // Actions
                _ActionButton(
                  icon: Icons.visibility_rounded,
                  tooltip: 'View App',
                  onTap: onView,
                  colors: colors,
                ),
                const SizedBox(width: AppSpacing.xs),
                _ActionButton(
                  icon: Icons.delete_outline_rounded,
                  tooltip: 'Remove',
                  onTap: onRemove,
                  colors: colors,
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final bool isGlobal;
  final AppColorsExtension colors;

  const _TypeBadge({
    required this.isGlobal,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final color = isGlobal ? colors.purple : colors.accent;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        border: Border.all(color: color.withAlpha(50)),
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
      ),
      child: Text(
        isGlobal ? 'Global' : 'Contextual',
        style: AppTypography.caption.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final AppColorsExtension colors;
  final bool isDestructive;

  const _ActionButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    required this.colors,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppColors.radiusSmall),
          hoverColor: isDestructive
              ? colors.red.withAlpha(20)
              : colors.bgHover,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Icon(
              icon,
              size: 18,
              color: isDestructive ? colors.red : colors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
