import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/country_provider.dart';
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
    final ratingsAsync = ref.watch(appRatingsProvider(appId));

    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassPanel,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
      ),
      child: Column(
        children: [
          // Toolbar
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
            ),
            child: Row(
              children: [
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                  child: InkWell(
                    onTap: () => context.pop(),
                    borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                    hoverColor: AppColors.bgHover,
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.arrow_back_rounded, size: 20, color: AppColors.textMuted),
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Text(
                        'Ratings by Country',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
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
                        color: AppColors.redMuted,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.error_outline_rounded,
                        size: 32,
                        color: AppColors.red,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Error: $e',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Material(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                      child: InkWell(
                        onTap: () => ref.invalidate(appRatingsProvider(appId)),
                        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Text(
                            'Retry',
                            style: TextStyle(
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
                            color: AppColors.bgActive,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.star_outline_rounded,
                            size: 40,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'No ratings available',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'This app has no ratings yet',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textMuted,
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
                      ),
                      const SizedBox(height: 16),
                      // Ratings table
                      _RatingsTable(
                        ratings: response.ratings,
                        lastUpdated: response.lastUpdated,
                        appId: appId,
                        appName: appName,
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

  const _SummaryCard({
    required this.totalRatings,
    required this.averageRating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgActive.withAlpha(50),
        border: Border.all(color: AppColors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SummaryItem(
            icon: Icons.people_rounded,
            iconColor: AppColors.accent,
            value: _formatCount(totalRatings),
            label: 'Total Ratings',
          ),
          Container(
            width: 1,
            height: 60,
            color: AppColors.glassBorder,
          ),
          _SummaryItem(
            icon: Icons.star_rounded,
            iconColor: _getRatingColor(averageRating),
            value: averageRating?.toStringAsFixed(2) ?? '--',
            label: 'Average Rating',
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

  Color _getRatingColor(double? rating) {
    if (rating == null) return AppColors.textMuted;
    if (rating >= 4.5) return AppColors.green;
    if (rating >= 4.0) return const Color(0xFF84cc16);
    if (rating >= 3.5) return AppColors.yellow;
    return AppColors.red;
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
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: iconColor),
            const SizedBox(width: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textMuted,
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

  const _RatingsTable({
    required this.ratings,
    required this.lastUpdated,
    required this.appId,
    required this.appName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgActive.withAlpha(50),
        border: Border.all(color: AppColors.glassBorder),
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
                  '${ratings.length} countries',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (lastUpdated != null)
                  Text(
                    'Updated: ${_formatDate(lastUpdated!)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
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
                Expanded(
                  flex: 3,
                  child: Text(
                    'COUNTRY',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    'RATINGS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: AppColors.textMuted,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    'AVERAGE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: AppColors.textMuted,
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
    final flag = getFlagForStorefront(rating.country);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.push('/apps/$appId/reviews/${rating.country}?name=${Uri.encodeComponent(appName)}');
        },
        hoverColor: AppColors.bgHover,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
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
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 100,
                child: Text(
                  _formatCount(rating.ratingCount),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
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
                        color: _getRatingColor(rating.rating),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: _getRatingColor(rating.rating),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
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

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  Color _getRatingColor(double? rating) {
    if (rating == null) return AppColors.textMuted;
    if (rating >= 4.5) return AppColors.green;
    if (rating >= 4.0) return const Color(0xFF84cc16);
    if (rating >= 3.5) return AppColors.yellow;
    return AppColors.red;
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
