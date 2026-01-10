import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PlatformTabs extends StatefulWidget {
  final String selectedPlatform;
  final List<String> availablePlatforms;
  final ValueChanged<String> onPlatformChanged;

  const PlatformTabs({
    super.key,
    required this.selectedPlatform,
    required this.availablePlatforms,
    required this.onPlatformChanged,
  });

  @override
  State<PlatformTabs> createState() => _PlatformTabsState();
}

class _PlatformTabsState extends State<PlatformTabs>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  int _selectedIndex = 0;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.availablePlatforms.indexOf(widget.selectedPlatform);
    _previousIndex = _selectedIndex;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 280),
      vsync: this,
    );

    _slideAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.18), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.18, end: 1.0), weight: 60),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(PlatformTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedPlatform != widget.selectedPlatform) {
      _previousIndex = _selectedIndex;
      _selectedIndex =
          widget.availablePlatforms.indexOf(widget.selectedPlatform);
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
    final colors = context.colors;
    final itemCount = widget.availablePlatforms.length;

    return Container(
      decoration: BoxDecoration(
        color: colors.bgActive,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        border: Border.all(color: colors.glassBorder),
      ),
      padding: const EdgeInsets.all(4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Animated sliding indicator
              AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  final itemWidth = constraints.maxWidth / itemCount;
                  final startPos = _previousIndex * itemWidth;
                  final endPos = _selectedIndex * itemWidth;
                  final currentPos =
                      startPos + (endPos - startPos) * _slideAnimation.value;

                  return Positioned(
                    left: currentPos,
                    top: 0,
                    bottom: 0,
                    width: itemWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.glassPanel,
                        borderRadius:
                            BorderRadius.circular(AppColors.radiusSmall - 2),
                        boxShadow: [
                          BoxShadow(
                            color: colors.accent.withAlpha(20),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              // Tab items
              Row(
                mainAxisSize: MainAxisSize.min,
                children: widget.availablePlatforms.map((platform) {
                  final isSelected = platform == widget.selectedPlatform;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => widget.onPlatformChanged(platform),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Animated emoji
                            AnimatedBuilder(
                              animation: _scaleAnimation,
                              builder: (context, child) {
                                final scale = isSelected &&
                                        _controller.status ==
                                            AnimationStatus.forward
                                    ? _scaleAnimation.value
                                    : 1.0;
                                return Transform.scale(
                                  scale: scale,
                                  child: Text(
                                    platform == 'ios' ? '🍎' : '🤖',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 6),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? colors.textPrimary
                                    : colors.textMuted,
                              ),
                              child: Text(
                                platform == 'ios' ? 'iOS' : 'Android',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
