import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/buttons.dart';
import '../../../shared/widgets/safe_image.dart';
import '../providers/apps_provider.dart';
import '../providers/app_preview_provider.dart';
import '../data/apps_repository.dart';
import '../domain/app_model.dart';
import '../../competitors/providers/competitors_provider.dart';

class AppPreviewScreen extends ConsumerWidget {
  final String platform;
  final String storeId;

  const AppPreviewScreen({
    super.key,
    required this.platform,
    required this.storeId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final previewAsync = ref.watch(
      appPreviewProvider((platform: platform, storeId: storeId)),
    );

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanel,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
      ),
      child: Column(
        children: [
          // Toolbar
          _Toolbar(onBack: () => context.pop()),
          // Content
          Expanded(
            child: previewAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (e, _) => _ErrorFallback(
                platform: platform,
                storeId: storeId,
                error: e.toString(),
                onRetry: () => ref.invalidate(
                  appPreviewProvider((platform: platform, storeId: storeId)),
                ),
              ),
              data: (preview) => _PreviewContent(preview: preview),
            ),
          ),
        ],
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  final VoidCallback onBack;

  const _Toolbar({required this.onBack});

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
          ToolbarButton(
            icon: Icons.arrow_back_rounded,
            label: 'Back',
            onTap: onBack,
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            'App Preview',
            style: AppTypography.title.copyWith(color: colors.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _PreviewContent extends ConsumerWidget {
  final AppPreview preview;

  const _PreviewContent({required this.preview});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header card with app info
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: colors.bgActive.withAlpha(50),
              borderRadius: BorderRadius.circular(AppColors.radiusMedium),
              border: Border.all(color: colors.glassBorder),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: colors.bgActive,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: preview.iconUrl != null
                      ? SafeImage(
                          imageUrl: preview.iconUrl!,
                          fit: BoxFit.cover,
                          errorWidget: Icon(
                            preview.isIos ? Icons.apple : Icons.android,
                            size: 48,
                            color: colors.textMuted,
                          ),
                        )
                      : Icon(
                          preview.isIos ? Icons.apple : Icons.android,
                          size: 48,
                          color: colors.textMuted,
                        ),
                ),
                const SizedBox(width: AppSpacing.lg),
                // App details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        preview.name,
                        style: AppTypography.headline.copyWith(
                          color: colors.textPrimary,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (preview.developer != null)
                        Text(
                          preview.developer!,
                          style: AppTypography.body.copyWith(
                            color: colors.accent,
                          ),
                        ),
                      const SizedBox(height: AppSpacing.sm),
                      // Platform badge
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: preview.isIos
                                  ? colors.textMuted.withAlpha(30)
                                  : colors.green.withAlpha(30),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  preview.isIos ? Icons.apple : Icons.android,
                                  size: 14,
                                  color: preview.isIos
                                      ? colors.textSecondary
                                      : colors.green,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  preview.isIos ? 'iOS' : 'Android',
                                  style: AppTypography.caption.copyWith(
                                    color: preview.isIos
                                        ? colors.textSecondary
                                        : colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (preview.categoryName != null ||
                              preview.categoryId != null) ...[
                            const SizedBox(width: AppSpacing.sm),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colors.purple.withAlpha(30),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                preview.categoryName ?? preview.categoryId!,
                                style: AppTypography.caption.copyWith(
                                  color: colors.purple,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // Rating and reviews
                      Row(
                        children: [
                          if (preview.rating != null) ...[
                            Icon(
                              Icons.star_rounded,
                              size: 20,
                              color: colors.yellow,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              preview.rating!.toStringAsFixed(1),
                              style: AppTypography.bodyMedium.copyWith(
                                color: colors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                          ],
                          if (preview.ratingCount > 0)
                            Text(
                              '${_formatCount(preview.ratingCount)} ratings',
                              style: AppTypography.caption.copyWith(
                                color: colors.textMuted,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Action buttons
          _ActionButtons(preview: preview),
          const SizedBox(height: AppSpacing.lg),

          // Description
          if (preview.description != null) ...[
            Text(
              'Description',
              style: AppTypography.headline.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.sm),
            _ExpandableDescription(description: preview.description!),
            const SizedBox(height: AppSpacing.lg),
          ],

          // Screenshots
          if (preview.screenshots != null &&
              preview.screenshots!.isNotEmpty) ...[
            Text(
              'Screenshots',
              style: AppTypography.headline.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 400,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: preview.screenshots!.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppColors.radiusMedium,
                      ),
                      border: Border.all(color: colors.glassBorder),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: SafeImage(
                      imageUrl: preview.screenshots![index],
                      fit: BoxFit.contain,
                      errorWidget: Container(
                        width: 200,
                        color: colors.bgActive,
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 48,
                          color: colors.textMuted,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ] else ...[
            Text(
              'Screenshots',
              style: AppTypography.headline.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: colors.bgActive.withAlpha(30),
                borderRadius: BorderRadius.circular(AppColors.radiusMedium),
                border: Border.all(color: colors.glassBorder),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_outlined,
                      size: 48,
                      color: colors.textMuted.withAlpha(100),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Screenshots not available',
                      style: AppTypography.caption.copyWith(
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
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

class _ActionButtons extends ConsumerStatefulWidget {
  final AppPreview preview;

  const _ActionButtons({required this.preview});

  @override
  ConsumerState<_ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends ConsumerState<_ActionButtons> {
  bool _isAddingApp = false;
  bool _isAddingCompetitor = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final appsAsync = ref.watch(appsNotifierProvider);

    // Check if this app is already tracked
    final trackedApp = appsAsync.maybeWhen(
      data: (apps) => apps.cast<AppModel?>().firstWhere(
        (app) =>
            app?.storeId == widget.preview.storeId &&
            app?.platform == widget.preview.platform,
        orElse: () => null,
      ),
      orElse: () => null,
    );

    final isOwned = trackedApp?.isOwner ?? false;
    final isCompetitor = trackedApp?.isCompetitor ?? false;
    final isTracked = trackedApp != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Show tracking status if tracked
        if (isTracked) ...[
          Container(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            decoration: BoxDecoration(
              color: colors.green.withAlpha(20),
              borderRadius: BorderRadius.circular(AppColors.radiusMedium),
              border: Border.all(color: colors.green.withAlpha(50)),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle_rounded, color: colors.green, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    isOwned
                        ? 'This app is in your tracked apps'
                        : isCompetitor
                        ? 'This app is tracked as a competitor'
                        : 'This app is already tracked',
                    style: AppTypography.body.copyWith(color: colors.green),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        // Action buttons
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            // Add to my apps (only show if not owned)
            if (!isOwned)
              PrimaryButton(
                icon: Icons.add_rounded,
                label: _isAddingApp ? 'Adding...' : 'Add to my apps',
                onTap: _isAddingApp ? () {} : _addToMyApps,
              ),

            // Add as competitor (only show if not a competitor)
            if (!isCompetitor)
              ToolbarButton(
                icon: Icons.people_outline,
                label: _isAddingCompetitor ? 'Adding...' : 'Add as competitor',
                onTap: _isAddingCompetitor ? null : _addAsCompetitor,
              ),

            // Open in store (always show)
            ToolbarButton(
              icon: widget.preview.isIos ? Icons.apple : Icons.android,
              label:
                  'Open in ${widget.preview.isIos ? "App Store" : "Play Store"}',
              onTap: _openInStore,
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _addToMyApps() async {
    final colors = context.colors;
    setState(() => _isAddingApp = true);

    try {
      final repository = ref.read(appsRepositoryProvider);
      await repository.addApp(
        storeId: widget.preview.storeId,
        platform: widget.preview.platform,
      );
      ref.invalidate(appsNotifierProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.preview.name} added to your apps'),
            backgroundColor: colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add app: $e'),
            backgroundColor: colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAddingApp = false);
      }
    }
  }

  Future<void> _addAsCompetitor() async {
    final colors = context.colors;
    setState(() => _isAddingCompetitor = true);

    try {
      // First add the app to our system, then mark as competitor
      final repository = ref.read(appsRepositoryProvider);
      final app = await repository.addApp(
        storeId: widget.preview.storeId,
        platform: widget.preview.platform,
      );

      // Now add as global competitor using the app ID
      final competitorsRepository = ref.read(competitorsRepositoryProvider);
      await competitorsRepository.addGlobalCompetitor(app.id);

      ref.invalidate(appsNotifierProvider);
      ref.invalidate(competitorsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.preview.name} added as competitor'),
            backgroundColor: colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add competitor: $e'),
            backgroundColor: colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAddingCompetitor = false);
      }
    }
  }

  Future<void> _openInStore() async {
    final url =
        widget.preview.storeUrl ??
        (widget.preview.isIos
            ? 'https://apps.apple.com/app/id${widget.preview.storeId}'
            : 'https://play.google.com/store/apps/details?id=${widget.preview.storeId}');

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _ErrorFallback extends StatelessWidget {
  final String platform;
  final String storeId;
  final String error;
  final VoidCallback onRetry;

  const _ErrorFallback({
    required this.platform,
    required this.storeId,
    required this.error,
    required this.onRetry,
  });

  bool get isIos => platform == 'ios';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: colors.red.withAlpha(15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 56,
                color: colors.red.withAlpha(150),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Could not load app preview',
              style: AppTypography.headline.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              error,
              style: AppTypography.body.copyWith(color: colors.textMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Store ID: $storeId',
              style: AppTypography.caption.copyWith(color: colors.textMuted),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToolbarButton(
                  icon: Icons.refresh_rounded,
                  label: 'Retry',
                  onTap: onRetry,
                ),
                const SizedBox(width: AppSpacing.sm),
                PrimaryButton(
                  icon: isIos ? Icons.apple : Icons.android,
                  label: 'Open in ${isIos ? "App Store" : "Play Store"}',
                  onTap: () => _openInStore(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openInStore() async {
    final url = isIos
        ? 'https://apps.apple.com/app/id$storeId'
        : 'https://play.google.com/store/apps/details?id=$storeId';

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _ExpandableDescription extends StatefulWidget {
  final String description;

  const _ExpandableDescription({required this.description});

  @override
  State<_ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<_ExpandableDescription> {
  bool _isExpanded = false;
  static const int _maxLines = 5;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(color: colors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedCrossFade(
            firstChild: Text(
              widget.description,
              maxLines: _maxLines,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.body.copyWith(
                color: colors.textSecondary,
                height: 1.6,
              ),
            ),
            secondChild: Text(
              widget.description,
              style: AppTypography.body.copyWith(
                color: colors.textSecondary,
                height: 1.6,
              ),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
          const SizedBox(height: AppSpacing.sm),
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isExpanded ? 'Show less' : 'Show more',
                  style: AppTypography.bodyMedium.copyWith(
                    color: colors.accent,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: colors.accent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
