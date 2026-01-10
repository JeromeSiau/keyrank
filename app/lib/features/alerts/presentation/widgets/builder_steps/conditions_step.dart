import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/theme/app_colors.dart';

/// Step 3: Configure conditions based on alert type
class ConditionsStep extends StatelessWidget {
  final String alertType;
  final Map<String, dynamic> conditions;
  final ValueChanged<Map<String, dynamic>> onConditionsChanged;

  const ConditionsStep({
    super.key,
    required this.alertType,
    required this.conditions,
    required this.onConditionsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CONFIGURE CONDITIONS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Set the trigger conditions for this alert',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _buildConditionsForm(context, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionsForm(BuildContext context, bool isDark) {
    // Specific conditions UI for supported types
    return switch (alertType) {
      'position_change' => _PositionChangeConditions(
          conditions: conditions,
          onChanged: onConditionsChanged,
        ),
      'rating_change' => _RatingChangeConditions(
          conditions: conditions,
          onChanged: onConditionsChanged,
        ),
      _ => _GenericConditionsPlaceholder(
          alertType: alertType,
          conditions: conditions,
        ),
    };
  }
}

/// Conditions for position_change alert type
class _PositionChangeConditions extends StatelessWidget {
  final Map<String, dynamic> conditions;
  final ValueChanged<Map<String, dynamic>> onChanged;

  const _PositionChangeConditions({
    required this.conditions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final direction = conditions['direction'] as String? ?? 'any';
    final threshold = conditions['threshold'] as int? ?? 5;

    return ListView(
      children: [
        // Direction selector
        _ConditionCard(
          title: 'Direction',
          description: 'Which direction of change to monitor',
          child: _DirectionSelector(
            value: direction,
            onChanged: (newDirection) {
              onChanged({...conditions, 'direction': newDirection});
            },
          ),
        ),
        const SizedBox(height: 12),
        // Threshold input
        _ConditionCard(
          title: 'Threshold',
          description: 'Minimum position change to trigger alert',
          child: _ThresholdInput(
            value: threshold,
            suffix: 'positions',
            onChanged: (newThreshold) {
              onChanged({...conditions, 'threshold': newThreshold});
            },
          ),
        ),
      ],
    );
  }
}

/// Conditions for rating_change alert type
class _RatingChangeConditions extends StatelessWidget {
  final Map<String, dynamic> conditions;
  final ValueChanged<Map<String, dynamic>> onChanged;

  const _RatingChangeConditions({
    required this.conditions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final direction = conditions['direction'] as String? ?? 'any';
    final threshold = conditions['threshold'] as double? ?? 0.5;

    return ListView(
      children: [
        // Direction selector
        _ConditionCard(
          title: 'Direction',
          description: 'Which direction of rating change to monitor',
          child: _DirectionSelector(
            value: direction,
            onChanged: (newDirection) {
              onChanged({...conditions, 'direction': newDirection});
            },
          ),
        ),
        const SizedBox(height: 12),
        // Threshold input
        _ConditionCard(
          title: 'Threshold',
          description: 'Minimum rating change to trigger alert',
          child: _ThresholdInput(
            value: threshold is int ? threshold.toDouble() : threshold,
            suffix: 'stars',
            isDecimal: true,
            onChanged: (newThreshold) {
              onChanged({...conditions, 'threshold': newThreshold});
            },
          ),
        ),
      ],
    );
  }
}

/// Placeholder for types that don't have a specific UI yet
class _GenericConditionsPlaceholder extends StatelessWidget {
  final String alertType;
  final Map<String, dynamic> conditions;

  const _GenericConditionsPlaceholder({
    required this.alertType,
    required this.conditions,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 48,
            color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            'Conditions for "$alertType"',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Custom conditions UI not yet implemented.\nDefault conditions will be used.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 32),
            decoration: BoxDecoration(
              color: isDark ? AppColors.bgPanel : AppColorsLight.bgPanel,
              borderRadius: BorderRadius.circular(AppColors.radiusMedium),
              border: Border.all(
                color: isDark ? AppColors.border : AppColorsLight.border,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current conditions:',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  conditions.isEmpty ? '{}' : conditions.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                    color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable condition card wrapper
class _ConditionCard extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;

  const _ConditionCard({
    required this.title,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
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
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

/// Direction selector (up/down/any)
class _DirectionSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _DirectionSelector({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.accent : AppColorsLight.accent;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgBase : AppColorsLight.bgBase,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        border: Border.all(
          color: isDark ? AppColors.border : AppColorsLight.border,
        ),
      ),
      child: Row(
        children: [
          _DirectionOption(
            label: 'Up',
            icon: Icons.arrow_upward,
            isSelected: value == 'up',
            onTap: () => onChanged('up'),
            isFirst: true,
            color: isDark ? AppColors.green : AppColorsLight.green,
          ),
          _DirectionOption(
            label: 'Down',
            icon: Icons.arrow_downward,
            isSelected: value == 'down',
            onTap: () => onChanged('down'),
            color: isDark ? AppColors.red : AppColorsLight.red,
          ),
          _DirectionOption(
            label: 'Any',
            icon: Icons.swap_vert,
            isSelected: value == 'any',
            onTap: () => onChanged('any'),
            isLast: true,
            color: accent,
          ),
        ],
      ),
    );
  }
}

class _DirectionOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;
  final Color color;

  const _DirectionOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.textPrimary : AppColorsLight.textPrimary;
    final textMuted = isDark ? AppColors.textMuted : AppColorsLight.textMuted;

    return Expanded(
      child: Material(
        color: isSelected ? color.withAlpha(25) : Colors.transparent,
        borderRadius: BorderRadius.horizontal(
          left: isFirst ? const Radius.circular(AppColors.radiusSmall - 1) : Radius.zero,
          right: isLast ? const Radius.circular(AppColors.radiusSmall - 1) : Radius.zero,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.horizontal(
            left: isFirst ? const Radius.circular(AppColors.radiusSmall - 1) : Radius.zero,
            right: isLast ? const Radius.circular(AppColors.radiusSmall - 1) : Radius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected ? color : textMuted,
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? textPrimary : textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Threshold number input
class _ThresholdInput extends StatefulWidget {
  final num value;
  final String suffix;
  final bool isDecimal;
  final ValueChanged<num> onChanged;

  const _ThresholdInput({
    required this.value,
    required this.suffix,
    this.isDecimal = false,
    required this.onChanged,
  });

  @override
  State<_ThresholdInput> createState() => _ThresholdInputState();
}

class _ThresholdInputState extends State<_ThresholdInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.isDecimal
          ? widget.value.toStringAsFixed(1)
          : widget.value.toString(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.numberWithOptions(decimal: widget.isDecimal),
            inputFormatters: [
              if (widget.isDecimal)
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
              else
                FilteringTextInputFormatter.digitsOnly,
            ],
            style: TextStyle(
              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark ? AppColors.bgBase : AppColorsLight.bgBase,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                borderSide: BorderSide(
                  color: isDark ? AppColors.border : AppColorsLight.border,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                borderSide: BorderSide(
                  color: isDark ? AppColors.border : AppColorsLight.border,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                borderSide: BorderSide(
                  color: isDark ? AppColors.accent : AppColorsLight.accent,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            onChanged: (text) {
              final value = widget.isDecimal
                  ? double.tryParse(text) ?? 0.0
                  : int.tryParse(text) ?? 0;
              widget.onChanged(value);
            },
          ),
        ),
        const SizedBox(width: 12),
        Text(
          widget.suffix,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
          ),
        ),
      ],
    );
  }
}
