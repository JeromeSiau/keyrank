import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/integration_model.dart';
import '../providers/integrations_provider.dart';

class IntegrationsScreen extends ConsumerStatefulWidget {
  const IntegrationsScreen({super.key});

  @override
  ConsumerState<IntegrationsScreen> createState() => _IntegrationsScreenState();
}

class _IntegrationsScreenState extends ConsumerState<IntegrationsScreen> {
  bool _isRefreshing = false;

  Future<void> _refreshIntegration(Integration integration) async {
    setState(() => _isRefreshing = true);
    try {
      final result = await ref
          .read(integrationsProvider.notifier)
          .refreshIntegration(integration.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Synced ${result.appsImported} apps (${result.appsDiscovered} discovered)',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sync failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final integrationsAsync = ref.watch(integrationsProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgBase : AppColorsLight.bgBase,
      appBar: AppBar(
        title: const Text('Integrations'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connect your store accounts to import apps, reply to reviews, and access analytics.',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColorsLight.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                integrationsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Column(
                  children: [
                    Text(
                      'Error loading integrations: $e',
                      style: TextStyle(
                        color: isDark ? AppColors.red : AppColorsLight.red,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(integrationsProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (integrations) {
                final iosIntegration = integrations
                    .where((i) => i.type == 'app_store_connect')
                    .firstOrNull;
                final androidIntegration = integrations
                    .where((i) => i.type == 'google_play_console')
                    .firstOrNull;

                return Column(
                  children: [
                    _IntegrationCard(
                      isDark: isDark,
                      type: 'app_store_connect',
                      title: 'App Store Connect',
                      subtitle: 'Connect your Apple Developer account',
                      icon: Icons.apple,
                      integration: iosIntegration,
                      onConnect: () =>
                          context.push('/settings/integrations/app-store'),
                      onDisconnect: iosIntegration != null
                          ? () => _showDisconnectDialog(
                              context, ref, iosIntegration)
                          : null,
                      onRefresh:
                          iosIntegration != null && iosIntegration.isActive
                              ? () => _refreshIntegration(iosIntegration)
                              : null,
                      isRefreshing: _isRefreshing,
                    ),
                    const SizedBox(height: 16),
                    _IntegrationCard(
                      isDark: isDark,
                      type: 'google_play_console',
                      title: 'Google Play Console',
                      subtitle: 'Connect your Google Play account',
                      icon: Icons.android,
                      integration: androidIntegration,
                      onConnect: () =>
                          context.push('/settings/integrations/google-play'),
                      onDisconnect: androidIntegration != null
                          ? () => _showDisconnectDialog(
                              context, ref, androidIntegration)
                          : null,
                      onRefresh: androidIntegration != null &&
                              androidIntegration.isActive
                          ? () => _refreshIntegration(androidIntegration)
                          : null,
                      isRefreshing: _isRefreshing,
                    ),
                  ],
                );
              },
            ),
          ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDisconnectDialog(
    BuildContext context,
    WidgetRef ref,
    Integration integration,
  ) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Disconnect?'),
        content: Text(
          'Are you sure you want to disconnect ${integration.typeLabel}? '
          'This will remove ${integration.appsCount ?? 0} imported apps.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Disconnect',
              style: TextStyle(
                color: isDark ? AppColors.red : AppColorsLight.red,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref
            .read(integrationsProvider.notifier)
            .deleteIntegration(integration.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Disconnected successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }
}

class _IntegrationCard extends StatelessWidget {
  final bool isDark;
  final String type;
  final String title;
  final String subtitle;
  final IconData icon;
  final Integration? integration;
  final VoidCallback onConnect;
  final VoidCallback? onDisconnect;
  final VoidCallback? onRefresh;
  final bool isRefreshing;

  const _IntegrationCard({
    required this.isDark,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.integration,
    required this.onConnect,
    this.onDisconnect,
    this.onRefresh,
    this.isRefreshing = false,
  });

  @override
  Widget build(BuildContext context) {
    final isConnected = integration != null && integration!.isActive;
    final hasError = integration != null && integration!.hasError;
    final accent = isDark ? AppColors.accent : AppColorsLight.accent;
    final green = isDark ? AppColors.green : AppColorsLight.green;
    final red = isDark ? AppColors.red : AppColorsLight.red;

    Color statusColor = accent;
    if (isConnected) statusColor = green;
    if (hasError) statusColor = red;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.glassPanelAlpha
            : AppColorsLight.glassPanelAlpha,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(
          color: isDark ? AppColors.glassBorder : AppColorsLight.glassBorder,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: statusColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColorsLight.textPrimary,
                          ),
                        ),
                        if (isConnected) ...[
                          const SizedBox(width: 8),
                          _StatusBadge(
                            text: 'Connected',
                            color: green,
                          ),
                        ] else if (hasError) ...[
                          const SizedBox(width: 8),
                          _StatusBadge(
                            text: 'Error',
                            color: red,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    _buildSubtitle(context),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              if (isConnected)
                OutlinedButton(
                  onPressed: onDisconnect,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: red,
                    side: BorderSide(color: red.withAlpha(100)),
                  ),
                  child: const Text('Disconnect'),
                )
              else
                FilledButton(
                  onPressed: onConnect,
                  style: FilledButton.styleFrom(backgroundColor: accent),
                  child: const Text('Connect'),
                ),
            ],
          ),
          if (isConnected) ...[
            const SizedBox(height: 16),
            _buildAppsInfo(context, accent),
            if (onRefresh != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: isRefreshing ? null : onRefresh,
                  icon: isRefreshing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.sync, size: 18),
                  label: Text(isRefreshing ? 'Syncing...' : 'Refresh Apps'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: accent,
                    side: BorderSide(color: accent.withAlpha(100)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ],
          if (hasError && integration!.errorMessage != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: red.withAlpha(15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: red.withAlpha(50)),
              ),
              child: Text(
                integration!.errorMessage!,
                style: TextStyle(fontSize: 13, color: red),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    if (integration == null) {
      return Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
        ),
      );
    }

    if (integration!.lastSyncAt != null) {
      return Text(
        'Last synced: ${DateFormat.yMMMd().add_jm().format(integration!.lastSyncAt!)}',
        style: TextStyle(
          fontSize: 13,
          color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
        ),
      );
    }

    return Text(
      'Connected on ${DateFormat.yMMMd().format(integration!.createdAt)}',
      style: TextStyle(
        fontSize: 13,
        color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
      ),
    );
  }

  Widget _buildAppsInfo(BuildContext context, Color accent) {
    final appsCount = integration?.appsCount ?? 0;
    return Row(
      children: [
        Icon(Icons.apps, size: 18, color: accent),
        const SizedBox(width: 8),
        Text(
          '$appsCount app${appsCount == 1 ? '' : 's'} imported',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _StatusBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
