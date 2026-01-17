import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../data/metadata_repository.dart';
import '../../domain/metadata_model.dart';
import '../../providers/metadata_provider.dart';

class MetadataLocaleEditor extends ConsumerStatefulWidget {
  final int appId;
  final String locale;
  final String platform;
  final VoidCallback? onSaved;
  final VoidCallback? onPublish;
  final VoidCallback? onBack;

  const MetadataLocaleEditor({
    super.key,
    required this.appId,
    required this.locale,
    required this.platform,
    this.onSaved,
    this.onPublish,
    this.onBack,
  });

  @override
  ConsumerState<MetadataLocaleEditor> createState() =>
      _MetadataLocaleEditorState();
}

class _MetadataLocaleEditorState extends ConsumerState<MetadataLocaleEditor> {
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late TextEditingController _keywordsController;
  late TextEditingController _descriptionController;
  late TextEditingController _promotionalTextController;
  late TextEditingController _whatsNewController;

  bool _isDirty = false;
  bool _isSaving = false;
  MetadataLimits _limits = MetadataLimits();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _subtitleController = TextEditingController();
    _keywordsController = TextEditingController();
    _descriptionController = TextEditingController();
    _promotionalTextController = TextEditingController();
    _whatsNewController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _keywordsController.dispose();
    _descriptionController.dispose();
    _promotionalTextController.dispose();
    _whatsNewController.dispose();
    super.dispose();
  }

  void _initControllers(MetadataLocaleDetail detail) {
    final content = detail.draft != null
        ? MetadataContent(
            title: detail.draft!.title ?? detail.live?.title,
            subtitle: detail.draft!.subtitle ?? detail.live?.subtitle,
            keywords: detail.draft!.keywords ?? detail.live?.keywords,
            description: detail.draft!.description ?? detail.live?.description,
            promotionalText:
                detail.draft!.promotionalText ?? detail.live?.promotionalText,
            whatsNew: detail.draft!.whatsNew ?? detail.live?.whatsNew,
          )
        : detail.live;

    if (content != null) {
      _titleController.text = content.title ?? '';
      _subtitleController.text = content.subtitle ?? '';
      _keywordsController.text = content.keywords ?? '';
      _descriptionController.text = content.description ?? '';
      _promotionalTextController.text = content.promotionalText ?? '';
      _whatsNewController.text = content.whatsNew ?? '';
    }

    _limits = detail.limits;
  }

  void _markDirty() {
    if (!_isDirty) {
      setState(() => _isDirty = true);
    }
  }

  Future<void> _saveDraft() async {
    if (!_isDirty) return;

    setState(() => _isSaving = true);

    try {
      final repository = ref.read(metadataRepositoryProvider);
      await repository.saveDraft(
        appId: widget.appId,
        locale: widget.locale,
        title: _titleController.text.isEmpty ? null : _titleController.text,
        subtitle:
            _subtitleController.text.isEmpty ? null : _subtitleController.text,
        keywords:
            _keywordsController.text.isEmpty ? null : _keywordsController.text,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        promotionalText: _promotionalTextController.text.isEmpty
            ? null
            : _promotionalTextController.text,
        whatsNew:
            _whatsNewController.text.isEmpty ? null : _whatsNewController.text,
      );

      setState(() {
        _isDirty = false;
        _isSaving = false;
      });

      // Invalidate to refresh
      ref.invalidate(localeMetadataProvider(
          LocaleMetadataParams(appId: widget.appId, locale: widget.locale)));

      widget.onSaved?.call();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.metadata_draftSaved),
            backgroundColor: AppColors.green,
          ),
        );
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final params =
        LocaleMetadataParams(appId: widget.appId, locale: widget.locale);
    final detailAsync = ref.watch(localeMetadataProvider(params));

    return detailAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text(error.toString())),
      data: (detail) {
        // Initialize controllers on first load
        if (!_isDirty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _initControllers(detail);
          });
        }

        return _buildEditor(detail);
      },
    );
  }

  Widget _buildEditor(MetadataLocaleDetail detail) {
    final isIos = widget.platform == 'ios';
    final isAndroid = widget.platform == 'android';

    return Column(
      children: [
        // Header with actions
        _buildHeader(),
        const Divider(height: 1),

        // Editor content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                _buildField(
                  label: context.l10n.metadata_title,
                  controller: _titleController,
                  maxLength: _limits.title,
                  maxLines: 1,
                  hint: context.l10n.metadata_titleHint(_limits.title),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Subtitle (iOS) / Short Description (Android)
                if (isIos) ...[
                  _buildField(
                    label: context.l10n.metadata_subtitle,
                    controller: _subtitleController,
                    maxLength: _limits.subtitle,
                    maxLines: 1,
                    hint: context.l10n.metadata_subtitleHint(_limits.subtitle),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
                if (isAndroid && _limits.subtitle > 0) ...[
                  _buildField(
                    label: context.l10n.metadata_shortDescription,
                    controller: _subtitleController,
                    maxLength: _limits.subtitle,
                    maxLines: 2,
                    hint: context.l10n.metadata_shortDescriptionHint(_limits.subtitle),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],

                // Keywords (iOS only)
                if (isIos && _limits.keywords > 0) ...[
                  _buildField(
                    label: context.l10n.metadata_keywords,
                    controller: _keywordsController,
                    maxLength: _limits.keywords,
                    maxLines: 2,
                    hint: context.l10n.metadata_keywordsHint(_limits.keywords),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],

                // Description (Full Description on Android)
                _buildField(
                  label: isAndroid
                      ? context.l10n.metadata_fullDescription
                      : context.l10n.metadata_description,
                  controller: _descriptionController,
                  maxLength: _limits.description,
                  maxLines: 8,
                  hint: isAndroid
                      ? context.l10n.metadata_fullDescriptionHint(_limits.description)
                      : context.l10n.metadata_descriptionHint(_limits.description),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Promotional Text (iOS only)
                if (isIos && _limits.promotionalText > 0) ...[
                  _buildField(
                    label: context.l10n.metadata_promotionalText,
                    controller: _promotionalTextController,
                    maxLength: _limits.promotionalText,
                    maxLines: 3,
                    hint: context.l10n
                        .metadata_promotionalTextHint(_limits.promotionalText),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],

                // What's New / Release Notes
                _buildField(
                  label: isAndroid
                      ? context.l10n.metadata_releaseNotes
                      : context.l10n.metadata_whatsNew,
                  controller: _whatsNewController,
                  maxLength: _limits.whatsNew,
                  maxLines: 5,
                  hint: isAndroid
                      ? context.l10n.metadata_releaseNotesHint(_limits.whatsNew)
                      : context.l10n.metadata_whatsNewHint(_limits.whatsNew),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Keyword Analysis (iOS only - Android doesn't have keyword field)
                if (isIos && detail.keywordAnalysis.isNotEmpty) ...[
                  _buildKeywordAnalysis(detail.keywordAnalysis),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          if (widget.onBack != null)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: widget.onBack,
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.locale,
                  style: AppTypography.title,
                ),
                if (_isDirty)
                  Text(
                    context.l10n.metadata_hasChanges,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.yellow,
                    ),
                  ),
              ],
            ),
          ),
          if (_isDirty) ...[
            TextButton(
              onPressed: () {
                ref.invalidate(localeMetadataProvider(LocaleMetadataParams(
                    appId: widget.appId, locale: widget.locale)));
                setState(() => _isDirty = false);
              },
              child: Text(context.l10n.metadata_discardChanges),
            ),
            const SizedBox(width: AppSpacing.sm),
            FilledButton.icon(
              onPressed: _isSaving ? null : _saveDraft,
              icon: _isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save, size: 18),
              label: Text(context.l10n.metadata_saveDraft),
            ),
          ],
          if (!_isDirty && widget.onPublish != null) ...[
            const SizedBox(width: AppSpacing.sm),
            FilledButton.icon(
              onPressed: widget.onPublish,
              icon: const Icon(Icons.publish, size: 18),
              label: Text(context.l10n.metadata_publish),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required int maxLength,
    required int maxLines,
    String? hint,
  }) {
    final currentLength = controller.text.length;
    final isOverLimit = currentLength > maxLength;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.titleSmall),
            Text(
              context.l10n.metadata_charCount(currentLength, maxLength),
              style: AppTypography.caption.copyWith(
                color: isOverLimit ? AppColors.red : AppColors.textMuted,
                fontWeight: isOverLimit ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: controller,
          maxLines: maxLines,
          onChanged: (_) {
            _markDirty();
            setState(() {}); // Update char count
          },
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.bgPanel,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              borderSide: BorderSide(
                color: isOverLimit ? AppColors.red : AppColors.border,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              borderSide: BorderSide(
                color: isOverLimit ? AppColors.red : AppColors.border,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              borderSide: BorderSide(
                color: isOverLimit ? AppColors.red : AppColors.accent,
              ),
            ),
          ),
        ),
        if (isOverLimit)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              'Exceeds maximum length by ${currentLength - maxLength} characters',
              style: AppTypography.caption.copyWith(color: AppColors.red),
            ),
          ),
      ],
    );
  }

  Widget _buildKeywordAnalysis(List<KeywordAnalysis> keywords) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.metadata_keywordAnalysis,
          style: AppTypography.title,
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgPanel,
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: keywords.map((kw) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.border,
                      width: kw == keywords.last ? 0 : 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        kw.keyword,
                        style: AppTypography.bodyMedium,
                      ),
                    ),
                    _buildPresenceChip(context.l10n.metadata_inTitle, kw.inTitle),
                    const SizedBox(width: 4),
                    _buildPresenceChip(
                        context.l10n.metadata_inSubtitle, kw.inSubtitle),
                    const SizedBox(width: 4),
                    _buildPresenceChip(
                        context.l10n.metadata_inKeywords, kw.inKeywords),
                    const SizedBox(width: 4),
                    _buildPresenceChip(
                        context.l10n.metadata_inDescription, kw.inDescription),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPresenceChip(String label, bool present) {
    return Tooltip(
      message: label,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: present ? AppColors.greenMuted : AppColors.redMuted,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          present ? Icons.check : Icons.close,
          size: 14,
          color: present ? AppColors.green : AppColors.red,
        ),
      ),
    );
  }
}
