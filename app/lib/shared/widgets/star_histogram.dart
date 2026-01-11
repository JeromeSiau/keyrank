import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A horizontal histogram showing rating distribution (5 stars to 1 star).
/// Each bar is proportional to the count, with color gradient from green (5) to red (1).
class StarHistogram extends StatelessWidget {
  final int fiveStars;
  final int fourStars;
  final int threeStars;
  final int twoStars;
  final int oneStar;
  final double barHeight;
  final double spacing;

  const StarHistogram({
    super.key,
    required this.fiveStars,
    required this.fourStars,
    required this.threeStars,
    required this.twoStars,
    required this.oneStar,
    this.barHeight = 12,
    this.spacing = 6,
  });

  int get total => fiveStars + fourStars + threeStars + twoStars + oneStar;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final maxCount = [fiveStars, fourStars, threeStars, twoStars, oneStar]
        .reduce((a, b) => a > b ? a : b);

    final bars = [
      _BarData(5, fiveStars, colors.green),
      _BarData(4, fourStars, colors.greenBright),
      _BarData(3, threeStars, colors.yellow),
      _BarData(2, twoStars, colors.orange),
      _BarData(1, oneStar, colors.red),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: bars.map((bar) {
        final fraction = maxCount > 0 ? bar.count / maxCount : 0.0;
        return Padding(
          padding: EdgeInsets.only(bottom: bar.stars > 1 ? spacing : 0),
          child: _StarBar(
            stars: bar.stars,
            count: bar.count,
            fraction: fraction,
            color: bar.color,
            height: barHeight,
          ),
        );
      }).toList(),
    );
  }
}

class _BarData {
  final int stars;
  final int count;
  final Color color;

  _BarData(this.stars, this.count, this.color);
}

class _StarBar extends StatelessWidget {
  final int stars;
  final int count;
  final double fraction;
  final Color color;
  final double height;

  const _StarBar({
    required this.stars,
    required this.count,
    required this.fraction,
    required this.color,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        // Star icons
        SizedBox(
          width: 70,
          child: Row(
            children: List.generate(5, (index) {
              return Icon(
                index < stars ? Icons.star : Icons.star_border,
                size: 12,
                color: index < stars ? colors.yellow : colors.textMuted.withAlpha(100),
              );
            }),
          ),
        ),
        const SizedBox(width: 8),
        // Bar
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  // Background
                  Container(
                    height: height,
                    decoration: BoxDecoration(
                      color: colors.bgHover,
                      borderRadius: BorderRadius.circular(height / 2),
                    ),
                  ),
                  // Filled bar
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    width: constraints.maxWidth * fraction,
                    height: height,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(height / 2),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        // Count
        SizedBox(
          width: 50,
          child: Text(
            _formatCount(count),
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colors.textSecondary,
            ),
          ),
        ),
      ],
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

/// A compact rating display with average rating and total count.
class RatingSummary extends StatelessWidget {
  final double averageRating;
  final int totalRatings;

  const RatingSummary({
    super.key,
    required this.averageRating,
    required this.totalRatings,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Icon(Icons.star, size: 28, color: colors.yellow),
            const SizedBox(width: 4),
            Text(
              averageRating.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${_formatCount(totalRatings)} Ratings',
          style: TextStyle(
            fontSize: 13,
            color: colors.textMuted,
          ),
        ),
      ],
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
