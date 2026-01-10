import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/l10n_extension.dart';
import '../data/keywords_repository.dart';
import '../domain/keyword_model.dart';

class KeywordSuggestionsModal extends ConsumerStatefulWidget {
  final int appId;
  final String appName;
  final String country;
  final List<String> existingKeywords;
  final Future<void> Function(List<String> keywords) onAddKeywords;

  const KeywordSuggestionsModal({
    super.key,
    required this.appId,
    required this.appName,
    required this.country,
    required this.existingKeywords,
    required this.onAddKeywords,
  });

  @override
  ConsumerState<KeywordSuggestionsModal> createState() => _KeywordSuggestionsModalState();
}

class _KeywordSuggestionsModalState extends ConsumerState<KeywordSuggestionsModal> {
  List<KeywordSuggestion>? _suggestions;
  bool _isLoading = true;
  String? _error;
  final Set<String> _selectedKeywords = {};
  String _searchQuery = '';
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repository = ref.read(keywordsRepositoryProvider);
      final response = await repository.getKeywordSuggestions(
        widget.appId,
        country: widget.country,
        limit: 50,
      );
      if (mounted) {
        setState(() {
          _suggestions = response.suggestions
              .where((s) => !widget.existingKeywords.contains(s.keyword.toLowerCase()))
              .toList();
          _isLoading = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  List<KeywordSuggestion> get _filteredSuggestions {
    if (_suggestions == null) return [];
    if (_searchQuery.isEmpty) return _suggestions!;
    return _suggestions!
        .where((s) => s.keyword.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _toggleSelection(String keyword) {
    setState(() {
      if (_selectedKeywords.contains(keyword)) {
        _selectedKeywords.remove(keyword);
      } else {
        _selectedKeywords.add(keyword);
      }
    });
  }

  void _selectAll() {
    setState(() {
      _selectedKeywords.addAll(_filteredSuggestions.map((s) => s.keyword));
    });
  }

  void _selectNone() {
    setState(() {
      _selectedKeywords.clear();
    });
  }

  Future<void> _addSelected() async {
    if (_selectedKeywords.isEmpty) return;

    setState(() => _isAdding = true);

    try {
      await widget.onAddKeywords(_selectedKeywords.toList());
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        final colors = context.colors;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.keywordSuggestions_errorAdding(e.toString())),
            backgroundColor: colors.red,
          ),
        );
        setState(() => _isAdding = false);
      }
    }
  }

  Color _getDifficultyColor(String label) {
    final colors = context.colors;
    switch (label) {
      case 'easy':
        return colors.green;
      case 'medium':
        return colors.yellow;
      case 'hard':
        return colors.orange;
      case 'very_hard':
        return colors.red;
      default:
        return colors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Dialog(
      backgroundColor: colors.glassPanel,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
        side: BorderSide(color: colors.glassBorder),
      ),
      child: Container(
        width: 700,
        height: 600,
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(child: _buildContent()),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.greenMuted,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.lightbulb_outline_rounded, size: 20, color: colors.green),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.keywordSuggestions_title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  context.l10n.keywordSuggestions_appInCountry(widget.appName, widget.country),
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _loadSuggestions,
            icon: const Icon(Icons.refresh_rounded, size: 20),
            color: colors.textMuted,
            tooltip: context.l10n.keywordSuggestions_refresh,
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded, size: 20),
            color: colors.textMuted,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colors.bgBase,
                border: Border.all(color: colors.glassBorder),
                borderRadius: BorderRadius.circular(AppColors.radiusSmall),
              ),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                style: TextStyle(fontSize: 14, color: colors.textPrimary),
                decoration: InputDecoration(
                  hintText: context.l10n.keywordSuggestions_search,
                  hintStyle: TextStyle(color: colors.textMuted),
                  prefixIcon: Icon(Icons.search_rounded, size: 18, color: colors.textMuted),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          TextButton(
            onPressed: _selectAll,
            child: Text(context.l10n.keywordSuggestions_selectAll),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: _selectNone,
            child: Text(context.l10n.keywordSuggestions_clear),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final colors = context.colors;
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(strokeWidth: 2),
            const SizedBox(height: 16),
            Text(
              context.l10n.keywordSuggestions_analyzing,
              style: TextStyle(color: colors.textMuted),
            ),
            const SizedBox(height: 4),
            Text(
              context.l10n.keywordSuggestions_mayTakeFewSeconds,
              style: TextStyle(fontSize: 12, color: colors.textMuted),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: colors.redMuted,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.error_outline_rounded, size: 28, color: colors.red),
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: TextStyle(color: colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _loadSuggestions,
              child: Text(context.l10n.common_retry),
            ),
          ],
        ),
      );
    }

    final suggestions = _filteredSuggestions;

    if (suggestions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: colors.bgActive,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.search_off_rounded, size: 28, color: colors.textMuted),
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty ? context.l10n.keywordSuggestions_noSuggestions : context.l10n.keywordSuggestions_noMatchingSuggestions,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Table header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: colors.bgActive.withAlpha(50),
          ),
          child: Row(
            children: [
              const SizedBox(width: 40),
              Expanded(
                flex: 3,
                child: Text(
                  context.l10n.keywordSuggestions_headerKeyword,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: colors.textMuted,
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: Text(
                  context.l10n.keywordSuggestions_headerDifficulty,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: colors.textMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 80,
                child: Text(
                  context.l10n.keywordSuggestions_headerApps,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: colors.textMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        // Table content
        Expanded(
          child: ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];
              final isSelected = _selectedKeywords.contains(suggestion.keyword);
              final difficultyColor = _getDifficultyColor(suggestion.difficultyLabel);

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _toggleSelection(suggestion.keyword),
                  hoverColor: colors.bgHover,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? colors.accentMuted : Colors.transparent,
                      border: Border(
                        bottom: BorderSide(color: colors.glassBorder),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Checkbox
                        SizedBox(
                          width: 40,
                          child: Checkbox(
                            value: isSelected,
                            onChanged: (_) => _toggleSelection(suggestion.keyword),
                            activeColor: colors.accent,
                            side: BorderSide(color: colors.textMuted),
                          ),
                        ),
                        // Keyword
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                suggestion.keyword,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: colors.textPrimary,
                                ),
                              ),
                              if (suggestion.position != null)
                                Text(
                                  context.l10n.keywordSuggestions_rankedAt(suggestion.position!),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: colors.green,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // Difficulty
                        SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${suggestion.difficulty}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: difficultyColor,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ProgressBar(
                                  value: suggestion.difficulty,
                                  height: 4,
                                  width: 50,
                                  color: difficultyColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Apps count
                        SizedBox(
                          width: 80,
                          child: Text(
                            '${suggestion.competition}',
                            style: TextStyle(
                              fontSize: 13,
                              color: colors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.glassBorder)),
      ),
      child: Row(
        children: [
          Text(
            context.l10n.keywordSuggestions_keywordsSelected(_selectedKeywords.length),
            style: TextStyle(
              fontSize: 13,
              color: colors.textMuted,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.compare_cancel),
          ),
          const SizedBox(width: 12),
          FilledButton(
            onPressed: _selectedKeywords.isEmpty || _isAdding ? null : _addSelected,
            style: FilledButton.styleFrom(
              backgroundColor: colors.green,
              disabledBackgroundColor: colors.greenMuted,
            ),
            child: _isAdding
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text(context.l10n.keywordSuggestions_addKeywords(_selectedKeywords.length)),
          ),
        ],
      ),
    );
  }
}
