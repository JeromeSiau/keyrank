import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/buttons.dart';
import '../../../shared/widgets/states.dart';
import '../providers/apps_provider.dart';

class AppsListScreen extends ConsumerWidget {
  const AppsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appsAsync = ref.watch(appsNotifierProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassPanel,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
      ),
      child: Column(
        children: [
          // Toolbar
          _Toolbar(
            onAddApp: () => context.go('/apps/add'),
            onRefresh: () => ref.read(appsNotifierProvider.notifier).load(),
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
              data: (apps) => apps.isEmpty
                  ? EmptyStateView(
                      icon: Icons.app_shortcut_outlined,
                      title: 'No apps tracked yet',
                      subtitle: 'Add an app to start tracking its rankings',
                      actionLabel: 'Add App',
                      actionIcon: Icons.add_rounded,
                      onAction: () => context.go('/apps/add'),
                    )
                  : _AppsTable(apps: apps),
            ),
          ),
        ],
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  final VoidCallback onAddApp;
  final VoidCallback onRefresh;

  const _Toolbar({required this.onAddApp, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Row(
        children: [
          const Text(
            'My Apps',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          ToolbarButton(
            icon: Icons.refresh_rounded,
            label: 'Refresh',
            onTap: onRefresh,
          ),
          const SizedBox(width: 10),
          PrimaryButton(
            icon: Icons.add_rounded,
            label: 'Add App',
            onTap: onAddApp,
          ),
        ],
      ),
    );
  }
}

class _AppsTable extends StatelessWidget {
  final List apps;

  const _AppsTable({required this.apps});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgActive.withAlpha(50),
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
          border: Border.all(color: AppColors.glassBorder),
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
                    '${apps.length} apps',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Row(
                    children: [
                      SmallButton(label: 'Filter', onTap: () {}),
                      const SizedBox(width: 6),
                      SmallButton(label: 'Sort', onTap: () {}),
                    ],
                  ),
                ],
              ),
            ),
            // Table header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.bgActive.withAlpha(80),
                border: const Border(
                  top: BorderSide(color: AppColors.glassBorder),
                  bottom: BorderSide(color: AppColors.glassBorder),
                ),
              ),
              child: const Row(
                children: [
                  SizedBox(width: 52),
                  Expanded(
                    child: Text(
                      'APP',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: Text(
                      'DEVELOPER',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  SizedBox(
                    width: 80,
                    child: Text(
                      'KEYWORDS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  SizedBox(
                    width: 110,
                    child: Text(
                      'PLATFORM',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  SizedBox(
                    width: 70,
                    child: Text(
                      'RATING',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                  SizedBox(width: 36),
                ],
              ),
            ),
            // Apps list
            Expanded(
              child: ListView.builder(
                itemCount: apps.length,
                itemBuilder: (context, index) {
                  final app = apps[index];
                  return _AppRow(
                    app: app,
                    gradientIndex: index,
                    onTap: () => context.go('/apps/${app.id}'),
                  );
                },
              ),
            ),
          ],
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: AppColors.bgHover,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
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
              // App name
              Expanded(
                child: Text(
                  app.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Developer
              SizedBox(
                width: 120,
                child: Text(
                  app.developer ?? '--',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 16),
              // Keywords count
              SizedBox(
                width: 80,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accentMuted,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${app.trackedKeywordsCount ?? 0}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Platform badge
              SizedBox(
                width: 110,
                child: Row(
                  children: [
                    if (app.isIos)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          color: AppColors.textMuted.withAlpha(30),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'iOS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    if (app.isAndroid)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.green.withAlpha(30),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Android',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.green,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Rating
              SizedBox(
                width: 70,
                child: Row(
                  children: [
                    if (app.rating != null) ...[
                      const Icon(Icons.star_rounded, size: 16, color: AppColors.yellow),
                      const SizedBox(width: 4),
                      Text(
                        app.rating!.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ] else
                      const Text(
                        '--',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                      ),
                  ],
                ),
              ),
              // Arrow
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

