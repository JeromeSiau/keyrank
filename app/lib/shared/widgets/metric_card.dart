// app/lib/shared/widgets/metric_card.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A clean metric card displaying a value with trend indicator.
class MetricCard extends StatefulWidget {
  final String label;
  final String value;
  final double? change; // Percentage change, e.g., 29.0 for +29%
  final String? subtitle; // e.g., "vs last period"
  final IconData? icon;
  final VoidCallback? onTap;

  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    this.change,
    this.subtitle,
    this.icon,
    this.onTap,
  });

  @override
  State<MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<MetricCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered ? colors.bgHover : colors.bgSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, size: 16, color: colors.textMuted),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              if (widget.change != null || widget.subtitle != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (widget.change != null) TrendBadge(change: widget.change!),
                    if (widget.change != null && widget.subtitle != null)
                      const SizedBox(width: 6),
                    if (widget.subtitle != null)
                      Expanded(
                        child: Text(
                          widget.subtitle!,
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.textMuted,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A small badge showing trend direction and percentage.
class TrendBadge extends StatelessWidget {
  final double change;
  final bool showIcon;

  const TrendBadge({
    super.key,
    required this.change,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isPositive = change >= 0;
    final isZero = change == 0;
    final color = isZero ? colors.textMuted : (isPositive ? colors.green : colors.red);
    final icon = isZero
        ? Icons.remove
        : (isPositive ? Icons.arrow_upward : Icons.arrow_downward);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon)
            Icon(icon, size: 12, color: color),
          if (showIcon)
            const SizedBox(width: 2),
          Text(
            '${isPositive && !isZero ? '+' : ''}${change.toStringAsFixed(change.truncateToDouble() == change ? 0 : 1)}%',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
