import 'dart:ui';
import 'package:flutter/material.dart';

/// Design system colors for liquid glass dark theme
class AppColors {
  // Base backgrounds - darker for contrast with glass panels
  static const bgBase = Color(0xFF0a0a0a);
  static const bgSurface = Color(0xFF111111);

  // Glass effect backgrounds (semi-transparent)
  static const glassPanel = Color(0xFF1a1a1a);
  static const glassPanelAlpha = Color(0xE61a1a1a); // 90% opacity
  static const glassBorder = Color(0xFF2d2d2d);
  static const glassHighlight = Color(0x0Affffff); // subtle white highlight

  // Legacy support
  static const bgPanel = glassPanel;
  static const bgHover = Color(0xFF252525);
  static const bgActive = Color(0xFF2a2a2a);

  // Borders
  static const border = Color(0xFF2d2d2d);
  static const borderLight = Color(0xFF3a3a3a);

  // Text
  static const textPrimary = Color(0xFFf0f0f0);
  static const textSecondary = Color(0xFFa0a0a0);
  static const textMuted = Color(0xFF6a6a6a);

  // Accent - vibrant blue
  static const accent = Color(0xFF3b82f6);
  static const accentHover = Color(0xFF2563eb);
  static const accentMuted = Color(0x263b82f6);

  // Semantic colors - more vibrant for progress bars
  static const green = Color(0xFF22c55e);
  static const greenBright = Color(0xFF4ade80);
  static const greenDim = Color(0xFF166534);
  static const greenMuted = Color(0x2622c55e);

  static const red = Color(0xFFef4444);
  static const redBright = Color(0xFFf87171);
  static const redDim = Color(0xFF991b1b);
  static const redMuted = Color(0x26ef4444);

  static const yellow = Color(0xFFeab308);
  static const yellowBright = Color(0xFFfacc15);
  static const orange = Color(0xFFf97316);
  static const purple = Color(0xFFa855f7);

  // Standard radius for liquid glass effect
  static const double radiusSmall = 10.0;
  static const double radiusMedium = 14.0;
  static const double radiusLarge = 18.0;
  static const double radiusXLarge = 24.0;

  // Gradients for app icons
  static const gradient1 = [Color(0xFF6366f1), Color(0xFF8b5cf6)];
  static const gradient2 = [Color(0xFF10b981), Color(0xFF34d399)];
  static const gradient3 = [Color(0xFFf97316), Color(0xFFfb923c)];
  static const gradient4 = [Color(0xFFec4899), Color(0xFFf472b6)];

  static List<List<Color>> get gradients => [gradient1, gradient2, gradient3, gradient4];

  static LinearGradient getGradient(int index) {
    final colors = gradients[index % gradients.length];
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );
  }

  // Progress bar color based on value (0-100)
  static Color getProgressColor(int value) {
    if (value >= 70) return greenBright;
    if (value >= 40) return yellowBright;
    return redBright;
  }
}

/// Design system colors for liquid glass light theme
class AppColorsLight {
  // Base backgrounds - light for contrast with glass panels
  static const bgBase = Color(0xFFf5f5f7);
  static const bgSurface = Color(0xFFffffff);

  // Glass effect backgrounds (semi-transparent white)
  static const glassPanel = Color(0xFFffffff);
  static const glassPanelAlpha = Color(0xCCffffff); // 80% opacity
  static const glassBorder = Color(0xFFe0e0e0);
  static const glassHighlight = Color(0x08000000); // subtle dark highlight

  // Legacy support
  static const bgPanel = glassPanel;
  static const bgHover = Color(0xFFf0f0f0);
  static const bgActive = Color(0xFFe8e8e8);

  // Borders
  static const border = Color(0xFFe5e5e5);
  static const borderLight = Color(0xFFd4d4d4);

  // Text
  static const textPrimary = Color(0xFF1a1a1a);
  static const textSecondary = Color(0xFF6b6b6b);
  static const textMuted = Color(0xFF9a9a9a);

  // Accent - slightly darker blue for contrast
  static const accent = Color(0xFF2563eb);
  static const accentHover = Color(0xFF1d4ed8);
  static const accentMuted = Color(0x262563eb);

  // Semantic colors remain vibrant
  static const green = Color(0xFF16a34a);
  static const greenBright = Color(0xFF22c55e);
  static const greenDim = Color(0xFF166534);
  static const greenMuted = Color(0x2616a34a);

  static const red = Color(0xFFdc2626);
  static const redBright = Color(0xFFef4444);
  static const redDim = Color(0xFF991b1b);
  static const redMuted = Color(0x26dc2626);

  static const yellow = Color(0xFFca8a04);
  static const yellowBright = Color(0xFFeab308);
  static const orange = Color(0xFFea580c);
  static const purple = Color(0xFF9333ea);
}

/// Glass panel decoration with frosted effect
class GlassDecoration extends BoxDecoration {
  GlassDecoration({
    double radius = AppColors.radiusMedium,
    bool showBorder = true,
    Color? backgroundColor,
  }) : super(
          color: backgroundColor ?? AppColors.glassPanelAlpha,
          borderRadius: BorderRadius.circular(radius),
          border: showBorder
              ? Border.all(color: AppColors.glassBorder, width: 1)
              : null,
          boxShadow: const [
            BoxShadow(
              color: Color(0x20000000),
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        );
}

/// Glass container widget with optional blur
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool showBorder;
  final Color? backgroundColor;
  final double? width;
  final double? height;

  const GlassContainer({
    super.key,
    required this.child,
    this.radius = AppColors.radiusMedium,
    this.padding,
    this.margin,
    this.showBorder = true,
    this.backgroundColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: GlassDecoration(
        radius: radius,
        showBorder: showBorder,
        backgroundColor: backgroundColor,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.glassHighlight,
                  Colors.transparent,
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Colored progress bar widget
class ProgressBar extends StatelessWidget {
  final int value; // 0-100
  final double height;
  final double width;
  final Color? color;
  final Color backgroundColor;

  const ProgressBar({
    super.key,
    required this.value,
    this.height = 6,
    this.width = 80,
    this.color,
    this.backgroundColor = const Color(0xFF2a2a2a),
  });

  @override
  Widget build(BuildContext context) {
    final progressColor = color ?? AppColors.getProgressColor(value);
    final clampedValue = value.clamp(0, 100);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: clampedValue / 100,
        child: Container(
          decoration: BoxDecoration(
            color: progressColor,
            borderRadius: BorderRadius.circular(height / 2),
            boxShadow: [
              BoxShadow(
                color: progressColor.withAlpha(100),
                blurRadius: 6,
                offset: const Offset(0, 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
