import 'dart:ui';
import 'package:flutter/material.dart';

/// Theme extension for custom app colors
/// Usage: Theme.of(context).extension<AppColorsExtension>()!.textMuted
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color bgBase;
  final Color bgSurface;
  final Color glassPanel;
  final Color glassPanelAlpha;
  final Color glassBorder;
  final Color glassHighlight;
  final Color bgPanel;
  final Color bgHover;
  final Color bgActive;
  final Color border;
  final Color borderLight;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color accent;
  final Color accentHover;
  final Color accentMuted;
  final Color green;
  final Color greenBright;
  final Color greenDim;
  final Color greenMuted;
  final Color red;
  final Color redBright;
  final Color redDim;
  final Color redMuted;
  final Color yellow;
  final Color yellowBright;
  final Color orange;
  final Color purple;

  const AppColorsExtension({
    required this.bgBase,
    required this.bgSurface,
    required this.glassPanel,
    required this.glassPanelAlpha,
    required this.glassBorder,
    required this.glassHighlight,
    required this.bgPanel,
    required this.bgHover,
    required this.bgActive,
    required this.border,
    required this.borderLight,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.accent,
    required this.accentHover,
    required this.accentMuted,
    required this.green,
    required this.greenBright,
    required this.greenDim,
    required this.greenMuted,
    required this.red,
    required this.redBright,
    required this.redDim,
    required this.redMuted,
    required this.yellow,
    required this.yellowBright,
    required this.orange,
    required this.purple,
  });

  /// Dark theme colors
  static const dark = AppColorsExtension(
    bgBase: AppColors.bgBase,
    bgSurface: AppColors.bgSurface,
    glassPanel: AppColors.glassPanel,
    glassPanelAlpha: AppColors.glassPanelAlpha,
    glassBorder: AppColors.glassBorder,
    glassHighlight: AppColors.glassHighlight,
    bgPanel: AppColors.bgPanel,
    bgHover: AppColors.bgHover,
    bgActive: AppColors.bgActive,
    border: AppColors.border,
    borderLight: AppColors.borderLight,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textMuted: AppColors.textMuted,
    accent: AppColors.accent,
    accentHover: AppColors.accentHover,
    accentMuted: AppColors.accentMuted,
    green: AppColors.green,
    greenBright: AppColors.greenBright,
    greenDim: AppColors.greenDim,
    greenMuted: AppColors.greenMuted,
    red: AppColors.red,
    redBright: AppColors.redBright,
    redDim: AppColors.redDim,
    redMuted: AppColors.redMuted,
    yellow: AppColors.yellow,
    yellowBright: AppColors.yellowBright,
    orange: AppColors.orange,
    purple: AppColors.purple,
  );

  /// Light theme colors
  static const light = AppColorsExtension(
    bgBase: AppColorsLight.bgBase,
    bgSurface: AppColorsLight.bgSurface,
    glassPanel: AppColorsLight.glassPanel,
    glassPanelAlpha: AppColorsLight.glassPanelAlpha,
    glassBorder: AppColorsLight.glassBorder,
    glassHighlight: AppColorsLight.glassHighlight,
    bgPanel: AppColorsLight.bgPanel,
    bgHover: AppColorsLight.bgHover,
    bgActive: AppColorsLight.bgActive,
    border: AppColorsLight.border,
    borderLight: AppColorsLight.borderLight,
    textPrimary: AppColorsLight.textPrimary,
    textSecondary: AppColorsLight.textSecondary,
    textMuted: AppColorsLight.textMuted,
    accent: AppColorsLight.accent,
    accentHover: AppColorsLight.accentHover,
    accentMuted: AppColorsLight.accentMuted,
    green: AppColorsLight.green,
    greenBright: AppColorsLight.greenBright,
    greenDim: AppColorsLight.greenDim,
    greenMuted: AppColorsLight.greenMuted,
    red: AppColorsLight.red,
    redBright: AppColorsLight.redBright,
    redDim: AppColorsLight.redDim,
    redMuted: AppColorsLight.redMuted,
    yellow: AppColorsLight.yellow,
    yellowBright: AppColorsLight.yellowBright,
    orange: AppColorsLight.orange,
    purple: AppColorsLight.purple,
  );

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? bgBase,
    Color? bgSurface,
    Color? glassPanel,
    Color? glassPanelAlpha,
    Color? glassBorder,
    Color? glassHighlight,
    Color? bgPanel,
    Color? bgHover,
    Color? bgActive,
    Color? border,
    Color? borderLight,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? accent,
    Color? accentHover,
    Color? accentMuted,
    Color? green,
    Color? greenBright,
    Color? greenDim,
    Color? greenMuted,
    Color? red,
    Color? redBright,
    Color? redDim,
    Color? redMuted,
    Color? yellow,
    Color? yellowBright,
    Color? orange,
    Color? purple,
  }) {
    return AppColorsExtension(
      bgBase: bgBase ?? this.bgBase,
      bgSurface: bgSurface ?? this.bgSurface,
      glassPanel: glassPanel ?? this.glassPanel,
      glassPanelAlpha: glassPanelAlpha ?? this.glassPanelAlpha,
      glassBorder: glassBorder ?? this.glassBorder,
      glassHighlight: glassHighlight ?? this.glassHighlight,
      bgPanel: bgPanel ?? this.bgPanel,
      bgHover: bgHover ?? this.bgHover,
      bgActive: bgActive ?? this.bgActive,
      border: border ?? this.border,
      borderLight: borderLight ?? this.borderLight,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      accent: accent ?? this.accent,
      accentHover: accentHover ?? this.accentHover,
      accentMuted: accentMuted ?? this.accentMuted,
      green: green ?? this.green,
      greenBright: greenBright ?? this.greenBright,
      greenDim: greenDim ?? this.greenDim,
      greenMuted: greenMuted ?? this.greenMuted,
      red: red ?? this.red,
      redBright: redBright ?? this.redBright,
      redDim: redDim ?? this.redDim,
      redMuted: redMuted ?? this.redMuted,
      yellow: yellow ?? this.yellow,
      yellowBright: yellowBright ?? this.yellowBright,
      orange: orange ?? this.orange,
      purple: purple ?? this.purple,
    );
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
    covariant ThemeExtension<AppColorsExtension>? other,
    double t,
  ) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      bgBase: Color.lerp(bgBase, other.bgBase, t)!,
      bgSurface: Color.lerp(bgSurface, other.bgSurface, t)!,
      glassPanel: Color.lerp(glassPanel, other.glassPanel, t)!,
      glassPanelAlpha: Color.lerp(glassPanelAlpha, other.glassPanelAlpha, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      glassHighlight: Color.lerp(glassHighlight, other.glassHighlight, t)!,
      bgPanel: Color.lerp(bgPanel, other.bgPanel, t)!,
      bgHover: Color.lerp(bgHover, other.bgHover, t)!,
      bgActive: Color.lerp(bgActive, other.bgActive, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderLight: Color.lerp(borderLight, other.borderLight, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentHover: Color.lerp(accentHover, other.accentHover, t)!,
      accentMuted: Color.lerp(accentMuted, other.accentMuted, t)!,
      green: Color.lerp(green, other.green, t)!,
      greenBright: Color.lerp(greenBright, other.greenBright, t)!,
      greenDim: Color.lerp(greenDim, other.greenDim, t)!,
      greenMuted: Color.lerp(greenMuted, other.greenMuted, t)!,
      red: Color.lerp(red, other.red, t)!,
      redBright: Color.lerp(redBright, other.redBright, t)!,
      redDim: Color.lerp(redDim, other.redDim, t)!,
      redMuted: Color.lerp(redMuted, other.redMuted, t)!,
      yellow: Color.lerp(yellow, other.yellow, t)!,
      yellowBright: Color.lerp(yellowBright, other.yellowBright, t)!,
      orange: Color.lerp(orange, other.orange, t)!,
      purple: Color.lerp(purple, other.purple, t)!,
    );
  }
}

/// Convenience extension to access AppColorsExtension
extension AppColorsExtensionContext on BuildContext {
  AppColorsExtension get colors =>
      Theme.of(this).extension<AppColorsExtension>()!;
}

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

  static List<List<Color>> get gradients => [
    gradient1,
    gradient2,
    gradient3,
    gradient4,
  ];

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
    bool isDark = true,
  }) : super(
         color:
             backgroundColor ??
             (isDark
                 ? AppColors.glassPanelAlpha
                 : AppColorsLight.glassPanelAlpha),
         borderRadius: BorderRadius.circular(radius),
         border: showBorder
             ? Border.all(
                 color: isDark
                     ? AppColors.glassBorder
                     : AppColorsLight.glassBorder,
                 width: 1,
               )
             : null,
         boxShadow: [
           BoxShadow(
             color: isDark ? const Color(0x20000000) : const Color(0x10000000),
             blurRadius: 20,
             offset: const Offset(0, 4),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: GlassDecoration(
        radius: radius,
        showBorder: showBorder,
        backgroundColor: backgroundColor,
        isDark: isDark,
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
                  isDark
                      ? AppColors.glassHighlight
                      : AppColorsLight.glassHighlight,
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

/// Colored progress bar widget with animated fill
class ProgressBar extends StatefulWidget {
  final int value; // 0-100
  final double height;
  final double width;
  final Color? color;
  final Color backgroundColor;
  final bool animate;
  final Duration animationDuration;

  const ProgressBar({
    super.key,
    required this.value,
    this.height = 6,
    this.width = 80,
    this.color,
    this.backgroundColor = const Color(0xFF2a2a2a),
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 600),
  });

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fillAnimation;
  late Animation<double> _glowAnimation;
  int _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.animate ? 0 : widget.value;

    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _setupAnimations();

    if (widget.animate) {
      _controller.forward();
    }
  }

  void _setupAnimations() {
    _fillAnimation = Tween<double>(
      begin: _previousValue / 100,
      end: widget.value.clamp(0, 100) / 100,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    // Glow pulses at the end of the animation
    _glowAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 70),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.5), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 1.5, end: 1.0), weight: 15),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(ProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
      _setupAnimations();
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progressColor = widget.color ?? AppColors.getProgressColor(widget.value);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.height / 2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _fillAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: progressColor,
                borderRadius: BorderRadius.circular(widget.height / 2),
                boxShadow: [
                  BoxShadow(
                    color: progressColor.withAlpha((100 * _glowAnimation.value).round()),
                    blurRadius: 6 * _glowAnimation.value,
                    spreadRadius: (_glowAnimation.value - 1) * 2,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
