/// Responsive breakpoints for the app
class Breakpoints {
  Breakpoints._();

  /// Mobile: < 600px - Bottom Navigation Bar
  static const double mobile = 600;

  /// Tablet: 600-1024px - Navigation Rail
  static const double tablet = 1024;

  /// Check if width is mobile
  static bool isMobile(double width) => width < mobile;

  /// Check if width is tablet
  static bool isTablet(double width) => width >= mobile && width < tablet;

  /// Check if width is desktop
  static bool isDesktop(double width) => width >= tablet;
}

/// Screen size enum for cleaner conditionals
enum ScreenSize { mobile, tablet, desktop }

/// Extension to get ScreenSize from width
extension ScreenSizeExtension on double {
  ScreenSize get screenSize {
    if (this < Breakpoints.mobile) return ScreenSize.mobile;
    if (this < Breakpoints.tablet) return ScreenSize.tablet;
    return ScreenSize.desktop;
  }
}
