import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CollapsibleSection extends StatefulWidget {
  final String label;
  final int count;
  final bool isExpanded;
  final VoidCallback onToggle;
  final List<Widget> children;
  final double maxHeight;
  final bool animateChildren;

  const CollapsibleSection({
    super.key,
    required this.label,
    required this.count,
    required this.isExpanded,
    required this.onToggle,
    required this.children,
    this.maxHeight = 200,
    this.animateChildren = true,
  });

  @override
  State<CollapsibleSection> createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<CollapsibleSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _arrowRotation;
  late Animation<double> _contentHeight;
  int _animationKey = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
      value: widget.isExpanded ? 1.0 : 0.0,
    );

    _arrowRotation = Tween<double>(
      begin: 0.0,
      end: 0.25, // 90 degrees (0.25 * 2 * pi)
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _contentHeight = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void didUpdateWidget(CollapsibleSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isExpanded != widget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
        // Trigger child re-animation when expanding
        if (widget.animateChildren) {
          setState(() => _animationKey++);
        }
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onToggle,
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
            hoverColor: colors.bgHover,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  // Animated rotating arrow
                  AnimatedBuilder(
                    animation: _arrowRotation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _arrowRotation.value * 3.14159 * 2,
                        child: Icon(
                          Icons.keyboard_arrow_right_rounded,
                          size: 16,
                          color: colors.textMuted,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: colors.textMuted,
                    ),
                  ),
                  const Spacer(),
                  // Animated count badge
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: widget.isExpanded
                          ? colors.accent.withAlpha(30)
                          : colors.bgActive,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${widget.count}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: widget.isExpanded
                            ? colors.accent
                            : colors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Content with slide animation
        SizeTransition(
          sizeFactor: _contentHeight,
          axisAlignment: -1.0,
          child: FadeTransition(
            opacity: _contentHeight,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: widget.maxHeight),
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: widget.animateChildren
                    ? widget.children.asMap().entries.map((entry) {
                        return _StaggeredListItem(
                          key: ValueKey('${_animationKey}_${entry.key}'),
                          index: entry.key,
                          child: entry.value,
                        );
                      }).toList()
                    : widget.children,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Internal widget for staggered list item animation
class _StaggeredListItem extends StatefulWidget {
  final int index;
  final Widget child;

  const _StaggeredListItem({
    super.key,
    required this.index,
    required this.child,
  });

  @override
  State<_StaggeredListItem> createState() => _StaggeredListItemState();
}

class _StaggeredListItemState extends State<_StaggeredListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.15, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Stagger delay capped at 200ms
    final delay = Duration(
      milliseconds: (widget.index * 40).clamp(0, 200),
    );

    Future.delayed(delay, () {
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
