import 'package:flutter/material.dart';

/// KeyRank logo colors (from 1B design)
class KeyrankColors {
  static const Color bar1 = Color(0xFF4f46e5);
  static const Color bar2 = Color(0xFF6366f1);
  static const Color bar3 = Color(0xFF818cf8);
  static const Color arrow = Color(0xFFa5b4fc);
  static const Color bgDark = Color(0xFF18181b);
  static const Color border = Color(0xFF27272a);
}

/// KeyRank Logo icon widget - renders the 1B contained logo
class KeyrankLogoIcon extends StatelessWidget {
  final double size;
  final bool showBackground;

  const KeyrankLogoIcon({
    super.key,
    this.size = 56,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _KeyrankLogoPainter(showBackground: showBackground),
      ),
    );
  }
}

/// Full KeyRank logo with icon and wordmark
class KeyrankLogo extends StatelessWidget {
  final double iconSize;
  final double fontSize;
  final bool showBackground;
  final bool showTagline;
  final String? tagline;
  final Color? textColor;
  final MainAxisAlignment alignment;

  const KeyrankLogo({
    super.key,
    this.iconSize = 56,
    this.fontSize = 28,
    this.showBackground = true,
    this.showTagline = false,
    this.tagline,
    this.textColor,
    this.alignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: alignment,
          children: [
            KeyrankLogoIcon(
              size: iconSize,
              showBackground: showBackground,
            ),
            SizedBox(width: iconSize * 0.25),
            Text(
              'keyrank',
              style: TextStyle(
                fontFamily: 'Sora',
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                color: textColor ?? Colors.white,
                letterSpacing: -1,
              ),
            ),
          ],
        ),
        if (showTagline && tagline != null) ...[
          SizedBox(height: iconSize * 0.15),
          Text(
            tagline!,
            style: TextStyle(
              fontSize: fontSize * 0.5,
              color: (textColor ?? Colors.white).withAlpha(150),
            ),
          ),
        ],
      ],
    );
  }
}

/// Stacked logo variant (icon on top, text below)
class KeyrankLogoStacked extends StatelessWidget {
  final double iconSize;
  final double fontSize;
  final bool showBackground;
  final String? tagline;
  final Color? textColor;

  const KeyrankLogoStacked({
    super.key,
    this.iconSize = 64,
    this.fontSize = 26,
    this.showBackground = true,
    this.tagline,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = textColor ?? Colors.white;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        KeyrankLogoIcon(
          size: iconSize,
          showBackground: showBackground,
        ),
        SizedBox(height: iconSize * 0.28),
        Text(
          'keyrank',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: -0.5,
          ),
        ),
        if (tagline != null) ...[
          const SizedBox(height: 4),
          Text(
            tagline!,
            style: TextStyle(
              fontSize: 14,
              color: color.withAlpha(150),
            ),
          ),
        ],
      ],
    );
  }
}

class _KeyrankLogoPainter extends CustomPainter {
  final bool showBackground;

  _KeyrankLogoPainter({this.showBackground = true});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 56;
    canvas.scale(scale);

    if (showBackground) {
      // Background rounded rectangle
      final bgRect = RRect.fromRectAndRadius(
        const Rect.fromLTWH(2, 2, 52, 52),
        const Radius.circular(14),
      );

      // Fill
      final bgPaint = Paint()
        ..color = KeyrankColors.bgDark
        ..style = PaintingStyle.fill;
      canvas.drawRRect(bgRect, bgPaint);

      // Border
      final borderPaint = Paint()
        ..color = KeyrankColors.border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawRRect(bgRect, borderPaint);
    }

    // Bar 1 (smallest)
    final bar1Rect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(10, 34, 10, 14),
      const Radius.circular(2),
    );
    canvas.drawRRect(bar1Rect, Paint()..color = KeyrankColors.bar1);

    // Bar 2 (medium)
    final bar2Rect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(23, 26, 10, 22),
      const Radius.circular(2),
    );
    canvas.drawRRect(bar2Rect, Paint()..color = KeyrankColors.bar2);

    // Bar 3 (tallest)
    final bar3Rect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(36, 16, 10, 32),
      const Radius.circular(2),
    );
    canvas.drawRRect(bar3Rect, Paint()..color = KeyrankColors.bar3);

    // Arrow - vertical line
    final arrowPaint = Paint()
      ..color = KeyrankColors.arrow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(46, 8), const Offset(46, 14), arrowPaint);

    // Arrow - head
    final arrowPath = Path()
      ..moveTo(43, 11)
      ..lineTo(46, 8)
      ..lineTo(49, 11);

    final arrowHeadPaint = Paint()
      ..color = KeyrankColors.arrow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(arrowPath, arrowHeadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
