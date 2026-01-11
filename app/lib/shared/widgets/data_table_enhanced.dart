import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A column definition for EnhancedDataTable.
class EnhancedColumn {
  final String label;
  final double? width;
  final bool sortable;
  final TextAlign align;

  const EnhancedColumn({
    required this.label,
    this.width,
    this.sortable = false,
    this.align = TextAlign.left,
  });
}

/// A cell that can contain text, a widget, or a sparkline.
class EnhancedCell {
  final String? text;
  final Widget? widget;
  final TextStyle? style;
  final TextAlign align;

  const EnhancedCell({
    this.text,
    this.widget,
    this.style,
    this.align = TextAlign.left,
  });

  const EnhancedCell.text(
    String value, {
    this.style,
    this.align = TextAlign.left,
  })  : text = value,
        widget = null;

  const EnhancedCell.widget(Widget value, {this.align = TextAlign.left})
      : text = null,
        widget = value,
        style = null;
}

/// An enhanced data table with glass styling and hover effects.
class EnhancedDataTable extends StatefulWidget {
  final List<EnhancedColumn> columns;
  final List<List<EnhancedCell>> rows;
  final void Function(int index)? onRowTap;
  final int? sortColumnIndex;
  final bool sortAscending;
  final void Function(int columnIndex, bool ascending)? onSort;

  const EnhancedDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.onRowTap,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSort,
  });

  @override
  State<EnhancedDataTable> createState() => _EnhancedDataTableState();
}

class _EnhancedDataTableState extends State<EnhancedDataTable> {
  int? _hoveredRow;

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
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.glassBorder)),
            ),
            child: Row(
              children: widget.columns.asMap().entries.map((entry) {
                final index = entry.key;
                final column = entry.value;
                final isLast = index == widget.columns.length - 1;

                return _buildHeaderCell(column, index, isLast, colors);
              }).toList(),
            ),
          ),
          // Rows
          ...widget.rows.asMap().entries.map((entry) {
            final rowIndex = entry.key;
            final row = entry.value;
            final isHovered = _hoveredRow == rowIndex;
            final isLast = rowIndex == widget.rows.length - 1;

            return MouseRegion(
              onEnter: (_) => setState(() => _hoveredRow = rowIndex),
              onExit: (_) => setState(() => _hoveredRow = null),
              child: GestureDetector(
                onTap: widget.onRowTap != null
                    ? () => widget.onRowTap!(rowIndex)
                    : null,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isHovered ? colors.bgHover : Colors.transparent,
                    border: isLast
                        ? null
                        : Border(
                            bottom: BorderSide(
                              color: colors.glassBorder.withAlpha(100),
                            ),
                          ),
                  ),
                  child: Row(
                    children: row.asMap().entries.map((cellEntry) {
                      final cellIndex = cellEntry.key;
                      final cell = cellEntry.value;
                      final column = widget.columns[cellIndex];
                      final isLastCell = cellIndex == row.length - 1;

                      return _buildDataCell(cell, column, isLastCell, colors);
                    }).toList(),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(
    EnhancedColumn column,
    int index,
    bool isLast,
    AppColorsExtension colors,
  ) {
    final isSorted = widget.sortColumnIndex == index;

    Widget content = Text(
      column.label.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: colors.textMuted,
      ),
    );

    if (column.sortable) {
      content = GestureDetector(
        onTap: () {
          if (widget.onSort != null) {
            final newAscending = isSorted ? !widget.sortAscending : true;
            widget.onSort!(index, newAscending);
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            content,
            const SizedBox(width: 4),
            Icon(
              isSorted
                  ? (widget.sortAscending
                      ? Icons.arrow_upward
                      : Icons.arrow_downward)
                  : Icons.unfold_more,
              size: 14,
              color: isSorted ? colors.accent : colors.textMuted,
            ),
          ],
        ),
      );
    }

    return _wrapCell(content, column, isLast, column.align);
  }

  Widget _buildDataCell(
    EnhancedCell cell,
    EnhancedColumn column,
    bool isLast,
    AppColorsExtension colors,
  ) {
    Widget content;

    if (cell.widget != null) {
      content = cell.widget!;
    } else {
      content = Text(
        cell.text ?? '',
        style: cell.style ??
            TextStyle(
              fontSize: 13,
              color: colors.textPrimary,
            ),
        textAlign: cell.align,
      );
    }

    return _wrapCell(content, column, isLast, cell.align);
  }

  Widget _wrapCell(
    Widget content,
    EnhancedColumn column,
    bool isLast,
    TextAlign align,
  ) {
    if (column.width != null) {
      return SizedBox(
        width: column.width,
        child: Align(
          alignment: _alignmentFromTextAlign(align),
          child: content,
        ),
      );
    }

    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: isLast ? 0 : 16),
        child: Align(
          alignment: _alignmentFromTextAlign(align),
          child: content,
        ),
      ),
    );
  }

  Alignment _alignmentFromTextAlign(TextAlign align) {
    switch (align) {
      case TextAlign.right:
      case TextAlign.end:
        return Alignment.centerRight;
      case TextAlign.center:
        return Alignment.center;
      default:
        return Alignment.centerLeft;
    }
  }
}
