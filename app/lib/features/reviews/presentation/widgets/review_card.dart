import 'package:flutter/material.dart';
import '../../../../core/providers/country_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../domain/review_model.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  final VoidCallback? onReply;

  const ReviewCard({
    super.key,
    required this.review,
    this.onReply,
  });

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
          // App info row (if available)
          if (review.app != null) ...[
            _buildAppInfo(context, review.app!),
            const SizedBox(height: 12),
            Divider(color: colors.glassBorder, height: 1),
            const SizedBox(height: 12),
          ],

          // Header: Rating + Author + Country + Date
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
              // Country flag
              Text(
                getFlagForStorefront(review.country),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 8),
              // Version & Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (review.version != null)
                    Text(
                      context.l10n.reviews_version(review.version!),
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

          // Response section or Reply button
          const SizedBox(height: 12),
          if (review.isAnswered) ...[
            _buildResponseBox(context),
          ] else if (onReply != null) ...[
            _buildReplyButton(context),
          ],
        ],
      ),
    );
  }

  Widget _buildAppInfo(BuildContext context, ReviewApp app) {
    final colors = context.colors;

    return Row(
      children: [
        // App icon
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: app.iconUrl != null
              ? Image.network(
                  app.iconUrl!,
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _buildPlaceholderIcon(colors),
                )
              : _buildPlaceholderIcon(colors),
        ),
        const SizedBox(width: 10),
        // App name and platform
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                app.name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                app.platform.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  color: colors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderIcon(AppColorsExtension colors) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: colors.bgActive,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.apps,
        size: 18,
        color: colors.textMuted,
      ),
    );
  }

  Widget _buildResponseBox(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.green.withAlpha(20),
        border: Border.all(color: colors.green.withAlpha(50)),
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 16,
                color: colors.green,
              ),
              const SizedBox(width: 6),
              Text(
                context.l10n.reviewsInbox_responded,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.green,
                ),
              ),
              const Spacer(),
              if (review.respondedAt != null)
                Text(
                  _formatDate(context, review.respondedAt!),
                  style: TextStyle(
                    fontSize: 11,
                    color: colors.green.withAlpha(180),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.ourResponse!,
            style: TextStyle(
              fontSize: 13,
              color: colors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReplyButton(BuildContext context) {
    final colors = context.colors;

    return Align(
      alignment: Alignment.centerRight,
      child: FilledButton.icon(
        onPressed: onReply,
        icon: const Icon(Icons.reply, size: 18),
        label: Text(context.l10n.reviewsInbox_reply),
        style: FilledButton.styleFrom(
          backgroundColor: colors.accent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
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
