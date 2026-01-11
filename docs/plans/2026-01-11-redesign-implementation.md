# Redesign Appfigures-Style Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Refonte complète de l'UI Keyrank inspirée d'Appfigures avec nouvelle navigation, composants visuels enrichis, et dashboards améliorés.

**Architecture:** Approche modulaire par phases. Phase 1 crée les composants fondamentaux réutilisables. Les phases suivantes utilisent ces composants pour reconstruire les écrans. Chaque phase est indépendante et livrable.

**Tech Stack:** Flutter 3.x, Riverpod 2.6+, GoRouter, fl_chart, Freezed

---

## Phase 1: Composants Visuels Fondamentaux

### Task 1.1: MetricCard - Carte de métrique avec tendance

**Files:**
- Create: `app/lib/shared/widgets/metric_card.dart`
- Modify: `app/lib/shared/widgets/widgets.dart` (export)
- Test: `app/test/shared/widgets/metric_card_test.dart`

**Step 1: Create the widget file**

```dart
// app/lib/shared/widgets/metric_card.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A glass-styled metric card displaying a value with trend indicator.
///
/// Used in dashboards to show KPIs like downloads, revenue, ratings.
/// Features hover glow effect and colored trend badge.
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
    final isPositive = (widget.change ?? 0) >= 0;
    final trendColor = widget.change == null
        ? colors.textMuted
        : (isPositive ? colors.green : colors.red);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.glassPanelAlpha,
            borderRadius: BorderRadius.circular(AppColors.radiusMedium),
            border: Border.all(color: colors.glassBorder),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? colors.accent.withAlpha(30)
                    : colors.bgBase.withAlpha(20),
                blurRadius: _isHovered ? 16 : 8,
                spreadRadius: _isHovered ? 2 : 0,
              ),
            ],
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
              if (widget.change != null) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    TrendBadge(change: widget.change!),
                    if (widget.subtitle != null) ...[
                      const SizedBox(width: 6),
                      Text(
                        widget.subtitle!,
                        style: TextStyle(
                          fontSize: 11,
                          color: colors.textMuted,
                        ),
                      ),
                    ],
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
```

**Step 2: Export from widgets barrel**

Add to `app/lib/shared/widgets/widgets.dart`:
```dart
export 'metric_card.dart';
```

**Step 3: Write widget test**

```dart
// app/test/shared/widgets/metric_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ranking/shared/widgets/metric_card.dart';
import 'package:ranking/core/theme/app_theme.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(body: child),
    );
  }

  group('MetricCard', () {
    testWidgets('displays label and value', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const MetricCard(label: 'Downloads', value: '36.7K'),
      ));

      expect(find.text('Downloads'), findsOneWidget);
      expect(find.text('36.7K'), findsOneWidget);
    });

    testWidgets('displays positive trend with green color', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const MetricCard(label: 'Downloads', value: '36.7K', change: 29.0),
      ));

      expect(find.text('+29%'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
    });

    testWidgets('displays negative trend with red color', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const MetricCard(label: 'Downloads', value: '36.7K', change: -15.0),
      ));

      expect(find.text('-15%'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(buildTestWidget(
        MetricCard(
          label: 'Downloads',
          value: '36.7K',
          onTap: () => tapped = true,
        ),
      ));

      await tester.tap(find.byType(MetricCard));
      expect(tapped, isTrue);
    });
  });

  group('TrendBadge', () {
    testWidgets('displays zero change correctly', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const TrendBadge(change: 0),
      ));

      expect(find.text('0%'), findsOneWidget);
    });
  });
}
```

**Step 4: Run tests**

```bash
cd app && flutter test test/shared/widgets/metric_card_test.dart -v
```
Expected: All tests PASS

**Step 5: Commit**

```bash
git add app/lib/shared/widgets/metric_card.dart app/lib/shared/widgets/widgets.dart app/test/shared/widgets/metric_card_test.dart
git commit -m "feat(widgets): add MetricCard and TrendBadge components"
```

---

### Task 1.2: Sparkline - Mini graphique inline

**Files:**
- Create: `app/lib/shared/widgets/sparkline.dart`
- Modify: `app/lib/shared/widgets/widgets.dart` (export)
- Test: `app/test/shared/widgets/sparkline_test.dart`

**Step 1: Create the widget file**

```dart
// app/lib/shared/widgets/sparkline.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A minimal sparkline chart for inline trend visualization.
///
/// Used in tables to show 30-day trends without axes or labels.
/// Color is determined by overall trend direction (first vs last point).
class Sparkline extends StatelessWidget {
  final List<double> data;
  final double width;
  final double height;
  final double strokeWidth;
  final Color? color;
  final bool showGradient;

  const Sparkline({
    super.key,
    required this.data,
    this.width = 80,
    this.height = 24,
    this.strokeWidth = 2,
    this.color,
    this.showGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty || data.length < 2) {
      return SizedBox(width: width, height: height);
    }

    final colors = context.colors;
    final trend = data.last - data.first;
    final lineColor = color ?? (trend >= 0 ? colors.green : colors.red);

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _SparklinePainter(
          data: data,
          color: lineColor,
          strokeWidth: strokeWidth,
          showGradient: showGradient,
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final double strokeWidth;
  final bool showGradient;

  _SparklinePainter({
    required this.data,
    required this.color,
    required this.strokeWidth,
    required this.showGradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final minValue = data.reduce((a, b) => a < b ? a : b);
    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final range = maxValue - minValue;
    final effectiveRange = range == 0 ? 1.0 : range;

    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final normalizedY = (data[i] - minValue) / effectiveRange;
      final y = size.height - (normalizedY * size.height * 0.8) - (size.height * 0.1);
      points.add(Offset(x, y));
    }

    // Draw gradient fill
    if (showGradient && points.length >= 2) {
      final fillPath = Path()
        ..moveTo(points.first.dx, size.height)
        ..lineTo(points.first.dx, points.first.dy);

      for (final point in points.skip(1)) {
        fillPath.lineTo(point.dx, point.dy);
      }
      fillPath.lineTo(points.last.dx, size.height);
      fillPath.close();

      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withAlpha(40),
          color.withAlpha(0),
        ],
      );

      final fillPaint = Paint()
        ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      canvas.drawPath(fillPath, fillPaint);
    }

    // Draw line
    final linePath = Path();
    linePath.moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      linePath.lineTo(point.dx, point.dy);
    }

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
```

**Step 2: Export from widgets barrel**

Add to `app/lib/shared/widgets/widgets.dart`:
```dart
export 'sparkline.dart';
```

**Step 3: Write widget test**

```dart
// app/test/shared/widgets/sparkline_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ranking/shared/widgets/sparkline.dart';
import 'package:ranking/core/theme/app_theme.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(body: child),
    );
  }

  group('Sparkline', () {
    testWidgets('renders with valid data', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Sparkline(data: [1, 2, 3, 4, 5]),
      ));

      expect(find.byType(Sparkline), findsOneWidget);
      expect(find.byType(CustomPaint), findsOneWidget);
    });

    testWidgets('handles empty data gracefully', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Sparkline(data: []),
      ));

      expect(find.byType(Sparkline), findsOneWidget);
    });

    testWidgets('handles single data point', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Sparkline(data: [5]),
      ));

      expect(find.byType(Sparkline), findsOneWidget);
    });

    testWidgets('respects custom dimensions', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Sparkline(data: [1, 2, 3], width: 120, height: 32),
      ));

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, 120);
      expect(sizedBox.height, 32);
    });
  });
}
```

**Step 4: Run tests**

```bash
cd app && flutter test test/shared/widgets/sparkline_test.dart -v
```
Expected: All tests PASS

**Step 5: Commit**

```bash
git add app/lib/shared/widgets/sparkline.dart app/lib/shared/widgets/widgets.dart app/test/shared/widgets/sparkline_test.dart
git commit -m "feat(widgets): add Sparkline chart component"
```

---

### Task 1.3: SentimentBar - Barre de sentiment

**Files:**
- Create: `app/lib/shared/widgets/sentiment_bar.dart`
- Modify: `app/lib/shared/widgets/widgets.dart` (export)
- Test: `app/test/shared/widgets/sentiment_bar_test.dart`

**Step 1: Create the widget file**

```dart
// app/lib/shared/widgets/sentiment_bar.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A horizontal bar showing positive/negative sentiment distribution.
///
/// Displays percentages on both ends with a bi-color bar.
/// Tooltip shows the basis for the calculation.
class SentimentBar extends StatelessWidget {
  final double positivePercent; // 0-100
  final String? tooltipText; // e.g., "Based on 1,847 reviews"
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
                      Text('😊', style: TextStyle(fontSize: 14)),
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
                      Text('😞', style: TextStyle(fontSize: 14)),
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

/// A compact sentiment indicator without the full bar.
/// Shows just the percentage and a small colored dot.
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
```

**Step 2: Export from widgets barrel**

Add to `app/lib/shared/widgets/widgets.dart`:
```dart
export 'sentiment_bar.dart';
```

**Step 3: Write widget test**

```dart
// app/test/shared/widgets/sentiment_bar_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ranking/shared/widgets/sentiment_bar.dart';
import 'package:ranking/core/theme/app_theme.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(body: Center(child: SizedBox(width: 200, child: child))),
    );
  }

  group('SentimentBar', () {
    testWidgets('displays correct percentages', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const SentimentBar(positivePercent: 89),
      ));

      expect(find.text('89%'), findsOneWidget);
      expect(find.text('11%'), findsOneWidget);
    });

    testWidgets('displays tooltip text when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const SentimentBar(
          positivePercent: 89,
          tooltipText: 'Based on 1,847 reviews',
        ),
      ));

      expect(find.text('Based on 1,847 reviews'), findsOneWidget);
    });

    testWidgets('hides labels when showLabels is false', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const SentimentBar(positivePercent: 89, showLabels: false),
      ));

      expect(find.text('89%'), findsNothing);
    });
  });

  group('SentimentIndicator', () {
    testWidgets('shows positive sentiment correctly', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const SentimentIndicator(positivePercent: 75),
      ));

      expect(find.text('75%'), findsOneWidget);
    });
  });
}
```

**Step 4: Run tests**

```bash
cd app && flutter test test/shared/widgets/sentiment_bar_test.dart -v
```
Expected: All tests PASS

**Step 5: Commit**

```bash
git add app/lib/shared/widgets/sentiment_bar.dart app/lib/shared/widgets/widgets.dart app/test/shared/widgets/sentiment_bar_test.dart
git commit -m "feat(widgets): add SentimentBar and SentimentIndicator components"
```

---

### Task 1.4: StarHistogram - Distribution des notes

**Files:**
- Create: `app/lib/shared/widgets/star_histogram.dart`
- Modify: `app/lib/shared/widgets/widgets.dart` (export)
- Test: `app/test/shared/widgets/star_histogram_test.dart`

**Step 1: Create the widget file**

```dart
// app/lib/shared/widgets/star_histogram.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A horizontal histogram showing rating distribution (5 stars to 1 star).
///
/// Each bar is proportional to the count, with color gradient from green (5★) to red (1★).
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

/// A compact rating display with average and total.
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
```

**Step 2: Export from widgets barrel**

Add to `app/lib/shared/widgets/widgets.dart`:
```dart
export 'star_histogram.dart';
```

**Step 3: Write widget test**

```dart
// app/test/shared/widgets/star_histogram_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ranking/shared/widgets/star_histogram.dart';
import 'package:ranking/core/theme/app_theme.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(body: Center(child: SizedBox(width: 300, child: child))),
    );
  }

  group('StarHistogram', () {
    testWidgets('renders all 5 bars', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const StarHistogram(
          fiveStars: 9300000,
          fourStars: 965000,
          threeStars: 389000,
          twoStars: 156000,
          oneStar: 539000,
        ),
      ));

      // Should have 5 rows (one for each star level)
      expect(find.byIcon(Icons.star), findsWidgets);
    });

    testWidgets('formats large numbers correctly', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const StarHistogram(
          fiveStars: 9300000,
          fourStars: 965000,
          threeStars: 389000,
          twoStars: 156000,
          oneStar: 539000,
        ),
      ));

      expect(find.text('9.3M'), findsOneWidget);
      expect(find.text('965.0K'), findsOneWidget);
    });

    testWidgets('handles zero values', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const StarHistogram(
          fiveStars: 100,
          fourStars: 0,
          threeStars: 0,
          twoStars: 0,
          oneStar: 0,
        ),
      ));

      expect(find.byType(StarHistogram), findsOneWidget);
    });
  });

  group('RatingSummary', () {
    testWidgets('displays rating and count', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const RatingSummary(averageRating: 4.61, totalRatings: 11400000),
      ));

      expect(find.text('4.61'), findsOneWidget);
      expect(find.text('11.4M Ratings'), findsOneWidget);
    });
  });
}
```

**Step 4: Run tests**

```bash
cd app && flutter test test/shared/widgets/star_histogram_test.dart -v
```
Expected: All tests PASS

**Step 5: Commit**

```bash
git add app/lib/shared/widgets/star_histogram.dart app/lib/shared/widgets/widgets.dart app/test/shared/widgets/star_histogram_test.dart
git commit -m "feat(widgets): add StarHistogram and RatingSummary components"
```

---

### Task 1.5: CountryDistribution - Distribution par pays

**Files:**
- Create: `app/lib/shared/widgets/country_distribution.dart`
- Modify: `app/lib/shared/widgets/widgets.dart` (export)
- Test: `app/test/shared/widgets/country_distribution_test.dart`

**Step 1: Create the widget file**

```dart
// app/lib/shared/widgets/country_distribution.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A country entry for the distribution list.
class CountryData {
  final String code; // ISO country code, e.g., 'us'
  final String name;
  final double percent;
  final String? flagEmoji;

  const CountryData({
    required this.code,
    required this.name,
    required this.percent,
    this.flagEmoji,
  });
}

/// A list showing distribution by country with flag, name, bar, and percentage.
class CountryDistribution extends StatelessWidget {
  final List<CountryData> countries;
  final int maxItems;
  final double barHeight;

  const CountryDistribution({
    super.key,
    required this.countries,
    this.maxItems = 5,
    this.barHeight = 6,
  });

  @override
  Widget build(BuildContext context) {
    final displayCountries = countries.take(maxItems).toList();
    final maxPercent = displayCountries.isNotEmpty
        ? displayCountries.map((c) => c.percent).reduce((a, b) => a > b ? a : b)
        : 100.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: displayCountries.asMap().entries.map((entry) {
        final index = entry.key;
        final country = entry.value;
        return Padding(
          padding: EdgeInsets.only(bottom: index < displayCountries.length - 1 ? 12 : 0),
          child: _CountryRow(
            country: country,
            maxPercent: maxPercent,
            barHeight: barHeight,
          ),
        );
      }).toList(),
    );
  }
}

class _CountryRow extends StatelessWidget {
  final CountryData country;
  final double maxPercent;
  final double barHeight;

  const _CountryRow({
    required this.country,
    required this.maxPercent,
    required this.barHeight,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fraction = maxPercent > 0 ? country.percent / maxPercent : 0.0;

    return Row(
      children: [
        // Flag
        Text(
          country.flagEmoji ?? _getFlag(country.code),
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 8),
        // Country name
        Expanded(
          flex: 2,
          child: Text(
            country.name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: colors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),
        // Bar
        Expanded(
          flex: 3,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: colors.bgHover,
                      borderRadius: BorderRadius.circular(barHeight / 2),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    width: constraints.maxWidth * fraction,
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: colors.accent,
                      borderRadius: BorderRadius.circular(barHeight / 2),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        // Percentage
        SizedBox(
          width: 45,
          child: Text(
            '${country.percent.toStringAsFixed(1)}%',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  String _getFlag(String countryCode) {
    // Convert country code to flag emoji
    final code = countryCode.toUpperCase();
    if (code.length != 2) return '🏳️';

    final first = code.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final second = code.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCodes([first, second]);
  }
}
```

**Step 2: Export from widgets barrel**

Add to `app/lib/shared/widgets/widgets.dart`:
```dart
export 'country_distribution.dart';
```

**Step 3: Write widget test**

```dart
// app/test/shared/widgets/country_distribution_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ranking/shared/widgets/country_distribution.dart';
import 'package:ranking/core/theme/app_theme.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(body: Center(child: SizedBox(width: 300, child: child))),
    );
  }

  final testCountries = [
    const CountryData(code: 'us', name: 'United States', percent: 24.3),
    const CountryData(code: 'au', name: 'Australia', percent: 8.9),
    const CountryData(code: 'ca', name: 'Canada', percent: 8.7),
    const CountryData(code: 'gb', name: 'United Kingdom', percent: 8.7),
    const CountryData(code: 'fr', name: 'France', percent: 8.5),
  ];

  group('CountryDistribution', () {
    testWidgets('displays all countries up to maxItems', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        CountryDistribution(countries: testCountries),
      ));

      expect(find.text('United States'), findsOneWidget);
      expect(find.text('Australia'), findsOneWidget);
      expect(find.text('24.3%'), findsOneWidget);
    });

    testWidgets('respects maxItems limit', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        CountryDistribution(countries: testCountries, maxItems: 3),
      ));

      expect(find.text('United States'), findsOneWidget);
      expect(find.text('Canada'), findsOneWidget);
      expect(find.text('United Kingdom'), findsNothing);
    });

    testWidgets('handles empty list', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const CountryDistribution(countries: []),
      ));

      expect(find.byType(CountryDistribution), findsOneWidget);
    });
  });
}
```

**Step 4: Run tests**

```bash
cd app && flutter test test/shared/widgets/country_distribution_test.dart -v
```
Expected: All tests PASS

**Step 5: Commit**

```bash
git add app/lib/shared/widgets/country_distribution.dart app/lib/shared/widgets/widgets.dart app/test/shared/widgets/country_distribution_test.dart
git commit -m "feat(widgets): add CountryDistribution component"
```

---

### Task 1.6: DataTable améliorée avec sparklines

**Files:**
- Create: `app/lib/shared/widgets/data_table_enhanced.dart`
- Modify: `app/lib/shared/widgets/widgets.dart` (export)

**Step 1: Create the widget file**

```dart
// app/lib/shared/widgets/data_table_enhanced.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'sparkline.dart';

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

  const EnhancedCell.text(String value, {TextStyle? style, TextAlign align = TextAlign.left})
      : text = value,
        widget = null,
        style = style,
        align = align;

  const EnhancedCell.widget(Widget value, {TextAlign align = TextAlign.left})
      : text = null,
        widget = value,
        style = null,
        align = align;
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
                onTap: widget.onRowTap != null ? () => widget.onRowTap!(rowIndex) : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isHovered ? colors.bgHover : Colors.transparent,
                    border: isLast ? null : Border(bottom: BorderSide(color: colors.glassBorder.withAlpha(100))),
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

  Widget _buildHeaderCell(EnhancedColumn column, int index, bool isLast, AppColorsExtension colors) {
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
                  ? (widget.sortAscending ? Icons.arrow_upward : Icons.arrow_downward)
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

  Widget _buildDataCell(EnhancedCell cell, EnhancedColumn column, bool isLast, AppColorsExtension colors) {
    Widget content;

    if (cell.widget != null) {
      content = cell.widget!;
    } else {
      content = Text(
        cell.text ?? '',
        style: cell.style ?? TextStyle(
          fontSize: 13,
          color: colors.textPrimary,
        ),
        textAlign: cell.align,
      );
    }

    return _wrapCell(content, column, isLast, cell.align);
  }

  Widget _wrapCell(Widget content, EnhancedColumn column, bool isLast, TextAlign align) {
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
```

**Step 2: Export from widgets barrel**

Add to `app/lib/shared/widgets/widgets.dart`:
```dart
export 'data_table_enhanced.dart';
```

**Step 3: Commit**

```bash
git add app/lib/shared/widgets/data_table_enhanced.dart app/lib/shared/widgets/widgets.dart
git commit -m "feat(widgets): add EnhancedDataTable with glass styling"
```

---

## Phase 2: Navigation Restructurée

### Task 2.1: Ajouter les nouvelles routes

**Files:**
- Modify: `app/lib/core/router/app_router.dart`
- Create: `app/lib/features/ratings/presentation/ratings_analysis_screen.dart` (placeholder)
- Create: `app/lib/features/keywords/presentation/top_charts_screen.dart` (placeholder)
- Create: `app/lib/features/keywords/presentation/competitors_screen.dart` (placeholder)

**Step 1: Create placeholder screens**

```dart
// app/lib/features/ratings/presentation/ratings_analysis_screen.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class RatingsAnalysisScreen extends StatelessWidget {
  const RatingsAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      body: Center(
        child: Text(
          'Ratings Analysis - Coming Soon',
          style: TextStyle(color: colors.textPrimary),
        ),
      ),
    );
  }
}
```

```dart
// app/lib/features/keywords/presentation/top_charts_screen.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TopChartsScreen extends StatelessWidget {
  const TopChartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      body: Center(
        child: Text(
          'Top Charts - Coming Soon',
          style: TextStyle(color: colors.textPrimary),
        ),
      ),
    );
  }
}
```

```dart
// app/lib/features/keywords/presentation/competitors_screen.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class CompetitorsScreen extends StatelessWidget {
  const CompetitorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      body: Center(
        child: Text(
          'Competitors - Coming Soon',
          style: TextStyle(color: colors.textPrimary),
        ),
      ),
    );
  }
}
```

**Step 2: Update router with new routes**

In `app/lib/core/router/app_router.dart`, add imports and routes:

```dart
// Add imports
import '../../features/ratings/presentation/ratings_analysis_screen.dart';
import '../../features/keywords/presentation/top_charts_screen.dart';
import '../../features/keywords/presentation/competitors_screen.dart';

// Add routes inside ShellRoute routes list (after /reviews):
GoRoute(
  path: '/ratings',
  builder: (context, state) => const RatingsAnalysisScreen(),
),
GoRoute(
  path: '/top-charts',
  builder: (context, state) => const TopChartsScreen(),
),
GoRoute(
  path: '/competitors',
  builder: (context, state) => const CompetitorsScreen(),
),
```

**Step 3: Commit**

```bash
git add app/lib/features/ratings/presentation/ratings_analysis_screen.dart app/lib/features/keywords/presentation/top_charts_screen.dart app/lib/features/keywords/presentation/competitors_screen.dart app/lib/core/router/app_router.dart
git commit -m "feat(router): add new routes for ratings, top charts, competitors"
```

---

### Task 2.2: Refactorer la sidebar avec nouvelle structure

**Files:**
- Modify: `app/lib/core/router/app_router.dart` (sidebar sections)
- Modify: `app/lib/l10n/app_en.arb` (new navigation labels)
- Modify: `app/lib/l10n/app_fr.arb` (new navigation labels)

**Step 1: Add new localization keys**

In `app/lib/l10n/app_en.arb`, add:
```json
"nav_optimization": "Optimization",
"nav_keywordInspector": "Keyword Inspector",
"nav_keywordPerformance": "Keyword Performance",
"nav_ratingsAnalysis": "Ratings Analysis",
"nav_intelligence": "Intelligence",
"nav_topCharts": "Top Charts",
"nav_competitors": "Competitors"
```

In `app/lib/l10n/app_fr.arb`, add:
```json
"nav_optimization": "Optimisation",
"nav_keywordInspector": "Inspecteur de mots-clés",
"nav_keywordPerformance": "Performance des mots-clés",
"nav_ratingsAnalysis": "Analyse des notes",
"nav_intelligence": "Intelligence",
"nav_topCharts": "Top Charts",
"nav_competitors": "Concurrents"
```

**Step 2: Update sidebar navigation structure**

Modify `_GlassSidebar.build()` in `app/lib/core/router/app_router.dart`:

```dart
// Inside _buildNavSection calls, update to new structure:

// OVERVIEW section
_buildNavSection(
  context,
  isDark: isDark,
  label: context.l10n.nav_overview,
  items: [
    _NavItemData(
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      label: context.l10n.nav_dashboard,
      index: 0,
    ),
  ],
),
const SizedBox(height: 16),

// MES APPS section with app list
_buildNavSection(
  context,
  isDark: isDark,
  label: context.l10n.nav_myApps,
  items: [],
),
SidebarAppsList(selectedAppId: selectedAppId),
const SizedBox(height: 20),

// OPTIMIZATION section
_buildNavSection(
  context,
  isDark: isDark,
  label: context.l10n.nav_optimization,
  items: [
    _NavItemData(
      icon: Icons.search_outlined,
      selectedIcon: Icons.search,
      label: context.l10n.nav_keywordInspector,
      index: 2,
    ),
  ],
),
const SizedBox(height: 20),

// ENGAGEMENT section
_buildNavSection(
  context,
  isDark: isDark,
  label: context.l10n.nav_engagement,
  items: [
    _NavItemData(
      icon: Icons.inbox_outlined,
      selectedIcon: Icons.inbox_rounded,
      label: context.l10n.nav_reviewsInbox,
      index: 3,
    ),
    _NavItemData(
      icon: Icons.star_outline,
      selectedIcon: Icons.star,
      label: context.l10n.nav_ratingsAnalysis,
      index: 4,
    ),
  ],
),
const SizedBox(height: 20),

// INTELLIGENCE section
_buildNavSection(
  context,
  isDark: isDark,
  label: context.l10n.nav_intelligence,
  items: [
    _NavItemData(
      icon: Icons.explore_outlined,
      selectedIcon: Icons.explore,
      label: context.l10n.nav_discover,
      index: 5,
    ),
    _NavItemData(
      icon: Icons.leaderboard_outlined,
      selectedIcon: Icons.leaderboard,
      label: context.l10n.nav_topCharts,
      index: 6,
    ),
    _NavItemData(
      icon: Icons.people_outline,
      selectedIcon: Icons.people,
      label: context.l10n.nav_competitors,
      index: 7,
    ),
  ],
),
```

**Step 3: Update navigation index mappings**

Update `_getSelectedIndex` and `_onDestinationSelected` in MainShell:

```dart
int _getSelectedIndex(BuildContext context) {
  final location = GoRouterState.of(context).matchedLocation;
  if (location.startsWith('/apps')) return 1;
  if (location == '/discover') return 2;
  if (location.startsWith('/reviews')) return 3;
  if (location.startsWith('/ratings')) return 4;
  if (location.startsWith('/discover')) return 5;
  if (location.startsWith('/top-charts')) return 6;
  if (location.startsWith('/competitors')) return 7;
  return 0;
}

void _onDestinationSelected(BuildContext context, int index) {
  switch (index) {
    case 0:
      context.go('/dashboard');
      break;
    case 1:
      context.go('/apps');
      break;
    case 2:
      context.go('/discover'); // Keyword Inspector
      break;
    case 3:
      context.go('/reviews');
      break;
    case 4:
      context.go('/ratings');
      break;
    case 5:
      context.go('/discover');
      break;
    case 6:
      context.go('/top-charts');
      break;
    case 7:
      context.go('/competitors');
      break;
  }
}
```

**Step 4: Run Flutter gen-l10n**

```bash
cd app && flutter gen-l10n
```

**Step 5: Commit**

```bash
git add app/lib/core/router/app_router.dart app/lib/l10n/
git commit -m "feat(nav): restructure sidebar with new sections"
```

---

## Phase 3: Dashboard Refactor

### Task 3.1: Créer le nouveau layout Dashboard

**Files:**
- Modify: `app/lib/features/dashboard/presentation/dashboard_screen.dart`

**Step 1: Rewrite dashboard with new components**

Le dashboard actuel sera remplacé par le nouveau layout avec:
- Metrics bar (5 cards)
- Downloads trend chart
- Top countries
- Sentiment overview
- Recent activity
- Top performing apps table

*(Code complet fourni lors de l'implémentation - environ 300 lignes)*

**Step 2: Run app to verify**

```bash
cd app && flutter run --dart-define=API_BASE_URL=http://localhost:8000/api
```

**Step 3: Commit**

```bash
git add app/lib/features/dashboard/
git commit -m "feat(dashboard): implement new Appfigures-style layout"
```

---

## Phase 4: App Detail avec onglets

### Task 4.1: Refactorer AppDetailScreen avec TabBar

**Files:**
- Modify: `app/lib/features/apps/presentation/app_detail_screen.dart`
- Create: `app/lib/features/apps/presentation/tabs/app_overview_tab.dart`
- Create: `app/lib/features/apps/presentation/tabs/app_keywords_tab.dart`
- Create: `app/lib/features/apps/presentation/tabs/app_reviews_tab.dart`
- Create: `app/lib/features/apps/presentation/tabs/app_ratings_tab.dart`
- Create: `app/lib/features/apps/presentation/tabs/app_insights_tab.dart`

*(Détails fournis lors de l'implémentation)*

---

## Phase 5: Reviews & Ratings enrichis

### Task 5.1: Enrichir Reviews Inbox

**Files:**
- Modify: `app/lib/features/reviews/presentation/reviews_inbox_screen.dart`

*(Ajouter overview cards, sentiment breakdown chart, améliorer les filtres)*

### Task 5.2: Implémenter Ratings Analysis screen

**Files:**
- Modify: `app/lib/features/ratings/presentation/ratings_analysis_screen.dart`

*(Layout avec current rating, histogram, by country, trend chart)*

---

## Phase 6: Intelligence section

### Task 6.1: Refactorer Keyword Inspector (Discover)

**Files:**
- Modify: `app/lib/features/keywords/presentation/discover_screen.dart`

### Task 6.2: Implémenter Top Charts

**Files:**
- Modify: `app/lib/features/keywords/presentation/top_charts_screen.dart`

### Task 6.3: Implémenter Competitors view

**Files:**
- Modify: `app/lib/features/keywords/presentation/competitors_screen.dart`

---

## Récapitulatif des commits

1. `feat(widgets): add MetricCard and TrendBadge components`
2. `feat(widgets): add Sparkline chart component`
3. `feat(widgets): add SentimentBar and SentimentIndicator components`
4. `feat(widgets): add StarHistogram and RatingSummary components`
5. `feat(widgets): add CountryDistribution component`
6. `feat(widgets): add EnhancedDataTable with glass styling`
7. `feat(router): add new routes for ratings, top charts, competitors`
8. `feat(nav): restructure sidebar with new sections`
9. `feat(dashboard): implement new Appfigures-style layout`
10. `feat(app-detail): add tabbed layout with overview, keywords, reviews, ratings, insights`
11. `feat(reviews): enhance inbox with sentiment analysis`
12. `feat(ratings): implement ratings analysis screen`
13. `feat(intelligence): refactor keyword inspector`
14. `feat(intelligence): implement top charts screen`
15. `feat(intelligence): implement competitors view`

---

## Notes pour l'implémentation

- **Tests** : Chaque widget a des tests unitaires. Les écrans complexes auront des tests d'intégration.
- **Ordre** : Respecter l'ordre des phases. Phase 1 (widgets) est requise avant les autres.
- **Données** : Certaines fonctionnalités (geographic data, revenue) dépendent du backend. Utiliser des données mock si non disponibles.
- **Responsive** : Tous les écrans doivent fonctionner sur mobile/tablet/desktop.
