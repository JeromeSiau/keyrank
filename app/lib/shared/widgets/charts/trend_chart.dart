import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_animations.dart';
import '../change_indicator.dart';

/// A data point for the trend chart
class ChartDataPoint {
  final DateTime date;
  final double value;
  final String? label;

  const ChartDataPoint({
    required this.date,
    required this.value,
    this.label,
  });
}

/// Available time periods for the chart
enum ChartPeriod {
  day7('7D'),
  day30('30D'),
  day90('90D'),
  year1('1Y'),
  all('All');

  final String label;
  const ChartPeriod(this.label);
}

/// A trend chart with period selector and optional comparison data.
///
/// Features:
/// - Smooth curved lines with gradient fill
/// - Interactive touch tooltips
/// - Period selector chips
/// - Optional comparison overlay (dashed line)
/// - Support for inverted Y axis (for rankings)
class TrendChart extends StatefulWidget {
  final List<ChartDataPoint> data;
  final List<ChartPeriod> periods;
  final ChartPeriod selectedPeriod;
  final ValueChanged<ChartPeriod> onPeriodChanged;
  final bool showGradient;
  final bool invertYAxis;
  final Color? color;
  final String? title;
  final String? subtitle;
  final List<ChartDataPoint>? compareData;
  final String? compareLabel;
  final double height;

  const TrendChart({
    super.key,
    required this.data,
    required this.periods,
    required this.selectedPeriod,
    required this.onPeriodChanged,
    this.showGradient = true,
    this.invertYAxis = false,
    this.color,
    this.title,
    this.subtitle,
    this.compareData,
    this.compareLabel,
    this.height = 200,
  });

  @override
  State<TrendChart> createState() => _TrendChartState();
}

class _TrendChartState extends State<TrendChart> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) _buildHeader(colors),
        const SizedBox(height: AppSpacing.md),
        _buildPeriodSelector(colors),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          height: widget.height,
          child: _buildChart(colors),
        ),
        if (widget.compareData != null) ...[
          const SizedBox(height: AppSpacing.md),
          _buildLegend(colors),
        ],
      ],
    );
  }

  Widget _buildHeader(AppColorsExtension colors) {
    final change = _calculateChange();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title!,
              style: AppTypography.title.copyWith(color: colors.textPrimary),
            ),
            if (widget.subtitle != null)
              Text(
                widget.subtitle!,
                style: AppTypography.caption.copyWith(color: colors.textMuted),
              ),
          ],
        ),
        if (change != null)
          ChangeIndicator(
            value: change,
            format: ChangeFormat.percent,
            invertColors: widget.invertYAxis,
          ),
      ],
    );
  }

  Widget _buildPeriodSelector(AppColorsExtension colors) {
    return Row(
      children: widget.periods.map((period) {
        final isSelected = period == widget.selectedPeriod;
        return Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: GestureDetector(
            onTap: () => widget.onPeriodChanged(period),
            child: AnimatedContainer(
              duration: AppAnimations.fast,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? colors.accent : colors.bgActive,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                period.label,
                style: AppTypography.micro.copyWith(
                  color: isSelected ? Colors.white : colors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChart(AppColorsExtension colors) {
    if (widget.data.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: AppTypography.body.copyWith(color: colors.textMuted),
        ),
      );
    }

    final chartColor = widget.color ?? colors.accent;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: _calculateInterval(),
          getDrawingHorizontalLine: (value) => FlLine(
            color: colors.border,
            strokeWidth: 1,
          ),
        ),
        titlesData: _buildTitlesData(colors),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          _buildLineBarData(widget.data, chartColor, false),
          if (widget.compareData != null)
            _buildLineBarData(widget.compareData!, colors.textMuted, true),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (spot) => colors.glassPanel,
            tooltipBorder: BorderSide(color: colors.glassBorder),
            tooltipRoundedRadius: 8,
            getTooltipItems: _buildTooltipItems,
          ),
          touchCallback: (event, response) {
            setState(() {
              if (response?.lineBarSpots != null &&
                  response!.lineBarSpots!.isNotEmpty) {
                _touchedIndex = response.lineBarSpots!.first.spotIndex;
              } else {
                _touchedIndex = null;
              }
            });
          },
          handleBuiltInTouches: true,
        ),
        minY: widget.invertYAxis ? null : 0,
      ),
      duration: AppAnimations.chartLoad,
      curve: AppAnimations.chartCurve,
    );
  }

  LineChartBarData _buildLineBarData(
    List<ChartDataPoint> data,
    Color color,
    bool isDashed,
  ) {
    final spots = data.asMap().entries.map((e) {
      final yValue = widget.invertYAxis ? -e.value.value : e.value.value;
      return FlSpot(e.key.toDouble(), yValue);
    }).toList();

    return LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.3,
      color: color,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          final isHighlighted = index == _touchedIndex;
          return FlDotCirclePainter(
            radius: isHighlighted ? 4 : 0,
            color: color,
            strokeWidth: 2,
            strokeColor: Colors.white,
          );
        },
      ),
      dashArray: isDashed ? [5, 5] : null,
      belowBarData: widget.showGradient && !isDashed
          ? BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  color.withAlpha(60),
                  color.withAlpha(0),
                ],
              ),
            )
          : null,
    );
  }

  FlTitlesData _buildTitlesData(AppColorsExtension colors) {
    return FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            final displayValue = widget.invertYAxis ? -value : value;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                _formatAxisValue(displayValue),
                style: AppTypography.micro.copyWith(color: colors.textMuted),
                textAlign: TextAlign.right,
              ),
            );
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: _calculateBottomInterval(),
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index < 0 || index >= widget.data.length) {
              return const SizedBox.shrink();
            }
            final date = widget.data[index].date;
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _formatDate(date),
                style: AppTypography.micro.copyWith(color: colors.textMuted),
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
    );
  }

  List<LineTooltipItem?> _buildTooltipItems(List<LineBarSpot> spots) {
    final colors = context.colors;

    return spots.map((spot) {
      final index = spot.spotIndex;
      final dataPoint = spot.barIndex == 0
          ? (index < widget.data.length ? widget.data[index] : null)
          : (widget.compareData != null && index < widget.compareData!.length
              ? widget.compareData![index]
              : null);

      if (dataPoint == null) return null;

      final displayValue = widget.invertYAxis ? -spot.y : spot.y;
      final dateStr = DateFormat('MMM d, yyyy').format(dataPoint.date);
      final label = spot.barIndex == 0
          ? (widget.title ?? 'Value')
          : (widget.compareLabel ?? 'Compare');

      return LineTooltipItem(
        '$dateStr\n$label: ${_formatAxisValue(displayValue)}',
        AppTypography.micro.copyWith(color: colors.textPrimary),
      );
    }).toList();
  }

  Widget _buildLegend(AppColorsExtension colors) {
    final chartColor = widget.color ?? colors.accent;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendItem(
          color: chartColor,
          label: widget.title ?? 'Current',
          isDashed: false,
        ),
        const SizedBox(width: AppSpacing.lg),
        _LegendItem(
          color: colors.textMuted,
          label: widget.compareLabel ?? 'Previous',
          isDashed: true,
        ),
      ],
    );
  }

  double? _calculateChange() {
    if (widget.data.length < 2) return null;

    final first = widget.data.first.value;
    final last = widget.data.last.value;

    if (first == 0) return null;

    return ((last - first) / first) * 100;
  }

  double _calculateInterval() {
    if (widget.data.isEmpty) return 10;

    final values = widget.data.map((d) => d.value);
    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final minVal = values.reduce((a, b) => a < b ? a : b);
    final range = maxVal - minVal;

    if (range == 0) return 10;
    if (range < 10) return 1;
    if (range < 50) return 5;
    if (range < 100) return 10;
    if (range < 500) return 50;
    return 100;
  }

  double _calculateBottomInterval() {
    final count = widget.data.length;
    if (count <= 7) return 1;
    if (count <= 14) return 2;
    if (count <= 30) return 5;
    if (count <= 90) return 14;
    return 30;
  }

  String _formatAxisValue(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    } else if (value == value.toInt()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }

  String _formatDate(DateTime date) {
    switch (widget.selectedPeriod) {
      case ChartPeriod.day7:
        return DateFormat('E').format(date);
      case ChartPeriod.day30:
        return DateFormat('d').format(date);
      case ChartPeriod.day90:
        return DateFormat('MMM d').format(date);
      case ChartPeriod.year1:
      case ChartPeriod.all:
        return DateFormat('MMM').format(date);
    }
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool isDashed;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.isDashed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 2,
          decoration: BoxDecoration(
            color: isDashed ? Colors.transparent : color,
            border: isDashed
                ? Border(
                    bottom: BorderSide(
                      color: color,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  )
                : null,
          ),
          child: isDashed
              ? CustomPaint(
                  painter: _DashedLinePainter(color: color),
                )
              : null,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTypography.caption.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;

  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 4.0;
    const dashSpace = 2.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
