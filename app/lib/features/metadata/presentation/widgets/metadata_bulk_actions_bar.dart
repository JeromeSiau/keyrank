import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../data/metadata_repository.dart';
import '../../domain/metadata_model.dart';
import '../../providers/metadata_provider.dart';

class MetadataBulkActionsBar extends ConsumerStatefulWidget {
  final int appId;
  final List<MetadataLocale> locales;
  final VoidCallback onActionComplete;

  const MetadataBulkActionsBar({
    super.key,
    required this.appId,
    required this.locales,
    required this.onActionComplete,
  });

  @override
  ConsumerState<MetadataBulkActionsBar> createState() =>
      _MetadataBulkActionsBarState();
}

class _MetadataBulkActionsBarState
    extends ConsumerState<MetadataBulkActionsBar> {
  bool _isLoading = false;
  String? _loadingAction;

  @override
  Widget build(BuildContext context) {
    final selectedLocales = ref.watch(selectedLocalesProvider);

    if (selectedLocales.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Text(
              context.l10n.metadataSelected(selectedLocales.length),
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.md),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      _loadingAction ?? '',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              )
            else ...[
              // Copy button
              _ActionButton(
                icon: Icons.content_copy,
                label: context.l10n.metadataCopyTo,
                onPressed: () => _showCopyDialog(context, selectedLocales),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Translate button
              _ActionButton(
                icon: Icons.translate,
                label: context.l10n.metadataTranslateTo,
                onPressed: () => _showTranslateDialog(context, selectedLocales),
                color: AppColors.accent,
              ),
              const SizedBox(width: AppSpacing.sm),
              // Publish button
              _ActionButton(
                icon: Icons.publish,
                label: context.l10n.metadataPublishSelected,
                onPressed: () => _publishSelected(selectedLocales),
                color: AppColors.green,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _showCopyDialog(
      BuildContext context, Set<String> selectedLocales) async {
    final sourceLocale = await showDialog<String>(
      context: context,
      builder: (ctx) => _SourceLocaleDialog(
        locales: widget.locales,
        title: context.l10n.metadataSelectSource,
      ),
    );

    if (sourceLocale == null || !mounted) return;

    setState(() {
      _isLoading = true;
      _loadingAction = 'Copying...';
    });

    try {
      final repository = ref.read(metadataRepositoryProvider);
      final result = await repository.copyLocale(
        appId: widget.appId,
        sourceLocale: sourceLocale,
        targetLocales: selectedLocales.toList(),
      );

      if (mounted) {
        ref.read(selectedLocalesProvider.notifier).clear();
        widget.onActionComplete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.metadataCopySuccess(result.successCount)),
            backgroundColor: AppColors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadingAction = null;
        });
      }
    }
  }

  Future<void> _showTranslateDialog(
      BuildContext context, Set<String> selectedLocales) async {
    final sourceLocale = await showDialog<String>(
      context: context,
      builder: (ctx) => _SourceLocaleDialog(
        locales: widget.locales,
        title: context.l10n.metadataSelectSource,
      ),
    );

    if (sourceLocale == null || !mounted) return;

    setState(() {
      _isLoading = true;
      _loadingAction = context.l10n.metadataTranslating;
    });

    try {
      final repository = ref.read(metadataRepositoryProvider);
      final result = await repository.translateLocale(
        appId: widget.appId,
        sourceLocale: sourceLocale,
        targetLocales: selectedLocales.toList(),
      );

      if (mounted) {
        ref.read(selectedLocalesProvider.notifier).clear();
        widget.onActionComplete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.hasErrors
                  ? '${context.l10n.metadataTranslateSuccess(result.successCount)} (${result.errors.length} errors)'
                  : context.l10n.metadataTranslateSuccess(result.successCount),
            ),
            backgroundColor: result.hasErrors ? AppColors.yellow : AppColors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadingAction = null;
        });
      }
    }
  }

  Future<void> _publishSelected(Set<String> selectedLocales) async {
    // Only publish locales that have drafts
    final localesWithDrafts = widget.locales
        .where((l) => selectedLocales.contains(l.locale) && l.hasDraft)
        .map((l) => l.locale)
        .toList();

    if (localesWithDrafts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No drafts to publish in selection'),
          backgroundColor: AppColors.yellow,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.metadataPublishSelected),
        content: Text(
          'Publish ${localesWithDrafts.length} locale(s) to the store?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.l10n.common_cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.l10n.metadata_publish),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _isLoading = true;
      _loadingAction = 'Publishing...';
    });

    try {
      final repository = ref.read(metadataRepositoryProvider);
      final result = await repository.publishMetadata(
        appId: widget.appId,
        locales: localesWithDrafts,
      );

      if (mounted) {
        ref.read(selectedLocalesProvider.notifier).clear();
        widget.onActionComplete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.isSuccess
                  ? 'Published ${result.successCount} locale(s)'
                  : 'Published ${result.successCount}, failed ${result.failureCount}',
            ),
            backgroundColor: result.isSuccess ? AppColors.green : AppColors.yellow,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadingAction = null;
        });
      }
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18, color: color),
      label: Text(
        label,
        style: AppTypography.buttonSmall.copyWith(color: color),
      ),
    );
  }
}

class _SourceLocaleDialog extends StatelessWidget {
  final List<MetadataLocale> locales;
  final String title;

  const _SourceLocaleDialog({
    required this.locales,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    // Filter locales that have content
    final sourcableLocales = locales.where((l) {
      return l.live != null &&
          (l.live!.title?.isNotEmpty == true ||
              l.live!.description?.isNotEmpty == true);
    }).toList();

    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: 300,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: sourcableLocales.length,
          itemBuilder: (context, index) {
            final locale = sourcableLocales[index];
            return ListTile(
              leading: _buildLocaleFlag(locale.locale),
              title: Text(_getLocaleName(locale.locale)),
              subtitle: Text(
                locale.effective?.title ?? 'No title',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => Navigator.pop(context, locale.locale),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.common_cancel),
        ),
      ],
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

  String _getLocaleName(String localeCode) {
    const localeNames = {
      'en-US': 'English (US)',
      'en-GB': 'English (UK)',
      'fr-FR': 'French',
      'de-DE': 'German',
      'es-ES': 'Spanish (Spain)',
      'es-MX': 'Spanish (Mexico)',
      'it-IT': 'Italian',
      'pt-BR': 'Portuguese (Brazil)',
      'ja-JP': 'Japanese',
      'ko-KR': 'Korean',
      'zh-Hans': 'Chinese (Simplified)',
      'zh-Hant': 'Chinese (Traditional)',
    };
    return localeNames[localeCode] ?? localeCode;
  }
}
