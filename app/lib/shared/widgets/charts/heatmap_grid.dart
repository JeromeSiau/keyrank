import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_animations.dart';

/// Intensity level for heatmap cells
enum HeatmapIntensity {
  none, // No data or not ranked
  low, // Low performance (e.g., rank 51-100)
  medium, // Medium performance (e.g., rank 11-50)
  high, // High performance (e.g., rank 1-10)
}

/// A single cell in the heatmap
class HeatmapCell {
  final String rowKey;
  final String columnKey;
  final int? value;
  final HeatmapIntensity intensity;
  final String? tooltip;

  const HeatmapCell({
    required this.rowKey,
    required this.columnKey,
    this.value,
    required this.intensity,
    this.tooltip,
  });
}

/// A heatmap grid for visualizing keyword rankings across countries.
///
/// Rows typically represent keywords, columns represent countries,
/// and cell colors indicate ranking performance.
class HeatmapGrid extends StatefulWidget {
  final List<String> rowLabels;
  final List<String> columnLabels;
  final List<HeatmapCell> cells;
  final double cellSize;
  final double rowLabelWidth;
  final bool showLegend;
  final ValueChanged<HeatmapCell>? onCellTap;
  final String legendTitle;

  const HeatmapGrid({
    super.key,
    required this.rowLabels,
    required this.columnLabels,
    required this.cells,
    this.cellSize = 32,
    this.rowLabelWidth = 120,
    this.showLegend = true,
    this.onCellTap,
    this.legendTitle = 'Ranking',
  });

  /// Creates a heatmap from a map of "rowKey-columnKey" -> value.
  /// The [intensityMapper] converts a value to an intensity level.
  factory HeatmapGrid.fromMap({
    Key? key,
    required List<String> rowLabels,
    required List<String> columnLabels,
    required Map<String, int?> values,
    required HeatmapIntensity Function(int? value) intensityMapper,
    required String Function(int? value) tooltipFormatter,
    double cellSize = 32,
    double rowLabelWidth = 120,
    bool showLegend = true,
    ValueChanged<HeatmapCell>? onCellTap,
    String legendTitle = 'Ranking',
  }) {
    final cells = <HeatmapCell>[];

    for (final row in rowLabels) {
      for (final col in columnLabels) {
        final key = '$row-$col';
        final value = values[key];
        cells.add(HeatmapCell(
          rowKey: row,
          columnKey: col,
          value: value,
          intensity: intensityMapper(value),
          tooltip: tooltipFormatter(value),
        ));
      }
    }

    return HeatmapGrid(
      key: key,
      rowLabels: rowLabels,
      columnLabels: columnLabels,
      cells: cells,
      cellSize: cellSize,
      rowLabelWidth: rowLabelWidth,
      showLegend: showLegend,
      onCellTap: onCellTap,
      legendTitle: legendTitle,
    );
  }

  @override
  State<HeatmapGrid> createState() => _HeatmapGridState();
}

class _HeatmapGridState extends State<HeatmapGrid> {
  String? _hoveredCellKey;

  HeatmapCell? _getCell(String rowKey, String columnKey) {
    return widget.cells.firstWhere(
      (c) => c.rowKey == rowKey && c.columnKey == columnKey,
      orElse: () => HeatmapCell(
        rowKey: rowKey,
        columnKey: columnKey,
        intensity: HeatmapIntensity.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row (column labels)
        Row(
          children: [
            SizedBox(width: widget.rowLabelWidth),
            ...widget.columnLabels.map((label) => SizedBox(
                  width: widget.cellSize,
                  child: Center(
                    child: Text(
                      label,
                      style: AppTypography.micro.copyWith(
                        color: colors.textMuted,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        // Data rows
        ...widget.rowLabels.map((rowLabel) => _buildRow(rowLabel, colors)),
        if (widget.showLegend) ...[
          const SizedBox(height: AppSpacing.md),
          _buildLegend(colors),
        ],
      ],
    );
  }

  Widget _buildRow(String rowLabel, AppColorsExtension colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: widget.rowLabelWidth,
            child: Text(
              rowLabel,
              style: AppTypography.caption.copyWith(
                color: colors.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ...widget.columnLabels.map((colLabel) {
            final cell = _getCell(rowLabel, colLabel);
            final cellKey = '$rowLabel-$colLabel';
            final isHovered = _hoveredCellKey == cellKey;

            return MouseRegion(
              onEnter: (_) => setState(() => _hoveredCellKey = cellKey),
              onExit: (_) => setState(() => _hoveredCellKey = null),
              child: GestureDetector(
                onTap: widget.onCellTap != null && cell != null
                    ? () => widget.onCellTap!(cell)
                    : null,
                child: Tooltip(
                  message: cell?.tooltip ?? 'No data',
                  waitDuration: const Duration(milliseconds: 300),
                  child: AnimatedContainer(
                    duration: AppAnimations.fast,
                    width: widget.cellSize - 2,
                    height: widget.cellSize - 4,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: _getCellColor(colors, cell?.intensity),
                      borderRadius: BorderRadius.circular(4),
                      border: isHovered
                          ? Border.all(color: colors.accent, width: 2)
                          : null,
                      boxShadow: isHovered
                          ? [
                              BoxShadow(
                                color: colors.accent.withAlpha(40),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    child: cell?.value != null
                        ? Center(
                            child: Text(
                              cell!.value.toString(),
                              style: AppTypography.micro.copyWith(
                                color: cell.intensity == HeatmapIntensity.high
                                    ? Colors.white
                                    : colors.textSecondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 9,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLegend(AppColorsExtension colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.legendTitle,
          style: AppTypography.caption.copyWith(color: colors.textMuted),
        ),
        const SizedBox(width: AppSpacing.md),
        _LegendItem(
          color: _getCellColor(colors, HeatmapIntensity.high),
          label: 'Top 10',
        ),
        const SizedBox(width: AppSpacing.md),
        _LegendItem(
          color: _getCellColor(colors, HeatmapIntensity.medium),
          label: 'Top 50',
        ),
        const SizedBox(width: AppSpacing.md),
        _LegendItem(
          color: _getCellColor(colors, HeatmapIntensity.low),
          label: 'Top 100',
        ),
        const SizedBox(width: AppSpacing.md),
        _LegendItem(
          color: _getCellColor(colors, HeatmapIntensity.none),
          label: 'Not ranked',
        ),
      ],
    );
  }

  Color _getCellColor(AppColorsExtension colors, HeatmapIntensity? intensity) {
    switch (intensity) {
      case HeatmapIntensity.high:
        return colors.green;
      case HeatmapIntensity.medium:
        return colors.green.withAlpha(150);
      case HeatmapIntensity.low:
        return colors.green.withAlpha(80);
      case HeatmapIntensity.none:
      case null:
        return colors.bgActive;
    }
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.micro.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }
}

/// Helper function to create a standard ranking intensity mapper
HeatmapIntensity rankingIntensityMapper(int? value) {
  if (value == null) return HeatmapIntensity.none;
  if (value <= 10) return HeatmapIntensity.high;
  if (value <= 50) return HeatmapIntensity.medium;
  if (value <= 100) return HeatmapIntensity.low;
  return HeatmapIntensity.none;
}

/// Helper function to create a standard ranking tooltip formatter
String rankingTooltipFormatter(int? value) {
  if (value == null) return 'Not ranked';
  return 'Rank #$value';
}
