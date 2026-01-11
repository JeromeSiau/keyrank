import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../providers/chat_provider.dart';

class SuggestedQuestionsWidget extends ConsumerWidget {
  final int appId;
  final Function(String) onQuestionSelected;

  const SuggestedQuestionsWidget({
    super.key,
    required this.appId,
    required this.onQuestionSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final suggestionsAsync = ref.watch(suggestedQuestionsProvider(appId));

    return suggestionsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (suggestions) {
        if (suggestions.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.chat_suggestedQuestions,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final category in suggestions)
                  for (final question in category.questions)
                    _SuggestionChip(
                      question: question,
                      category: category.category,
                      onTap: () => onQuestionSelected(question),
                    ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String question;
  final String category;
  final VoidCallback onTap;

  const _SuggestionChip({
    required this.question,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    IconData icon;
    Color chipColor;

    switch (category) {
      case 'reviews':
        icon = Icons.rate_review_outlined;
        chipColor = colors.yellow;
        break;
      case 'rankings':
        icon = Icons.trending_up;
        chipColor = colors.green;
        break;
      case 'analytics':
        icon = Icons.analytics_outlined;
        chipColor = colors.accent;
        break;
      case 'competitors':
        icon = Icons.groups_outlined;
        chipColor = colors.purple;
        break;
      default:
        icon = Icons.help_outline;
        chipColor = colors.textMuted;
    }

    return Material(
      color: colors.bgActive,
      borderRadius: BorderRadius.circular(AppColors.radiusSmall),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: colors.glassBorder),
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: chipColor),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  question,
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
