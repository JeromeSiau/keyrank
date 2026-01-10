import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/api/api_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/l10n_extension.dart';
import '../data/insights_repository.dart';
import '../domain/insight_model.dart';

class InsightsCompareScreen extends ConsumerStatefulWidget {
  final List<int> appIds;

  const InsightsCompareScreen({super.key, required this.appIds});

  @override
  ConsumerState<InsightsCompareScreen> createState() => _InsightsCompareScreenState();
}

class _CompareColumn {
  final int appId;
  String appName = '';
  String? iconUrl;
  String platform = '';
  String? storefront;
  AppInsight? insight;
  bool isLoading = true;
  String? error;

  _CompareColumn({required this.appId});
}

class _InsightsCompareScreenState extends ConsumerState<InsightsCompareScreen> {
  late List<_CompareColumn> _columns;

  @override
  void initState() {
    super.initState();
    _columns = widget.appIds.map((id) => _CompareColumn(appId: id)).toList();
    _loadComparisons();
  }

  Future<void> _loadComparisons() async {
    final repository = ref.read(insightsRepositoryProvider);

    try {
      final comparisons = await repository.compareApps(widget.appIds);

      for (final comparison in comparisons) {
        final index = _columns.indexWhere((c) => c.appId == comparison.appId);
        if (index != -1) {
          setState(() {
            _columns[index].appName = comparison.appName;
            _columns[index].iconUrl = comparison.iconUrl;
            _columns[index].platform = comparison.platform;
            _columns[index].storefront = comparison.storefront;
            _columns[index].insight = comparison.insight;
            _columns[index].isLoading = comparison.insight == null;
          });

          // Auto-generate if no insight
          if (comparison.insight == null) {
            _generateInsight(index);
          }
        }
      }
    } on ApiException catch (e) {
      for (var i = 0; i < _columns.length; i++) {
        setState(() {
          _columns[i].isLoading = false;
          _columns[i].error = e.message;
        });
      }
    }
  }

  Future<void> _generateInsight(int index) async {
    final repository = ref.read(insightsRepositoryProvider);
    final column = _columns[index];
    final country = column.storefront ?? 'US';

    try {
      final insight = await repository.generateInsights(
        appId: column.appId,
        countries: [country],
        periodMonths: 6,
      );

      if (mounted) {
        setState(() {
          _columns[index].insight = insight;
          _columns[index].isLoading = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _columns[index].isLoading = false;
          _columns[index].error = e.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanel,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
      ),
      child: Column(
        children: [
          _buildToolbar(),
          _buildStickyHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _columns.map((column) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: _buildColumn(column),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    final colors = context.colors;
    return Container(
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
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colors.accent.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.compare_arrows_rounded, size: 18, color: colors.accent),
          ),
          const SizedBox(width: 12),
          Text(
            context.l10n.insights_compareTitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyHeader() {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        border: Border(bottom: BorderSide(color: colors.glassBorder)),
      ),
      child: Row(
        children: _columns.map((column) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: colors.bgActive,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: column.iconUrl != null
                        ? Image.network(column.iconUrl!, fit: BoxFit.cover)
                        : Icon(
                            column.platform == 'ios' ? Icons.apple : Icons.android,
                            size: 18,
                            color: colors.textMuted,
                          ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      column.appName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildColumn(_CompareColumn column) {
    if (column.isLoading) {
      return _buildLoadingColumn();
    }

    if (column.error != null) {
      return _buildErrorColumn(column);
    }

    if (column.insight == null) {
      return _buildNoInsightColumn();
    }

    return _buildInsightColumn(column.insight!);
  }

  Widget _buildLoadingColumn() {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(30),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          const CircularProgressIndicator(strokeWidth: 2),
          const SizedBox(height: 16),
          Text(
            context.l10n.insights_analyzingReviews,
            style: TextStyle(color: colors.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildErrorColumn(_CompareColumn column) {
    final colors = context.colors;
    final index = _columns.indexOf(column);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.redMuted.withAlpha(30),
        border: Border.all(color: colors.red.withAlpha(50)),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Icon(Icons.error_outline_rounded, size: 32, color: colors.red),
          const SizedBox(height: 12),
          Text(
            column.error!,
            style: TextStyle(color: colors.red, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              setState(() {
                _columns[index].isLoading = true;
                _columns[index].error = null;
              });
              _generateInsight(index);
            },
            child: Text(context.l10n.common_retry),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildNoInsightColumn() {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(30),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(Icons.analytics_outlined, size: 32, color: colors.textMuted),
          const SizedBox(height: 12),
          Text(
            context.l10n.insights_noInsightsAvailable,
            style: TextStyle(color: colors.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildInsightColumn(AppInsight insight) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Strengths
        _buildSectionCard(
          title: context.l10n.insights_strengths,
          icon: Icons.thumb_up_rounded,
          iconColor: colors.green,
          bgColor: colors.greenMuted,
          items: insight.overallStrengths,
        ),
        const SizedBox(height: 12),
        // Weaknesses
        _buildSectionCard(
          title: context.l10n.insights_weaknesses,
          icon: Icons.thumb_down_rounded,
          iconColor: colors.red,
          bgColor: colors.redMuted,
          items: insight.overallWeaknesses,
        ),
        const SizedBox(height: 12),
        // Category Scores
        _buildCategoryScores(insight),
        const SizedBox(height: 12),
        // Opportunities
        if (insight.opportunities.isNotEmpty)
          _buildSectionCard(
            title: context.l10n.insights_opportunities,
            icon: Icons.lightbulb_rounded,
            iconColor: colors.yellow,
            bgColor: colors.yellow.withAlpha(30),
            items: insight.opportunities,
          ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required List<String> items,
  }) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(14),
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
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('•', style: TextStyle(color: iconColor, fontSize: 12)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(fontSize: 12, color: colors.textSecondary),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCategoryScores(AppInsight insight) {
    final colors = context.colors;
    final categoryLabels = {
      'ux': context.l10n.insights_categoryUx,
      'performance': context.l10n.insights_categoryPerf,
      'features': context.l10n.insights_categoryFeatures,
      'pricing': context.l10n.insights_categoryPricing,
      'support': context.l10n.insights_categorySupport,
      'onboarding': context.l10n.insights_categoryOnboard,
    };

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.insights_scores,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: insight.categoryScores.entries.map((entry) {
              final score = entry.value.score;
              final color = score >= 4
                  ? colors.green
                  : score >= 3
                      ? colors.yellow
                      : colors.red;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withAlpha(20),
                  border: Border.all(color: color.withAlpha(50)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      categoryLabels[entry.key] ?? entry.key,
                      style: TextStyle(fontSize: 11, color: colors.textSecondary),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        score.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
