import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/app_model.dart';

class SidebarAppTile extends StatefulWidget {
  final AppModel app;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final bool showPlatformBadge;

  const SidebarAppTile({
    super.key,
    required this.app,
    required this.isSelected,
    required this.onTap,
    required this.onToggleFavorite,
    this.showPlatformBadge = false,
  });

  @override
  State<SidebarAppTile> createState() => _SidebarAppTileState();
}

class _SidebarAppTileState extends State<SidebarAppTile>
    with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  late AnimationController _starController;
  late Animation<double> _starScale;
  late Animation<double> _starRotation;

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _starScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.35), weight: 35),
      TweenSequenceItem(tween: Tween(begin: 1.35, end: 0.9), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 40),
    ]).animate(CurvedAnimation(
      parent: _starController,
      curve: Curves.easeOutBack,
    ));

    _starRotation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.15), weight: 30),
      TweenSequenceItem(tween: Tween(begin: -0.15, end: 0.1), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.1, end: 0.0), weight: 30),
    ]).animate(CurvedAnimation(
      parent: _starController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(SidebarAppTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.app.isFavorite != widget.app.isFavorite) {
      _starController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _starController.dispose();
    super.dispose();
  }

  void _handleFavoriteTap() {
    _starController.forward(from: 0);
    widget.onToggleFavorite();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final showStar = _isHovering || widget.app.isFavorite;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Material(
        color: widget.isSelected
            ? colors.accent.withAlpha(30)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(AppColors.radiusSmall),
          hoverColor: colors.bgHover,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                // App icon
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: colors.bgActive,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: widget.app.iconUrl != null
                      ? Image.network(
                          widget.app.iconUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Icon(
                            Icons.apps,
                            size: 14,
                            color: colors.textMuted,
                          ),
                        )
                      : Icon(
                          Icons.apps,
                          size: 14,
                          color: colors.textMuted,
                        ),
                ),
                const SizedBox(width: 8),
                // Platform icon (inline before name)
                if (widget.showPlatformBadge)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(
                      widget.app.isIos ? Icons.apple : Icons.android,
                      size: 14,
                      color: colors.textMuted,
                    ),
                  ),
                // App name
                Expanded(
                  child: Text(
                    widget.app.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: widget.isSelected
                          ? colors.textPrimary
                          : colors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Animated favorite star
                AnimatedOpacity(
                  opacity: showStar ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 150),
                  child: AnimatedScale(
                    scale: showStar ? 1.0 : 0.5,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutBack,
                    child: GestureDetector(
                      onTap: _handleFavoriteTap,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: AnimatedBuilder(
                          animation: _starController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _starScale.value,
                              child: Transform.rotate(
                                angle: _starRotation.value,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  transitionBuilder: (child, animation) {
                                    return ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    );
                                  },
                                  child: Icon(
                                    widget.app.isFavorite
                                        ? Icons.star_rounded
                                        : Icons.star_outline_rounded,
                                    key: ValueKey(widget.app.isFavorite),
                                    size: 16,
                                    color: widget.app.isFavorite
                                        ? colors.yellow
                                        : colors.textMuted,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
