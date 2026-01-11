import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A horizontal bar showing positive/negative sentiment distribution.
class SentimentBar extends StatelessWidget {
  final double positivePercent; // 0-100
  final String? tooltipText;
  final double height;
  final bool showLabels;
  final bool showIcons;

  const SentimentBar({
    super.key,
    required this.positivePercent,
    this.tooltipText,
    this.height = 8,
    this.showLabels = true,
    this.showIcons = true,
  });

  double get negativePercent => 100 - positivePercent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final bar = ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            Expanded(
              flex: positivePercent.round(),
              child: Container(color: colors.green),
            ),
            Expanded(
              flex: negativePercent.round(),
              child: Container(color: colors.red),
            ),
          ],
        ),
      ),
    );

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabels)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (showIcons) ...[
                      const Text('😊', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      '${positivePercent.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.green,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '${negativePercent.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.red,
                      ),
                    ),
                    if (showIcons) ...[
                      const SizedBox(width: 4),
                      const Text('😞', style: TextStyle(fontSize: 14)),
                    ],
                  ],
                ),
              ],
            ),
          ),
        bar,
        if (tooltipText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              tooltipText!,
              style: TextStyle(
                fontSize: 11,
                color: colors.textMuted,
              ),
            ),
          ),
      ],
    );

    return content;
  }
}

/// A compact sentiment indicator with dot and percentage.
class SentimentIndicator extends StatelessWidget {
  final double positivePercent;

  const SentimentIndicator({
    super.key,
    required this.positivePercent,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isPositive = positivePercent >= 50;
    final color = isPositive ? colors.green : colors.red;

    return Row(
      mainAxisSize: MainAxisSize.min,
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
          '${positivePercent.toStringAsFixed(0)}%',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}
