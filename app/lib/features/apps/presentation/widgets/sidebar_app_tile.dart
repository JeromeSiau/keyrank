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

class _SidebarAppTileState extends State<SidebarAppTile> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Material(
        color: widget.isSelected
            ? AppColors.accent.withAlpha(30)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(AppColors.radiusSmall),
          hoverColor: AppColors.bgHover,
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
                    color: AppColors.bgActive,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: widget.app.iconUrl != null
                      ? Image.network(
                          widget.app.iconUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const Icon(
                            Icons.apps,
                            size: 14,
                            color: AppColors.textMuted,
                          ),
                        )
                      : const Icon(
                          Icons.apps,
                          size: 14,
                          color: AppColors.textMuted,
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
                      color: AppColors.textMuted,
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
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Favorite star (visible on hover or if favorite)
                if (_isHovering || widget.app.isFavorite)
                  GestureDetector(
                    onTap: widget.onToggleFavorite,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Icon(
                        widget.app.isFavorite
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: 16,
                        color: widget.app.isFavorite
                            ? AppColors.yellow
                            : AppColors.textMuted,
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
