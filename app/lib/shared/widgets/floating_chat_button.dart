import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A floating action button for opening AI chat.
/// Features pulse animation when first shown.
class FloatingChatButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isExpanded;

  const FloatingChatButton({
    super.key,
    required this.onTap,
    this.isExpanded = false,
  });

  @override
  State<FloatingChatButton> createState() => _FloatingChatButtonState();
}

class _FloatingChatButtonState extends State<FloatingChatButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _isHovered ? 1.1 : _scaleAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  horizontal: widget.isExpanded ? 16 : 14,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colors.accent, colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(
                    widget.isExpanded ? 28 : 56,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.accent.withAlpha(_isHovered ? 100 : 60),
                      blurRadius: _isHovered ? 20 : 12,
                      spreadRadius: _isHovered ? 2 : 0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
                    if (widget.isExpanded) ...[
                      const SizedBox(width: 8),
                      const Text(
                        'Chat AI',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
