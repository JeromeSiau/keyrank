import 'package:flutter/material.dart';
import '../constants/breakpoints.dart';

/// Builder widget that provides different layouts based on screen size
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) mobile;
  final Widget Function(BuildContext context)? tablet;
  final Widget Function(BuildContext context) desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (Breakpoints.isMobile(width)) {
          return mobile(context);
        }

        if (Breakpoints.isTablet(width)) {
          return tablet?.call(context) ?? desktop(context);
        }

        return desktop(context);
      },
    );
  }
}

/// Simpler widget that just provides the current screen size
class ResponsiveWidget extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenSize screenSize) builder;

  const ResponsiveWidget({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = constraints.maxWidth.screenSize;
        return builder(context, screenSize);
      },
    );
  }
}
