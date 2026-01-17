import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/app_context_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../apps/providers/apps_provider.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../shared/widgets/change_indicator.dart';
import '../../../../shared/widgets/states.dart';
import '../../domain/ranking_mover.dart';
import '../../providers/dashboard_providers.dart';
import '../../../../shared/widgets/safe_image.dart';

/// Section showing keywords with the biggest ranking changes
class RankingMoversSection extends ConsumerWidget {
  const RankingMoversSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final period = ref.watch(moversPeriodProvider);
    final moversAsync = ref.watch(currentMoversProvider);

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(color: colors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, ref, period),
          Divider(height: 1, color: colors.glassBorder),
          moversAsync.when(
            data: (data) => _buildContent(context, data),
            loading: () => _buildLoading(context),
            error: (e, _) => _buildError(context, ref, e),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, String period) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.cardPadding,
        vertical: AppSpacing.sm + 2,
      ),
      child: Row(
        children: [
          Icon(Icons.swap_vert_rounded, size: 18, color: colors.textMuted),
          const SizedBox(width: AppSpacing.iconTextGap),
          Text(
            'Ranking Movements',
            style: AppTypography.titleSmall.copyWith(color: colors.textPrimary),
          ),
          const Spacer(),
          _PeriodSelector(
            selected: period,
            onChanged: (p) => ref.read(moversPeriodProvider.notifier).state = p,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, RankingMoversData data) {
    final colors = context.colors;

    if (data.improving.isEmpty && data.declining.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.trending_flat, size: 40, color: colors.textMuted),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'No significant ranking changes',
                style: AppTypography.body.copyWith(color: colors.textMuted),
              ),
              Text(
                'during this period',
                style: AppTypography.caption.copyWith(color: colors.textMuted),
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _MoversList(
                  title: 'Improving',
                  movers: data.improving,
                  isPositive: true,
                ),
              ),
              Container(
                width: 1,
                color: colors.glassBorder,
              ),
              Expanded(
                child: _MoversList(
                  title: 'Declining',
                  movers: data.declining,
                  isPositive: false,
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            _MoversList(
              title: 'Improving',
              movers: data.improving,
              isPositive: true,
            ),
            Divider(height: 1, color: colors.glassBorder),
            _MoversList(
              title: 'Declining',
              movers: data.declining,
              isPositive: false,
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoading(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, Object error) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: ErrorView(
        message: error.toString(),
        onRetry: () => ref.invalidate(currentMoversProvider),
      ),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _PeriodSelector({
    required this.selected,
    required this.onChanged,
  });

  static const _periods = ['24h', '7d', '30d'];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _periods.map((period) {
        final isSelected = period == selected;
        return Padding(
          padding: const EdgeInsets.only(left: 4),
          child: GestureDetector(
            onTap: () => onChanged(period),
            child: AnimatedContainer(
              duration: AppAnimations.fast,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? colors.accent : colors.bgActive,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                period.toUpperCase(),
                style: AppTypography.micro.copyWith(
                  color: isSelected ? Colors.white : colors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _MoversList extends StatelessWidget {
  final String title;
  final List<RankingMover> movers;
  final bool isPositive;

  const _MoversList({
    required this.title,
    required this.movers,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final displayMovers = movers.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.cardPadding,
            AppSpacing.sm,
            AppSpacing.cardPadding,
            AppSpacing.xs,
          ),
          child: Row(
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                size: 14,
                color: isPositive ? colors.green : colors.red,
              ),
              const SizedBox(width: 4),
              Text(
                title,
                style: AppTypography.caption.copyWith(
                  color: isPositive ? colors.green : colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${movers.length} keywords',
                style: AppTypography.micro.copyWith(color: colors.textMuted),
              ),
            ],
          ),
        ),
        if (displayMovers.isEmpty)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Center(
              child: Text(
                'No ${isPositive ? 'improving' : 'declining'} keywords',
                style: AppTypography.caption.copyWith(color: colors.textMuted),
              ),
            ),
          )
        else
          ...displayMovers.map((mover) => _MoverRow(
                mover: mover,
                isPositive: isPositive,
              )),
        if (movers.length > 5)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.cardPadding,
              0,
              AppSpacing.cardPadding,
              AppSpacing.sm,
            ),
            child: TextButton(
              onPressed: () {
                // Navigate to keywords with filter
                context.go('/keywords');
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'View all ${movers.length} →',
                style: AppTypography.caption.copyWith(color: colors.accent),
              ),
            ),
          ),
      ],
    );
  }
}

class _MoverRow extends ConsumerWidget {
  final RankingMover mover;
  final bool isPositive;

  const _MoverRow({
    required this.mover,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final apps = ref.watch(appsNotifierProvider).valueOrNull ?? [];

    return InkWell(
      onTap: () {
        try {
          final app = apps.firstWhere((a) => a.id == mover.appId);
          ref.read(appContextProvider.notifier).select(app);
        } catch (_) {
          // App not found in list, ignore tap
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardPadding,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            // App icon
            if (mover.appIcon != null)
              SafeImage(
                imageUrl: mover.appIcon!,
                width: 24,
                height: 24,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(6),
                errorWidget: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: colors.bgActive,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(Icons.apps, size: 14, color: colors.textMuted),
                ),
              )
            else
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: colors.bgActive,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.apps, size: 14, color: colors.textMuted),
              ),
            const SizedBox(width: AppSpacing.sm),
            // Keyword and app name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mover.keyword,
                    style: AppTypography.bodyMedium.copyWith(
                      color: colors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    mover.appName,
                    style: AppTypography.micro.copyWith(
                      color: colors.textMuted,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            // Position change
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '#${mover.oldPosition}',
                      style: AppTypography.micro.copyWith(
                        color: colors.textMuted,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      size: 10,
                      color: colors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '#${mover.newPosition}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
                ChangeIndicator(
                  value: isPositive ? mover.change.toDouble() : -mover.change.toDouble(),
                  format: ChangeFormat.position,
                  invertColors: true, // For rankings, lower is better
                  size: ChangeIndicatorSize.small,
                  showBackground: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
