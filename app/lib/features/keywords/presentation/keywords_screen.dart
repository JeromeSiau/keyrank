import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_context_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../apps/presentation/tabs/app_keywords_tab.dart';
import '../providers/global_keywords_provider.dart';

/// Keywords screen that uses the global app context.
/// - Global mode (no app selected): Shows all keywords from all apps with App column
/// - App mode (app selected): Shows keywords for that app
class KeywordsScreen extends ConsumerWidget {
  const KeywordsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedApp = ref.watch(appContextProvider);

    if (selectedApp == null) {
      return const _GlobalKeywordsView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Keywords - ${selectedApp.name}'),
      ),
      body: AppKeywordsTab(
        appId: selectedApp.id,
        app: selectedApp,
      ),
    );
  }
}

/// Global view showing keywords from all apps
class _GlobalKeywordsView extends ConsumerWidget {
  const _GlobalKeywordsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keywordsAsync = ref.watch(globalKeywordsProvider);
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keywords (All Apps)'),
      ),
      body: keywordsAsync.when(
        data: (keywords) {
          if (keywords.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: colors.accentMuted,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.key_off_rounded, size: 32, color: colors.accent),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No keywords tracked yet',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select an app to add keywords',
                    style: TextStyle(fontSize: 14, color: colors.textMuted),
                  ),
                ],
              ),
            );
          }

          // Calculate stats
          final allKeywords = keywords.map((k) => k.keyword).toList();
          final rankedKeywords = allKeywords.where((k) => k.isRanked).length;
          final improvedKeywords = allKeywords.where((k) => k.hasImproved).length;
          final declinedKeywords = allKeywords.where((k) => k.hasDeclined).length;
          final avgPosition = allKeywords.where((k) => k.isRanked).isEmpty
              ? 0.0
              : allKeywords.where((k) => k.isRanked).map((k) => k.position!).reduce((a, b) => a + b) /
                  allKeywords.where((k) => k.isRanked).length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats row
                _buildStatsRow(context, allKeywords.length, rankedKeywords, improvedKeywords, declinedKeywords, avgPosition),
                const SizedBox(height: 20),
                // Keywords table
                _GlobalKeywordsTable(keywords: keywords),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: colors.red),
              const SizedBox(height: 16),
              Text('Error loading keywords', style: TextStyle(color: colors.textSecondary)),
              const SizedBox(height: 8),
              Text(error.toString(), style: TextStyle(color: colors.textMuted, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, int total, int ranked, int improved, int declined, double avgPos) {
    final colors = context.colors;
    return Row(
      children: [
        _StatCard(
          icon: Icons.key_rounded,
          iconColor: colors.accent,
          label: 'Total',
          value: total.toString(),
        ),
        const SizedBox(width: 12),
        _StatCard(
          icon: Icons.visibility_rounded,
          iconColor: colors.green,
          label: 'Ranked',
          value: ranked.toString(),
        ),
        const SizedBox(width: 12),
        _StatCard(
          icon: Icons.trending_up_rounded,
          iconColor: colors.green,
          label: 'Improved',
          value: improved.toString(),
        ),
        const SizedBox(width: 12),
        _StatCard(
          icon: Icons.trending_down_rounded,
          iconColor: colors.red,
          label: 'Declined',
          value: declined.toString(),
        ),
        const SizedBox(width: 12),
        _StatCard(
          icon: Icons.analytics_rounded,
          iconColor: colors.yellow,
          label: 'Avg Position',
          value: avgPos > 0 ? '#${avgPos.toStringAsFixed(0)}' : '-',
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.glassPanelAlpha,
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
          border: Border.all(color: colors.glassBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: iconColor),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Table showing keywords with app column - styled like app_keywords_tab
class _GlobalKeywordsTable extends ConsumerWidget {
  final List<KeywordWithApp> keywords;

  const _GlobalKeywordsTable({required this.keywords});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    // Sort by position (ranked first)
    final sortedKeywords = List<KeywordWithApp>.from(keywords)
      ..sort((a, b) {
        if (a.keyword.position == null && b.keyword.position == null) return 0;
        if (a.keyword.position == null) return 1;
        if (b.keyword.position == null) return -1;
        return a.keyword.position!.compareTo(b.keyword.position!);
      });

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(color: colors.glassBorder),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.glassBorder)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 140,
                  child: Text(
                    'App',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Keyword',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    'Position',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: Text(
                    'Change',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: Text(
                    'Popularity',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    'Country',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Rows
          ...sortedKeywords.map((kwa) => _GlobalKeywordRow(
                data: kwa,
                onTapApp: () {
                  ref.read(appContextProvider.notifier).select(kwa.app);
                },
              )),
        ],
      ),
    );
  }
}

class _GlobalKeywordRow extends StatelessWidget {
  final KeywordWithApp data;
  final VoidCallback onTapApp;

  const _GlobalKeywordRow({
    required this.data,
    required this.onTapApp,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final keyword = data.keyword;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder.withAlpha(100))),
      ),
      child: Row(
        children: [
          // App
          SizedBox(
            width: 140,
            child: InkWell(
              onTap: onTapApp,
              borderRadius: BorderRadius.circular(4),
              child: Row(
                children: [
                  if (data.app.iconUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        data.app.iconUrl!,
                        width: 20,
                        height: 20,
                        errorBuilder: (_, _, _) => Icon(Icons.apps, size: 20, color: colors.textMuted),
                      ),
                    )
                  else
                    Icon(Icons.apps, size: 20, color: colors.textMuted),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      data.app.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Keyword name with favorite
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Icon(
                  keyword.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 18,
                  color: keyword.isFavorite ? colors.yellow : colors.textMuted,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        keyword.keyword,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: colors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (keyword.tags.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          children: keyword.tags.take(2).map((tag) => Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: tag.colorValue.withAlpha(30),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  tag.name,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: tag.colorValue,
                                  ),
                                ),
                              )).toList(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Position
          SizedBox(
            width: 80,
            child: Center(
              child: keyword.isRanked
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getPositionColor(colors, keyword.position!).withAlpha(30),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '#${keyword.position}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _getPositionColor(colors, keyword.position!),
                        ),
                      ),
                    )
                  : Text(
                      '-',
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.textMuted,
                      ),
                    ),
            ),
          ),
          // Change
          SizedBox(
            width: 70,
            child: Center(
              child: keyword.change != null && keyword.change != 0
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          keyword.change! > 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                          size: 14,
                          color: keyword.change! > 0 ? colors.green : colors.red,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${keyword.change!.abs()}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: keyword.change! > 0 ? colors.green : colors.red,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      '-',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textMuted,
                      ),
                    ),
            ),
          ),
          // Popularity
          SizedBox(
            width: 70,
            child: Center(
              child: keyword.popularity != null
                  ? _PopularityBar(popularity: keyword.popularity!)
                  : Text(
                      '-',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textMuted,
                      ),
                    ),
            ),
          ),
          // Country
          SizedBox(
            width: 60,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: colors.bgActive,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  keyword.storefront.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPositionColor(AppColorsExtension colors, int position) {
    if (position <= 3) return colors.green;
    if (position <= 10) return colors.greenBright;
    if (position <= 50) return colors.yellow;
    return colors.textSecondary;
  }
}

class _PopularityBar extends StatelessWidget {
  final int popularity;

  const _PopularityBar({required this.popularity});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final normalizedPopularity = popularity.clamp(0, 100) / 100;

    return Column(
      children: [
        Text(
          popularity.toString(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 50,
          height: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: normalizedPopularity,
              backgroundColor: colors.bgHover,
              color: _getPopularityColor(colors, popularity),
            ),
          ),
        ),
      ],
    );
  }

  Color _getPopularityColor(AppColorsExtension colors, int popularity) {
    if (popularity >= 70) return colors.green;
    if (popularity >= 40) return colors.yellow;
    return colors.red;
  }
}
