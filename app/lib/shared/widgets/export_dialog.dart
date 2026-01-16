import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/csv_exporter.dart';
import '../../core/utils/l10n_extension.dart';

/// Dialog for configuring and triggering CSV export
class ExportKeywordsDialog extends StatefulWidget {
  final int keywordCount;
  final Future<void> Function(ExportOptions options) onExport;

  const ExportKeywordsDialog({
    super.key,
    required this.keywordCount,
    required this.onExport,
  });

  @override
  State<ExportKeywordsDialog> createState() => _ExportKeywordsDialogState();
}

class _ExportKeywordsDialogState extends State<ExportKeywordsDialog> {
  var _options = const ExportOptions();
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Dialog(
      backgroundColor: colors.glassPanel,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        side: BorderSide(color: colors.glassBorder),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: colors.glassBorder)),
              ),
              child: Row(
                children: [
                  Icon(Icons.download_rounded, size: 20, color: colors.accent),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.export_keywordsTitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, size: 20, color: colors.textMuted),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.export_columnsToInclude,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Column options
                  _CheckboxTile(
                    label: l10n.export_keyword,
                    value: _options.includeKeyword,
                    onChanged: (v) => setState(() => _options = _options.copyWith(includeKeyword: v)),
                  ),
                  _CheckboxTile(
                    label: l10n.export_position,
                    value: _options.includePosition,
                    onChanged: (v) => setState(() => _options = _options.copyWith(includePosition: v)),
                  ),
                  _CheckboxTile(
                    label: l10n.export_change,
                    value: _options.includeChange,
                    onChanged: (v) => setState(() => _options = _options.copyWith(includeChange: v)),
                  ),
                  _CheckboxTile(
                    label: l10n.export_popularity,
                    value: _options.includePopularity,
                    onChanged: (v) => setState(() => _options = _options.copyWith(includePopularity: v)),
                  ),
                  _CheckboxTile(
                    label: l10n.export_difficulty,
                    value: _options.includeDifficulty,
                    onChanged: (v) => setState(() => _options = _options.copyWith(includeDifficulty: v)),
                  ),
                  _CheckboxTile(
                    label: l10n.export_tags,
                    value: _options.includeTags,
                    onChanged: (v) => setState(() => _options = _options.copyWith(includeTags: v)),
                  ),
                  _CheckboxTile(
                    label: l10n.export_notes,
                    value: _options.includeNotes,
                    onChanged: (v) => setState(() => _options = _options.copyWith(includeNotes: v)),
                  ),
                  _CheckboxTile(
                    label: l10n.export_trackedSince,
                    value: _options.includeTrackedSince,
                    onChanged: (v) => setState(() => _options = _options.copyWith(includeTrackedSince: v)),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    l10n.export_keywordsCount(widget.keywordCount),
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
            ),

            // Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: colors.glassBorder)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isExporting ? null : () => Navigator.of(context).pop(),
                    child: Text(
                      l10n.common_cancel,
                      style: TextStyle(color: colors.textSecondary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: _isExporting ? null : _handleExport,
                    icon: _isExporting
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.download_rounded, size: 18),
                    label: Text(l10n.export_button),
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.accent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleExport() async {
    setState(() => _isExporting = true);
    try {
      await widget.onExport(_options);
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }
}

/// Dialog for configuring review export
class ExportReviewsDialog extends StatefulWidget {
  final int reviewCount;
  final Future<void> Function(ReviewExportOptions options) onExport;

  const ExportReviewsDialog({
    super.key,
    required this.reviewCount,
    required this.onExport,
  });

  @override
  State<ExportReviewsDialog> createState() => _ExportReviewsDialogState();
}

class _ExportReviewsDialogState extends State<ExportReviewsDialog> {
  var _options = const ReviewExportOptions();
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Dialog(
      backgroundColor: colors.glassPanel,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        side: BorderSide(color: colors.glassBorder),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: colors.glassBorder)),
              ),
              child: Row(
                children: [
                  Icon(Icons.download_rounded, size: 20, color: colors.accent),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.export_reviewsTitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, size: 20, color: colors.textMuted),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.export_columnsToInclude,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _CheckboxTile(
                      label: l10n.export_date,
                      value: _options.includeDate,
                      onChanged: (v) => setState(() => _options = _options.copyWith(includeDate: v)),
                    ),
                    _CheckboxTile(
                      label: l10n.export_rating,
                      value: _options.includeRating,
                      onChanged: (v) => setState(() => _options = _options.copyWith(includeRating: v)),
                    ),
                    _CheckboxTile(
                      label: l10n.export_author,
                      value: _options.includeAuthor,
                      onChanged: (v) => setState(() => _options = _options.copyWith(includeAuthor: v)),
                    ),
                    _CheckboxTile(
                      label: l10n.export_title,
                      value: _options.includeTitle,
                      onChanged: (v) => setState(() => _options = _options.copyWith(includeTitle: v)),
                    ),
                    _CheckboxTile(
                      label: l10n.export_content,
                      value: _options.includeContent,
                      onChanged: (v) => setState(() => _options = _options.copyWith(includeContent: v)),
                    ),
                    _CheckboxTile(
                      label: l10n.export_country,
                      value: _options.includeCountry,
                      onChanged: (v) => setState(() => _options = _options.copyWith(includeCountry: v)),
                    ),
                    _CheckboxTile(
                      label: l10n.export_version,
                      value: _options.includeVersion,
                      onChanged: (v) => setState(() => _options = _options.copyWith(includeVersion: v)),
                    ),
                    _CheckboxTile(
                      label: l10n.export_sentiment,
                      value: _options.includeSentiment,
                      onChanged: (v) => setState(() => _options = _options.copyWith(includeSentiment: v)),
                    ),
                    _CheckboxTile(
                      label: l10n.export_response,
                      value: _options.includeResponse,
                      onChanged: (v) => setState(() => _options = _options.copyWith(includeResponse: v)),
                    ),
                    _CheckboxTile(
                      label: l10n.export_responseDate,
                      value: _options.includeResponseDate,
                      onChanged: (v) => setState(() => _options = _options.copyWith(includeResponseDate: v)),
                    ),

                    const SizedBox(height: 16),
                    Text(
                      l10n.export_reviewsCount(widget.reviewCount),
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: colors.glassBorder)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isExporting ? null : () => Navigator.of(context).pop(),
                    child: Text(
                      l10n.common_cancel,
                      style: TextStyle(color: colors.textSecondary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: _isExporting ? null : _handleExport,
                    icon: _isExporting
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.download_rounded, size: 18),
                    label: Text(l10n.export_button),
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.accent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleExport() async {
    setState(() => _isExporting = true);
    try {
      await widget.onExport(_options);
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }
}

/// Reusable checkbox tile
class _CheckboxTile extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _CheckboxTile({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: value,
                onChanged: (v) => onChanged(v ?? false),
                activeColor: colors.accent,
                side: BorderSide(color: colors.glassBorder),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Quick export button that can be added to app bars
class ExportButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? tooltip;

  const ExportButton({
    super.key,
    required this.onPressed,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return IconButton(
      onPressed: onPressed,
      icon: Icon(Icons.download_rounded, size: 20, color: colors.textSecondary),
      tooltip: tooltip ?? l10n.export_button,
    );
  }
}
