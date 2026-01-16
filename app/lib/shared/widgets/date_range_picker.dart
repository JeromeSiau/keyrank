import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/l10n_extension.dart';

/// Represents a date period that can be either a preset or custom range
class DatePeriod {
  final String? presetKey;
  final DateTimeRange? customRange;

  const DatePeriod.preset(this.presetKey) : customRange = null;
  const DatePeriod.custom(this.customRange) : presetKey = null;

  bool get isCustom => presetKey == null && customRange != null;
  bool get isPreset => presetKey != null;

  /// Convert to API query parameter
  String toApiParam() {
    if (presetKey != null) return presetKey!;
    if (customRange != null) {
      final start = DateFormat('yyyy-MM-dd').format(customRange!.start);
      final end = DateFormat('yyyy-MM-dd').format(customRange!.end);
      return 'custom:$start:$end';
    }
    return '30d';
  }

  /// Get the actual date range for this period
  DateTimeRange getDateRange() {
    if (customRange != null) return customRange!;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (presetKey) {
      case 'today':
        return DateTimeRange(start: today, end: today);
      case 'yesterday':
        final yesterday = today.subtract(const Duration(days: 1));
        return DateTimeRange(start: yesterday, end: yesterday);
      case '7d':
        return DateTimeRange(
          start: today.subtract(const Duration(days: 6)),
          end: today,
        );
      case '30d':
        return DateTimeRange(
          start: today.subtract(const Duration(days: 29)),
          end: today,
        );
      case 'this_month':
        return DateTimeRange(
          start: DateTime(now.year, now.month, 1),
          end: today,
        );
      case 'last_month':
        final lastMonth = DateTime(now.year, now.month - 1, 1);
        final lastDayOfLastMonth = DateTime(now.year, now.month, 0);
        return DateTimeRange(start: lastMonth, end: lastDayOfLastMonth);
      case '90d':
        return DateTimeRange(
          start: today.subtract(const Duration(days: 89)),
          end: today,
        );
      case 'ytd':
        return DateTimeRange(
          start: DateTime(now.year, 1, 1),
          end: today,
        );
      case 'all':
      default:
        // Default to 1 year for 'all' in UI calculations
        return DateTimeRange(
          start: today.subtract(const Duration(days: 365)),
          end: today,
        );
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DatePeriod &&
          presetKey == other.presetKey &&
          customRange?.start == other.customRange?.start &&
          customRange?.end == other.customRange?.end;

  @override
  int get hashCode => Object.hash(presetKey, customRange?.start, customRange?.end);
}

/// A compact date range picker button that opens a modal with presets and custom range option
class DateRangePickerButton extends StatelessWidget {
  final DatePeriod selected;
  final ValueChanged<DatePeriod> onChanged;
  final bool showCompareOption;
  final bool compareEnabled;
  final ValueChanged<bool>? onCompareChanged;

  const DateRangePickerButton({
    super.key,
    required this.selected,
    required this.onChanged,
    this.showCompareOption = false,
    this.compareEnabled = false,
    this.onCompareChanged,
  });

  String _getDisplayText(BuildContext context) {
    final l10n = context.l10n;

    if (selected.isCustom && selected.customRange != null) {
      final range = selected.customRange!;
      final formatter = DateFormat.MMMd();
      return '${formatter.format(range.start)} - ${formatter.format(range.end)}';
    }

    switch (selected.presetKey) {
      case 'today':
        return l10n.dateRange_today;
      case 'yesterday':
        return l10n.dateRange_yesterday;
      case '7d':
        return l10n.dateRange_last7Days;
      case '30d':
        return l10n.dateRange_last30Days;
      case 'this_month':
        return l10n.dateRange_thisMonth;
      case 'last_month':
        return l10n.dateRange_lastMonth;
      case '90d':
        return l10n.dateRange_last90Days;
      case 'ytd':
        return l10n.dateRange_yearToDate;
      case 'all':
        return l10n.dateRange_allTime;
      default:
        return l10n.dateRange_last30Days;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showDateRangePicker(context),
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        hoverColor: colors.bgHover,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: colors.glassBorder),
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 14,
                color: colors.textMuted,
              ),
              const SizedBox(width: 6),
              Text(
                _getDisplayText(context),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 16,
                color: colors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDateRangePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DateRangePickerModal(
        selected: selected,
        onChanged: onChanged,
        showCompareOption: showCompareOption,
        compareEnabled: compareEnabled,
        onCompareChanged: onCompareChanged,
      ),
    );
  }
}

/// Modal dialog with preset options and custom date range picker
class DateRangePickerModal extends StatefulWidget {
  final DatePeriod selected;
  final ValueChanged<DatePeriod> onChanged;
  final bool showCompareOption;
  final bool compareEnabled;
  final ValueChanged<bool>? onCompareChanged;

  const DateRangePickerModal({
    super.key,
    required this.selected,
    required this.onChanged,
    this.showCompareOption = false,
    this.compareEnabled = false,
    this.onCompareChanged,
  });

  @override
  State<DateRangePickerModal> createState() => _DateRangePickerModalState();
}

class _DateRangePickerModalState extends State<DateRangePickerModal> {
  late DatePeriod _selectedPeriod;
  late bool _compareEnabled;
  bool _showCustomPicker = false;
  DateTimeRange? _customRange;

  static const _presets = [
    'today',
    'yesterday',
    '7d',
    '30d',
    'this_month',
    'last_month',
    '90d',
    'ytd',
    'all',
  ];

  @override
  void initState() {
    super.initState();
    _selectedPeriod = widget.selected;
    _compareEnabled = widget.compareEnabled;
    _customRange = widget.selected.customRange;
    _showCustomPicker = widget.selected.isCustom;
  }

  String _getPresetLabel(BuildContext context, String preset) {
    final l10n = context.l10n;
    switch (preset) {
      case 'today':
        return l10n.dateRange_today;
      case 'yesterday':
        return l10n.dateRange_yesterday;
      case '7d':
        return l10n.dateRange_last7Days;
      case '30d':
        return l10n.dateRange_last30Days;
      case 'this_month':
        return l10n.dateRange_thisMonth;
      case 'last_month':
        return l10n.dateRange_lastMonth;
      case '90d':
        return l10n.dateRange_last90Days;
      case 'ytd':
        return l10n.dateRange_yearToDate;
      case 'all':
        return l10n.dateRange_allTime;
      default:
        return preset;
    }
  }

  void _selectPreset(String preset) {
    setState(() {
      _selectedPeriod = DatePeriod.preset(preset);
      _showCustomPicker = false;
    });
    widget.onChanged(_selectedPeriod);
    Navigator.of(context).pop();
  }

  Future<void> _selectCustomRange() async {
    final colors = context.colors;
    final now = DateTime.now();
    final initialRange = _customRange ??
        DateTimeRange(
          start: now.subtract(const Duration(days: 29)),
          end: now,
        );

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: initialRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: colors.accent,
              onPrimary: Colors.white,
              surface: colors.bgSurface,
              onSurface: colors.textPrimary,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: colors.glassPanel,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _customRange = picked;
        _selectedPeriod = DatePeriod.custom(picked);
        _showCustomPicker = true;
      });
      widget.onChanged(_selectedPeriod);
      if (mounted) Navigator.of(context).pop();
    }
  }

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
        constraints: const BoxConstraints(
          maxWidth: 280,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: colors.glassBorder),
                ),
              ),
              child: Text(
                l10n.dateRange_title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
            ),
            // Preset options
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ..._presets.map((preset) {
                      final isSelected =
                          _selectedPeriod.presetKey == preset && !_showCustomPicker;
                      return _buildOptionTile(
                        label: _getPresetLabel(context, preset),
                        isSelected: isSelected,
                        onTap: () => _selectPreset(preset),
                      );
                    }),
                    const Divider(height: 16),
                    // Custom option
                    _buildOptionTile(
                      label: l10n.dateRange_custom,
                      isSelected: _showCustomPicker,
                      onTap: _selectCustomRange,
                      trailing: _showCustomPicker && _customRange != null
                          ? Text(
                              '${DateFormat.MMMd().format(_customRange!.start)} - ${DateFormat.MMMd().format(_customRange!.end)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.textMuted,
                              ),
                            )
                          : Icon(
                              Icons.edit_calendar_rounded,
                              size: 16,
                              color: colors.textMuted,
                            ),
                    ),
                  ],
                ),
              ),
            ),
            // Compare option
            if (widget.showCompareOption) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: colors.glassBorder),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: _compareEnabled,
                        onChanged: (value) {
                          setState(() => _compareEnabled = value ?? false);
                          widget.onCompareChanged?.call(_compareEnabled);
                        },
                        activeColor: colors.accent,
                        side: BorderSide(color: colors.glassBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.dateRange_compareToPrevious,
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: isSelected ? colors.bgActive : null,
          child: Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? colors.accent : colors.glassBorder,
                    width: isSelected ? 5 : 1.5,
                  ),
                  color: isSelected ? colors.accent : Colors.transparent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }
}

/// Simple dropdown for period selection (backward compatible with string-based periods)
class PeriodDropdown extends StatelessWidget {
  final String value;
  final List<(String, String)> options;
  final ValueChanged<String> onChanged;

  const PeriodDropdown({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return DropdownButton<String>(
      value: value,
      underline: const SizedBox(),
      dropdownColor: colors.glassPanel,
      borderRadius: BorderRadius.circular(AppColors.radiusSmall),
      style: TextStyle(
        fontSize: 13,
        color: colors.textSecondary,
      ),
      items: options.map((option) {
        return DropdownMenuItem(
          value: option.$1,
          child: Text(option.$2),
        );
      }).toList(),
      onChanged: (newValue) {
        if (newValue != null) onChanged(newValue);
      },
    );
  }
}
