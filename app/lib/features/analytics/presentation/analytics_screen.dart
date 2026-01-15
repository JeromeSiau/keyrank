import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/app_context_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/analytics_provider.dart';
import '../providers/global_analytics_provider.dart';
import 'app_analytics_screen.dart';

/// Analytics screen that uses the global app context.
/// - Global mode (no app selected): Shows analytics summary for all apps
/// - App mode (app selected): Shows detailed analytics for that app
class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedApp = ref.watch(appContextProvider);

    if (selectedApp == null) {
      return const _GlobalAnalyticsView();
    }

    return AppAnalyticsScreen(
      appId: selectedApp.id,
      appName: selectedApp.name,
    );
  }
}

/// Global view showing analytics summary for all apps
class _GlobalAnalyticsView extends ConsumerWidget {
  const _GlobalAnalyticsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(globalAnalyticsProvider);
    final totals = ref.watch(globalAnalyticsTotalsProvider);
    final period = ref.watch(analyticsPeriodProvider);
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics (All Apps)'),
        actions: [
          // Period selector
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: DropdownButton<String>(
              value: period,
              underline: const SizedBox(),
              items: analyticsPeriodOptions.map((option) {
                return DropdownMenuItem(
                  value: option.$1,
                  child: Text(option.$2),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  ref.read(analyticsPeriodProvider.notifier).state = value;
                }
              },
            ),
          ),
        ],
      ),
      body: analyticsAsync.when(
        data: (analytics) {
          if (analytics.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.analytics_outlined, size: 64, color: colors.textMuted),
                  const SizedBox(height: 16),
                  Text(
                    'No analytics data available',
                    style: TextStyle(fontSize: 18, color: colors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Analytics data will appear once apps are connected',
                    style: TextStyle(fontSize: 14, color: colors.textMuted),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Totals summary cards
                _TotalsSummary(totals: totals),
                const SizedBox(height: 24),

                // Apps table
                Text(
                  '${analytics.length} apps with analytics',
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.textMuted,
                  ),
                ),
                const SizedBox(height: 16),
                _AnalyticsTable(analytics: analytics),
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
              Text('Error loading analytics', style: TextStyle(color: colors.textSecondary)),
              const SizedBox(height: 8),
              Text(error.toString(), style: TextStyle(color: colors.textMuted, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Summary cards showing totals across all apps
class _TotalsSummary extends StatelessWidget {
  final GlobalAnalyticsTotals totals;

  const _TotalsSummary({required this.totals});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    final numberFormat = NumberFormat.compact();

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 800 ? 4 : 2;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          childAspectRatio: 2.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _SummaryCard(
              icon: Icons.download_outlined,
              label: 'Total Downloads',
              value: numberFormat.format(totals.totalDownloads),
              color: colors.accent,
            ),
            _SummaryCard(
              icon: Icons.attach_money,
              label: 'Total Revenue',
              value: currencyFormat.format(totals.totalRevenue),
              color: colors.green,
            ),
            _SummaryCard(
              icon: Icons.account_balance_wallet_outlined,
              label: 'Total Proceeds',
              value: currencyFormat.format(totals.totalProceeds),
              color: colors.orange,
            ),
            _SummaryCard(
              icon: Icons.people_outline,
              label: 'Active Subscribers',
              value: numberFormat.format(totals.totalSubscribers),
              color: colors.purple,
            ),
          ],
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.bgSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Table showing analytics for all apps
class _AnalyticsTable extends ConsumerWidget {
  final List<AnalyticsWithApp> analytics;

  const _AnalyticsTable({required this.analytics});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    final numberFormat = NumberFormat.compact();

    return Container(
      decoration: BoxDecoration(
        color: colors.bgSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(colors.bgActive),
            columns: [
              DataColumn(
                label: Text('App', style: TextStyle(fontWeight: FontWeight.w600, color: colors.textPrimary)),
              ),
              DataColumn(
                label: Text('Downloads', style: TextStyle(fontWeight: FontWeight.w600, color: colors.textPrimary)),
                numeric: true,
              ),
              DataColumn(
                label: Text('Revenue', style: TextStyle(fontWeight: FontWeight.w600, color: colors.textPrimary)),
                numeric: true,
              ),
              DataColumn(
                label: Text('Proceeds', style: TextStyle(fontWeight: FontWeight.w600, color: colors.textPrimary)),
                numeric: true,
              ),
              DataColumn(
                label: Text('Subscribers', style: TextStyle(fontWeight: FontWeight.w600, color: colors.textPrimary)),
                numeric: true,
              ),
            ],
            rows: analytics.map((item) {
              final summary = item.summary;
              final app = item.app;

              return DataRow(
                cells: [
                  DataCell(
                    InkWell(
                      onTap: () {
                        ref.read(appContextProvider.notifier).select(app);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (app.iconUrl != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                app.iconUrl!,
                                width: 24,
                                height: 24,
                                errorBuilder: (_, _, _) => Icon(Icons.apps, size: 24, color: colors.textMuted),
                              ),
                            )
                          else
                            Icon(Icons.apps, size: 24, color: colors.textMuted),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              app.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  DataCell(
                    _MetricWithChange(
                      value: numberFormat.format(summary.totalDownloads),
                      change: summary.downloadsChangePct,
                    ),
                  ),
                  DataCell(
                    _MetricWithChange(
                      value: currencyFormat.format(summary.totalRevenue),
                      change: summary.revenueChangePct,
                    ),
                  ),
                  DataCell(
                    Text(
                      currencyFormat.format(summary.totalProceeds),
                      style: TextStyle(color: colors.textSecondary),
                    ),
                  ),
                  DataCell(
                    _MetricWithChange(
                      value: numberFormat.format(summary.activeSubscribers),
                      change: summary.subscribersChangePct,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

/// Metric value with optional change percentage
class _MetricWithChange extends StatelessWidget {
  final String value;
  final double? change;

  const _MetricWithChange({required this.value, this.change});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: TextStyle(color: colors.textPrimary)),
        if (change != null) ...[
          const SizedBox(width: 6),
          _ChangeIndicator(change: change!),
        ],
      ],
    );
  }
}

class _ChangeIndicator extends StatelessWidget {
  final double change;

  const _ChangeIndicator({required this.change});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isPositive = change > 0;

    if (change == 0) {
      return Text('-', style: TextStyle(color: colors.textMuted, fontSize: 12));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isPositive ? Icons.arrow_upward : Icons.arrow_downward,
          size: 12,
          color: isPositive ? colors.green : colors.red,
        ),
        Text(
          '${change.abs().toStringAsFixed(1)}%',
          style: TextStyle(
            fontSize: 12,
            color: isPositive ? colors.green : colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
