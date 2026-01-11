import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_animations.dart';

/// Rating distribution data for the ring chart
class RatingDistribution {
  final int stars;
  final double percentage;
  final int count;

  const RatingDistribution({
    required this.stars,
    required this.percentage,
    required this.count,
  });
}

/// A donut/ring chart for displaying ratings distribution.
///
/// Shows the average rating in the center with a breakdown
/// by star count around the ring.
class RingChart extends StatefulWidget {
  final double average;
  final List<RatingDistribution> distribution;
  final double size;
  final bool showLabels;
  final bool showLegend;
  final bool animate;

  const RingChart({
    super.key,
    required this.average,
    required this.distribution,
    this.size = 140,
    this.showLabels = false,
    this.showLegend = true,
    this.animate = true,
  });

  @override
  State<RingChart> createState() => _RingChartState();
}

class _RingChartState extends State<RingChart>
    with SingleTickerProviderStateMixin {
  int? _touchedIndex;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.chartLoad,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: AppAnimations.chartCurve,
    );

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (widget.showLegend) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildChart(colors),
          const SizedBox(width: AppSpacing.xl),
          Expanded(child: _buildLegend(colors)),
        ],
      );
    }

    return _buildChart(colors);
  }

  Widget _buildChart(AppColorsExtension colors) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: widget.size * 0.32,
                  startDegreeOffset: -90,
                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) {
                      setState(() {
                        if (response?.touchedSection != null) {
                          _touchedIndex =
                              response!.touchedSection!.touchedSectionIndex;
                        } else {
                          _touchedIndex = null;
                        }
                      });
                    },
                  ),
                  sections: _buildSections(colors),
                ),
              );
            },
          ),
          _buildCenterContent(colors),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections(AppColorsExtension colors) {
    // Colors from 5 stars (best) to 1 star (worst)
    final sectionColors = [
      colors.green, // 5 stars
      const Color(0xFF8BC34A), // 4 stars
      colors.yellow, // 3 stars
      colors.orange, // 2 stars
      colors.red, // 1 star
    ];

    // Sort distribution by stars descending (5, 4, 3, 2, 1)
    final sortedDist = List<RatingDistribution>.from(widget.distribution)
      ..sort((a, b) => b.stars.compareTo(a.stars));

    return sortedDist.asMap().entries.map((entry) {
      final index = entry.key;
      final dist = entry.value;
      final isTouched = index == _touchedIndex;
      final colorIndex = 5 - dist.stars; // 5 stars -> index 0, 1 star -> index 4

      return PieChartSectionData(
        value: dist.percentage * _animation.value,
        color: sectionColors[colorIndex.clamp(0, 4)],
        radius: isTouched ? widget.size * 0.18 : widget.size * 0.15,
        showTitle: widget.showLabels && dist.percentage >= 5,
        title: widget.showLabels ? '${dist.percentage.toInt()}%' : '',
        titleStyle: AppTypography.micro.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      );
    }).toList();
  }

  Widget _buildCenterContent(AppColorsExtension colors) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final displayValue = widget.average * _animation.value;
            return Text(
              displayValue.toStringAsFixed(1),
              style: AppTypography.headline.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            );
          },
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            final filled = index < widget.average.floor();
            final partial =
                index == widget.average.floor() && widget.average % 1 > 0;

            IconData icon;
            if (filled) {
              icon = Icons.star_rounded;
            } else if (partial) {
              icon = Icons.star_half_rounded;
            } else {
              icon = Icons.star_outline_rounded;
            }

            return Icon(
              icon,
              size: 14,
              color: filled || partial ? colors.yellow : colors.textMuted,
            );
          }),
        ),
      ],
    );
  }

  Widget _buildLegend(AppColorsExtension colors) {
    // Sort distribution by stars descending (5, 4, 3, 2, 1)
    final sortedDist = List<RatingDistribution>.from(widget.distribution)
      ..sort((a, b) => b.stars.compareTo(a.stars));

    final sectionColors = [
      colors.green,
      const Color(0xFF8BC34A),
      colors.yellow,
      colors.orange,
      colors.red,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: sortedDist.map((dist) {
        final colorIndex = 5 - dist.stars;
        final isHighlighted = sortedDist.indexOf(dist) == _touchedIndex;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            children: [
              // Star icons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(dist.stars, (index) {
                  return Icon(
                    Icons.star_rounded,
                    size: 12,
                    color: colors.yellow,
                  );
                }),
              ),
              // Pad remaining stars as empty
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5 - dist.stars, (index) {
                  return const Icon(
                    Icons.star_rounded,
                    size: 12,
                    color: Colors.transparent,
                  );
                }),
              ),
              const SizedBox(width: 8),
              // Progress bar
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: colors.bgActive,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return FractionallySizedBox(
                          widthFactor:
                              (dist.percentage / 100) * _animation.value,
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: sectionColors[colorIndex.clamp(0, 4)],
                              borderRadius: BorderRadius.circular(3),
                              boxShadow: isHighlighted
                                  ? [
                                      BoxShadow(
                                        color: sectionColors[
                                                colorIndex.clamp(0, 4)]
                                            .withAlpha(100),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Percentage
              SizedBox(
                width: 36,
                child: Text(
                  '${dist.percentage.toStringAsFixed(0)}%',
                  style: AppTypography.micro.copyWith(
                    color: isHighlighted
                        ? colors.textPrimary
                        : colors.textSecondary,
                    fontWeight:
                        isHighlighted ? FontWeight.w600 : FontWeight.w500,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

/// A compact version of the ring chart without legend
class CompactRingChart extends StatelessWidget {
  final double average;
  final int totalCount;
  final double size;

  const CompactRingChart({
    super.key,
    required this.average,
    required this.totalCount,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: _getRatingColor(colors, average),
              width: 3,
            ),
          ),
          child: Center(
            child: Text(
              average.toStringAsFixed(1),
              style: AppTypography.bodyMedium.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (index) {
                return Icon(
                  index < average.round()
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  size: 12,
                  color: index < average.round()
                      ? colors.yellow
                      : colors.textMuted,
                );
              }),
            ),
            Text(
              '$totalCount reviews',
              style: AppTypography.micro.copyWith(color: colors.textMuted),
            ),
          ],
        ),
      ],
    );
  }

  Color _getRatingColor(AppColorsExtension colors, double rating) {
    if (rating >= 4.5) return colors.green;
    if (rating >= 4.0) return const Color(0xFF8BC34A);
    if (rating >= 3.0) return colors.yellow;
    if (rating >= 2.0) return colors.orange;
    return colors.red;
  }
}
