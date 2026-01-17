import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyrank/features/chat/domain/chat_action_model.dart';
import 'package:keyrank/l10n/app_localizations.dart';

class ActionCard extends ConsumerStatefulWidget {
  final ChatAction action;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final bool isExecuting;

  const ActionCard({
    super.key,
    required this.action,
    required this.onConfirm,
    required this.onCancel,
    this.isExecuting = false,
  });

  @override
  ConsumerState<ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends ConsumerState<ActionCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final action = widget.action;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: _getBackgroundColor(theme),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getBorderColor(theme),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(theme, l10n),

          // Divider
          Divider(height: 1, color: theme.dividerColor.withValues(alpha: 0.3)),

          // Content - different per action type
          Padding(
            padding: const EdgeInsets.all(12),
            child: _buildContent(theme, l10n),
          ),

          // Footer with buttons (only for proposed actions)
          if (action.isProposed && !widget.isExecuting)
            _buildFooter(theme, l10n),

          // Executing state
          if (widget.isExecuting) _buildExecutingState(theme, l10n),

          // Result state (executed or failed)
          if (action.isExecuted || action.isFailed)
            _buildResultState(theme, l10n),

          // Cancelled state
          if (action.isCancelled) _buildCancelledState(theme, l10n),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, AppLocalizations l10n) {
    final action = widget.action;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _getHeaderColor(theme).withValues(alpha: 0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
      ),
      child: Row(
        children: [
          Text(
            action.icon,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _getLocalizedTitle(l10n),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (action.reversible && action.isProposed)
            Tooltip(
              message: l10n.chatActionReversible,
              child: Icon(
                Icons.undo_rounded,
                size: 16,
                color: theme.colorScheme.outline,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme, AppLocalizations l10n) {
    final action = widget.action;

    return switch (action.type) {
      'add_keywords' => _buildAddKeywordsContent(theme, l10n),
      'remove_keywords' => _buildRemoveKeywordsContent(theme, l10n),
      'create_alert' => _buildCreateAlertContent(theme, l10n),
      'add_competitor' => _buildAddCompetitorContent(theme, l10n),
      'export_data' => _buildExportDataContent(theme, l10n),
      _ => Text(action.explanation),
    };
  }

  Widget _buildAddKeywordsContent(ThemeData theme, AppLocalizations l10n) {
    final action = widget.action;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          theme,
          l10n.chatActionKeywords,
          action.keywords.join(', '),
        ),
        const SizedBox(height: 6),
        _buildInfoRow(
          theme,
          l10n.chatActionCountry,
          _getCountryName(action.country),
        ),
      ],
    );
  }

  Widget _buildRemoveKeywordsContent(ThemeData theme, AppLocalizations l10n) {
    final action = widget.action;

    return _buildInfoRow(
      theme,
      l10n.chatActionKeywords,
      action.keywords.join(', '),
    );
  }

  Widget _buildCreateAlertContent(ThemeData theme, AppLocalizations l10n) {
    final action = widget.action;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          theme,
          l10n.chatActionAlertCondition,
          _formatAlertCondition(l10n, action.keyword ?? '', action.condition,
              action.threshold ?? 0),
        ),
        const SizedBox(height: 6),
        _buildInfoRow(
          theme,
          l10n.chatActionNotifyVia,
          action.channels.map(_getChannelName).join(' & '),
        ),
      ],
    );
  }

  Widget _buildAddCompetitorContent(ThemeData theme, AppLocalizations l10n) {
    final action = widget.action;

    return _buildInfoRow(
      theme,
      l10n.chatActionCompetitor,
      action.appName ?? 'Unknown',
    );
  }

  Widget _buildExportDataContent(ThemeData theme, AppLocalizations l10n) {
    final action = widget.action;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          theme,
          l10n.chatActionExportType,
          _getExportTypeName(l10n, action.exportType ?? 'keywords'),
        ),
        const SizedBox(height: 6),
        _buildInfoRow(
          theme,
          l10n.chatActionDateRange,
          _getDateRangeName(action.dateRange ?? '30d'),
        ),
      ],
    );
  }

  Widget _buildInfoRow(ThemeData theme, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(ThemeData theme, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: widget.onCancel,
            child: Text(l10n.chatActionCancel),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: widget.onConfirm,
            icon: const Icon(Icons.check, size: 18),
            label: Text(l10n.chatActionConfirm),
          ),
        ],
      ),
    );
  }

  Widget _buildExecutingState(ThemeData theme, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            l10n.chatActionExecuting,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultState(ThemeData theme, AppLocalizations l10n) {
    final action = widget.action;
    final isSuccess = action.isExecuted;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSuccess
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
            : theme.colorScheme.errorContainer.withValues(alpha: 0.3),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(11)),
      ),
      child: Row(
        children: [
          Icon(
            isSuccess ? Icons.check_circle : Icons.error,
            size: 18,
            color: isSuccess
                ? theme.colorScheme.primary
                : theme.colorScheme.error,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isSuccess
                  ? (action.resultMessage ?? l10n.chatActionExecuted)
                  : (action.errorMessage ?? l10n.chatActionFailed),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSuccess
                    ? theme.colorScheme.primary
                    : theme.colorScheme.error,
              ),
            ),
          ),
          // Download button for export actions
          if (isSuccess && action.downloadUrl != null)
            TextButton.icon(
              onPressed: () {
                // TODO: Open download URL
              },
              icon: const Icon(Icons.download, size: 18),
              label: Text(l10n.chatActionDownload),
            ),
        ],
      ),
    );
  }

  Widget _buildCancelledState(ThemeData theme, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(11)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.cancel_outlined,
            size: 18,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(width: 8),
          Text(
            l10n.chatActionCancelled,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor(ThemeData theme) {
    final action = widget.action;
    if (action.isCancelled) {
      return theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);
    }
    return theme.colorScheme.surface;
  }

  Color _getBorderColor(ThemeData theme) {
    final action = widget.action;
    if (action.isExecuted) return theme.colorScheme.primary.withValues(alpha: 0.5);
    if (action.isFailed) return theme.colorScheme.error.withValues(alpha: 0.5);
    if (action.isCancelled) return theme.colorScheme.outline.withValues(alpha: 0.3);
    return theme.colorScheme.outlineVariant;
  }

  Color _getHeaderColor(ThemeData theme) {
    return switch (widget.action.type) {
      'add_keywords' => Colors.green,
      'remove_keywords' => Colors.red,
      'create_alert' => Colors.orange,
      'add_competitor' => Colors.purple,
      'export_data' => Colors.blue,
      _ => theme.colorScheme.primary,
    };
  }

  String _getLocalizedTitle(AppLocalizations l10n) {
    return switch (widget.action.type) {
      'add_keywords' => l10n.chatActionAddKeywords,
      'remove_keywords' => l10n.chatActionRemoveKeywords,
      'create_alert' => l10n.chatActionCreateAlert,
      'add_competitor' => l10n.chatActionAddCompetitor,
      'export_data' => l10n.chatActionExportData,
      _ => widget.action.displayName,
    };
  }

  String _getCountryName(String code) {
    // Simple mapping - could be expanded
    return switch (code.toUpperCase()) {
      'US' => 'United States',
      'FR' => 'France',
      'DE' => 'Germany',
      'GB' => 'United Kingdom',
      'JP' => 'Japan',
      'CN' => 'China',
      'KR' => 'South Korea',
      'BR' => 'Brazil',
      'ES' => 'Spain',
      'IT' => 'Italy',
      _ => code.toUpperCase(),
    };
  }

  String _getChannelName(String channel) {
    return switch (channel) {
      'push' => 'Push',
      'email' => 'Email',
      _ => channel,
    };
  }

  String _formatAlertCondition(
    AppLocalizations l10n,
    String keyword,
    String? condition,
    int threshold,
  ) {
    return switch (condition) {
      'reaches_top' => '"$keyword" reaches top $threshold',
      'drops_below' => '"$keyword" drops below position $threshold',
      'improves_by' => '"$keyword" improves by $threshold positions',
      'drops_by' => '"$keyword" drops by $threshold positions',
      _ => '"$keyword" $condition $threshold',
    };
  }

  String _getExportTypeName(AppLocalizations l10n, String type) {
    return switch (type) {
      'keywords' => l10n.chatActionKeywordsLabel,
      'analytics' => l10n.chatActionAnalyticsLabel,
      'reviews' => l10n.chatActionReviewsLabel,
      _ => type,
    };
  }

  String _getDateRangeName(String range) {
    return switch (range) {
      '7d' => 'Last 7 days',
      '30d' => 'Last 30 days',
      '90d' => 'Last 90 days',
      'all' => 'All time',
      _ => range,
    };
  }
}
