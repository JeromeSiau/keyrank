import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/l10n_extension.dart';
import '../providers/reviews_provider.dart';
import 'widgets/review_card.dart';
import 'widgets/reply_modal.dart';

class ReviewsInboxScreen extends ConsumerStatefulWidget {
  const ReviewsInboxScreen({super.key});

  @override
  ConsumerState<ReviewsInboxScreen> createState() => _ReviewsInboxScreenState();
}

class _ReviewsInboxScreenState extends ConsumerState<ReviewsInboxScreen> {
  // Filter states
  bool _filterUnanswered = false;
  bool _filterNegative = false;
  int? _filterRating;
  int _currentPage = 1;

  ReviewsInboxParams get _params => ReviewsInboxParams(
        status: _filterUnanswered ? 'unanswered' : null,
        sentiment: _filterNegative ? 'negative' : null,
        rating: _filterRating,
        page: _currentPage,
      );

  void _resetFilters() {
    setState(() {
      _filterUnanswered = false;
      _filterNegative = false;
      _filterRating = null;
      _currentPage = 1;
    });
  }

  void _toggleUnanswered() {
    setState(() {
      _filterUnanswered = !_filterUnanswered;
      _currentPage = 1;
    });
  }

  void _toggleNegative() {
    setState(() {
      _filterNegative = !_filterNegative;
      _currentPage = 1;
    });
  }

  void _setRatingFilter(int? rating) {
    setState(() {
      _filterRating = _filterRating == rating ? null : rating;
      _currentPage = 1;
    });
  }

  void _goToPage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final reviewsAsync = ref.watch(reviewsInboxProvider(_params));

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanel,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
      ),
      child: Column(
        children: [
          // Toolbar
          _buildToolbar(context),

          // Filter chips
          _buildFilterChips(context),

          // Content
          Expanded(
            child: reviewsAsync.when(
              loading: () => _buildLoadingState(context),
              error: (e, _) => _buildErrorState(context, e),
              data: (paginatedReviews) {
                if (paginatedReviews.reviews.isEmpty) {
                  return _buildEmptyState(context);
                }
                return _buildReviewsList(context, paginatedReviews);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    final colors = context.colors;

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.inbox_rounded,
            color: colors.accent,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            context.l10n.reviewsInbox_title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: colors.textMuted),
            onPressed: () => ref.invalidate(reviewsInboxProvider(_params)),
            tooltip: context.l10n.common_refresh,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Unanswered filter
            _FilterChip(
              label: context.l10n.reviewsInbox_filterUnanswered,
              isSelected: _filterUnanswered,
              onTap: _toggleUnanswered,
              icon: Icons.chat_bubble_outline,
            ),
            const SizedBox(width: 8),
            // Negative sentiment filter
            _FilterChip(
              label: context.l10n.reviewsInbox_filterNegative,
              isSelected: _filterNegative,
              onTap: _toggleNegative,
              icon: Icons.sentiment_dissatisfied,
            ),
            const SizedBox(width: 16),
            // Divider
            Container(
              width: 1,
              height: 24,
              color: colors.glassBorder,
            ),
            const SizedBox(width: 16),
            // Star rating filters
            ...List.generate(5, (index) {
              final rating = index + 1;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _RatingFilterChip(
                  rating: rating,
                  isSelected: _filterRating == rating,
                  onTap: () => _setRatingFilter(rating),
                ),
              );
            }),
            // Clear filters
            if (_filterUnanswered || _filterNegative || _filterRating != null) ...[
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: _resetFilters,
                icon: Icon(Icons.clear_all, size: 18, color: colors.textMuted),
                label: Text(
                  'Clear',
                  style: TextStyle(color: colors.textMuted),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final colors = context.colors;
    return Center(
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
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    final colors = context.colors;
    return Center(
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
            context.l10n.common_error(error.toString()),
            style: TextStyle(
              fontSize: 14,
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => ref.invalidate(reviewsInboxProvider(_params)),
            icon: const Icon(Icons.refresh, size: 18),
            label: Text(context.l10n.common_retry),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colors = context.colors;
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
              Icons.inbox_rounded,
              size: 40,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            context.l10n.reviewsInbox_noReviews,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.reviewsInbox_noReviewsDesc,
            style: TextStyle(
              fontSize: 14,
              color: colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsList(BuildContext context, paginatedReviews) {
    final colors = context.colors;
    final reviews = paginatedReviews.reviews;
    final totalPages = paginatedReviews.lastPage;

    return Column(
      children: [
        // Reviews list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return ReviewCard(
                review: review,
                onReply: review.isAnswered
                    ? null
                    : () => showReplyModal(context, review),
              );
            },
          ),
        ),

        // Pagination
        if (totalPages > 1)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: colors.glassBorder)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, color: colors.textMuted),
                  onPressed: _currentPage > 1
                      ? () => _goToPage(_currentPage - 1)
                      : null,
                ),
                const SizedBox(width: 8),
                ...List.generate(
                  totalPages > 5 ? 5 : totalPages,
                  (index) {
                    int pageNumber;
                    if (totalPages <= 5) {
                      pageNumber = index + 1;
                    } else {
                      // Show pages around current page
                      int start = _currentPage - 2;
                      if (start < 1) start = 1;
                      if (start + 4 > totalPages) start = totalPages - 4;
                      pageNumber = start + index;
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: _PageButton(
                        pageNumber: pageNumber,
                        isSelected: pageNumber == _currentPage,
                        onTap: () => _goToPage(pageNumber),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.chevron_right, color: colors.textMuted),
                  onPressed: _currentPage < totalPages
                      ? () => _goToPage(_currentPage + 1)
                      : null,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: isSelected ? colors.accent.withAlpha(30) : colors.bgActive,
      borderRadius: BorderRadius.circular(AppColors.radiusSmall),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? colors.accent : colors.glassBorder,
            ),
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: isSelected ? colors.accent : colors.textMuted,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? colors.accent : colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RatingFilterChip extends StatelessWidget {
  final int rating;
  final bool isSelected;
  final VoidCallback onTap;

  const _RatingFilterChip({
    required this.rating,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: isSelected ? colors.yellow.withAlpha(30) : colors.bgActive,
      borderRadius: BorderRadius.circular(AppColors.radiusSmall),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? colors.yellow : colors.glassBorder,
            ),
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.star_rounded,
                size: 16,
                color: isSelected ? colors.yellow : colors.textMuted,
              ),
              const SizedBox(width: 4),
              Text(
                '$rating',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? colors.yellow : colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageButton extends StatelessWidget {
  final int pageNumber;
  final bool isSelected;
  final VoidCallback onTap;

  const _PageButton({
    required this.pageNumber,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: isSelected ? colors.accent : Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          child: Text(
            '$pageNumber',
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.white : colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
