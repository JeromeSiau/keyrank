import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../domain/app_model.dart';

class AppRatingsTab extends ConsumerWidget {
  final int appId;
  final AppModel app;

  const AppRatingsTab({
    super.key,
    required this.appId,
    required this.app,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.appDetail_tabRatings,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          // TODO: Move ratings histogram and analysis here
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colors.bgHover,
              borderRadius: BorderRadius.circular(AppColors.radiusMedium),
              border: Border.all(color: colors.glassBorder),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.bar_chart_rounded,
                  size: 48,
                  color: colors.textMuted,
                ),
                const SizedBox(height: 12),
                Text(
                  'Ratings histogram and analysis will be displayed here',
                  style: TextStyle(color: colors.textMuted),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
