import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../../../core/providers/country_provider.dart';
import '../../../reviews/providers/reviews_provider.dart';
import '../../../reviews/domain/review_model.dart';
import '../../../reviews/presentation/widgets/review_card.dart';
import '../../../ratings/providers/ratings_provider.dart';
import '../../../ratings/domain/rating_model.dart';
import '../../domain/app_model.dart';

class AppReviewsTab extends ConsumerStatefulWidget {
  final int appId;
  final AppModel app;

  const AppReviewsTab({
    super.key,
    required this.appId,
    required this.app,
  });

  @override
  ConsumerState<AppReviewsTab> createState() => _AppReviewsTabState();
}

class _AppReviewsTabState extends ConsumerState<AppReviewsTab> {
  String? _selectedCountry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // Use ratings countries as the master list (more complete)
    final ratingsAsync = ref.watch(appRatingsProvider(widget.appId));
    // Also get reviews summary to show review counts
    final reviewsSummaryAsync = ref.watch(reviewsSummaryProvider(widget.appId));

    return ratingsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: colors.red),
            const SizedBox(height: 12),
            Text(
              error.toString(),
              style: TextStyle(color: colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => ref.invalidate(appRatingsProvider(widget.appId)),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.l10n.common_retry),
            ),
          ],
        ),
      ),
      data: (ratingsResponse) {
        final countries = ratingsResponse.ratings;
        if (countries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.rate_review_outlined, size: 48, color: colors.textMuted),
                const SizedBox(height: 12),
                Text(
                  'No countries tracked',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add countries to track reviews',
                  style: TextStyle(color: colors.textMuted),
                ),
              ],
            ),
          );
        }

        // Get review summaries map for quick lookup
        final reviewSummaries = reviewsSummaryAsync.valueOrNull ?? [];
        final reviewSummaryMap = {
          for (final s in reviewSummaries) s.country: s,
        };

        // Calculate totals from REVIEWS data (not ratings)
        final totalReviews = reviewSummaries.fold<int>(0, (sum, s) => sum + s.reviewCount);
        final avgReviewRating = reviewSummaries.isEmpty
            ? null
            : reviewSummaries.fold<double>(0, (sum, s) => sum + (s.avgRating * s.reviewCount)) /
                (totalReviews > 0 ? totalReviews : 1);
        final loadedCountries = reviewSummaries.length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary cards - show reviews data, not ratings
              _buildSummaryRow(
                context,
                totalReviews,
                avgReviewRating,
                countries.length,
                loadedCountries,
              ),
              const SizedBox(height: 20),
              // Country list and reviews
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Countries sidebar - use ratings countries
                  SizedBox(
                    width: 200,
                    child: _buildCountriesListFromRatings(context, countries, reviewSummaryMap),
                  ),
                  const SizedBox(width: 16),
                  // Reviews content
                  Expanded(
                    child: _selectedCountry != null
                        ? _buildReviewsForCountry(context)
                        : _buildSelectCountryPrompt(context),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    int totalReviews,
    double? avgRating,
    int totalCountries,
    int loadedCountries,
  ) {
    final colors = context.colors;
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            icon: Icons.reviews_rounded,
            iconColor: colors.accent,
            label: 'Total Reviews',
            value: totalReviews > 0 ? _formatNumber(totalReviews) : '-',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            icon: Icons.star_rounded,
            iconColor: colors.yellow,
            label: 'Avg Review Rating',
            value: avgRating != null && avgRating > 0 ? avgRating.toStringAsFixed(2) : '-',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            icon: Icons.public_rounded,
            iconColor: colors.green,
            label: 'Countries',
            value: '$loadedCountries / $totalCountries',
          ),
        ),
      ],
    );
  }

  Widget _buildCountriesListFromRatings(
    BuildContext context,
    List<CountryRating> countries,
    Map<String, CountryReviewSummary> reviewSummaryMap,
  ) {
    final colors = context.colors;
    // Sort by rating count (most ratings first)
    final sortedCountries = List.of(countries)
      ..sort((a, b) => b.ratingCount.compareTo(a.ratingCount));

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(color: colors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'By Country',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.textMuted,
              ),
            ),
          ),
          Divider(color: colors.glassBorder, height: 1),
          ...sortedCountries.map((countryRating) {
            final reviewSummary = reviewSummaryMap[countryRating.country];
            return _CountryRowFromRating(
              countryRating: countryRating,
              reviewCount: reviewSummary?.reviewCount,
              isSelected: _selectedCountry == countryRating.country,
              onTap: () => setState(() => _selectedCountry = countryRating.country),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSelectCountryPrompt(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: colors.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(color: colors.glassBorder),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.touch_app_rounded, size: 48, color: colors.textMuted),
            const SizedBox(height: 12),
            Text(
              'Select a country to view reviews',
              style: TextStyle(
                fontSize: 14,
                color: colors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsForCountry(BuildContext context) {
    final colors = context.colors;
    final reviewsAsync = ref.watch(countryReviewsProvider((appId: widget.appId, country: _selectedCountry!)));

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(color: colors.glassBorder),
      ),
      child: reviewsAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(40),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (error, _) => Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.error_outline_rounded, size: 32, color: colors.red),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: TextStyle(color: colors.textSecondary, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        data: (response) {
          if (response.reviews.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.inbox_rounded, size: 48, color: colors.textMuted),
                    const SizedBox(height: 12),
                    Text(
                      'No reviews for this country',
                      style: TextStyle(color: colors.textMuted),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Text(
                      getFlagForStorefront(_selectedCountry!),
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${response.total} reviews',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: colors.glassBorder, height: 1),
              // Reviews list
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: response.reviews.map((review) => ReviewCard(review: review)).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _SummaryCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(color: colors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountryRowFromRating extends StatelessWidget {
  final CountryRating countryRating;
  final int? reviewCount;
  final bool isSelected;
  final VoidCallback onTap;

  const _CountryRowFromRating({
    required this.countryRating,
    this.reviewCount,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: isSelected ? colors.accent.withAlpha(20) : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: colors.bgHover,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: isSelected ? colors.accent : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              Text(
                getFlagForStorefront(countryRating.country),
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      countryRating.country.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? colors.accent : colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      reviewCount != null
                          ? '$reviewCount reviews'
                          : 'Click to load',
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.textMuted,
                        fontStyle: reviewCount == null ? FontStyle.italic : FontStyle.normal,
                      ),
                    ),
                  ],
                ),
              ),
              // Rating from store
              if (countryRating.rating != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, size: 14, color: colors.yellow),
                    const SizedBox(width: 2),
                    Text(
                      countryRating.rating!.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
