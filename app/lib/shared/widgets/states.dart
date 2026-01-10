import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/l10n_extension.dart';

/// Loading indicator widget
class LoadingView extends StatelessWidget {
  final String? message;

  const LoadingView({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(strokeWidth: 2),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(
                color: colors.textMuted,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Error view with retry button
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  const ErrorView({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colors.redMuted,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 32, color: colors.red),
          ),
          const SizedBox(height: 20),
          Text(
            'Error: $message',
            style: TextStyle(
              fontSize: 14,
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 20),
            Material(
              color: colors.accent,
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              child: InkWell(
                onTap: onRetry,
                borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text(
                    context.l10n.common_retry,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Empty state view with icon, title, subtitle and optional action
class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;
  final Color? iconBackgroundColor;

  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
    this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: iconBackgroundColor ?? colors.bgActive,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              size: 40,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: colors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 28),
            Material(
              color: colors.accent,
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              child: InkWell(
                onTap: onAction,
                borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (actionIcon != null) ...[
                        Icon(actionIcon, size: 18, color: Colors.white),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        actionLabel!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
