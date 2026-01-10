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
/// Set [animate] to true to enable staggered bar animation on mount
class KeyrankLogoIcon extends StatefulWidget {
  final double size;
  final bool showBackground;
  final bool animate;
  final bool pulseArrow;

  const KeyrankLogoIcon({
    super.key,
    this.size = 56,
    this.showBackground = true,
    this.animate = false,
    this.pulseArrow = false,
  });

  @override
  State<KeyrankLogoIcon> createState() => _KeyrankLogoIconState();
}

class _KeyrankLogoIconState extends State<KeyrankLogoIcon>
    with TickerProviderStateMixin {
  late AnimationController _barController;
  late AnimationController _arrowController;
  late Animation<double> _bar1Height;
  late Animation<double> _bar2Height;
  late Animation<double> _bar3Height;
  late Animation<double> _arrowOpacity;

  @override
  void initState() {
    super.initState();

    // Staggered bar animation
    _barController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Bar 1: smallest, animates first (0.0 - 0.4)
    _bar1Height = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _barController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutBack),
      ),
    );

    // Bar 2: medium, animates second (0.15 - 0.55)
    _bar2Height = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _barController,
        curve: const Interval(0.15, 0.55, curve: Curves.easeOutBack),
      ),
    );

    // Bar 3: tallest, animates last (0.3 - 0.7)
    _bar3Height = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _barController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOutBack),
      ),
    );

    // Arrow pulse animation
    _arrowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _arrowOpacity = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _arrowController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.animate) {
      _barController.forward();
    } else {
      _barController.value = 1.0;
    }

    if (widget.pulseArrow) {
      _arrowController.repeat(reverse: true);
    } else {
      _arrowController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(KeyrankLogoIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      _barController.forward(from: 0);
    }
    if (widget.pulseArrow && !oldWidget.pulseArrow) {
      _arrowController.repeat(reverse: true);
    } else if (!widget.pulseArrow && oldWidget.pulseArrow) {
      _arrowController.stop();
      _arrowController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _barController.dispose();
    _arrowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([_barController, _arrowController]),
        builder: (context, child) {
          return CustomPaint(
            painter: _KeyrankLogoPainter(
              showBackground: widget.showBackground,
              bar1Progress: _bar1Height.value,
              bar2Progress: _bar2Height.value,
              bar3Progress: _bar3Height.value,
              arrowOpacity: _arrowOpacity.value,
            ),
          );
        },
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
  final double bar1Progress;
  final double bar2Progress;
  final double bar3Progress;
  final double arrowOpacity;

  _KeyrankLogoPainter({
    this.showBackground = true,
    this.bar1Progress = 1.0,
    this.bar2Progress = 1.0,
    this.bar3Progress = 1.0,
    this.arrowOpacity = 1.0,
  });

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

    // Bar 1 (smallest) - height: 14, bottom: 48
    final bar1Height = 14 * bar1Progress;
    if (bar1Height > 0) {
      final bar1Rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(10, 48 - bar1Height, 10, bar1Height),
        const Radius.circular(2),
      );
      canvas.drawRRect(bar1Rect, Paint()..color = KeyrankColors.bar1);
    }

    // Bar 2 (medium) - height: 22, bottom: 48
    final bar2Height = 22 * bar2Progress;
    if (bar2Height > 0) {
      final bar2Rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(23, 48 - bar2Height, 10, bar2Height),
        const Radius.circular(2),
      );
      canvas.drawRRect(bar2Rect, Paint()..color = KeyrankColors.bar2);
    }

    // Bar 3 (tallest) - height: 32, bottom: 48
    final bar3Height = 32 * bar3Progress;
    if (bar3Height > 0) {
      final bar3Rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(36, 48 - bar3Height, 10, bar3Height),
        const Radius.circular(2),
      );
      canvas.drawRRect(bar3Rect, Paint()..color = KeyrankColors.bar3);
    }

    // Arrow - vertical line
    final arrowColor = KeyrankColors.arrow.withAlpha((255 * arrowOpacity).round());
    final arrowPaint = Paint()
      ..color = arrowColor
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
      ..color = arrowColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(arrowPath, arrowHeadPaint);
  }

  @override
  bool shouldRepaint(covariant _KeyrankLogoPainter oldDelegate) {
    return oldDelegate.bar1Progress != bar1Progress ||
        oldDelegate.bar2Progress != bar2Progress ||
        oldDelegate.bar3Progress != bar3Progress ||
        oldDelegate.arrowOpacity != arrowOpacity ||
        oldDelegate.showBackground != showBackground;
  }
}
