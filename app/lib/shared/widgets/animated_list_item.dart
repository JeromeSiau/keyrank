import 'package:flutter/material.dart';

/// A wrapper widget that animates its child with a staggered slide-in effect.
/// Use this to animate list items appearing in sequence.
class AnimatedListItem extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration delay;
  final Duration duration;
  final Offset slideOffset;
  final Curve curve;

  const AnimatedListItem({
    super.key,
    required this.child,
    required this.index,
    this.delay = const Duration(milliseconds: 50),
    this.duration = const Duration(milliseconds: 300),
    this.slideOffset = const Offset(-0.1, 0),
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.slideOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Stagger the animation based on index
    final staggerDelay = Duration(
      milliseconds: widget.delay.inMilliseconds * widget.index,
    );

    // Cap the delay at 300ms to prevent too long waits
    final cappedDelay = staggerDelay.inMilliseconds > 300
        ? const Duration(milliseconds: 300)
        : staggerDelay;

    Future.delayed(cappedDelay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: widget.child,
      ),
    );
  }
}

/// A wrapper for building animated lists with staggered entrance.
/// Wraps each child with AnimatedListItem automatically.
class AnimatedListBuilder extends StatelessWidget {
  final List<Widget> children;
  final Duration itemDelay;
  final Duration itemDuration;
  final Offset slideOffset;
  final Curve curve;

  const AnimatedListBuilder({
    super.key,
    required this.children,
    this.itemDelay = const Duration(milliseconds: 50),
    this.itemDuration = const Duration(milliseconds: 300),
    this.slideOffset = const Offset(-0.1, 0),
    this.curve = Curves.easeOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children.asMap().entries.map((entry) {
        return AnimatedListItem(
          index: entry.key,
          delay: itemDelay,
          duration: itemDuration,
          slideOffset: slideOffset,
          curve: curve,
          child: entry.value,
        );
      }).toList(),
    );
  }
}
