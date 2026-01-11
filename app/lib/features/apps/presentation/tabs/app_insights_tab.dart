import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../../insights/providers/insights_provider.dart';
import '../../../insights/data/insights_repository.dart';
import '../../../insights/domain/insight_model.dart';
import '../../domain/app_model.dart';

class AppInsightsTab extends ConsumerStatefulWidget {
  final int appId;
  final AppModel app;

  const AppInsightsTab({
    super.key,
    required this.appId,
    required this.app,
  });

  @override
  ConsumerState<AppInsightsTab> createState() => _AppInsightsTabState();
}

class _AppInsightsTabState extends ConsumerState<AppInsightsTab> {
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final insightAsync = ref.watch(appInsightProvider(widget.appId));

    return insightAsync.when(
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
              onPressed: () => ref.invalidate(appInsightProvider(widget.appId)),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.l10n.common_retry),
            ),
          ],
        ),
      ),
      data: (insight) {
        if (insight == null) {
          return _buildNoInsightsView(context);
        }
        return _buildInsightsContent(context, insight);
      },
    );
  }

  Widget _buildNoInsightsView(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colors.accent.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 40,
                color: colors.accent,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'AI Insights',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Get AI-powered analysis of your app\'s reviews. Discover strengths, weaknesses, and opportunities.',
              style: TextStyle(
                fontSize: 14,
                color: colors.textMuted,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _isGenerating
                ? Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        context.l10n.insights_analyzingReviews,
                        style: TextStyle(color: colors.textMuted),
                      ),
                    ],
                  )
                : FilledButton.icon(
                    onPressed: _generateInsights,
                    icon: const Icon(Icons.auto_awesome_rounded),
                    label: Text(context.l10n.insights_generateAnalysis),
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateInsights() async {
    setState(() => _isGenerating = true);
    try {
      final repository = ref.read(insightsRepositoryProvider);
      await repository.generateInsights(
        appId: widget.appId,
        countries: ['us'], // Default country
        periodMonths: 6,
      );
      ref.invalidate(appInsightProvider(widget.appId));
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  Widget _buildInsightsContent(BuildContext context, AppInsight insight) {
    final colors = context.colors;
    final dateFormat = DateFormat('d MMM yyyy');

    // Compute overall score from category scores
    final overallScore = insight.categoryScores.isNotEmpty
        ? insight.categoryScores.values.map((c) => c.score).reduce((a, b) => a + b) /
            insight.categoryScores.length
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with refresh button
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colors.accent.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.auto_awesome_rounded, size: 22, color: colors.accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Analysis',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      'Analyzed ${dateFormat.format(insight.analyzedAt)} • ${insight.reviewsCount} reviews',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: _generateInsights,
                icon: Icon(Icons.refresh_rounded, size: 18, color: colors.accent),
                label: Text('Regenerate', style: TextStyle(color: colors.accent)),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Overall Score
          if (overallScore != null) ...[
            _buildOverallScoreCard(context, overallScore),
            const SizedBox(height: 20),
          ],

          // Two column layout for strengths and weaknesses
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildSectionCard(
                  context,
                  title: context.l10n.insights_strengths,
                  icon: Icons.thumb_up_rounded,
                  iconColor: colors.green,
                  bgColor: colors.greenMuted,
                  items: insight.overallStrengths,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSectionCard(
                  context,
                  title: context.l10n.insights_weaknesses,
                  icon: Icons.thumb_down_rounded,
                  iconColor: colors.red,
                  bgColor: colors.redMuted,
                  items: insight.overallWeaknesses,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Category Scores
          _buildCategoryScoresCard(context, insight.categoryScores),
          const SizedBox(height: 20),

          // Opportunities
          if (insight.opportunities.isNotEmpty)
            _buildSectionCard(
              context,
              title: context.l10n.insights_opportunities,
              icon: Icons.lightbulb_rounded,
              iconColor: colors.yellow,
              bgColor: colors.yellow.withAlpha(30),
              items: insight.opportunities,
            ),
          const SizedBox(height: 20),

          // Emergent Themes
          if (insight.emergentThemes.isNotEmpty) _buildThemesCard(context, insight.emergentThemes),

          // Notes
          if (insight.note != null && insight.note!.isNotEmpty) ...[
            const SizedBox(height: 20),
            _buildNotesCard(context, insight.note!),
          ],
        ],
      ),
    );
  }

  Widget _buildOverallScoreCard(BuildContext context, double score) {
    final colors = context.colors;
    final scoreColor = score >= 4.0
        ? colors.green
        : score >= 3.0
            ? colors.yellow
            : colors.red;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scoreColor.withAlpha(20),
            scoreColor.withAlpha(5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(color: scoreColor.withAlpha(50)),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: scoreColor.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                score.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: scoreColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overall Score',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getScoreDescription(score),
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: score / 5,
                    backgroundColor: colors.bgHover,
                    color: scoreColor,
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getScoreDescription(double score) {
    if (score >= 4.5) return 'Excellent - Users love your app!';
    if (score >= 4.0) return 'Very Good - Above average performance';
    if (score >= 3.5) return 'Good - Some room for improvement';
    if (score >= 3.0) return 'Average - Consider addressing issues';
    if (score >= 2.0) return 'Below Average - Significant improvements needed';
    return 'Poor - Major issues to address';
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required List<String> items,
  }) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor.withAlpha(30),
        border: Border.all(color: bgColor),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            Text(
              'No data available',
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: colors.textMuted,
              ),
            )
          else
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '•',
                        style: TextStyle(color: iconColor, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 13,
                            color: colors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }

  Widget _buildCategoryScoresCard(BuildContext context, Map<String, CategoryScore> categoryScores) {
    final colors = context.colors;
    final categoryLabels = {
      'ux': context.l10n.insights_categoryUxFull,
      'performance': context.l10n.insights_categoryPerformance,
      'features': context.l10n.insights_categoryFeatures,
      'pricing': context.l10n.insights_categoryPricing,
      'support': context.l10n.insights_categorySupport,
      'onboarding': context.l10n.insights_categoryOnboarding,
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.glassPanelAlpha,
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.category_rounded, size: 20, color: colors.accent),
              const SizedBox(width: 8),
              Text(
                context.l10n.insights_categoryScores,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...categoryScores.entries.map((entry) {
            final score = entry.value.score;
            final color = score >= 4
                ? colors.green
                : score >= 3
                    ? colors.yellow
                    : colors.red;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        categoryLabels[entry.key] ?? entry.key,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: colors.textSecondary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          score.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: score / 5,
                      backgroundColor: colors.bgHover,
                      color: color,
                      minHeight: 6,
                    ),
                  ),
                  if (entry.value.summary.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      entry.value.summary,
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.textMuted,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildThemesCard(BuildContext context, List<EmergentTheme> themes) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.glassPanelAlpha,
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bubble_chart_rounded, size: 20, color: colors.accent),
              const SizedBox(width: 8),
              Text(
                context.l10n.insights_emergentThemes,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...themes.map((theme) {
            final sentimentColor = theme.sentiment == 'positive'
                ? colors.green
                : theme.sentiment == 'negative'
                    ? colors.red
                    : colors.yellow;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: sentimentColor.withAlpha(10),
                border: Border.all(color: sentimentColor.withAlpha(30)),
                borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: sentimentColor.withAlpha(30),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          theme.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: sentimentColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${theme.frequency} mentions',
                        style: TextStyle(
                          fontSize: 11,
                          color: colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  if (theme.summary.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      theme.summary,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNotesCard(BuildContext context, String note) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.glassPanelAlpha,
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.note_rounded, size: 20, color: colors.accent),
              const SizedBox(width: 8),
              Text(
                context.l10n.insights_yourNotes,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            note,
            style: TextStyle(
              fontSize: 13,
              color: colors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
