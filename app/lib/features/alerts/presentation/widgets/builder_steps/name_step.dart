import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

/// Step 4: Name the rule and save
class NameStep extends StatefulWidget {
  final String name;
  final String alertType;
  final String scopeType;
  final ValueChanged<String> onNameChanged;
  final VoidCallback onSave;
  final bool isSaving;

  const NameStep({
    super.key,
    required this.name,
    required this.alertType,
    required this.scopeType,
    required this.onNameChanged,
    required this.onSave,
    this.isSaving = false,
  });

  @override
  State<NameStep> createState() => _NameStepState();
}

class _NameStepState extends State<NameStep> {
  late TextEditingController _controller;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.name);
    // Auto-focus the text field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void didUpdateWidget(NameStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.name != widget.name && _controller.text != widget.name) {
      _controller.text = widget.name;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _formatAlertType(String type) {
    return type
        .split('_')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }

  String _formatScopeType(String scope) {
    return switch (scope) {
      'global' => 'All Apps',
      'app' => 'Specific App',
      'category' => 'Category',
      'keyword' => 'Keyword',
      _ => scope,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.accent : AppColorsLight.accent;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NAME YOUR RULE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Give your alert rule a descriptive name',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          // Rule name input
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'e.g., Daily Position Alert',
              hintStyle: TextStyle(
                color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
              ),
              filled: true,
              fillColor: isDark ? AppColors.bgBase : AppColorsLight.bgBase,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppColors.radiusMedium),
                borderSide: BorderSide(
                  color: isDark ? AppColors.border : AppColorsLight.border,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppColors.radiusMedium),
                borderSide: BorderSide(
                  color: isDark ? AppColors.border : AppColorsLight.border,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppColors.radiusMedium),
                borderSide: BorderSide(
                  color: accent,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            onChanged: widget.onNameChanged,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) {
              if (widget.name.trim().isNotEmpty) {
                widget.onSave();
              }
            },
          ),

          const SizedBox(height: 32),

          // Summary card
          Container(
            padding: const EdgeInsets.all(16),
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
                  'SUMMARY',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                  ),
                ),
                const SizedBox(height: 16),
                _SummaryRow(
                  label: 'Type',
                  value: _formatAlertType(widget.alertType),
                ),
                const SizedBox(height: 12),
                _SummaryRow(
                  label: 'Scope',
                  value: _formatScopeType(widget.scopeType),
                ),
                if (widget.name.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _SummaryRow(
                    label: 'Name',
                    value: widget.name,
                  ),
                ],
              ],
            ),
          ),

          const Spacer(),

          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.name.trim().isEmpty || widget.isSaving
                  ? null
                  : widget.onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                disabledBackgroundColor: accent.withAlpha(100),
                disabledForegroundColor: Colors.white.withAlpha(150),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppColors.radiusMedium),
                ),
              ),
              child: widget.isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Save Alert Rule',
                      style: TextStyle(
                        fontSize: 16,
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

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
            ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
