import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../data/reviews_repository.dart';
import '../../domain/review_model.dart';
import '../../providers/reviews_provider.dart';

class ReplyModal extends ConsumerStatefulWidget {
  final Review review;
  final VoidCallback? onSuccess;

  const ReplyModal({
    super.key,
    required this.review,
    this.onSuccess,
  });

  @override
  ConsumerState<ReplyModal> createState() => _ReplyModalState();
}

class _ReplyModalState extends ConsumerState<ReplyModal> {
  final _controller = TextEditingController();
  bool _isGenerating = false;
  bool _isSending = false;
  String? _error;

  // AI suggestions state
  AiReplyResponse? _aiResponse;
  ReplyTone _selectedTone = ReplyTone.professional;

  static const int _maxChars = 5970; // Apple limit

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _generateAiSuggestions() async {
    if (widget.review.app == null) return;

    setState(() {
      _isGenerating = true;
      _error = null;
    });

    try {
      final repository = ref.read(reviewsRepositoryProvider);
      final response = await repository.suggestReply(
        appId: widget.review.app!.id,
        reviewId: widget.review.id,
      );

      setState(() {
        _aiResponse = response;
        // Auto-select the first suggestion
        if (response.suggestions.isNotEmpty) {
          _selectedTone = response.suggestions.first.tone;
          _controller.text = response.suggestions.first.content;
        }
      });
    } catch (e) {
      setState(() {
        _error = context.l10n.reviewsInbox_aiError(e.toString());
      });
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  void _selectTone(ReplyTone tone) {
    if (_aiResponse == null) return;

    final suggestion = _aiResponse!.suggestions.firstWhere(
      (s) => s.tone == tone,
      orElse: () => _aiResponse!.suggestions.first,
    );

    setState(() {
      _selectedTone = tone;
      _controller.text = suggestion.content;
    });
  }

  Future<void> _sendReply() async {
    if (widget.review.app == null) return;
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _isSending = true;
      _error = null;
    });

    try {
      final repository = ref.read(reviewsRepositoryProvider);
      await repository.replyToReview(
        appId: widget.review.app!.id,
        reviewId: widget.review.id,
        response: _controller.text.trim(),
      );

      // Invalidate the inbox provider to refresh the list
      ref.invalidate(reviewsInboxProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.reviewsInbox_replySent),
            backgroundColor: context.colors.green,
          ),
        );
        Navigator.of(context).pop();
        widget.onSuccess?.call();
      }
    } catch (e) {
      setState(() {
        _error = context.l10n.reviewsInbox_replyError(e.toString());
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  String _getToneLabel(ReplyTone tone) {
    switch (tone) {
      case ReplyTone.professional:
        return context.l10n.reviewsInbox_toneProfessional;
      case ReplyTone.empathetic:
        return context.l10n.reviewsInbox_toneEmpathetic;
      case ReplyTone.brief:
        return context.l10n.reviewsInbox_toneBrief;
    }
  }

  IconData _getToneIcon(ReplyTone tone) {
    switch (tone) {
      case ReplyTone.professional:
        return Icons.business_center_outlined;
      case ReplyTone.empathetic:
        return Icons.favorite_outline;
      case ReplyTone.brief:
        return Icons.short_text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final charCount = _controller.text.length;

    return Dialog(
      backgroundColor: colors.glassPanel,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
        side: BorderSide(color: colors.glassBorder),
      ),
      child: Container(
        width: 560,
        constraints: const BoxConstraints(maxHeight: 700),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.reply,
                  color: colors.accent,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    context.l10n.reviewsInbox_replyModalTitle,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: colors.textMuted),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Review summary
            _buildReviewSummary(context),

            const SizedBox(height: 16),

            // AI Suggestions section
            if (widget.review.app != null) ...[
              _buildAiSection(context),
              const SizedBox(height: 16),
            ],

            // Response text field
            Flexible(
              child: TextField(
                controller: _controller,
                maxLines: 6,
                maxLength: _maxChars,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: context.l10n.reviewsInbox_replyPlaceholder,
                  hintStyle: TextStyle(color: colors.textMuted),
                  filled: true,
                  fillColor: colors.bgActive.withAlpha(50),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                    borderSide: BorderSide(color: colors.glassBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                    borderSide: BorderSide(color: colors.glassBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                    borderSide: BorderSide(color: colors.accent),
                  ),
                  counterText: context.l10n.reviewsInbox_charLimit(charCount),
                  counterStyle: TextStyle(
                    color: charCount > _maxChars ? colors.red : colors.textMuted,
                    fontSize: 12,
                  ),
                ),
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),

            // Error message
            if (_error != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.red.withAlpha(20),
                  border: Border.all(color: colors.red.withAlpha(50)),
                  borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, size: 18, color: colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error!,
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    context.l10n.appDetail_cancel,
                    style: TextStyle(color: colors.textSecondary),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: _isSending ||
                          _controller.text.trim().isEmpty ||
                          charCount > _maxChars
                      ? null
                      : _sendReply,
                  icon: _isSending
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send, size: 18),
                  label: Text(
                    _isSending
                        ? context.l10n.reviewsInbox_sending
                        : context.l10n.reviewsInbox_sendReply,
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.accent,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: colors.accent.withAlpha(50),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewSummary(BuildContext context) {
    final colors = context.colors;
    final review = widget.review;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(30),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating and author
          Row(
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  index < review.rating
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  size: 14,
                  color: index < review.rating ? colors.yellow : colors.textMuted,
                );
              }),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  review.author,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          // Title
          if (review.title != null && review.title!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              review.title!,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          // Content preview
          if (review.content.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              review.content,
              style: TextStyle(
                fontSize: 12,
                color: colors.textSecondary,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAiSection(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.accent.withAlpha(10),
        border: Border.all(color: colors.accent.withAlpha(30)),
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Header
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                size: 18,
                color: colors.accent,
              ),
              const SizedBox(width: 8),
              Text(
                context.l10n.reviewsInbox_aiSuggestions,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.accent,
                ),
              ),
              const Spacer(),
              // Generate / Regenerate button
              TextButton.icon(
                onPressed: _isGenerating ? null : _generateAiSuggestions,
                icon: _isGenerating
                    ? SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colors.accent,
                        ),
                      )
                    : Icon(
                        _aiResponse != null ? Icons.refresh : Icons.auto_awesome,
                        size: 16,
                      ),
                label: Text(
                  _isGenerating
                      ? context.l10n.reviewsInbox_generating
                      : _aiResponse != null
                          ? context.l10n.reviewsInbox_regenerate
                          : context.l10n.reviewsInbox_generateAi,
                  style: const TextStyle(fontSize: 13),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: colors.accent,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),
            ],
          ),

          // Detected issues (if any)
          if (_aiResponse != null && _aiResponse!.detectedIssues.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                Text(
                  context.l10n.reviewsInbox_detectedIssues,
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textMuted,
                  ),
                ),
                ..._aiResponse!.detectedIssues.map((issue) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: colors.orange.withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.orange.withAlpha(50)),
                      ),
                      child: Text(
                        issue,
                        style: TextStyle(
                          fontSize: 11,
                          color: colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
              ],
            ),
          ],

          // Tone selector (only show if we have suggestions)
          if (_aiResponse != null && _aiResponse!.suggestions.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              context.l10n.reviewsInbox_selectTone,
              style: TextStyle(
                fontSize: 12,
                color: colors.textMuted,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: ReplyTone.values.map((tone) {
                final isSelected = _selectedTone == tone;
                final hasSuggestion =
                    _aiResponse!.suggestions.any((s) => s.tone == tone);

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    selected: isSelected,
                    onSelected: hasSuggestion ? (_) => _selectTone(tone) : null,
                    avatar: Icon(
                      _getToneIcon(tone),
                      size: 16,
                      color: isSelected ? Colors.white : colors.textSecondary,
                    ),
                    label: Text(
                      _getToneLabel(tone),
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.white : colors.textSecondary,
                      ),
                    ),
                    selectedColor: colors.accent,
                    backgroundColor: colors.bgActive.withAlpha(50),
                    side: BorderSide(
                      color: isSelected ? colors.accent : colors.glassBorder,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    labelPadding: const EdgeInsets.only(left: 4),
                  ),
                );
              }).toList(),
            ),
          ],

          // No suggestions yet - show prompt
          if (_aiResponse == null && !_isGenerating) ...[
            const SizedBox(height: 8),
            Text(
              context.l10n.reviewsInbox_aiPrompt,
              style: TextStyle(
                fontSize: 12,
                color: colors.textMuted,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Shows the reply modal dialog
Future<void> showReplyModal(
  BuildContext context,
  Review review, {
  VoidCallback? onSuccess,
}) {
  return showDialog(
    context: context,
    builder: (context) => ReplyModal(
      review: review,
      onSuccess: onSuccess,
    ),
  );
}
