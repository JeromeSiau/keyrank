import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../alerts/domain/alert_preferences_model.dart';
import '../../../alerts/providers/alerts_provider.dart';

class AlertDeliverySettings extends ConsumerWidget {
  final bool isDark;

  const AlertDeliverySettings({super.key, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(alertPreferencesNotifierProvider);
    final typesAsync = ref.watch(alertTypesProvider);

    return prefsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorState(isDark: isDark, error: e.toString()),
      data: (prefs) => typesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorState(isDark: isDark, error: e.toString()),
        data: (types) => _SettingsContent(
          isDark: isDark,
          prefs: prefs,
          types: types,
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final bool isDark;
  final String error;

  const _ErrorState({required this.isDark, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Error: $error',
        style: TextStyle(
          color: isDark ? AppColors.red : AppColorsLight.red,
        ),
      ),
    );
  }
}

class _SettingsContent extends ConsumerWidget {
  final bool isDark;
  final AlertPreferences prefs;
  final List<AlertTypeInfo> types;

  const _SettingsContent({
    required this.isDark,
    required this.prefs,
    required this.types,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textPrimary = isDark ? AppColors.textPrimary : AppColorsLight.textPrimary;
    final textSecondary = isDark ? AppColors.textSecondary : AppColorsLight.textSecondary;
    final accent = isDark ? AppColors.accent : AppColorsLight.accent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Master email switch
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email Notifications',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    prefs.email,
                    style: TextStyle(
                      fontSize: 12,
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: prefs.emailNotificationsEnabled,
              onChanged: (value) {
                ref.read(alertPreferencesNotifierProvider.notifier)
                    .setEmailNotificationsEnabled(value);
              },
              activeTrackColor: accent.withAlpha(128),
              activeThumbColor: accent,
            ),
          ],
        ),

        if (prefs.emailNotificationsEnabled) ...[
          const SizedBox(height: 24),

          // Delivery matrix header
          Text(
            'DELIVERY METHOD BY ALERT TYPE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
            ),
          ),
          const SizedBox(height: 12),

          // Column headers
          Row(
            children: [
              const Expanded(flex: 3, child: SizedBox()),
              _ColumnHeader(isDark: isDark, label: 'Push', icon: Icons.phone_android),
              _ColumnHeader(isDark: isDark, label: 'Email', icon: Icons.email_outlined),
              _ColumnHeader(isDark: isDark, label: 'Digest', icon: Icons.schedule),
            ],
          ),
          const SizedBox(height: 8),

          // Alert type rows
          ...types.map((type) => _AlertTypeRow(
            isDark: isDark,
            type: type,
            delivery: prefs.getDeliveryFor(type.type),
            onChanged: (delivery) {
              ref.read(alertPreferencesNotifierProvider.notifier)
                  .updateDeliveryForType(type.type, delivery);
            },
          )),

          const SizedBox(height: 24),

          // Digest schedule
          Text(
            'DIGEST SCHEDULE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _TimeSelector(
                  isDark: isDark,
                  label: 'Daily digest at',
                  value: prefs.digestTime,
                  onChanged: (time) {
                    ref.read(alertPreferencesNotifierProvider.notifier)
                        .setDigestTime(time);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _DaySelector(
                  isDark: isDark,
                  label: 'Weekly summary',
                  value: prefs.weeklyDigestDay,
                  onChanged: (day) {
                    ref.read(alertPreferencesNotifierProvider.notifier)
                        .setWeeklyDigestDay(day);
                  },
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _ColumnHeader extends StatelessWidget {
  final bool isDark;
  final String label;
  final IconData icon;

  const _ColumnHeader({
    required this.isDark,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final textMuted = isDark ? AppColors.textMuted : AppColorsLight.textMuted;

    return SizedBox(
      width: 60,
      child: Column(
        children: [
          Icon(icon, size: 16, color: textMuted),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertTypeRow extends StatelessWidget {
  final bool isDark;
  final AlertTypeInfo type;
  final AlertDelivery delivery;
  final ValueChanged<AlertDelivery> onChanged;

  const _AlertTypeRow({
    required this.isDark,
    required this.type,
    required this.delivery,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimary : AppColorsLight.textPrimary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: textPrimary,
                  ),
                ),
              ],
            ),
          ),
          _DeliveryCheckbox(
            isDark: isDark,
            value: delivery.push,
            onChanged: (v) => onChanged(AlertDelivery(
              push: v,
              email: delivery.email,
              digest: delivery.digest,
            )),
          ),
          _DeliveryCheckbox(
            isDark: isDark,
            value: delivery.email,
            onChanged: (v) => onChanged(AlertDelivery(
              push: delivery.push,
              email: v,
              digest: delivery.digest,
            )),
          ),
          _DeliveryCheckbox(
            isDark: isDark,
            value: delivery.digest,
            onChanged: (v) => onChanged(AlertDelivery(
              push: delivery.push,
              email: delivery.email,
              digest: v,
            )),
          ),
        ],
      ),
    );
  }
}

class _DeliveryCheckbox extends StatelessWidget {
  final bool isDark;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _DeliveryCheckbox({
    required this.isDark,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final accent = isDark ? AppColors.accent : AppColorsLight.accent;
    final border = isDark ? AppColors.border : AppColorsLight.border;

    return SizedBox(
      width: 60,
      child: Center(
        child: GestureDetector(
          onTap: () => onChanged(!value),
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: value ? accent : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: value ? accent : border,
                width: 2,
              ),
            ),
            child: value
                ? Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
        ),
      ),
    );
  }
}

class _TimeSelector extends StatelessWidget {
  final bool isDark;
  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  const _TimeSelector({
    required this.isDark,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimary : AppColorsLight.textPrimary;
    final textSecondary = isDark ? AppColors.textSecondary : AppColorsLight.textSecondary;
    final bgColor = isDark ? AppColors.bgBase : AppColorsLight.bgBase;
    final borderColor = isDark ? AppColors.border : AppColorsLight.border;

    final times = [
      '06:00', '07:00', '08:00', '09:00', '10:00', '11:00', '12:00',
      '13:00', '14:00', '15:00', '16:00', '17:00', '18:00',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
            border: Border.all(color: borderColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: times.contains(value) ? value : '09:00',
              isExpanded: true,
              dropdownColor: bgColor,
              icon: Icon(Icons.keyboard_arrow_down, color: textPrimary),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textPrimary,
              ),
              items: times.map((time) {
                return DropdownMenuItem<String>(
                  value: time,
                  child: Text(time),
                );
              }).toList(),
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _DaySelector extends StatelessWidget {
  final bool isDark;
  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  const _DaySelector({
    required this.isDark,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimary : AppColorsLight.textPrimary;
    final textSecondary = isDark ? AppColors.textSecondary : AppColorsLight.textSecondary;
    final bgColor = isDark ? AppColors.bgBase : AppColorsLight.bgBase;
    final borderColor = isDark ? AppColors.border : AppColorsLight.border;

    final days = DigestDay.values;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
            border: Border.all(color: borderColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: days.any((d) => d.name == value) ? value : 'monday',
              isExpanded: true,
              dropdownColor: bgColor,
              icon: Icon(Icons.keyboard_arrow_down, color: textPrimary),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textPrimary,
              ),
              items: days.map((day) {
                return DropdownMenuItem<String>(
                  value: day.name,
                  child: Text(day.label),
                );
              }).toList(),
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
            ),
          ),
        ),
      ],
    );
  }
}
