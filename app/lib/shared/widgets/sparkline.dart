import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A minimal sparkline chart for inline trend visualization.
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
