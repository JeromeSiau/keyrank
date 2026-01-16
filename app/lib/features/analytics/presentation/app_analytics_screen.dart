import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/utils/country_names.dart';
import '../../../core/providers/country_provider.dart';
import '../../../shared/widgets/date_range_picker.dart';
import '../domain/analytics_summary_model.dart';
import '../providers/analytics_provider.dart';

class AppAnalyticsScreen extends ConsumerWidget {
  final int appId;
  final String appName;

  const AppAnalyticsScreen({
    super.key,
    required this.appId,
    required this.appName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final summaryAsync = ref.watch(analyticsSummaryProvider(appId));
    final period = ref.watch(analyticsPeriodProvider);

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanel,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
      ),
      child: Column(
        children: [
          // Toolbar
          _Toolbar(appName: appName, appId: appId),

          // Content
          Expanded(
            child: summaryAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (e, _) => _ErrorView(
                error: e.toString(),
                onRetry: () => ref.invalidate(analyticsSummaryProvider(appId)),
              ),
              data: (summary) {
                if (!summary.hasData) {
                  return _EmptyView();
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Period selector
                      _PeriodSelector(
                        selectedPeriod: period,
                        onPeriodChanged: (p) =>
                            ref.read(analyticsPeriodProvider.notifier).state = p,
                      ),
                      const SizedBox(height: 16),

                      // KPI Cards
                      _KpiCards(summary: summary),
                      const SizedBox(height: 24),

                      // Downloads Chart
                      _DownloadsChart(appId: appId),
                      const SizedBox(height: 24),

                      // Revenue Chart
                      _RevenueChart(appId: appId),
                      const SizedBox(height: 24),

                      // Countries breakdown
                      _CountriesBreakdown(appId: appId),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  final String appName;
  final int appId;

  const _Toolbar({required this.appName, required this.appId});

  @override
  Widget build(BuildContext context) {
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
                child: Icon(Icons.arrow_back_rounded,
                    size: 20, color: colors.textMuted),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  context.l10n.analytics_title,
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

class _PeriodSelector extends StatelessWidget {
  final String selectedPeriod;
  final ValueChanged<String> onPeriodChanged;

  const _PeriodSelector({
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DateRangePickerButton(
      selected: DatePeriod.preset(selectedPeriod),
      onChanged: (newPeriod) {
        onPeriodChanged(newPeriod.presetKey ?? '30d');
      },
    );
  }
}

class _KpiCards extends StatelessWidget {
  final AnalyticsSummary summary;

  const _KpiCards({required this.summary});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _KpiCard(
          icon: Icons.download_rounded,
          iconColor: colors.accent,
          title: context.l10n.analytics_downloads,
          value: _formatNumber(summary.totalDownloads),
          change: summary.downloadsChangePct,
        ),
        _KpiCard(
          icon: Icons.attach_money_rounded,
          iconColor: colors.green,
          title: context.l10n.analytics_revenue,
          value: _formatCurrency(summary.totalRevenue),
          change: summary.revenueChangePct,
        ),
        _KpiCard(
          icon: Icons.account_balance_wallet_rounded,
          iconColor: colors.purple,
          title: context.l10n.analytics_proceeds,
          value: _formatCurrency(summary.totalProceeds),
          change: null,
        ),
        _KpiCard(
          icon: Icons.people_rounded,
          iconColor: colors.yellow,
          title: context.l10n.analytics_subscribers,
          value: _formatNumber(summary.activeSubscribers),
          change: summary.subscribersChangePct,
        ),
      ],
    );
  }

  String _formatNumber(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }

  String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(1)}K';
    }
    return '\$${value.toStringAsFixed(2)}';
  }
}

class _KpiCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final double? change;

  const _KpiCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    this.change,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const Spacer(),
              if (change != null)
                _ChangeIndicator(change: change!),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChangeIndicator extends StatelessWidget {
  final double change;

  const _ChangeIndicator({required this.change});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isPositive = change >= 0;
    final color = isPositive ? colors.green : colors.red;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
          size: 14,
          color: color,
        ),
        Text(
          '${change.abs().toStringAsFixed(1)}%',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _DownloadsChart extends ConsumerWidget {
  final int appId;

  const _DownloadsChart({required this.appId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final downloadsAsync = ref.watch(analyticsDownloadsProvider(appId));

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
            context.l10n.analytics_downloadsOverTime,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: downloadsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator(strokeWidth: 2)),
              error: (e, _) => Center(
                child: Text(
                  e.toString(),
                  style: TextStyle(color: colors.red),
                ),
              ),
              data: (data) {
                if (data.current.isEmpty) {
                  return Center(
                    child: Text(
                      context.l10n.analytics_noData,
                      style: TextStyle(color: colors.textMuted),
                    ),
                  );
                }

                return LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: _calculateInterval(data.current),
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: colors.glassBorder,
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) => Text(
                            _formatAxisValue(value),
                            style: TextStyle(
                              fontSize: 10,
                              color: colors.textMuted,
                            ),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 24,
                          interval: (data.current.length / 5).ceilToDouble(),
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= data.current.length) {
                              return const SizedBox.shrink();
                            }
                            final date = data.current[index].date;
                            return Text(
                              _formatDate(date),
                              style: TextStyle(
                                fontSize: 10,
                                color: colors.textMuted,
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      // Current period
                      LineChartBarData(
                        spots: data.current.asMap().entries.map((e) {
                          return FlSpot(e.key.toDouble(), e.value.downloads.toDouble());
                        }).toList(),
                        isCurved: true,
                        color: colors.accent,
                        barWidth: 2,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: colors.accent.withAlpha(30),
                        ),
                      ),
                      // Previous period (dashed)
                      if (data.previous.isNotEmpty)
                        LineChartBarData(
                          spots: data.previous.asMap().entries.map((e) {
                            return FlSpot(
                                e.key.toDouble(), e.value.downloads.toDouble());
                          }).toList(),
                          isCurved: true,
                          color: colors.textMuted.withAlpha(100),
                          barWidth: 1,
                          dotData: const FlDotData(show: false),
                          dashArray: [5, 5],
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  double _calculateInterval(List<DownloadsDataPoint> data) {
    if (data.isEmpty) return 1;
    final max = data.map((e) => e.downloads).reduce((a, b) => a > b ? a : b);
    return (max / 4).ceilToDouble().clamp(1, double.infinity);
  }

  String _formatAxisValue(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(0)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toInt().toString();
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('M/d').format(date);
    } catch (_) {
      return dateStr;
    }
  }
}

class _RevenueChart extends ConsumerWidget {
  final int appId;

  const _RevenueChart({required this.appId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final revenueAsync = ref.watch(analyticsRevenueProvider(appId));

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
            context.l10n.analytics_revenueOverTime,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: revenueAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator(strokeWidth: 2)),
              error: (e, _) => Center(
                child: Text(
                  e.toString(),
                  style: TextStyle(color: colors.red),
                ),
              ),
              data: (data) {
                if (data.current.isEmpty) {
                  return Center(
                    child: Text(
                      context.l10n.analytics_noData,
                      style: TextStyle(color: colors.textMuted),
                    ),
                  );
                }

                return LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: colors.glassBorder,
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          getTitlesWidget: (value, meta) => Text(
                            '\$${_formatAxisValue(value)}',
                            style: TextStyle(
                              fontSize: 10,
                              color: colors.textMuted,
                            ),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 24,
                          interval: (data.current.length / 5).ceilToDouble(),
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= data.current.length) {
                              return const SizedBox.shrink();
                            }
                            final date = data.current[index].date;
                            return Text(
                              _formatDate(date),
                              style: TextStyle(
                                fontSize: 10,
                                color: colors.textMuted,
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: data.current.asMap().entries.map((e) {
                          return FlSpot(e.key.toDouble(), e.value.revenue);
                        }).toList(),
                        isCurved: true,
                        color: colors.green,
                        barWidth: 2,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: colors.green.withAlpha(30),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatAxisValue(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(0)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toInt().toString();
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('M/d').format(date);
    } catch (_) {
      return dateStr;
    }
  }
}

class _CountriesBreakdown extends ConsumerWidget {
  final int appId;

  const _CountriesBreakdown({required this.appId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final countriesAsync = ref.watch(analyticsCountriesProvider(appId));

    return Container(
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              context.l10n.analytics_byCountry,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ),
          countriesAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                e.toString(),
                style: TextStyle(color: colors.red),
              ),
            ),
            data: (countries) {
              if (countries.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Text(
                      context.l10n.analytics_noData,
                      style: TextStyle(color: colors.textMuted),
                    ),
                  ),
                );
              }

              return Column(
                children: countries.map((country) {
                  final flag = getFlagForStorefront(country.countryCode);
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: colors.glassBorder)),
                    ),
                    child: Row(
                      children: [
                        Text(flag, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            getLocalizedCountryName(context, country.countryCode),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: colors.textPrimary,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _formatNumber(country.downloads),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: colors.textPrimary,
                              ),
                            ),
                            Text(
                              context.l10n.analytics_downloads,
                              style: TextStyle(
                                fontSize: 10,
                                color: colors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${country.revenue.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: colors.green,
                              ),
                            ),
                            Text(
                              context.l10n.analytics_revenue,
                              style: TextStyle(
                                fontSize: 10,
                                color: colors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatNumber(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }
}

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colors.redMuted,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 32,
              color: colors.red,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            context.l10n.common_error(error),
            style: TextStyle(
              fontSize: 14,
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Material(
            color: colors.accent,
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
            child: InkWell(
              onTap: onRetry,
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text(
                  context.l10n.common_retry,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colors.bgActive,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.analytics_outlined,
              size: 40,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            context.l10n.analytics_noDataTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              context.l10n.analytics_noDataDescription,
              style: TextStyle(
                fontSize: 14,
                color: colors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
