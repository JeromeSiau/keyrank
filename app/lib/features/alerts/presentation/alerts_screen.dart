import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/states.dart';
import '../providers/alerts_provider.dart';
import 'widgets/alert_template_card.dart';
import 'widgets/alert_rule_tile.dart';

class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final templatesAsync = ref.watch(alertTemplatesProvider);
    final rulesAsync = ref.watch(alertRulesNotifierProvider);
    final rulesNotifier = ref.read(alertRulesNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgBase : AppColorsLight.bgBase,
      appBar: AppBar(
        title: Text(l10n.alerts_title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/alerts/builder'),
            tooltip: l10n.alerts_createCustomRule,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Templates section
            Text(
              l10n.alerts_templatesTitle.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.alerts_templatesSubtitle,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
              ),
            ),
            const SizedBox(height: 16),

            templatesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text(l10n.common_error(e.toString())),
              data: (templates) {
                // Check by name to determine if template is already activated
                final activeNames = rulesAsync.valueOrNull?.map((r) => r.name).toSet() ?? {};

                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: templates.map((template) {
                    return AlertTemplateCard(
                      template: template,
                      isActivated: activeNames.contains(template.name),
                      onActivate: () async {
                        try {
                          await rulesNotifier.createFromTemplate(template);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.alerts_ruleActivated(template.name))),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.common_error(e.toString()))),
                            );
                          }
                        }
                      },
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 32),

            // My Rules section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.alerts_myRulesTitle.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => context.push('/alerts/builder'),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(l10n.alerts_create),
                ),
              ],
            ),
            const SizedBox(height: 12),

            rulesAsync.when(
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(message: e.toString(), onRetry: rulesNotifier.load),
              data: (rules) {
                if (rules.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.rule_folder_outlined,
                            size: 48,
                            color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${l10n.alerts_noRulesYet}. ${l10n.alerts_noRulesDescription}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: rules.length,
                  itemBuilder: (context, index) {
                    final rule = rules[index];
                    return AlertRuleTile(
                      rule: rule,
                      onToggle: () => rulesNotifier.toggle(rule.id),
                      onEdit: () => context.push('/alerts/builder', extra: rule),
                      onDelete: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(l10n.alerts_deleteConfirm),
                            content: Text(l10n.alerts_deleteMessage(rule.name)),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: Text(l10n.common_cancel),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: Text(
                                  l10n.common_delete,
                                  style: TextStyle(color: isDark ? AppColors.red : AppColorsLight.red),
                                ),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          await rulesNotifier.delete(rule.id);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
