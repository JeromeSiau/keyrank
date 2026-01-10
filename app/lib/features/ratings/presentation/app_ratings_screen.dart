import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/country_provider.dart';
import '../../../core/utils/l10n_extension.dart';
import '../data/ratings_repository.dart';
import '../domain/rating_model.dart';

final appRatingsProvider = FutureProvider.family<AppRatingsResponse, int>((ref, appId) async {
  final repository = ref.watch(ratingsRepositoryProvider);
  return repository.getRatingsForApp(appId);
});

class AppRatingsScreen extends ConsumerWidget {
  final int appId;
  final String appName;

  const AppRatingsScreen({
    super.key,
    required this.appId,
    required this.appName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final ratingsAsync = ref.watch(appRatingsProvider(appId));

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
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        context.l10n.ratings_byCountry,
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
            child: ratingsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
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
                    const SizedBox(height: 20),
                    Material(
                      color: colors.accent,
                      borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                      child: InkWell(
                        onTap: () => ref.invalidate(appRatingsProvider(appId)),
                        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Text(
                            context.l10n.common_retry,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              data: (response) {
                if (response.ratings.isEmpty) {
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
                            Icons.star_outline_rounded,
                            size: 40,
                            color: colors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          context.l10n.ratings_noRatingsAvailable,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.l10n.ratings_noRatingsYet,
                          style: TextStyle(
                            fontSize: 14,
                            color: colors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Summary card
                      _SummaryCard(
                        totalRatings: response.totalRatings,
                        averageRating: response.averageRating,
                        totalRatingsLabel: context.l10n.ratings_totalRatings,
                        averageRatingLabel: context.l10n.ratings_averageRating,
                      ),
                      const SizedBox(height: 16),
                      // Ratings table
                      _RatingsTable(
                        ratings: response.ratings,
                        lastUpdated: response.lastUpdated,
                        appId: appId,
                        appName: appName,
                        countriesCountLabel: context.l10n.ratings_countriesCount(response.ratings.length),
                        updatedLabel: (date) => context.l10n.ratings_updated(date),
                        headerCountry: context.l10n.ratings_headerCountry,
                        headerRatings: context.l10n.ratings_headerRatings,
                        headerAverage: context.l10n.ratings_headerAverage,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int totalRatings;
  final double? averageRating;
  final String totalRatingsLabel;
  final String averageRatingLabel;

  const _SummaryCard({
    required this.totalRatings,
    required this.averageRating,
    required this.totalRatingsLabel,
    required this.averageRatingLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SummaryItem(
            icon: Icons.people_rounded,
            iconColor: colors.accent,
            value: _formatCount(totalRatings),
            label: totalRatingsLabel,
          ),
          Container(
            width: 1,
            height: 60,
            color: colors.glassBorder,
          ),
          _SummaryItem(
            icon: Icons.star_rounded,
            iconColor: _getRatingColor(context, averageRating),
            value: averageRating?.toStringAsFixed(2) ?? '--',
            label: averageRatingLabel,
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(2)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(2)}K';
    }
    return count.toString();
  }

  Color _getRatingColor(BuildContext context, double? rating) {
    final colors = context.colors;
    if (rating == null) return colors.textMuted;
    if (rating >= 4.5) return colors.green;
    if (rating >= 4.0) return const Color(0xFF84cc16);
    if (rating >= 3.5) return colors.yellow;
    return colors.red;
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _SummaryItem({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: iconColor),
            const SizedBox(width: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: colors.textMuted,
          ),
        ),
      ],
    );
  }
}

class _RatingsTable extends StatelessWidget {
  final List<CountryRating> ratings;
  final DateTime? lastUpdated;
  final int appId;
  final String appName;
  final String countriesCountLabel;
  final String Function(String) updatedLabel;
  final String headerCountry;
  final String headerRatings;
  final String headerAverage;

  const _RatingsTable({
    required this.ratings,
    required this.lastUpdated,
    required this.appId,
    required this.appName,
    required this.countriesCountLabel,
    required this.updatedLabel,
    required this.headerCountry,
    required this.headerRatings,
    required this.headerAverage,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  countriesCountLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                  ),
                ),
                if (lastUpdated != null)
                  Text(
                    updatedLabel(_formatDate(lastUpdated!)),
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.textMuted,
                    ),
                  ),
              ],
            ),
          ),
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: colors.bgActive.withAlpha(80),
              border: Border(
                top: BorderSide(color: colors.glassBorder),
                bottom: BorderSide(color: colors.glassBorder),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    headerCountry,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    headerRatings,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: colors.textMuted,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    headerAverage,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: colors.textMuted,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          // Ratings list
          ...ratings.map((rating) => _RatingRow(
                rating: rating,
                appId: appId,
                appName: appName,
              )),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class _RatingRow extends StatelessWidget {
  final CountryRating rating;
  final int appId;
  final String appName;

  const _RatingRow({
    required this.rating,
    required this.appId,
    required this.appName,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final flag = getFlagForStorefront(rating.country);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.push('/apps/$appId/reviews/${rating.country}?name=${Uri.encodeComponent(appName)}');
        },
        hoverColor: colors.bgHover,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: colors.glassBorder)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Text(flag, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    Text(
                      _getCountryName(rating.country),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 100,
                child: Text(
                  _formatCount(rating.ratingCount),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.textSecondary,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      rating.rating?.toStringAsFixed(2) ?? '--',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _getRatingColor(context, rating.rating),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: _getRatingColor(context, rating.rating),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: colors.textMuted,
              ),
            ],
          ),
        ),
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

  Color _getRatingColor(BuildContext context, double? rating) {
    final colors = context.colors;
    if (rating == null) return colors.textMuted;
    if (rating >= 4.5) return colors.green;
    if (rating >= 4.0) return const Color(0xFF84cc16);
    if (rating >= 3.5) return colors.yellow;
    return colors.red;
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
