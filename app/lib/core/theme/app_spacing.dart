/// Spacing constants for consistent layout throughout the app
/// Based on an 8pt grid system with 4pt for fine-tuning
class AppSpacing {
  // Base unit
  static const double unit = 8.0;

  // Fine-grained spacing
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // Component-specific spacing
  static const double cardPadding = 16.0;
  static const double cardPaddingLarge = 20.0;
  static const double panelPadding = 20.0;
  static const double screenPadding = 20.0;
  static const double sectionSpacing = 24.0;

  // Grid gaps
  static const double gridGapSmall = 12.0;
  static const double gridGapMedium = 16.0;
  static const double gridGapLarge = 20.0;

  // List spacing
  static const double listItemSpacing = 12.0;
  static const double listSectionSpacing = 20.0;

  // Form spacing
  static const double formFieldSpacing = 16.0;
  static const double formSectionSpacing = 24.0;

  // Icon spacing
  static const double iconTextGap = 8.0;
  static const double iconTextGapSmall = 6.0;
  static const double iconTextGapLarge = 12.0;

  // Inline element spacing
  static const double inlineGap = 4.0;
  static const double inlineGapMedium = 8.0;
  static const double inlineGapLarge = 12.0;

  // Toolbar/header heights
  static const double toolbarHeight = 56.0;
  static const double toolbarHeightCompact = 48.0;
  static const double appBarHeight = 64.0;

  // Touch targets (minimum for accessibility)
  static const double touchTargetMin = 44.0;
  static const double touchTargetSmall = 36.0;

  // Breakpoints for responsive design
  static const double breakpointMobile = 600.0;
  static const double breakpointTablet = 900.0;
  static const double breakpointDesktop = 1200.0;
  static const double breakpointWide = 1600.0;
}
