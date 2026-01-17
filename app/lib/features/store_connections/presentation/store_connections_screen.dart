import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/store_connection_model.dart';
import '../providers/store_connections_provider.dart';

class StoreConnectionsScreen extends ConsumerStatefulWidget {
  const StoreConnectionsScreen({super.key});

  @override
  ConsumerState<StoreConnectionsScreen> createState() => _StoreConnectionsScreenState();
}

class _StoreConnectionsScreenState extends ConsumerState<StoreConnectionsScreen> {
  bool _isSyncing = false;

  Future<void> _syncApps(StoreConnection connection) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _isSyncing = true);
    try {
      final result = await ref.read(storeConnectionsProvider.notifier).syncApps(connection.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.storeConnections_syncedApps(result.syncedCount))),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.storeConnections_syncFailed(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final connectionsAsync = ref.watch(storeConnectionsProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgBase : AppColorsLight.bgBase,
      appBar: AppBar(
        title: Text(l10n.storeConnections_title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.storeConnections_description,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            connectionsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Column(
                  children: [
                    Text(
                      l10n.storeConnections_errorLoading(e.toString()),
                      style: TextStyle(color: isDark ? AppColors.red : AppColorsLight.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(storeConnectionsProvider),
                      child: Text(l10n.common_retry),
                    ),
                  ],
                ),
              ),
              data: (connections) {
                final iosConnection = connections.where((c) => c.platform == 'ios').firstOrNull;
                final androidConnection = connections.where((c) => c.platform == 'android').firstOrNull;

                return Column(
                  children: [
                    _ConnectionCard(
                      isDark: isDark,
                      platform: 'ios',
                      title: l10n.storeConnections_appStoreConnect,
                      subtitle: l10n.storeConnections_appStoreConnectDesc,
                      icon: Icons.apple,
                      connection: iosConnection,
                      onConnect: () => context.push('/settings/connections/apple'),
                      onDisconnect: iosConnection != null
                          ? () => _showDisconnectDialog(context, ref, iosConnection)
                          : null,
                      onSync: iosConnection != null && iosConnection.status == 'active'
                          ? () => _syncApps(iosConnection)
                          : null,
                      isSyncing: _isSyncing,
                    ),
                    const SizedBox(height: 16),
                    _ConnectionCard(
                      isDark: isDark,
                      platform: 'android',
                      title: l10n.storeConnections_googlePlayConsole,
                      subtitle: l10n.storeConnections_googlePlayConsoleDesc,
                      icon: Icons.android,
                      connection: androidConnection,
                      onConnect: () => context.push('/settings/connections/google'),
                      onDisconnect: androidConnection != null
                          ? () => _showDisconnectDialog(context, ref, androidConnection)
                          : null,
                      onSync: androidConnection != null && androidConnection.status == 'active'
                          ? () => _syncApps(androidConnection)
                          : null,
                      isSyncing: _isSyncing,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDisconnectDialog(
    BuildContext context,
    WidgetRef ref,
    StoreConnection connection,
  ) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final platformName = connection.platform == 'ios'
        ? l10n.storeConnections_appStoreConnect
        : l10n.storeConnections_googlePlayConsole;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.storeConnections_disconnectConfirm),
        content: Text(l10n.storeConnections_disconnectMessage(platformName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              l10n.storeConnections_disconnect,
              style: TextStyle(color: isDark ? AppColors.red : AppColorsLight.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(storeConnectionsProvider.notifier).disconnect(connection.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.storeConnections_disconnectSuccess)),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.common_error(e.toString()))),
          );
        }
      }
    }
  }
}

class _ConnectionCard extends StatelessWidget {
  final bool isDark;
  final String platform;
  final String title;
  final String subtitle;
  final IconData icon;
  final StoreConnection? connection;
  final VoidCallback onConnect;
  final VoidCallback? onDisconnect;
  final VoidCallback? onSync;
  final bool isSyncing;

  const _ConnectionCard({
    required this.isDark,
    required this.platform,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.connection,
    required this.onConnect,
    this.onDisconnect,
    this.onSync,
    this.isSyncing = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isConnected = connection != null && connection!.status == 'active';
    final accent = isDark ? AppColors.accent : AppColorsLight.accent;
    final green = isDark ? AppColors.green : AppColorsLight.green;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.glassPanelAlpha : AppColorsLight.glassPanelAlpha,
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
                  color: (isConnected ? green : accent).withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: isConnected ? green : accent,
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
                            color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                          ),
                        ),
                        if (isConnected) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: green.withAlpha(25),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              l10n.storeConnections_connected,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: green,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (isConnected && connection!.lastSyncAt != null)
                      Text(
                        l10n.storeConnections_lastSynced(DateFormat.yMMMd().add_jm().format(connection!.lastSyncAt!)),
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                        ),
                      )
                    else if (isConnected)
                      Text(
                        l10n.storeConnections_connectedOn(DateFormat.yMMMd().format(connection!.connectedAt)),
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                        ),
                      )
                    else
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              if (isConnected)
                OutlinedButton(
                  onPressed: onDisconnect,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark ? AppColors.red : AppColorsLight.red,
                    side: BorderSide(
                      color: (isDark ? AppColors.red : AppColorsLight.red).withAlpha(100),
                    ),
                  ),
                  child: Text(l10n.storeConnections_disconnect),
                )
              else
                FilledButton(
                  onPressed: onConnect,
                  style: FilledButton.styleFrom(
                    backgroundColor: accent,
                  ),
                  child: Text(l10n.storeConnections_connect),
                ),
            ],
          ),
          if (isConnected && onSync != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: isSyncing ? null : onSync,
                icon: isSyncing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.sync, size: 18),
                label: Text(isSyncing ? l10n.storeConnections_syncing : l10n.storeConnections_syncApps),
                style: OutlinedButton.styleFrom(
                  foregroundColor: accent,
                  side: BorderSide(color: accent.withAlpha(100)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.storeConnections_syncDescription,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
