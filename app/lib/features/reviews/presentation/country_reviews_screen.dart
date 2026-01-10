import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/country_provider.dart';
import '../../../core/utils/l10n_extension.dart';
import '../data/reviews_repository.dart';
import '../domain/review_model.dart';

final countryReviewsProvider = FutureProvider.family<ReviewsResponse, ({int appId, String country})>((ref, params) async {
  final repository = ref.watch(reviewsRepositoryProvider);
  return repository.getReviewsForCountry(params.appId, params.country);
});

class CountryReviewsScreen extends ConsumerWidget {
  final int appId;
  final String appName;
  final String country;

  const CountryReviewsScreen({
    super.key,
    required this.appId,
    required this.appName,
    required this.country,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final reviewsAsync = ref.watch(countryReviewsProvider((appId: appId, country: country)));
    final flag = getFlagForStorefront(country);
    final countryName = _getCountryName(country);

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanel,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
      ),
      child: Column(
        children: [
          // Toolbar
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.glassBorder)),
            ),
            child: Row(
              children: [
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                  child: InkWell(
                    onTap: () => context.pop(),
                    borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                    hoverColor: colors.bgHover,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(Icons.arrow_back_rounded, size: 20, color: colors.textMuted),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(flag, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        countryName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        context.l10n.reviews_reviewsFor(appName),
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: reviewsAsync.when(
              loading: () => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(strokeWidth: 2),
                    const SizedBox(height: 16),
                    Text(
                      context.l10n.reviews_loading,
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              error: (e, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: colors.redMuted,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.error_outline_rounded,
                        size: 32,
                        color: colors.red,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      context.l10n.common_error(e.toString()),
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              data: (response) {
                if (response.reviews.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: colors.bgActive,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.rate_review_outlined,
                            size: 40,
                            color: colors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          context.l10n.reviews_noReviews,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.l10n.reviews_noReviewsFor(countryName),
                          style: TextStyle(
                            fontSize: 14,
                            color: colors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: response.reviews.length + 1, // +1 for the info banner
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors.accent.withAlpha(20),
                          border: Border.all(color: colors.accent.withAlpha(50)),
                          borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline_rounded, size: 18, color: colors.accent.withAlpha(180)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                context.l10n.reviews_showingRecent(response.reviews.length),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: colors.textSecondary.withAlpha(200),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return _ReviewCard(review: response.reviews[index - 1]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getCountryName(String code) {
    final names = {
      'US': 'United States',
      'GB': 'United Kingdom',
      'FR': 'France',
      'DE': 'Germany',
      'JP': 'Japan',
      'CN': 'China',
      'KR': 'South Korea',
      'AU': 'Australia',
      'CA': 'Canada',
      'IT': 'Italy',
      'ES': 'Spain',
      'NL': 'Netherlands',
      'BR': 'Brazil',
      'MX': 'Mexico',
      'RU': 'Russia',
      'IN': 'India',
      'SE': 'Sweden',
      'NO': 'Norway',
      'DK': 'Denmark',
      'FI': 'Finland',
      'CH': 'Switzerland',
      'AT': 'Austria',
      'BE': 'Belgium',
      'PT': 'Portugal',
      'PL': 'Poland',
      'SG': 'Singapore',
      'HK': 'Hong Kong',
      'TW': 'Taiwan',
      'TH': 'Thailand',
      'ID': 'Indonesia',
      'MY': 'Malaysia',
      'PH': 'Philippines',
      'VN': 'Vietnam',
      'ZA': 'South Africa',
      'AE': 'United Arab Emirates',
      'SA': 'Saudi Arabia',
      'TR': 'Turkey',
      'IL': 'Israel',
      'EG': 'Egypt',
      'AR': 'Argentina',
      'CL': 'Chile',
      'CO': 'Colombia',
      'PE': 'Peru',
      'NZ': 'New Zealand',
    };
    return names[code.toUpperCase()] ?? code;
  }
}

class _ReviewCard extends StatelessWidget {
  final Review review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Rating + Author + Date
          Row(
            children: [
              // Star rating
              _StarRating(rating: review.rating),
              const SizedBox(width: 12),
              // Author
              Expanded(
                child: Text(
                  review.author,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Version & Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (review.version != null)
                    Text(
                      'v${review.version}',
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.textMuted,
                      ),
                    ),
                  Text(
                    _formatDate(context, review.reviewedAt),
                    style: TextStyle(
                      fontSize: 11,
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Title
          if (review.title != null && review.title!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              review.title!,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ],
          // Content
          if (review.content.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              review.content,
              style: TextStyle(
                fontSize: 14,
                color: colors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return context.l10n.reviews_today;
    } else if (diff.inDays == 1) {
      return context.l10n.reviews_yesterday;
    } else if (diff.inDays < 7) {
      return context.l10n.reviews_daysAgo(diff.inDays);
    } else if (diff.inDays < 30) {
      return context.l10n.reviews_weeksAgo((diff.inDays / 7).floor());
    } else if (diff.inDays < 365) {
      return context.l10n.reviews_monthsAgo((diff.inDays / 30).floor());
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class _StarRating extends StatelessWidget {
  final int rating;

  const _StarRating({required this.rating});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
          size: 16,
          color: index < rating ? colors.yellow : colors.textMuted,
        );
      }),
    );
  }
}
