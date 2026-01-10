import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CollapsibleSection extends StatelessWidget {
  final String label;
  final int count;
  final bool isExpanded;
  final VoidCallback onToggle;
  final List<Widget> children;
  final double maxHeight;

  const CollapsibleSection({
    super.key,
    required this.label,
    required this.count,
    required this.isExpanded,
    required this.onToggle,
    required this.children,
    this.maxHeight = 200,
  });

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
            onTap: onToggle,
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
            hoverColor: colors.bgHover,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_right_rounded,
                    size: 16,
                    color: colors.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: colors.textMuted,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: colors.bgActive,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: colors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Content
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState:
              isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: children,
            ),
          ),
        ),
      ],
    );
  }
}
