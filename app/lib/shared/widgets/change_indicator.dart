import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Format for displaying change values
enum ChangeFormat {
  /// Raw number: +5, -3
  number,

  /// Percentage: +5.2%, -3.1%
  percent,

  /// Position change (for rankings): ▲5, ▼3
  position,

  /// Compact: +5, -3 (no decimal)
  compact,
}

/// Size variants for the change indicator
enum ChangeIndicatorSize {
  small,
  medium,
  large,
}

/// A widget that displays a change value with appropriate styling.
///
/// Supports positive/negative/neutral states with color coding,
/// optional icons, and different display formats.
///
/// For rankings where lower is better (e.g., position 1 > position 10),
/// set [invertColors] to true so improvements show as green.
class ChangeIndicator extends StatelessWidget {
  /// The change value (positive, negative, or zero)
  final num value;

  /// How to format the displayed value
  final ChangeFormat format;

  /// Whether to invert color logic (for rankings where lower = better)
  final bool invertColors;

  /// Whether to show the direction icon
  final bool showIcon;

  /// Size variant
  final ChangeIndicatorSize size;

  /// Optional custom color override
  final Color? color;

  /// Whether to show a background pill
  final bool showBackground;

  /// Number of decimal places for percent format
  final int decimalPlaces;

  const ChangeIndicator({
    super.key,
    required this.value,
    this.format = ChangeFormat.number,
    this.invertColors = false,
    this.showIcon = true,
    this.size = ChangeIndicatorSize.medium,
    this.color,
    this.showBackground = true,
    this.decimalPlaces = 1,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isZero = value == 0;
    final isPositive = invertColors ? value < 0 : value > 0;

    final effectiveColor = color ??
        (isZero
            ? colors.textMuted
            : isPositive
                ? colors.green
                : colors.red);

    final icon = isZero
        ? Icons.remove
        : (isPositive ? Icons.arrow_upward : Icons.arrow_downward);

    final formattedValue = _formatValue();
    final (iconSize, fontSize, padding) = _getSizeParams();

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIcon) ...[
          Icon(icon, size: iconSize, color: effectiveColor),
          SizedBox(width: size == ChangeIndicatorSize.small ? 2 : 4),
        ],
        Text(
          formattedValue,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: effectiveColor,
            height: 1.2,
          ),
        ),
      ],
    );

    if (showBackground) {
      content = Container(
        padding: padding,
        decoration: BoxDecoration(
          color: effectiveColor.withAlpha(25),
          borderRadius: BorderRadius.circular(4),
        ),
        child: content,
      );
    }

    return content;
  }

  String _formatValue() {
    final absValue = value.abs();

    switch (format) {
      case ChangeFormat.number:
        if (absValue == absValue.toInt()) {
          return absValue.toInt().toString();
        }
        return absValue.toStringAsFixed(decimalPlaces);

      case ChangeFormat.percent:
        if (absValue == absValue.toInt()) {
          return '${absValue.toInt()}%';
        }
        return '${absValue.toStringAsFixed(decimalPlaces)}%';

      case ChangeFormat.position:
        return absValue.toInt().toString();

      case ChangeFormat.compact:
        if (absValue >= 1000000) {
          return '${(absValue / 1000000).toStringAsFixed(1)}M';
        } else if (absValue >= 1000) {
          return '${(absValue / 1000).toStringAsFixed(1)}K';
        }
        return absValue.toInt().toString();
    }
  }

  (double iconSize, double fontSize, EdgeInsets padding) _getSizeParams() {
    switch (size) {
      case ChangeIndicatorSize.small:
        return (10.0, 11.0, const EdgeInsets.symmetric(horizontal: 4, vertical: 2));
      case ChangeIndicatorSize.medium:
        return (12.0, 12.0, const EdgeInsets.symmetric(horizontal: 6, vertical: 3));
      case ChangeIndicatorSize.large:
        return (14.0, 14.0, const EdgeInsets.symmetric(horizontal: 8, vertical: 4));
    }
  }
}

/// A larger change indicator designed for hero metrics
class HeroChangeIndicator extends StatelessWidget {
  final num value;
  final ChangeFormat format;
  final bool invertColors;
  final String? label;

  const HeroChangeIndicator({
    super.key,
    required this.value,
    this.format = ChangeFormat.percent,
    this.invertColors = false,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isZero = value == 0;
    final isPositive = invertColors ? value < 0 : value > 0;

    final effectiveColor = isZero
        ? colors.textMuted
        : isPositive
            ? colors.green
            : colors.red;

    final icon = isZero
        ? Icons.remove
        : (isPositive ? Icons.trending_up : Icons.trending_down);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: effectiveColor.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: effectiveColor.withAlpha(40)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: effectiveColor),
          const SizedBox(width: 6),
          Text(
            _formatValue(),
            style: AppTypography.bodyMedium.copyWith(color: effectiveColor),
          ),
          if (label != null) ...[
            const SizedBox(width: 6),
            Text(
              label!,
              style: AppTypography.caption.copyWith(color: colors.textMuted),
            ),
          ],
        ],
      ),
    );
  }

  String _formatValue() {
    final absValue = value.abs();
    final sign = value > 0 ? '+' : (value < 0 ? '-' : '');

    switch (format) {
      case ChangeFormat.number:
        return '$sign${absValue.toStringAsFixed(absValue == absValue.toInt() ? 0 : 1)}';
      case ChangeFormat.percent:
        return '$sign${absValue.toStringAsFixed(absValue == absValue.toInt() ? 0 : 1)}%';
      case ChangeFormat.position:
      case ChangeFormat.compact:
        return '$sign${absValue.toInt()}';
    }
  }
}

/// Inline text change indicator (no background)
class InlineChangeIndicator extends StatelessWidget {
  final num value;
  final ChangeFormat format;
  final bool invertColors;
  final double fontSize;

  const InlineChangeIndicator({
    super.key,
    required this.value,
    this.format = ChangeFormat.percent,
    this.invertColors = false,
    this.fontSize = 13,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isZero = value == 0;
    final isPositive = invertColors ? value < 0 : value > 0;

    final effectiveColor = isZero
        ? colors.textMuted
        : isPositive
            ? colors.green
            : colors.red;

    return Text(
      _formatWithSign(),
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: effectiveColor,
      ),
    );
  }

  String _formatWithSign() {
    final absValue = value.abs();
    final sign = value > 0 ? '+' : (value < 0 ? '-' : '');

    switch (format) {
      case ChangeFormat.number:
        return '$sign${absValue.toStringAsFixed(absValue == absValue.toInt() ? 0 : 1)}';
      case ChangeFormat.percent:
        return '$sign${absValue.toStringAsFixed(absValue == absValue.toInt() ? 0 : 1)}%';
      case ChangeFormat.position:
      case ChangeFormat.compact:
        return '$sign${absValue.toInt()}';
    }
  }
}
