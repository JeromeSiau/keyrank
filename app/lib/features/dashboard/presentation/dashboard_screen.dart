import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../shared/widgets/buttons.dart';
import '../../../shared/widgets/states.dart';
import '../../../shared/widgets/metric_card.dart';
import '../../../shared/widgets/sentiment_bar.dart';
import '../../../shared/widgets/country_distribution.dart';
import '../../../shared/widgets/sparkline.dart';
import '../../../shared/widgets/data_table_enhanced.dart';
import '../../apps/domain/app_model.dart';
import '../../apps/providers/apps_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final appsAsync = ref.watch(appsNotifierProvider);

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanel,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
      ),
      child: Column(
        children: [
          // Toolbar
          _Toolbar(
            onAddApp: () => context.go('/apps/add'),
          ),
          // Content
          Expanded(
            child: appsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (e, _) => ErrorView(
                message: e.toString(),
                onRetry: () => ref.read(appsNotifierProvider.notifier).load(),
              ),
              data: (apps) => _DashboardContent(apps: apps),
            ),
          ),
        ],
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  final VoidCallback onAddApp;

  const _Toolbar({required this.onAddApp});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder)),
      ),
      child: Row(
        children: [
          Text(
            context.l10n.dashboard_title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const Spacer(),
          PrimaryButton(
            icon: Icons.add_rounded,
            label: context.l10n.dashboard_addApp,
            onTap: onAddApp,
          ),
        ],
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final List<AppModel> apps;

  const _DashboardContent({required this.apps});

  @override
  Widget build(BuildContext context) {
    final totalKeywords = apps.fold<int>(
      0,
      (sum, app) => sum + (app.trackedKeywordsCount ?? 0),
    );
    final avgRating = apps.isEmpty
        ? 0.0
        : apps.fold<double>(0, (sum, app) => sum + (app.rating ?? 0)) /
            apps.where((app) => app.rating != null).length.clamp(1, apps.length);
    final avgPosition = _calculateAvgPosition(apps);
    final totalReviews = apps.fold<int>(0, (sum, app) => sum + app.ratingCount);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1000;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Metrics Row
              _MetricsBar(
                appsCount: apps.length,
                keywordsCount: totalKeywords,
                avgPosition: avgPosition,
                reviewsCount: totalReviews,
                avgRating: avgRating,
              ),
              const SizedBox(height: 20),
              // Grid content
              if (isWide)
                _buildWideLayout(context, apps)
              else
                _buildNarrowLayout(context, apps),
            ],
          ),
        );
      },
    );
  }

  double? _calculateAvgPosition(List<AppModel> apps) {
    final appsWithRank = apps.where((app) => app.bestRank != null).toList();
    if (appsWithRank.isEmpty) return null;
    return appsWithRank.fold<int>(0, (sum, app) => sum + app.bestRank!) /
        appsWithRank.length;
  }

  Widget _buildWideLayout(BuildContext context, List<AppModel> apps) {
    return Column(
      children: [
        // Top row: Top Apps + Top Countries
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _TopPerformingAppsPanel(apps: apps),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _TopCountriesPanel(),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Bottom row: Sentiment + Quick Actions
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _SentimentOverviewPanel(),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _QuickActionsPanel(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context, List<AppModel> apps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TopPerformingAppsPanel(apps: apps),
        const SizedBox(height: 20),
        _TopCountriesPanel(),
        const SizedBox(height: 20),
        _SentimentOverviewPanel(),
        const SizedBox(height: 20),
        _QuickActionsPanel(),
      ],
    );
  }
}

class _MetricsBar extends StatelessWidget {
  final int appsCount;
  final int keywordsCount;
  final double? avgPosition;
  final int reviewsCount;
  final double avgRating;

  const _MetricsBar({
    required this.appsCount,
    required this.keywordsCount,
    required this.avgPosition,
    required this.reviewsCount,
    required this.avgRating,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 600;

        final metrics = [
          MetricCard(
            label: context.l10n.dashboard_appsTracked,
            value: appsCount.toString(),
            change: appsCount > 0 ? 12.0 : null,
            icon: Icons.apps_rounded,
          ),
          MetricCard(
            label: context.l10n.dashboard_keywords,
            value: keywordsCount.toString(),
            change: keywordsCount > 0 ? 8.5 : null,
            icon: Icons.key_rounded,
          ),
          MetricCard(
            label: context.l10n.dashboard_avgPosition,
            value: avgPosition?.toStringAsFixed(1) ?? '--',
            change: avgPosition != null ? -3.2 : null,
            icon: Icons.trending_up_rounded,
          ),
          MetricCard(
            label: context.l10n.dashboard_reviews,
            value: _formatCount(reviewsCount),
            change: reviewsCount > 0 ? 29.0 : null,
            icon: Icons.rate_review_rounded,
          ),
          MetricCard(
            label: context.l10n.dashboard_avgRating,
            value: avgRating > 0 ? avgRating.toStringAsFixed(1) : '--',
            change: avgRating > 0 ? 2.1 : null,
            icon: Icons.star_rounded,
          ),
        ];

        if (isNarrow) {
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: metrics.map((m) => SizedBox(
              width: (constraints.maxWidth - 12) / 2,
              child: m,
            )).toList(),
          );
        }

        return Row(
          children: metrics.map((m) => Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: m == metrics.last ? 0 : 12,
              ),
              child: m,
            ),
          )).toList(),
        );
      },
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}

class _TopPerformingAppsPanel extends StatelessWidget {
  final List<AppModel> apps;

  const _TopPerformingAppsPanel({required this.apps});

  // Mock sparkline data for each app
  static const List<List<double>> _mockTrends = [
    [10.0, 12.0, 11.0, 15.0, 14.0, 18.0, 17.0, 20.0],
    [20.0, 18.0, 19.0, 15.0, 16.0, 12.0, 14.0, 10.0],
    [5.0, 8.0, 7.0, 9.0, 11.0, 10.0, 13.0, 15.0],
    [15.0, 14.0, 16.0, 15.0, 17.0, 16.0, 18.0, 19.0],
    [8.0, 10.0, 9.0, 12.0, 11.0, 14.0, 13.0, 16.0],
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final topApps = apps.take(5).toList();

    if (topApps.isEmpty) {
      return _GlassPanel(
        title: context.l10n.dashboard_topPerformingApps,
        child: _EmptyStateMessage(
          icon: Icons.analytics_outlined,
          message: context.l10n.dashboard_noAppsYet,
        ),
      );
    }

    final columns = [
      const EnhancedColumn(label: 'App'),
      const EnhancedColumn(label: 'Keywords', width: 80, align: TextAlign.center),
      const EnhancedColumn(label: 'Avg Rank', width: 80, align: TextAlign.center),
      const EnhancedColumn(label: 'Trend', width: 100, align: TextAlign.center),
    ];

    final rows = topApps.asMap().entries.map((entry) {
      final index = entry.key;
      final app = entry.value;
      final trendData = _mockTrends[index % _mockTrends.length];

      return [
        EnhancedCell.widget(
          _AppNameCell(app: app, index: index),
        ),
        EnhancedCell.text(
          '${app.trackedKeywordsCount ?? 0}',
          align: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: colors.accent,
          ),
        ),
        EnhancedCell.widget(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: app.bestRank != null ? colors.greenMuted : colors.bgActive,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              app.bestRank?.toString() ?? '--',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: app.bestRank != null ? colors.green : colors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          align: TextAlign.center,
        ),
        EnhancedCell.widget(
          Sparkline(data: trendData, width: 80, height: 24),
          align: TextAlign.center,
        ),
      ];
    }).toList();

    return _GlassPanel(
      title: context.l10n.dashboard_topPerformingApps,
      child: EnhancedDataTable(
        columns: columns,
        rows: rows,
        onRowTap: (index) {
          if (index < topApps.length) {
            context.go('/apps/${topApps[index].id}');
          }
        },
      ),
    );
  }
}

class _AppNameCell extends StatelessWidget {
  final AppModel app;
  final int index;

  const _AppNameCell({required this.app, required this.index});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            gradient: AppColors.getGradient(index),
            borderRadius: BorderRadius.circular(8),
          ),
          child: app.iconUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    app.iconUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, error, stack) => const Center(
                      child: Icon(Icons.apps, size: 16, color: Colors.white),
                    ),
                  ),
                )
              : const Center(
                  child: Icon(Icons.apps, size: 16, color: Colors.white),
                ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
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
              if (app.developer != null)
                Text(
                  app.developer!,
                  style: TextStyle(
                    fontSize: 11,
                    color: colors.textMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TopCountriesPanel extends StatelessWidget {
  // Mock country data
  static const List<CountryData> _mockCountries = [
    CountryData(code: 'us', name: 'United States', percent: 42.3),
    CountryData(code: 'gb', name: 'United Kingdom', percent: 15.2),
    CountryData(code: 'de', name: 'Germany', percent: 12.8),
    CountryData(code: 'fr', name: 'France', percent: 9.5),
    CountryData(code: 'jp', name: 'Japan', percent: 8.1),
  ];

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      title: context.l10n.dashboard_topCountries,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: CountryDistribution(countries: _mockCountries),
      ),
    );
  }
}

class _SentimentOverviewPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return _GlassPanel(
      title: context.l10n.dashboard_sentimentOverview,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.dashboard_overallSentiment,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: colors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '85%',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: colors.green,
                        ),
                      ),
                      Text(
                        context.l10n.dashboard_positive,
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colors.greenMuted,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.trending_up, size: 16, color: colors.green),
                      const SizedBox(width: 4),
                      Text(
                        '+5%',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SentimentBar(
              positivePercent: 85,
              showIcons: false,
              height: 10,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SentimentLegendItem(
                  color: colors.green,
                  label: context.l10n.dashboard_positiveReviews,
                  value: '1,234',
                ),
                _SentimentLegendItem(
                  color: colors.red,
                  label: context.l10n.dashboard_negativeReviews,
                  value: '218',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SentimentLegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _SentimentLegendItem({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colors.textMuted,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _QuickActionsPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return _GlassPanel(
      title: context.l10n.dashboard_quickActions,
      child: Column(
        children: [
          _QuickActionItem(
            icon: Icons.add_circle_outline_rounded,
            label: context.l10n.dashboard_addNewApp,
            color: colors.accent,
            onTap: () => context.go('/apps/add'),
          ),
          _QuickActionItem(
            icon: Icons.search_rounded,
            label: context.l10n.dashboard_searchKeywords,
            color: colors.purple,
            onTap: () => context.go('/keywords'),
          ),
          _QuickActionItem(
            icon: Icons.apps_rounded,
            label: context.l10n.dashboard_viewAllApps,
            color: colors.green,
            onTap: () => context.go('/apps'),
          ),
          _QuickActionItem(
            icon: Icons.rate_review_outlined,
            label: context.l10n.dashboard_viewReviews,
            color: colors.yellow,
            onTap: () => context.go('/reviews'),
          ),
        ],
      ),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: colors.bgHover,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: colors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  final String title;
  final Widget child;

  const _GlassPanel({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(color: colors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ),
          Container(
            height: 1,
            color: colors.glassBorder,
          ),
          child,
        ],
      ),
    );
  }
}

class _EmptyStateMessage extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyStateMessage({
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colors.bgActive,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 24, color: colors.textMuted),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: colors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
