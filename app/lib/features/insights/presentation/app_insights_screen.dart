import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/api/api_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/country_provider.dart';
import '../../../core/utils/l10n_extension.dart';
import '../domain/insight_model.dart';
import '../data/insights_repository.dart';
import 'widgets/compare_app_selector_modal.dart';

class AppInsightsScreen extends ConsumerStatefulWidget {
  final int appId;
  final String appName;

  const AppInsightsScreen({
    super.key,
    required this.appId,
    required this.appName,
  });

  @override
  ConsumerState<AppInsightsScreen> createState() => _AppInsightsScreenState();
}

class _AppInsightsScreenState extends ConsumerState<AppInsightsScreen> {
  final List<String> _selectedCountries = ['US'];
  int _periodMonths = 6;
  bool _isGenerating = false;
  AppInsight? _insight;
  String? _error;
  bool _isEditingNote = false;
  late TextEditingController _noteController;

  bool get _isInsightRecent {
    if (_insight == null) return false;
    return DateTime.now().difference(_insight!.analyzedAt).inHours < 24;
  }

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
    _loadExistingInsight();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingInsight() async {
    try {
      final repository = ref.read(insightsRepositoryProvider);
      final insight = await repository.getInsight(widget.appId);
      if (mounted) {
        setState(() {
          _insight = insight;
          _noteController.text = insight?.note ?? '';
        });
      }
    } catch (e) {
      // No existing insight
    }
  }

  Future<void> _generateInsights() async {
    if (_selectedCountries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.insights_selectCountryFirst)),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
      _error = null;
    });

    try {
      final repository = ref.read(insightsRepositoryProvider);
      final insight = await repository.generateInsights(
        appId: widget.appId,
        countries: _selectedCountries,
        periodMonths: _periodMonths,
      );
      if (mounted) {
        setState(() {
          _insight = insight;
          _noteController.text = insight.note ?? '';
          _isGenerating = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _isGenerating = false;
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
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGenerateSection(),
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    _buildError(),
                  ],
                  if (_insight != null) ...[
                    const SizedBox(height: 24),
                    _buildInsightContent(),
                  ],
                ],
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
            child: Icon(Icons.insights_rounded, size: 18, color: colors.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.appName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  context.l10n.insights_reviewInsights,
                  style: TextStyle(fontSize: 12, color: colors.textMuted),
                ),
              ],
            ),
          ),
          // Compare button
          Tooltip(
            message: _insight == null ? context.l10n.insights_generateFirst : context.l10n.insights_compareWithOther,
            child: Material(
              color: _insight != null ? colors.bgActive : Colors.transparent,
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              child: InkWell(
                onTap: _insight != null ? _openCompareModal : null,
                borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                hoverColor: colors.bgHover,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.compare_arrows_rounded,
                        size: 18,
                        color: _insight != null ? colors.textSecondary : colors.textMuted.withAlpha(100),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        context.l10n.insights_compare,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: _insight != null ? colors.textSecondary : colors.textMuted.withAlpha(100),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openCompareModal() {
    showDialog(
      context: context,
      builder: (context) => CompareAppSelectorModal(
        currentAppId: widget.appId,
        currentAppName: widget.appName,
        onCompare: (selectedAppIds) {
          final allIds = [widget.appId, ...selectedAppIds];
          context.go('/apps/compare?ids=${allIds.join(',')}');
        },
      ),
    );
  }

  Widget _buildGenerateSection() {
    final colors = context.colors;
    final countries = ref.watch(countriesProvider).valueOrNull ?? availableCountries;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.insights_generateAnalysis,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          // Country selector
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: countries.take(10).map((country) {
              final isSelected = _selectedCountries.contains(country.code.toUpperCase());
              return FilterChip(
                label: Text('${country.flag} ${country.code}'),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedCountries.add(country.code.toUpperCase());
                    } else {
                      _selectedCountries.remove(country.code.toUpperCase());
                    }
                  });
                },
                selectedColor: colors.accentMuted,
                checkmarkColor: colors.accent,
                backgroundColor: colors.bgActive,
                labelStyle: TextStyle(
                  color: isSelected ? colors.accent : colors.textSecondary,
                  fontSize: 12,
                ),
                side: BorderSide(
                  color: isSelected ? colors.accent : colors.glassBorder,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          // Period selector
          Row(
            children: [
              Text(
                context.l10n.insights_period,
                style: TextStyle(fontSize: 13, color: colors.textSecondary),
              ),
              const SizedBox(width: 12),
              _PeriodChip(label: context.l10n.insights_3months, value: 3, selected: _periodMonths, onTap: () => setState(() => _periodMonths = 3)),
              const SizedBox(width: 8),
              _PeriodChip(label: context.l10n.insights_6months, value: 6, selected: _periodMonths, onTap: () => setState(() => _periodMonths = 6)),
              const SizedBox(width: 8),
              _PeriodChip(label: context.l10n.insights_12months, value: 12, selected: _periodMonths, onTap: () => setState(() => _periodMonths = 12)),
              const Spacer(),
              // Generate button - hidden if insight < 24h
              if (!_isInsightRecent)
                Material(
                  color: colors.accent,
                  borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                  child: InkWell(
                    onTap: _isGenerating ? null : _generateInsights,
                    borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: _isGenerating
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.auto_awesome, size: 16, color: Colors.white),
                                const SizedBox(width: 8),
                                Text(
                                  context.l10n.insights_analyze,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.redMuted,
        border: Border.all(color: colors.red.withAlpha(50)),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: colors.red, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _error!,
              style: TextStyle(color: colors.red, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightContent() {
    final insight = _insight!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Metadata
        _buildMetadata(insight),
        const SizedBox(height: 16),
        // Notes
        _buildNoteSection(insight),
        const SizedBox(height: 20),
        // Strengths & Weaknesses
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildStrengthsCard(insight)),
            const SizedBox(width: 16),
            Expanded(child: _buildWeaknessesCard(insight)),
          ],
        ),
        const SizedBox(height: 20),
        // Category scores
        _buildCategoryScores(insight),
        const SizedBox(height: 20),
        // Emergent themes
        if (insight.emergentThemes.isNotEmpty) _buildEmergentThemes(insight),
        const SizedBox(height: 20),
        // Opportunities
        if (insight.opportunities.isNotEmpty) _buildOpportunities(insight),
      ],
    );
  }

  Widget _buildMetadata(AppInsight insight) {
    final colors = context.colors;
    final dateFormat = DateFormat('d MMM yyyy');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, size: 16, color: colors.textMuted),
          const SizedBox(width: 8),
          Text(
            context.l10n.insights_reviewsCount(insight.reviewsCount),
            style: TextStyle(fontSize: 12, color: colors.textSecondary),
          ),
          const SizedBox(width: 12),
          Text(
            insight.countries.join(', '),
            style: TextStyle(fontSize: 12, color: colors.textSecondary),
          ),
          const SizedBox(width: 12),
          Text(
            '${dateFormat.format(insight.periodStart)} - ${dateFormat.format(insight.periodEnd)}',
            style: TextStyle(fontSize: 12, color: colors.textSecondary),
          ),
          const Spacer(),
          Text(
            context.l10n.insights_analyzedAgo(_timeAgo(context, insight.analyzedAt)),
            style: TextStyle(fontSize: 12, color: colors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteSection(AppInsight insight) {
    final colors = context.colors;
    Future<void> saveNote() async {
      final content = _noteController.text.trim();
      try {
        final repository = ref.read(insightsRepositoryProvider);
        await repository.saveNote(insight.id, content);
        if (mounted) {
          setState(() {
            _insight = insight.copyWith(note: content.isEmpty ? null : content);
            _isEditingNote = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.insights_noteSaved),
              backgroundColor: colors.green,
              duration: const Duration(seconds: 1),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: colors.red),
          );
        }
      }
    }

    if (_isEditingNote) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.bgActive.withAlpha(50),
          border: Border.all(color: colors.accent),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.edit_note_rounded, size: 16, color: colors.accent),
                const SizedBox(width: 8),
                Text(
                  context.l10n.insights_yourNotes,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                const Spacer(),
                Material(
                  color: colors.accent,
                  borderRadius: BorderRadius.circular(6),
                  child: InkWell(
                    onTap: saveNote,
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Text(
                        context.l10n.insights_save,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  child: InkWell(
                    onTap: () {
                      _noteController.text = insight.note ?? '';
                      setState(() => _isEditingNote = false);
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(Icons.close_rounded, size: 16, color: colors.textMuted),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: colors.bgBase,
                border: Border.all(color: colors.glassBorder),
                borderRadius: BorderRadius.circular(6),
              ),
              child: TextField(
                controller: _noteController,
                maxLines: 3,
                style: TextStyle(fontSize: 13, color: colors.textPrimary),
                decoration: InputDecoration(
                  hintText: context.l10n.insights_noteHint,
                  hintStyle: TextStyle(color: colors.textMuted),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Display mode
    final hasNote = insight.note != null && insight.note!.isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _isEditingNote = true),
        borderRadius: BorderRadius.circular(8),
        hoverColor: colors.bgHover,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.bgActive.withAlpha(30),
            border: Border.all(color: colors.glassBorder),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                hasNote ? Icons.sticky_note_2_rounded : Icons.edit_note_rounded,
                size: 16,
                color: hasNote ? colors.accent : colors.textMuted,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: hasNote
                    ? Text(
                        insight.note!,
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.textSecondary,
                        ),
                      )
                    : Text(
                        context.l10n.insights_clickToAddNotes,
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.textMuted.withAlpha(150),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
              ),
              Icon(
                Icons.edit_rounded,
                size: 14,
                color: colors.textMuted.withAlpha(100),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStrengthsCard(AppInsight insight) {
    final colors = context.colors;
    return _buildListCard(
      title: context.l10n.insights_strengths,
      icon: Icons.thumb_up_rounded,
      iconColor: colors.green,
      items: insight.overallStrengths,
      bgColor: colors.greenMuted,
    );
  }

  Widget _buildWeaknessesCard(AppInsight insight) {
    final colors = context.colors;
    return _buildListCard(
      title: context.l10n.insights_weaknesses,
      icon: Icons.thumb_down_rounded,
      iconColor: colors.red,
      items: insight.overallWeaknesses,
      bgColor: colors.redMuted,
    );
  }

  Widget _buildListCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<String> items,
    required Color bgColor,
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
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('•', style: TextStyle(color: iconColor, fontSize: 14)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(fontSize: 13, color: colors.textSecondary),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.insights_categoryScores,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: insight.categoryScores.entries.map((entry) {
              return _CategoryScoreCard(
                category: entry.key,
                score: entry.value.score,
                summary: entry.value.summary,
                categoryLabel: _getCategoryLabel(entry.key),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergentThemes(AppInsight insight) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.insights_emergentThemes,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...insight.emergentThemes.map((theme) => _EmergentThemeCard(
                theme: theme,
                exampleQuotesLabel: context.l10n.insights_exampleQuotes,
              )),
        ],
      ),
    );
  }

  Widget _buildOpportunities(AppInsight insight) {
    final colors = context.colors;
    return _buildListCard(
      title: context.l10n.insights_opportunities,
      icon: Icons.lightbulb_rounded,
      iconColor: colors.yellow,
      items: insight.opportunities,
      bgColor: colors.yellow.withAlpha(30),
    );
  }

  String _timeAgo(BuildContext context, DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return context.l10n.time_minutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return context.l10n.time_hoursAgo(diff.inHours);
    return context.l10n.time_daysAgo(diff.inDays);
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'ux':
        return context.l10n.insights_categoryUxFull;
      case 'performance':
        return context.l10n.insights_categoryPerformance;
      case 'features':
        return context.l10n.insights_categoryFeatures;
      case 'pricing':
        return context.l10n.insights_categoryPricing;
      case 'support':
        return context.l10n.insights_categorySupport;
      case 'onboarding':
        return context.l10n.insights_categoryOnboarding;
      default:
        return category;
    }
  }
}

class _PeriodChip extends StatelessWidget {
  final String label;
  final int value;
  final int selected;
  final VoidCallback onTap;

  const _PeriodChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isSelected = value == selected;
    return Material(
      color: isSelected ? colors.accent : colors.bgActive,
      borderRadius: BorderRadius.circular(AppColors.radiusSmall),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryScoreCard extends StatelessWidget {
  final String category;
  final double score;
  final String summary;
  final String categoryLabel;

  const _CategoryScoreCard({
    required this.category,
    required this.score,
    required this.summary,
    required this.categoryLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = score >= 4
        ? colors.green
        : score >= 3
            ? colors.yellow
            : colors.red;

    return Container(
      width: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        border: Border.all(color: color.withAlpha(50)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                categoryLabel,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  score.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          if (summary.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              summary,
              style: TextStyle(fontSize: 11, color: colors.textSecondary),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class _EmergentThemeCard extends StatefulWidget {
  final EmergentTheme theme;
  final String exampleQuotesLabel;

  const _EmergentThemeCard({
    required this.theme,
    required this.exampleQuotesLabel,
  });

  @override
  State<_EmergentThemeCard> createState() => _EmergentThemeCardState();
}

class _EmergentThemeCardState extends State<_EmergentThemeCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = widget.theme;
    final sentimentColor = theme.sentiment == 'positive'
        ? colors.green
        : theme.sentiment == 'negative'
            ? colors.red
            : colors.yellow;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: sentimentColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        theme.label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: colors.bgActive,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${theme.frequency}x',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: colors.textMuted,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      size: 18,
                      color: colors.textMuted,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  theme.summary,
                  style: TextStyle(fontSize: 12, color: colors.textSecondary),
                ),
                if (_expanded && theme.exampleQuotes.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Divider(color: colors.glassBorder, height: 1),
                  const SizedBox(height: 12),
                  Text(
                    widget.exampleQuotesLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: colors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...theme.exampleQuotes.map((quote) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          '"$quote"',
                          style: TextStyle(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            color: colors.textSecondary,
                          ),
                        ),
                      )),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
