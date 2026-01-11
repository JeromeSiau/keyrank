import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../shared/widgets/star_histogram.dart';
import '../../../shared/widgets/country_distribution.dart';
import '../../apps/domain/app_model.dart';
import '../../apps/providers/apps_provider.dart';

class RatingsAnalysisScreen extends ConsumerWidget {
  const RatingsAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final appsAsync = ref.watch(appsNotifierProvider);

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanel,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
      ),
      child: Column(
        children: [
          // Toolbar
          _buildToolbar(context, ref),
          // Content
          Expanded(
            child: appsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text(
                  'Error: $e',
                  style: TextStyle(color: colors.textPrimary),
                ),
              ),
              data: (apps) => _buildContent(context, apps),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder)),
      ),
      child: Row(
        children: [
          Icon(Icons.star_rounded, color: colors.yellow, size: 24),
          const SizedBox(width: 12),
          Text(
            context.l10n.nav_ratingsAnalysis,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: colors.textMuted),
            onPressed: () => ref.invalidate(appsNotifierProvider),
            tooltip: context.l10n.common_refresh,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<AppModel> apps) {
    // Calculate aggregate stats from apps
    final totalRatings =
        apps.fold<int>(0, (sum, app) => sum + app.ratingCount);
    final avgRating = apps.isEmpty
        ? 0.0
        : apps.fold<double>(0, (sum, app) => sum + (app.rating ?? 0)) /
            apps.length;

    // Mock distribution (would come from API aggregation)
    final mockDistribution = _getMockDistribution(totalRatings);

    // Mock country data
    final mockCountries = [
      CountryData(code: 'us', name: 'United States', percent: 38.5),
      CountryData(code: 'gb', name: 'United Kingdom', percent: 12.3),
      CountryData(code: 'de', name: 'Germany', percent: 9.8),
      CountryData(code: 'fr', name: 'France', percent: 7.2),
      CountryData(code: 'jp', name: 'Japan', percent: 5.6),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left column
                    Expanded(
                      child: _buildCurrentRatingCard(
                          context, avgRating, totalRatings),
                    ),
                    const SizedBox(width: 20),
                    // Right column
                    Expanded(
                      flex: 2,
                      child: _buildDistributionCard(context, mockDistribution),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    _buildCurrentRatingCard(context, avgRating, totalRatings),
                    const SizedBox(height: 20),
                    _buildDistributionCard(context, mockDistribution),
                  ],
                ),
              const SizedBox(height: 20),
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildByCountryCard(context, mockCountries)),
                    const SizedBox(width: 20),
                    Expanded(child: _buildTrendCard(context)),
                  ],
                )
              else
                Column(
                  children: [
                    _buildByCountryCard(context, mockCountries),
                    const SizedBox(height: 20),
                    _buildTrendCard(context),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentRatingCard(
      BuildContext context, double avgRating, int totalRatings) {
    final colors = context.colors;
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Rating',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          RatingSummary(
            averageRating: avgRating,
            totalRatings: totalRatings,
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionCard(
      BuildContext context, Map<int, int> distribution) {
    final colors = context.colors;
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Distribution',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          StarHistogram(
            fiveStars: distribution[5] ?? 0,
            fourStars: distribution[4] ?? 0,
            threeStars: distribution[3] ?? 0,
            twoStars: distribution[2] ?? 0,
            oneStar: distribution[1] ?? 0,
          ),
        ],
      ),
    );
  }

  Widget _buildByCountryCard(BuildContext context, List<CountryData> countries) {
    final colors = context.colors;
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'By Country',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          CountryDistribution(countries: countries),
        ],
      ),
    );
  }

  Widget _buildTrendCard(BuildContext context) {
    final colors = context.colors;
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rating Trend',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.textMuted,
                ),
              ),
              // Period selector
              Row(
                children: ['7D', '30D', '90D'].map((period) {
                  final isSelected = period == '30D';
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colors.accent.withAlpha(30)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        period,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? colors.accent : colors.textMuted,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Placeholder for chart
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: colors.bgHover,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'Rating trend chart',
                style: TextStyle(color: colors.textMuted),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<int, int> _getMockDistribution(int total) {
    // Generate realistic distribution based on total
    return {
      5: (total * 0.65).round(),
      4: (total * 0.18).round(),
      3: (total * 0.08).round(),
      2: (total * 0.04).round(),
      1: (total * 0.05).round(),
    };
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(color: colors.glassBorder),
      ),
      child: child,
    );
  }
}
