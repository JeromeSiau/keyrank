import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/apps_repository.dart';
import '../../../../shared/widgets/safe_image.dart';

/// Modal to display apps from the same developer
class DeveloperAppsModal extends ConsumerStatefulWidget {
  final int appId;
  final String developer;

  const DeveloperAppsModal({
    super.key,
    required this.appId,
    required this.developer,
  });

  static Future<void> show(BuildContext context, int appId, String developer) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DeveloperAppsModal(
        appId: appId,
        developer: developer,
      ),
    );
  }

  @override
  ConsumerState<DeveloperAppsModal> createState() => _DeveloperAppsModalState();
}

class _DeveloperAppsModalState extends ConsumerState<DeveloperAppsModal> {
  DeveloperAppsResult? _result;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDeveloperApps();
  }

  Future<void> _loadDeveloperApps() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repository = ref.read(appsRepositoryProvider);
      final result = await repository.getDeveloperApps(widget.appId);
      if (mounted) {
        setState(() {
          _result = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.75,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgSurface : AppColorsLight.bgSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.sm),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? AppColors.border : AppColorsLight.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Apps by Developer',
                        style: AppTypography.headline.copyWith(
                          color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        widget.developer,
                        style: AppTypography.body.copyWith(
                          color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Content
          Flexible(
            child: _buildContent(isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isDark) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: isDark ? AppColors.red : AppColorsLight.red,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Failed to load developer apps',
                style: AppTypography.body.copyWith(
                  color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: _loadDeveloperApps,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final apps = _result?.apps ?? [];

    if (apps.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.apps_outlined,
                size: 48,
                color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'No other apps found from this developer',
                style: AppTypography.body.copyWith(
                  color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      itemCount: apps.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final app = apps[index];
        return _DeveloperAppTile(
          app: app,
          isDark: isDark,
          onTap: () {
            Navigator.of(context).pop();
            // Navigate to app detail if tracked, or preview if not
            if (app.isTracked) {
              context.go('/apps/${app.id}');
            } else {
              context.go('/discover/preview/${app.platform}/${app.storeId}');
            }
          },
        );
      },
    );
  }
}

class _DeveloperAppTile extends StatelessWidget {
  final DeveloperApp app;
  final bool isDark;
  final VoidCallback onTap;

  const _DeveloperAppTile({
    required this.app,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.compact();

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            // App icon
            app.iconUrl != null
                ? SafeImage(
                    imageUrl: app.iconUrl!,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(12),
                    errorWidget: _buildPlaceholderIcon(),
                  )
                : _buildPlaceholderIcon(),
            const SizedBox(width: AppSpacing.md),
            // App info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    app.name,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      // Platform badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: app.isIos
                              ? (isDark ? AppColors.bgActive : AppColorsLight.bgActive)
                              : (isDark ? AppColors.greenMuted : AppColorsLight.greenMuted),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          app.isIos ? 'iOS' : 'Android',
                          style: AppTypography.micro.copyWith(
                            color: app.isIos
                                ? (isDark ? AppColors.textSecondary : AppColorsLight.textSecondary)
                                : (isDark ? AppColors.green : AppColorsLight.green),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      // Rating
                      if (app.rating != null) ...[
                        Icon(
                          Icons.star,
                          size: 14,
                          color: isDark ? AppColors.yellow : AppColorsLight.yellow,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          app.rating!.toStringAsFixed(1),
                          style: AppTypography.micro.copyWith(
                            color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                      ],
                      // Rating count
                      Text(
                        '(${numberFormat.format(app.ratingCount)})',
                        style: AppTypography.micro.copyWith(
                          color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Tracked indicator or chevron
            if (app.isTracked)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.accent : AppColorsLight.accent).withAlpha(30),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Tracked',
                  style: AppTypography.micro.copyWith(
                    color: isDark ? AppColors.accent : AppColorsLight.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else
              Icon(
                Icons.chevron_right,
                color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgPanel : AppColorsLight.bgPanel,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.apps,
        color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
      ),
    );
  }
}
