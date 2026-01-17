import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/country_provider.dart';
import '../../../core/providers/app_context_provider.dart';
import '../providers/competitors_provider.dart';
import 'widgets/competitor_keywords_tab.dart';
import 'widgets/competitor_metadata_history_tab.dart';
import '../../../shared/widgets/safe_image.dart';

class CompetitorDetailScreen extends ConsumerStatefulWidget {
  final int competitorId;

  const CompetitorDetailScreen({super.key, required this.competitorId});

  @override
  ConsumerState<CompetitorDetailScreen> createState() => _CompetitorDetailScreenState();
}

class _CompetitorDetailScreenState extends ConsumerState<CompetitorDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final selectedApp = ref.watch(appContextProvider);
    final country = ref.watch(selectedCountryProvider);

    if (selectedApp == null) {
      return _buildNoAppSelected(colors);
    }

    final keywordsAsync = ref.watch(
      competitorKeywordsProvider((
        competitorId: widget.competitorId,
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
            competitorId: widget.competitorId,
            onBack: () => context.go('/competitors'),
            onRefresh: () {
              ref.invalidate(
                competitorKeywordsProvider((
                  competitorId: widget.competitorId,
                  appId: selectedApp.id,
                  country: country.code,
                )),
              );
              ref.invalidate(
                competitorMetadataHistoryProvider((
                  competitorId: widget.competitorId,
                  locale: ref.read(metadataHistoryLocaleProvider),
                  days: ref.read(metadataHistoryDaysProvider),
                  changesOnly: ref.read(metadataHistoryChangesOnlyProvider),
                )),
              );
            },
          ),
          // Tab Bar
          _TabBar(
            tabController: _tabController,
            colors: colors,
          ),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Keywords Tab
                keywordsAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  error: (e, _) => _buildErrorState(colors, 'Error loading keywords', e.toString()),
                  data: (data) => CompetitorKeywordsTab(
                    response: data,
                    competitorId: widget.competitorId,
                    userAppId: selectedApp.id,
                    country: country.code,
                  ),
                ),
                // Metadata History Tab
                CompetitorMetadataHistoryTab(
                  competitorId: widget.competitorId,
                ),
              ],
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

  Widget _buildErrorState(AppColorsExtension colors, String title, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: colors.red),
          const SizedBox(height: 16),
          Text(
            title,
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
}

class _TabBar extends StatelessWidget {
  final TabController tabController;
  final AppColorsExtension colors;

  const _TabBar({
    required this.tabController,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder)),
      ),
      child: TabBar(
        controller: tabController,
        labelColor: colors.accent,
        unselectedLabelColor: colors.textMuted,
        labelStyle: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: AppTypography.bodyMedium,
        indicatorColor: colors.accent,
        indicatorWeight: 2,
        tabs: const [
          Tab(
            icon: Icon(Icons.compare_arrows, size: 18),
            text: 'Keywords',
          ),
          Tab(
            icon: Icon(Icons.history, size: 18),
            text: 'Metadata History',
          ),
        ],
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

    String title = 'Competitor';
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
            SafeImage(
              imageUrl: iconUrl!,
              width: 32,
              height: 32,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(8),
              errorWidget: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: colors.bgActive,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.apps, size: 18, color: colors.textMuted),
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
