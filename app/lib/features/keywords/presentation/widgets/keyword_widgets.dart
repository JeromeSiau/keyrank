import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../../tags/domain/tag_model.dart';
import '../../../tags/data/tags_repository.dart';
import '../../../tags/providers/tags_provider.dart';
import '../../domain/keyword_model.dart';
import '../../providers/keywords_provider.dart';

/// Enum for filtering keywords by difficulty level
enum DifficultyFilter { all, easy, medium, hard }

// =============================================================================
// Stat Card
// =============================================================================

class KeywordStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const KeywordStatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.glassPanelAlpha,
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
          border: Border.all(color: colors.glassBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: iconColor),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Difficulty Filter Chip
// =============================================================================

class DifficultyFilterChip extends StatelessWidget {
  final String label;
  final Color? color;
  final bool isSelected;
  final VoidCallback onTap;

  const DifficultyFilterChip({
    super.key,
    required this.label,
    this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final chipColor = color ?? colors.textSecondary;

    return Material(
      color: isSelected ? chipColor.withAlpha(30) : colors.bgActive,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? chipColor : colors.glassBorder,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? chipColor : colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Bulk Action Button
// =============================================================================

class BulkActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isDestructive;

  const BulkActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDisabled = onTap == null;
    final color = isDestructive ? colors.red : colors.accent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        hoverColor: isDisabled ? null : colors.bgHover,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isDisabled
                ? Colors.transparent
                : (isDestructive ? colors.redMuted : colors.accentMuted),
            border: Border.all(
              color: isDisabled ? colors.glassBorder : color.withAlpha(100),
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14,
                color: isDisabled ? colors.textMuted : color,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                label,
                style: AppTypography.micro.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDisabled ? colors.textMuted : color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Popularity Bar
// =============================================================================

class PopularityBar extends StatelessWidget {
  final int popularity;

  const PopularityBar({super.key, required this.popularity});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final normalizedPopularity = popularity.clamp(0, 100) / 100;

    return Column(
      children: [
        Text(
          popularity.toString(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 50,
          height: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: normalizedPopularity,
              backgroundColor: colors.bgHover,
              color: _getPopularityColor(colors, popularity),
            ),
          ),
        ),
      ],
    );
  }

  Color _getPopularityColor(AppColorsExtension colors, int popularity) {
    if (popularity >= 70) return colors.green;
    if (popularity >= 40) return colors.yellow;
    return colors.red;
  }
}

// =============================================================================
// Difficulty Badge
// =============================================================================

class DifficultyBadge extends StatelessWidget {
  final int difficulty;
  final String? label;

  const DifficultyBadge({
    super.key,
    required this.difficulty,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final difficultyColor = _getDifficultyColor(colors, label ?? _getLabelFromScore(difficulty));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: difficultyColor.withAlpha(30),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _getDisplayLabel(label ?? _getLabelFromScore(difficulty)),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: difficultyColor,
        ),
      ),
    );
  }

  String _getLabelFromScore(int score) {
    if (score < 33) return 'easy';
    if (score < 66) return 'medium';
    return 'hard';
  }

  String _getDisplayLabel(String label) {
    switch (label) {
      case 'easy':
        return 'Easy';
      case 'medium':
        return 'Med';
      case 'hard':
        return 'Hard';
      default:
        return label;
    }
  }

  Color _getDifficultyColor(AppColorsExtension colors, String label) {
    switch (label) {
      case 'easy':
        return colors.green;
      case 'medium':
        return colors.yellow;
      case 'hard':
        return colors.red;
      default:
        return colors.textMuted;
    }
  }
}

// =============================================================================
// Position Color Helper
// =============================================================================

Color getPositionColor(AppColorsExtension colors, int position) {
  if (position <= 3) return colors.green;
  if (position <= 10) return colors.greenBright;
  if (position <= 50) return colors.yellow;
  return colors.textSecondary;
}

// =============================================================================
// Tag Selection Dialog (for bulk operations)
// =============================================================================

class TagSelectionDialog extends ConsumerStatefulWidget {
  final List<TagModel> tags;

  const TagSelectionDialog({super.key, required this.tags});

  @override
  ConsumerState<TagSelectionDialog> createState() => _TagSelectionDialogState();
}

class _TagSelectionDialogState extends ConsumerState<TagSelectionDialog> {
  final Set<int> _selectedTagIds = {};
  final TextEditingController _newTagController = TextEditingController();
  bool _isCreatingTag = false;
  String _selectedColor = '#6366F1';
  late List<TagModel> _availableTags;

  static const List<String> _colorOptions = [
    '#6366F1', '#22C55E', '#EAB308', '#EF4444',
    '#3B82F6', '#F97316', '#EC4899', '#8B5CF6',
  ];

  @override
  void initState() {
    super.initState();
    _availableTags = List.from(widget.tags);
  }

  @override
  void dispose() {
    _newTagController.dispose();
    super.dispose();
  }

  Future<void> _createTag() async {
    final name = _newTagController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isCreatingTag = true);

    try {
      final newTag = await ref.read(tagsRepositoryProvider).createTag(
        name: name,
        color: _selectedColor,
      );
      ref.invalidate(tagsNotifierProvider);
      setState(() {
        _availableTags.add(newTag);
        _selectedTagIds.add(newTag.id);
        _isCreatingTag = false;
      });
      _newTagController.clear();
    } catch (e) {
      setState(() => _isCreatingTag = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AlertDialog(
      backgroundColor: colors.glassPanel,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        side: BorderSide(color: colors.glassBorder),
      ),
      title: Text(
        context.l10n.appDetail_addTagsTitle,
        style: AppTypography.title.copyWith(color: colors.textPrimary),
      ),
      content: SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.appDetail_selectTagsDescription,
              style: AppTypography.caption.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 12),
            if (_availableTags.isEmpty)
              Text(
                context.l10n.appDetail_noTagsYet,
                style: AppTypography.caption.copyWith(color: colors.textMuted),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableTags.map((tag) {
                  final isSelected = _selectedTagIds.contains(tag.id);
                  return FilterChip(
                    label: Text(tag.name),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedTagIds.add(tag.id);
                        } else {
                          _selectedTagIds.remove(tag.id);
                        }
                      });
                    },
                    selectedColor: tag.colorValue.withAlpha(50),
                    checkmarkColor: tag.colorValue,
                    labelStyle: TextStyle(
                      color: isSelected ? tag.colorValue : colors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                    side: BorderSide(
                      color: isSelected ? tag.colorValue : colors.glassBorder,
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 16),
            Divider(color: colors.glassBorder),
            const SizedBox(height: 12),

            Text(
              context.l10n.appDetail_createNewTag,
              style: AppTypography.caption.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                PopupMenuButton<String>(
                  initialValue: _selectedColor,
                  onSelected: (color) => setState(() => _selectedColor = color),
                  itemBuilder: (context) => _colorOptions.map((color) {
                    final colorValue = Color(int.parse(color.replaceFirst('#', '0xFF')));
                    return PopupMenuItem(
                      value: color,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: colorValue,
                          borderRadius: BorderRadius.circular(4),
                          border: color == _selectedColor
                              ? Border.all(color: colors.textPrimary, width: 2)
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Color(int.parse(_selectedColor.replaceFirst('#', '0xFF'))),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: colors.glassBorder),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _newTagController,
                    style: AppTypography.body.copyWith(color: colors.textPrimary),
                    decoration: InputDecoration(
                      hintText: context.l10n.appDetail_tagNameHint,
                      hintStyle: AppTypography.body.copyWith(color: colors.textMuted),
                      filled: true,
                      fillColor: colors.bgActive,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: colors.glassBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: colors.glassBorder),
                      ),
                    ),
                    onSubmitted: (_) => _createTag(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _isCreatingTag ? null : _createTag,
                  icon: _isCreatingTag
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: colors.accent),
                        )
                      : Icon(Icons.add_circle, color: colors.accent),
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.appDetail_cancel),
        ),
        FilledButton(
          onPressed: _selectedTagIds.isEmpty
              ? null
              : () => Navigator.pop(context, _selectedTagIds.toList()),
          child: Text(context.l10n.appDetail_addTagsCount(_selectedTagIds.length)),
        ),
      ],
    );
  }
}

// =============================================================================
// Keyword Tags Modal
// =============================================================================

class KeywordTagsModal extends ConsumerStatefulWidget {
  final int appId;
  final Keyword keyword;
  final VoidCallback? onTagsChanged;

  const KeywordTagsModal({
    super.key,
    required this.appId,
    required this.keyword,
    this.onTagsChanged,
  });

  @override
  ConsumerState<KeywordTagsModal> createState() => _KeywordTagsModalState();
}

class _KeywordTagsModalState extends ConsumerState<KeywordTagsModal> {
  late TextEditingController _newTagNameController;
  late List<TagModel> _currentTags;
  bool _isCreatingTag = false;
  String _selectedColor = '#6366F1';

  static const List<String> _colorOptions = [
    '#6366F1', '#22C55E', '#EAB308', '#EF4444',
    '#3B82F6', '#F97316', '#EC4899', '#8B5CF6',
  ];

  @override
  void initState() {
    super.initState();
    _newTagNameController = TextEditingController();
    _currentTags = List.from(widget.keyword.tags);
  }

  @override
  void dispose() {
    _newTagNameController.dispose();
    super.dispose();
  }

  Future<void> _addTag(TagModel tag) async {
    if (_currentTags.any((t) => t.id == tag.id)) return;

    setState(() => _currentTags.add(tag));

    try {
      await ref.read(tagsRepositoryProvider).addTagToKeyword(
        tagId: tag.id,
        trackedKeywordId: widget.keyword.trackedKeywordId!,
      );
      ref.read(keywordsNotifierProvider(widget.appId).notifier)
          .updateKeywordTags(widget.keyword.id, _currentTags);
      widget.onTagsChanged?.call();
    } catch (e) {
      setState(() => _currentTags.removeWhere((t) => t.id == tag.id));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.red),
        );
      }
    }
  }

  Future<void> _removeTag(TagModel tag) async {
    setState(() => _currentTags.removeWhere((t) => t.id == tag.id));

    try {
      await ref.read(tagsRepositoryProvider).removeTagFromKeyword(
        tagId: tag.id,
        trackedKeywordId: widget.keyword.trackedKeywordId!,
      );
      ref.read(keywordsNotifierProvider(widget.appId).notifier)
          .updateKeywordTags(widget.keyword.id, _currentTags);
      widget.onTagsChanged?.call();
    } catch (e) {
      setState(() => _currentTags.add(tag));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.red),
        );
      }
    }
  }

  Future<void> _createAndAddTag() async {
    final name = _newTagNameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isCreatingTag = true);

    try {
      final newTag = await ref.read(tagsRepositoryProvider).createTag(
        name: name,
        color: _selectedColor,
      );
      ref.invalidate(tagsNotifierProvider);
      await _addTag(newTag);
      _newTagNameController.clear();
      setState(() => _isCreatingTag = false);
    } catch (e) {
      setState(() => _isCreatingTag = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tagsAsync = ref.watch(tagsNotifierProvider);
    final allTags = tagsAsync.valueOrNull ?? [];
    final availableTags = allTags.where((t) => !_currentTags.any((ct) => ct.id == t.id)).toList();

    return AlertDialog(
      backgroundColor: colors.glassPanel,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        side: BorderSide(color: colors.glassBorder),
      ),
      title: Row(
        children: [
          Icon(Icons.label_outline, color: colors.accent, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Tags: ${widget.keyword.keyword}',
              style: AppTypography.title.copyWith(color: colors.textPrimary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: colors.textMuted),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
      content: SizedBox(
        width: 380,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.appDetail_currentTags,
                style: AppTypography.caption.copyWith(color: colors.textSecondary),
              ),
              const SizedBox(height: 8),
              if (_currentTags.isEmpty)
                Text(
                  context.l10n.appDetail_noTagsOnKeyword,
                  style: AppTypography.caption.copyWith(color: colors.textMuted),
                )
              else
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _currentTags.map((tag) => Chip(
                    label: Text(tag.name),
                    backgroundColor: tag.colorValue.withAlpha(30),
                    labelStyle: TextStyle(color: tag.colorValue, fontSize: 12),
                    deleteIcon: Icon(Icons.close, size: 16, color: tag.colorValue),
                    onDeleted: () => _removeTag(tag),
                    side: BorderSide.none,
                    visualDensity: VisualDensity.compact,
                  )).toList(),
                ),

              const SizedBox(height: 16),
              Divider(color: colors.glassBorder),
              const SizedBox(height: 12),

              if (availableTags.isNotEmpty) ...[
                Text(
                  context.l10n.appDetail_addExistingTag,
                  style: AppTypography.caption.copyWith(color: colors.textSecondary),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: availableTags.map((tag) => ActionChip(
                    label: Text(tag.name),
                    backgroundColor: colors.bgActive,
                    labelStyle: TextStyle(color: tag.colorValue, fontSize: 12),
                    avatar: Icon(Icons.add, size: 16, color: tag.colorValue),
                    onPressed: () => _addTag(tag),
                    side: BorderSide(color: tag.colorValue.withAlpha(50)),
                    visualDensity: VisualDensity.compact,
                  )).toList(),
                ),
                const SizedBox(height: 16),
                Divider(color: colors.glassBorder),
                const SizedBox(height: 12),
              ],

              Text(
                context.l10n.appDetail_createNewTag,
                style: AppTypography.caption.copyWith(color: colors.textSecondary),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  PopupMenuButton<String>(
                    initialValue: _selectedColor,
                    onSelected: (color) => setState(() => _selectedColor = color),
                    itemBuilder: (context) => _colorOptions.map((color) {
                      final colorValue = Color(int.parse(color.replaceFirst('#', '0xFF')));
                      return PopupMenuItem(
                        value: color,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: colorValue,
                            borderRadius: BorderRadius.circular(4),
                            border: color == _selectedColor
                                ? Border.all(color: colors.textPrimary, width: 2)
                                : null,
                          ),
                        ),
                      );
                    }).toList(),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Color(int.parse(_selectedColor.replaceFirst('#', '0xFF'))),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: colors.glassBorder),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _newTagNameController,
                      style: AppTypography.body.copyWith(color: colors.textPrimary),
                      decoration: InputDecoration(
                        hintText: context.l10n.appDetail_tagNameHint,
                        hintStyle: AppTypography.body.copyWith(color: colors.textMuted),
                        filled: true,
                        fillColor: colors.bgActive,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: colors.glassBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: colors.glassBorder),
                        ),
                      ),
                      onSubmitted: (_) => _createAndAddTag(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _isCreatingTag ? null : _createAndAddTag,
                    icon: _isCreatingTag
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: colors.accent),
                          )
                        : Icon(Icons.add_circle, color: colors.accent),
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.appDetail_done),
        ),
      ],
    );
  }
}

// =============================================================================
// Note Edit Modal
// =============================================================================

class NoteEditModal extends ConsumerStatefulWidget {
  final int appId;
  final Keyword keyword;
  final VoidCallback? onNoteSaved;

  const NoteEditModal({
    super.key,
    required this.appId,
    required this.keyword,
    this.onNoteSaved,
  });

  @override
  ConsumerState<NoteEditModal> createState() => _NoteEditModalState();
}

class _NoteEditModalState extends ConsumerState<NoteEditModal> {
  late TextEditingController _noteController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.keyword.note ?? '');
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    setState(() => _isSaving = true);

    try {
      await ref.read(keywordsNotifierProvider(widget.appId).notifier)
          .updateNote(widget.keyword, _noteController.text.trim());
      widget.onNoteSaved?.call();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AlertDialog(
      backgroundColor: colors.glassPanel,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        side: BorderSide(color: colors.glassBorder),
      ),
      title: Row(
        children: [
          Icon(Icons.note_alt_outlined, color: colors.accent, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Note: ${widget.keyword.keyword}',
              style: AppTypography.title.copyWith(color: colors.textPrimary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: colors.textMuted),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: TextField(
          controller: _noteController,
          maxLines: 5,
          autofocus: true,
          style: AppTypography.body.copyWith(color: colors.textPrimary),
          decoration: InputDecoration(
            hintText: context.l10n.appDetail_noteHint,
            hintStyle: AppTypography.body.copyWith(color: colors.textMuted),
            filled: true,
            fillColor: colors.bgActive,
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: colors.glassBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: colors.glassBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: colors.accent),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.appDetail_cancel),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _saveNote,
          child: _isSaving
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: colors.textPrimary),
                )
              : Text(context.l10n.appDetail_saveNote),
        ),
      ],
    );
  }
}
