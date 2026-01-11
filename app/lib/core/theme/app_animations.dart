import 'package:flutter/material.dart';

/// Animation constants for consistent motion throughout the app
/// Following Apple's fluid animation principles
class AppAnimations {
  // Default transitions
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration defaultDuration = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration slower = Duration(milliseconds: 600);

  // Specific use cases
  static const Duration hover = Duration(milliseconds: 150);
  static const Duration tooltip = Duration(milliseconds: 200);
  static const Duration modal = Duration(milliseconds: 300);
  static const Duration page = Duration(milliseconds: 350);
  static const Duration drawer = Duration(milliseconds: 300);

  // Chart animations
  static const Duration chartLoad = Duration(milliseconds: 600);
  static const Duration chartUpdate = Duration(milliseconds: 400);
  static const Duration chartTooltip = Duration(milliseconds: 150);

  // Counter/number animations
  static const Duration countUp = Duration(milliseconds: 400);
  static const Duration countUpSlow = Duration(milliseconds: 800);

  // Loading states
  static const Duration shimmer = Duration(milliseconds: 1500);
  static const Duration pulse = Duration(milliseconds: 1000);
  static const Duration spin = Duration(milliseconds: 1200);

  // Stagger delays for list animations
  static const Duration staggerDelay = Duration(milliseconds: 50);
  static const Duration staggerDelayFast = Duration(milliseconds: 30);

  // Default curves
  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve entrance = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve emphasized = Curves.easeInOutCubic;

  // Chart-specific curves
  static const Curve chartCurve = Curves.easeOutQuart;
  static const Curve chartEnter = Curves.easeOutBack;

  // Bounce effects
  static const Curve bounce = Curves.elasticOut;
  static const Curve bounceIn = Curves.bounceIn;
  static const Curve bounceOut = Curves.bounceOut;

  // Spring-like curves
  static const Curve spring = Curves.easeOutBack;
  static const Curve springTight = Curves.easeOutCubic;

  // Linear for continuous animations
  static const Curve linear = Curves.linear;
}

/// Staggered animation helper
class StaggeredAnimation {
  final int index;
  final Duration baseDelay;
  final Duration itemDelay;

  const StaggeredAnimation({
    required this.index,
    this.baseDelay = Duration.zero,
    this.itemDelay = AppAnimations.staggerDelay,
  });

  Duration get delay => baseDelay + (itemDelay * index);

  /// Creates a delayed animation controller
  Future<void> wait() => Future.delayed(delay);
}
