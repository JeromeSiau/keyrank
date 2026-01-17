import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/breakpoints.dart';
import '../../../core/providers/app_context_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/csv_exporter.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../shared/widgets/export_dialog.dart';
import '../../../shared/widgets/metric_card.dart';
import '../../../shared/widgets/sentiment_bar.dart';
import '../domain/review_model.dart';
import '../providers/reviews_provider.dart';
import 'widgets/review_card.dart';
import 'widgets/review_intelligence_card.dart';
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
  bool _showIntelligence = true;

  ReviewsInboxParams _getParams(int? appId) => ReviewsInboxParams(
        status: _filterUnanswered ? 'unanswered' : null,
        sentiment: _filterNegative ? 'negative' : null,
        rating: _filterRating,
        appId: appId,
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
    final selectedApp = ref.watch(appContextProvider);
    final params = _getParams(selectedApp?.id);
    final reviewsAsync = ref.watch(reviewsInboxProvider(params));

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanel,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
      ),
      child: Column(
        children: [
          // Toolbar
          _buildToolbar(context, params),

          // Content with overview
          Expanded(
            child: reviewsAsync.when(
              loading: () => _buildLoadingState(context),
              error: (e, _) => _buildErrorState(context, e, params),
              data: (paginatedReviews) {
                return CustomScrollView(
                  slivers: [
                    // Review Intelligence section (when app is selected)
                    if (selectedApp != null)
                      SliverToBoxAdapter(
                        child: _buildIntelligenceSection(context, selectedApp.id),
                      ),
                    // Overview section
                    SliverToBoxAdapter(
                      child: _buildOverviewSection(context, paginatedReviews),
                    ),
                    // Filter chips
                    SliverToBoxAdapter(
                      child: _buildFilterChips(context),
                    ),
                    // Reviews list or empty state
                    if (paginatedReviews.reviews.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _buildEmptyState(context),
                      )
                    else
                      SliverToBoxAdapter(
                        child: _buildReviewsList(context, paginatedReviews),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, ReviewsInboxParams params) {
    final colors = context.colors;
    final selectedApp = ref.watch(appContextProvider);

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
          if (selectedApp != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colors.accentMuted,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                selectedApp.name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.accent,
                ),
              ),
            ),
          ],
          const Spacer(),
          IconButton(
            icon: Icon(Icons.download_rounded, color: colors.textMuted),
            onPressed: () => _showExportDialog(context, params),
            tooltip: context.l10n.export_button,
          ),
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: colors.textMuted),
            onPressed: () => ref.invalidate(reviewsInboxProvider(params)),
            tooltip: context.l10n.common_refresh,
          ),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context, ReviewsInboxParams params) {
    final reviewsAsync = ref.read(reviewsInboxProvider(params));
    final reviews = reviewsAsync.value?.reviews ?? [];
    final selectedApp = ref.read(appContextProvider);

    showDialog(
      context: context,
      builder: (context) => ExportReviewsDialog(
        reviewCount: reviews.length,
        onExport: (options) async {
          final result = await CsvExporter.exportReviews(
            reviews: reviews,
            appName: selectedApp?.name ?? 'All_Apps',
            options: options,
          );
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  result.success
                      ? context.l10n.export_success(result.filename)
                      : context.l10n.export_error(result.error ?? 'Unknown error'),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildOverviewSection(BuildContext context, PaginatedReviews data) {
    final colors = context.colors;
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrow = Breakpoints.isMobile(screenWidth);

    // Compute metrics from available data
    final totalReviews = data.total;
    final unansweredCount =
        data.reviews.where((r) => !r.isAnswered).length;
    final positiveCount =
        data.reviews.where((r) => r.sentiment == 'positive' || r.rating >= 4).length;
    final positivePercent = data.reviews.isNotEmpty
        ? (positiveCount / data.reviews.length * 100)
        : 75.0;
    final avgRating = data.reviews.isNotEmpty
        ? data.reviews.map((r) => r.rating).reduce((a, b) => a + b) /
            data.reviews.length
        : 4.2;

    final metricCards = [
      MetricCard(
        label: context.l10n.reviewsInbox_totalReviews,
        value: _formatNumber(totalReviews),
        icon: Icons.rate_review_outlined,
      ),
      MetricCard(
        label: context.l10n.reviewsInbox_unanswered,
        value: unansweredCount.toString(),
        icon: Icons.pending_outlined,
        change: unansweredCount > 0 ? null : 0.0, // Show green badge if 0
      ),
      MetricCard(
        label: context.l10n.reviewsInbox_positive,
        value: '${positivePercent.toStringAsFixed(0)}%',
        icon: Icons.sentiment_satisfied_outlined,
      ),
      MetricCard(
        label: context.l10n.reviewsInbox_avgRating,
        value: avgRating.toStringAsFixed(1),
        icon: Icons.star_outline,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Metrics row - responsive layout
          if (isNarrow)
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: metricCards
                  .map((card) => SizedBox(
                        width: (screenWidth - 56) / 2, // Account for padding
                        child: card,
                      ))
                  .toList(),
            )
          else
            Row(
              children: metricCards
                  .map((card) => Expanded(child: card))
                  .expand((widget) => [widget, const SizedBox(width: 12)])
                  .toList()
                ..removeLast(), // Remove trailing SizedBox
            ),
          const SizedBox(height: 16),
          // Sentiment bar
          Text(
            context.l10n.reviewsInbox_sentimentOverview,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 50,
            child: SentimentBar(
              positivePercent: positivePercent,
              showIcons: true,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }

  Widget _buildIntelligenceSection(BuildContext context, int appId) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder)),
      ),
      child: ExpansionTile(
        initiallyExpanded: _showIntelligence,
        onExpansionChanged: (expanded) {
          setState(() => _showIntelligence = expanded);
        },
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Icon(Icons.psychology_rounded, color: colors.purple, size: 20),
        title: Text(
          context.l10n.reviewIntelligence_title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
        trailing: Icon(
          _showIntelligence ? Icons.expand_less : Icons.expand_more,
          color: colors.textMuted,
        ),
        children: [
          ReviewIntelligenceCard(appId: appId),
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

  Widget _buildErrorState(BuildContext context, Object error, ReviewsInboxParams params) {
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
            onPressed: () => ref.invalidate(reviewsInboxProvider(params)),
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
        // Reviews list (no longer using Expanded since we're in a CustomScrollView)
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: reviews.map<Widget>((review) {
              return ReviewCard(
                review: review,
                onReply: review.canReply && !review.isAnswered
                    ? () => showReplyModal(context, review)
                    : null,
              );
            }).toList(),
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
