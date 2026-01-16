import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/country_provider.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/providers/app_context_provider.dart';
import '../providers/competitors_provider.dart';
import 'widgets/competitor_keywords_tab.dart';

class CompetitorDetailScreen extends ConsumerWidget {
  final int competitorId;

  const CompetitorDetailScreen({super.key, required this.competitorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final selectedApp = ref.watch(appContextProvider);
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
                competitorId: competitorId,
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
    final selectedApp = ref.watch(appContextProvider);
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
