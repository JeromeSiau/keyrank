import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../domain/app_model.dart';

class AppKeywordsTab extends ConsumerWidget {
  final int appId;
  final AppModel app;

  const AppKeywordsTab({
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
            context.l10n.appDetail_tabKeywords,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          // TODO: Move keyword tracking table and add keyword functionality here
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
                  Icons.key_rounded,
                  size: 48,
                  color: colors.textMuted,
                ),
                const SizedBox(height: 12),
                Text(
                  'Keyword tracking functionality will be displayed here',
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
