import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/api/api_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/country_provider.dart';
import '../domain/insight_model.dart';
import '../data/insights_repository.dart';

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
        const SnackBar(content: Text('Select at least one country')),
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassPanel,
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
    return Container(
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
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.accent.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.insights_rounded, size: 18, color: AppColors.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.appName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const Text(
                  'Review Insights',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateSection() {
    final countries = ref.watch(countriesProvider).valueOrNull ?? availableCountries;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgActive.withAlpha(50),
        border: Border.all(color: AppColors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Generate Analysis',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
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
                selectedColor: AppColors.accentMuted,
                checkmarkColor: AppColors.accent,
                backgroundColor: AppColors.bgActive,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.accent : AppColors.textSecondary,
                  fontSize: 12,
                ),
                side: BorderSide(
                  color: isSelected ? AppColors.accent : AppColors.glassBorder,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          // Period selector
          Row(
            children: [
              const Text(
                'Period:',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 12),
              _PeriodChip(label: '3 months', value: 3, selected: _periodMonths, onTap: () => setState(() => _periodMonths = 3)),
              const SizedBox(width: 8),
              _PeriodChip(label: '6 months', value: 6, selected: _periodMonths, onTap: () => setState(() => _periodMonths = 6)),
              const SizedBox(width: 8),
              _PeriodChip(label: '12 months', value: 12, selected: _periodMonths, onTap: () => setState(() => _periodMonths = 12)),
              const Spacer(),
              // Generate button - hidden if insight < 24h
              if (!_isInsightRecent)
                Material(
                  color: AppColors.accent,
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
                          : const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.auto_awesome, size: 16, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Analyze',
                                  style: TextStyle(
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.redMuted,
        border: Border.all(color: AppColors.red.withAlpha(50)),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.red, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _error!,
              style: const TextStyle(color: AppColors.red, fontSize: 13),
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
    final dateFormat = DateFormat('d MMM yyyy');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bgActive.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.textMuted),
          const SizedBox(width: 8),
          Text(
            '${insight.reviewsCount} reviews',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 12),
          Text(
            insight.countries.join(', '),
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 12),
          Text(
            '${dateFormat.format(insight.periodStart)} - ${dateFormat.format(insight.periodEnd)}',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const Spacer(),
          Text(
            'Analyzed ${_timeAgo(insight.analyzedAt)}',
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteSection(AppInsight insight) {
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
            const SnackBar(
              content: Text('Note saved'),
              backgroundColor: AppColors.green,
              duration: Duration(seconds: 1),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.red),
          );
        }
      }
    }

    if (_isEditingNote) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.bgActive.withAlpha(50),
          border: Border.all(color: AppColors.accent),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.edit_note_rounded, size: 16, color: AppColors.accent),
                const SizedBox(width: 8),
                const Text(
                  'Your Notes',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Material(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(6),
                  child: InkWell(
                    onTap: saveNote,
                    borderRadius: BorderRadius.circular(6),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Text(
                        'Save',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
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
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.close_rounded, size: 16, color: AppColors.textMuted),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.bgBase,
                border: Border.all(color: AppColors.glassBorder),
                borderRadius: BorderRadius.circular(6),
              ),
              child: TextField(
                controller: _noteController,
                maxLines: 3,
                style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Add your notes about this insight analysis...',
                  hintStyle: TextStyle(color: AppColors.textMuted),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
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
        hoverColor: AppColors.bgHover,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.bgActive.withAlpha(30),
            border: Border.all(color: AppColors.glassBorder),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                hasNote ? Icons.sticky_note_2_rounded : Icons.edit_note_rounded,
                size: 16,
                color: hasNote ? AppColors.accent : AppColors.textMuted,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: hasNote
                    ? Text(
                        insight.note!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      )
                    : Text(
                        'Click to add notes...',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted.withAlpha(150),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
              ),
              Icon(
                Icons.edit_rounded,
                size: 14,
                color: AppColors.textMuted.withAlpha(100),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStrengthsCard(AppInsight insight) {
    return _buildListCard(
      title: 'Strengths',
      icon: Icons.thumb_up_rounded,
      iconColor: AppColors.green,
      items: insight.overallStrengths,
      bgColor: AppColors.greenMuted,
    );
  }

  Widget _buildWeaknessesCard(AppInsight insight) {
    return _buildListCard(
      title: 'Weaknesses',
      icon: Icons.thumb_down_rounded,
      iconColor: AppColors.red,
      items: insight.overallWeaknesses,
      bgColor: AppColors.redMuted,
    );
  }

  Widget _buildListCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<String> items,
    required Color bgColor,
  }) {
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
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
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
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgActive.withAlpha(50),
        border: Border.all(color: AppColors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Category Scores',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
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
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergentThemes(AppInsight insight) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgActive.withAlpha(50),
        border: Border.all(color: AppColors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Emergent Themes',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...insight.emergentThemes.map((theme) => _EmergentThemeCard(theme: theme)),
        ],
      ),
    );
  }

  Widget _buildOpportunities(AppInsight insight) {
    return _buildListCard(
      title: 'Opportunities',
      icon: Icons.lightbulb_rounded,
      iconColor: AppColors.yellow,
      items: insight.opportunities,
      bgColor: AppColors.yellow.withAlpha(30),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
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
    final isSelected = value == selected;
    return Material(
      color: isSelected ? AppColors.accent : AppColors.bgActive,
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
              color: isSelected ? Colors.white : AppColors.textSecondary,
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

  const _CategoryScoreCard({
    required this.category,
    required this.score,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final color = score >= 4
        ? AppColors.green
        : score >= 3
            ? AppColors.yellow
            : AppColors.red;

    final categoryLabels = {
      'ux': 'UX / Interface',
      'performance': 'Performance',
      'features': 'Features',
      'pricing': 'Pricing',
      'support': 'Support',
      'onboarding': 'Onboarding',
    };

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
                categoryLabels[category] ?? category,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
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
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
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

  const _EmergentThemeCard({required this.theme});

  @override
  State<_EmergentThemeCard> createState() => _EmergentThemeCardState();
}

class _EmergentThemeCardState extends State<_EmergentThemeCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final sentimentColor = theme.sentiment == 'positive'
        ? AppColors.green
        : theme.sentiment == 'negative'
            ? AppColors.red
            : AppColors.yellow;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.bgActive.withAlpha(50),
        border: Border.all(color: AppColors.glassBorder),
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
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.bgActive,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${theme.frequency}x',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      size: 18,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  theme.summary,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                if (_expanded && theme.exampleQuotes.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.glassBorder, height: 1),
                  const SizedBox(height: 12),
                  const Text(
                    'Example quotes:',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...theme.exampleQuotes.map((quote) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          '"$quote"',
                          style: const TextStyle(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            color: AppColors.textSecondary,
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
