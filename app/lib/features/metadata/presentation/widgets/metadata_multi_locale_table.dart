import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../domain/metadata_model.dart';
import '../../providers/metadata_provider.dart';

class MetadataMultiLocaleTable extends ConsumerWidget {
  final List<MetadataLocale> locales;
  final String? selectedLocale;
  final ValueChanged<String> onLocaleSelected;
  final int appId;

  const MetadataMultiLocaleTable({
    super.key,
    required this.locales,
    this.selectedLocale,
    required this.onLocaleSelected,
    required this.appId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(metadataFilterProvider);
    final selectedLocales = ref.watch(selectedLocalesProvider);
    final isSelectionMode = selectedLocales.isNotEmpty;

    final filteredLocales = _filterLocales(locales, filter);

    return Column(
      children: [
        // Filter bar
        _buildFilterBar(context, ref, filter),
        const Divider(height: 1),
        // Selection header (when in selection mode)
        if (isSelectionMode) _buildSelectionHeader(context, ref, selectedLocales),
        // Table
        Expanded(
          child: filteredLocales.isEmpty
              ? _buildEmptyState(context, filter)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  itemCount: filteredLocales.length,
                  itemBuilder: (context, index) {
                    final locale = filteredLocales[index];
                    final isSelected = locale.locale == selectedLocale;
                    final isChecked = selectedLocales.contains(locale.locale);

                    return _LocaleTableRow(
                      locale: locale,
                      isSelected: isSelected,
                      isChecked: isChecked,
                      isSelectionMode: isSelectionMode,
                      onTap: () => onLocaleSelected(locale.locale),
                      onCheckChanged: (checked) {
                        if (checked == true) {
                          ref.read(selectedLocalesProvider.notifier).add(locale.locale);
                        } else {
                          ref.read(selectedLocalesProvider.notifier).remove(locale.locale);
                        }
                      },
                      onLongPress: () {
                        // Start selection mode
                        ref.read(selectedLocalesProvider.notifier).add(locale.locale);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterBar(BuildContext context, WidgetRef ref, MetadataFilter current) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          _FilterChip(
            label: context.l10n.metadataFilterAll,
            isSelected: current == MetadataFilter.all,
            onTap: () => ref.read(metadataFilterProvider.notifier).state = MetadataFilter.all,
            count: locales.length,
          ),
          const SizedBox(width: AppSpacing.sm),
          _FilterChip(
            label: context.l10n.metadataFilterLive,
            isSelected: current == MetadataFilter.live,
            onTap: () => ref.read(metadataFilterProvider.notifier).state = MetadataFilter.live,
            count: locales.where((l) => _isLive(l)).length,
            color: AppColors.green,
          ),
          const SizedBox(width: AppSpacing.sm),
          _FilterChip(
            label: context.l10n.metadataFilterDraft,
            isSelected: current == MetadataFilter.draft,
            onTap: () => ref.read(metadataFilterProvider.notifier).state = MetadataFilter.draft,
            count: locales.where((l) => l.hasDraft).length,
            color: AppColors.yellowBright,
          ),
          const SizedBox(width: AppSpacing.sm),
          _FilterChip(
            label: context.l10n.metadataFilterEmpty,
            isSelected: current == MetadataFilter.empty,
            onTap: () => ref.read(metadataFilterProvider.notifier).state = MetadataFilter.empty,
            count: locales.where((l) => _isEmpty(l)).length,
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionHeader(BuildContext context, WidgetRef ref, Set<String> selected) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      color: AppColors.accentMuted,
      child: Row(
        children: [
          Checkbox(
            value: selected.length == locales.length,
            tristate: true,
            onChanged: (value) {
              if (value == true) {
                ref.read(selectedLocalesProvider.notifier).addAll(
                      locales.map((l) => l.locale).toList(),
                    );
              } else {
                ref.read(selectedLocalesProvider.notifier).clear();
              }
            },
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            context.l10n.metadataSelected(selected.length),
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () => ref.read(selectedLocalesProvider.notifier).clear(),
            child: Text(context.l10n.metadataDeselectAll),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, MetadataFilter filter) {
    String message;
    switch (filter) {
      case MetadataFilter.live:
        message = 'No live locales';
      case MetadataFilter.draft:
        message = 'No drafts';
      case MetadataFilter.empty:
        message = 'All locales have content';
      case MetadataFilter.all:
        message = 'No locales available';
    }

    return Center(
      child: Text(
        message,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  List<MetadataLocale> _filterLocales(List<MetadataLocale> all, MetadataFilter filter) {
    switch (filter) {
      case MetadataFilter.all:
        return all;
      case MetadataFilter.live:
        return all.where((l) => _isLive(l)).toList();
      case MetadataFilter.draft:
        return all.where((l) => l.hasDraft).toList();
      case MetadataFilter.empty:
        return all.where((l) => _isEmpty(l)).toList();
    }
  }

  bool _isLive(MetadataLocale locale) {
    return !locale.hasDraft &&
        locale.live != null &&
        (locale.live!.title?.isNotEmpty == true ||
            locale.live!.description?.isNotEmpty == true);
  }

  bool _isEmpty(MetadataLocale locale) {
    return !locale.hasDraft &&
        (locale.live == null ||
            (locale.live!.title?.isEmpty != false &&
                locale.live!.description?.isEmpty != false));
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int count;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.count,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppColors.radiusSmall),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (color ?? AppColors.accent).withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppColors.radiusSmall),
          border: Border.all(
            color: isSelected
                ? (color ?? AppColors.accent)
                : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: isSelected ? (color ?? AppColors.accent) : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(width: AppSpacing.xxs),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: (color ?? AppColors.textMuted).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                count.toString(),
                style: AppTypography.micro.copyWith(
                  color: color ?? AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocaleTableRow extends StatelessWidget {
  final MetadataLocale locale;
  final bool isSelected;
  final bool isChecked;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final ValueChanged<bool?> onCheckChanged;
  final VoidCallback onLongPress;

  const _LocaleTableRow({
    required this.locale,
    required this.isSelected,
    required this.isChecked,
    required this.isSelectionMode,
    required this.onTap,
    required this.onCheckChanged,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.accentMuted
            : isChecked
                ? AppColors.bgHover
                : Colors.transparent,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        border: isSelected
            ? Border.all(color: AppColors.accent.withValues(alpha: 0.3))
            : null,
      ),
      child: InkWell(
        onTap: isSelectionMode ? () => onCheckChanged(!isChecked) : onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              // Checkbox (always show in selection mode)
              if (isSelectionMode)
                Checkbox(
                  value: isChecked,
                  onChanged: onCheckChanged,
                )
              else
                _buildLocaleFlag(locale.locale),
              const SizedBox(width: AppSpacing.sm),
              // Locale info
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getLocaleName(locale.locale),
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    Text(
                      locale.locale,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              // Title preview
              Expanded(
                flex: 3,
                child: Text(
                  locale.effective?.title ?? '-',
                  style: AppTypography.bodySmall.copyWith(
                    color: locale.effective?.title != null
                        ? AppColors.textPrimary
                        : AppColors.textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Status badge
              _buildStatusBadge(),
              const SizedBox(width: AppSpacing.sm),
              // Completion indicator
              _buildCompletionIndicator(locale.completionPercentage),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocaleFlag(String localeCode) {
    final countryCode = localeCode.contains('-')
        ? localeCode.split('-').last.toUpperCase()
        : localeCode.toUpperCase();

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.bgHover,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          _countryCodeToEmoji(countryCode),
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  String _countryCodeToEmoji(String countryCode) {
    if (countryCode.length != 2) return '🌐';
    final firstLetter = countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final secondLetter = countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }

  Widget _buildStatusBadge() {
    String label;
    Color color;

    if (locale.hasDraft) {
      label = 'Draft';
      color = AppColors.yellowBright;
    } else if (locale.live != null &&
        (locale.live!.title?.isNotEmpty == true ||
            locale.live!.description?.isNotEmpty == true)) {
      label = 'Live';
      color = AppColors.green;
    } else {
      label = 'Empty';
      color = AppColors.textMuted;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: AppTypography.micro.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildCompletionIndicator(int percentage) {
    Color color;
    if (percentage >= 100) {
      color = AppColors.green;
    } else if (percentage >= 50) {
      color = AppColors.yellow;
    } else {
      color = AppColors.red;
    }

    return SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: percentage / 100,
            strokeWidth: 3,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation(color),
          ),
          if (percentage >= 100)
            Icon(Icons.check, size: 12, color: color),
        ],
      ),
    );
  }

  String _getLocaleName(String localeCode) {
    const localeNames = {
      'en-US': 'English (US)',
      'en-GB': 'English (UK)',
      'en-AU': 'English (Australia)',
      'en-CA': 'English (Canada)',
      'fr-FR': 'French',
      'fr-CA': 'French (Canada)',
      'de-DE': 'German',
      'es-ES': 'Spanish (Spain)',
      'es-MX': 'Spanish (Mexico)',
      'it-IT': 'Italian',
      'pt-BR': 'Portuguese (Brazil)',
      'pt-PT': 'Portuguese (Portugal)',
      'ja-JP': 'Japanese',
      'ja': 'Japanese',
      'ko-KR': 'Korean',
      'ko': 'Korean',
      'zh-Hans': 'Chinese (Simplified)',
      'zh-Hant': 'Chinese (Traditional)',
      'zh-CN': 'Chinese (Simplified)',
      'zh-TW': 'Chinese (Traditional)',
      'ru-RU': 'Russian',
      'ar-SA': 'Arabic',
      'nl-NL': 'Dutch',
      'sv-SE': 'Swedish',
      'da-DK': 'Danish',
      'fi-FI': 'Finnish',
      'no-NO': 'Norwegian',
      'pl-PL': 'Polish',
      'tr-TR': 'Turkish',
      'th-TH': 'Thai',
      'vi-VN': 'Vietnamese',
      'id-ID': 'Indonesian',
      'ms-MY': 'Malay',
      'hi-IN': 'Hindi',
      'he-IL': 'Hebrew',
      'cs-CZ': 'Czech',
      'el-GR': 'Greek',
      'hu-HU': 'Hungarian',
      'ro-RO': 'Romanian',
      'sk-SK': 'Slovak',
      'uk-UA': 'Ukrainian',
    };

    return localeNames[localeCode] ?? localeCode;
  }
}
