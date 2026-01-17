import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/billing_models.dart';
import '../providers/billing_provider.dart';

class BillingScreen extends ConsumerStatefulWidget {
  const BillingScreen({super.key});

  @override
  ConsumerState<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends ConsumerState<BillingScreen> {
  String _selectedPeriod = 'monthly';

  @override
  void initState() {
    super.initState();
    // Refresh status when returning from checkout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uri = GoRouterState.of(context).uri;
      if (uri.queryParameters['success'] == 'true') {
        ref.read(billingActionsProvider.notifier).refresh();
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.billing_subscriptionActivated),
            backgroundColor: AppColors.green,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final statusAsync = ref.watch(subscriptionStatusProvider);
    final plansAsync = ref.watch(availablePlansProvider);
    final actionsState = ref.watch(billingActionsProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgBase : AppColorsLight.bgBase,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.billing_title,
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
          ),
        ),
      ),
      body: statusAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (status) => plansAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (plans) => _buildContent(
            context,
            status,
            plans,
            isDark,
            actionsState.isLoading,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    SubscriptionStatus status,
    List<SubscriptionPlan> plans,
    bool isDark,
    bool isLoading,
  ) {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current plan card
          _CurrentPlanCard(status: status, isDark: isDark, l10n: l10n),

          const SizedBox(height: 24),

          // Actions for subscribed users
          if (status.isPaid) ...[
            _SubscriptionActionsCard(
              status: status,
              isDark: isDark,
              isLoading: isLoading,
              onManage: () => _openPortal(context),
              onCancel: () => _cancelSubscription(context),
              onResume: () => _resumeSubscription(context),
              l10n: l10n,
            ),
            const SizedBox(height: 24),
          ],

          // Billing period toggle
          if (!status.isPaid) ...[
            _BillingPeriodToggle(
              selectedPeriod: _selectedPeriod,
              isDark: isDark,
              onChanged: (period) => setState(() => _selectedPeriod = period),
              l10n: l10n,
            ),
            const SizedBox(height: 24),
          ],

          // Plans
          Text(
            status.isPaid ? l10n.billing_changePlan : l10n.billing_choosePlan,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          ...plans.map((plan) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _PlanCard(
              plan: plan,
              currentPlan: status.plan,
              billingPeriod: _selectedPeriod,
              isDark: isDark,
              isLoading: isLoading,
              onSelect: plan.key == status.plan || plan.isFree
                  ? null
                  : () => _selectPlan(context, plan.key),
              l10n: l10n,
            ),
          )),
        ],
      ),
    );
  }

  Future<void> _selectPlan(BuildContext context, String planKey) async {
    final checkoutUrl = await ref.read(billingActionsProvider.notifier).checkout(
      plan: planKey,
      billingPeriod: _selectedPeriod,
    );

    if (checkoutUrl != null && mounted) {
      final uri = Uri.parse(checkoutUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  Future<void> _openPortal(BuildContext context) async {
    final portalUrl = await ref.read(billingActionsProvider.notifier).getPortalUrl();

    if (portalUrl != null && mounted) {
      final uri = Uri.parse(portalUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  Future<void> _cancelSubscription(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.billing_cancelSubscription),
        content: Text(l10n.billing_cancelMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.billing_keepSubscription),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: Text(l10n.billing_cancelSubscription),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(billingActionsProvider.notifier).cancel();
    }
  }

  Future<void> _resumeSubscription(BuildContext context) async {
    await ref.read(billingActionsProvider.notifier).resume();
  }
}

class _CurrentPlanCard extends StatelessWidget {
  final SubscriptionStatus status;
  final bool isDark;
  final AppLocalizations l10n;

  const _CurrentPlanCard({required this.status, required this.isDark, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: status.isPaid
              ? [AppColors.accent, AppColors.purple]
              : [AppColors.glassPanel, AppColors.glassPanel],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(
          color: isDark ? AppColors.glassBorder : AppColorsLight.glassBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(status.isPaid ? 50 : 25),
                  borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                ),
                child: Text(
                  l10n.billing_currentPlan,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: status.isPaid
                        ? Colors.white.withAlpha(200)
                        : (isDark ? AppColors.textMuted : AppColorsLight.textMuted),
                  ),
                ),
              ),
              const Spacer(),
              if (status.onTrial)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.yellow.withAlpha(50),
                    borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                  ),
                  child: Text(
                    l10n.billing_trial,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.yellow,
                    ),
                  ),
                ),
              if (status.onGracePeriod)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.orange.withAlpha(50),
                    borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                  ),
                  child: Text(
                    l10n.billing_canceling,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.orange,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            status.planName,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: status.isPaid ? Colors.white : (isDark ? AppColors.textPrimary : AppColorsLight.textPrimary),
            ),
          ),
          if (status.endsAt != null) ...[
            const SizedBox(height: 8),
            Text(
              status.onGracePeriod
                  ? l10n.billing_accessUntil(DateFormat.yMMMd().format(status.endsAt!))
                  : l10n.billing_renewsOn(DateFormat.yMMMd().format(status.endsAt!)),
              style: TextStyle(
                fontSize: 14,
                color: status.isPaid
                    ? Colors.white.withAlpha(180)
                    : (isDark ? AppColors.textSecondary : AppColorsLight.textSecondary),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SubscriptionActionsCard extends StatelessWidget {
  final SubscriptionStatus status;
  final bool isDark;
  final bool isLoading;
  final VoidCallback onManage;
  final VoidCallback onCancel;
  final VoidCallback onResume;
  final AppLocalizations l10n;

  const _SubscriptionActionsCard({
    required this.status,
    required this.isDark,
    required this.isLoading,
    required this.onManage,
    required this.onCancel,
    required this.onResume,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.glassPanelAlpha : AppColorsLight.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(
          color: isDark ? AppColors.glassBorder : AppColorsLight.glassBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.billing_manageSubscription,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isLoading ? null : onManage,
                  icon: const Icon(Icons.open_in_new, size: 18),
                  label: Text(l10n.billing_billingPortal),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                    side: BorderSide(
                      color: isDark ? AppColors.border : AppColorsLight.border,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (status.canResume)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : onResume,
                    icon: const Icon(Icons.replay, size: 18),
                    label: Text(l10n.billing_resume),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                )
              else
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isLoading ? null : onCancel,
                    icon: const Icon(Icons.cancel_outlined, size: 18),
                    label: Text(l10n.billing_cancel),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.red,
                      side: BorderSide(color: AppColors.red.withAlpha(100)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BillingPeriodToggle extends StatelessWidget {
  final String selectedPeriod;
  final bool isDark;
  final ValueChanged<String> onChanged;
  final AppLocalizations l10n;

  const _BillingPeriodToggle({
    required this.selectedPeriod,
    required this.isDark,
    required this.onChanged,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgPanel : AppColorsLight.bgPanel,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        border: Border.all(
          color: isDark ? AppColors.border : AppColorsLight.border,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _PeriodOption(
              label: l10n.billing_monthly,
              isSelected: selectedPeriod == 'monthly',
              isDark: isDark,
              onTap: () => onChanged('monthly'),
            ),
          ),
          Expanded(
            child: _PeriodOption(
              label: l10n.billing_yearly,
              badge: l10n.billing_savePercent(20),
              isSelected: selectedPeriod == 'yearly',
              isDark: isDark,
              onTap: () => onChanged('yearly'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodOption extends StatelessWidget {
  final String label;
  final String? badge;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _PeriodOption({
    required this.label,
    this.badge,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.accent : AppColorsLight.accent)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppColors.radiusSmall - 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.textSecondary : AppColorsLight.textSecondary),
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withAlpha(50) : AppColors.green.withAlpha(50),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge!,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.green,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final String currentPlan;
  final String billingPeriod;
  final bool isDark;
  final bool isLoading;
  final VoidCallback? onSelect;
  final AppLocalizations l10n;

  const _PlanCard({
    required this.plan,
    required this.currentPlan,
    required this.billingPeriod,
    required this.isDark,
    required this.isLoading,
    this.onSelect,
    required this.l10n,
  });

  bool get isCurrentPlan => plan.key == currentPlan;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.glassPanelAlpha : AppColorsLight.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(
          color: isCurrentPlan
              ? (isDark ? AppColors.accent : AppColorsLight.accent)
              : (isDark ? AppColors.glassBorder : AppColorsLight.glassBorder),
          width: isCurrentPlan ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                plan.name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                ),
              ),
              const Spacer(),
              if (isCurrentPlan)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withAlpha(30),
                    borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                  ),
                  child: Text(
                    l10n.billing_current,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.accent : AppColorsLight.accent,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Features
          _FeatureRow(
            icon: Icons.apps,
            label: l10n.billing_apps,
            value: plan.limits.hasUnlimitedApps ? l10n.billing_unlimited : '${plan.limits.apps}',
            isDark: isDark,
          ),
          _FeatureRow(
            icon: Icons.search,
            label: l10n.billing_keywordsPerApp,
            value: plan.limits.hasUnlimitedKeywords ? l10n.billing_unlimited : '${plan.limits.keywordsPerApp}',
            isDark: isDark,
          ),
          _FeatureRow(
            icon: Icons.history,
            label: l10n.billing_history,
            value: plan.limits.hasUnlimitedHistory ? l10n.billing_unlimited : l10n.billing_days(plan.limits.historyDays),
            isDark: isDark,
          ),
          _FeatureRow(
            icon: Icons.download,
            label: l10n.billing_exports,
            value: plan.limits.exports ? l10n.billing_yes : l10n.billing_no,
            isEnabled: plan.limits.exports,
            isDark: isDark,
          ),
          _FeatureRow(
            icon: Icons.auto_awesome,
            label: l10n.billing_aiInsights,
            value: plan.limits.aiInsights ? l10n.billing_yes : l10n.billing_no,
            isEnabled: plan.limits.aiInsights,
            isDark: isDark,
          ),
          _FeatureRow(
            icon: Icons.api,
            label: l10n.billing_apiAccess,
            value: plan.limits.apiAccess ? l10n.billing_yes : l10n.billing_no,
            isEnabled: plan.limits.apiAccess,
            isDark: isDark,
          ),

          const SizedBox(height: 16),

          // Button
          if (!plan.isFree)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading || isCurrentPlan ? null : onSelect,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCurrentPlan
                      ? (isDark ? AppColors.bgHover : AppColorsLight.bgHover)
                      : (isDark ? AppColors.accent : AppColorsLight.accent),
                  foregroundColor: isCurrentPlan
                      ? (isDark ? AppColors.textMuted : AppColorsLight.textMuted)
                      : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        isCurrentPlan ? l10n.billing_currentPlanButton : l10n.billing_upgradeTo(plan.name),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isEnabled;
  final bool isDark;

  const _FeatureRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isEnabled = true,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isEnabled
                ? (isDark ? AppColors.textSecondary : AppColorsLight.textSecondary)
                : (isDark ? AppColors.textMuted : AppColorsLight.textMuted),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isEnabled
                  ? (isDark ? AppColors.textSecondary : AppColorsLight.textSecondary)
                  : (isDark ? AppColors.textMuted : AppColorsLight.textMuted),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isEnabled
                  ? (isDark ? AppColors.textPrimary : AppColorsLight.textPrimary)
                  : (isDark ? AppColors.textMuted : AppColorsLight.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}
