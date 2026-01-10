import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/api/api_client.dart';
import '../../../shared/widgets/country_picker.dart';
import '../../../core/providers/country_provider.dart' show Country, availableCountries, countriesProvider, selectedCountryProvider;
import '../../../shared/widgets/states.dart';
import '../../apps/providers/apps_provider.dart';
import '../data/keywords_repository.dart';
import '../domain/keyword_model.dart';

final _keywordSearchQueryProvider = StateProvider<String>((ref) => '');
final _selectedPlatformProvider = StateProvider<String>((ref) => 'ios');

final _keywordSearchResultsProvider = FutureProvider<KeywordSearchResponse?>((ref) async {
  final query = ref.watch(_keywordSearchQueryProvider);
  final country = ref.watch(selectedCountryProvider);
  final platform = ref.watch(_selectedPlatformProvider);
  if (query.length < 2) return null;

  final repository = ref.watch(keywordsRepositoryProvider);
  return repository.searchKeyword(query: query, country: country.code, platform: platform);
});

class KeywordSearchScreen extends ConsumerStatefulWidget {
  const KeywordSearchScreen({super.key});

  @override
  ConsumerState<KeywordSearchScreen> createState() => _KeywordSearchScreenState();
}

class _KeywordSearchScreenState extends ConsumerState<KeywordSearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final searchResults = ref.watch(_keywordSearchResultsProvider);
    final selectedCountry = ref.watch(selectedCountryProvider);
    final selectedPlatform = ref.watch(_selectedPlatformProvider);
    final countries = ref.watch(countriesProvider).valueOrNull ?? availableCountries;

    return Container(
      decoration: BoxDecoration(
        color: colors.glassPanel,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
      ),
      child: Column(
        children: [
          // Toolbar
          _Toolbar(
            selectedCountry: selectedCountry,
            onCountrySelected: (country) {
              ref.read(selectedCountryProvider.notifier).state = country;
            },
            selectedPlatform: selectedPlatform,
            onPlatformSelected: (platform) {
              ref.read(_selectedPlatformProvider.notifier).state = platform;
            },
            countries: countries,
          ),
          // Search bar
          _SearchBar(
            controller: _searchController,
            onChanged: (value) {
              ref.read(_keywordSearchQueryProvider.notifier).state = value;
            },
            onClear: () {
              _searchController.clear();
              ref.read(_keywordSearchQueryProvider.notifier).state = '';
            },
          ),
          // Results
          Expanded(
            child: searchResults.when(
              loading: () => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (e, _) => ErrorView(message: e.toString()),
              data: (response) {
                if (response == null) {
                  return EmptyStateView(
                    icon: Icons.search_rounded,
                    title: context.l10n.keywordSearch_searchTitle,
                    subtitle: context.l10n.keywordSearch_searchSubtitle,
                  );
                }
                return _ResultsView(response: response);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  final Country selectedCountry;
  final ValueChanged<Country> onCountrySelected;
  final String selectedPlatform;
  final ValueChanged<String> onPlatformSelected;
  final List<Country> countries;

  const _Toolbar({
    required this.selectedCountry,
    required this.onCountrySelected,
    required this.selectedPlatform,
    required this.onPlatformSelected,
    required this.countries,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder)),
      ),
      child: Row(
        children: [
          Text(
            context.l10n.keywordSearch_title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(width: 16),
          // Platform toggle
          Container(
            decoration: BoxDecoration(
              color: colors.bgActive,
              border: Border.all(color: colors.glassBorder),
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _PlatformToggleButton(
                  label: '🍎 ${context.l10n.filter_ios}',
                  isSelected: selectedPlatform == 'ios',
                  onTap: () => onPlatformSelected('ios'),
                ),
                _PlatformToggleButton(
                  label: '🤖 ${context.l10n.filter_android}',
                  isSelected: selectedPlatform == 'android',
                  onTap: () => onPlatformSelected('android'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Country selector
          CountryPickerButton(
            selectedCountry: selectedCountry,
            countries: countries,
            onCountryChanged: onCountrySelected,
          ),
        ],
      ),
    );
  }
}

class _PlatformToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlatformToggleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? colors.glassPanel : Colors.transparent,
          borderRadius: BorderRadius.circular(AppColors.radiusSmall - 2),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? colors.textPrimary : colors.textMuted,
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
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
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Icon(Icons.search_rounded, size: 20, color: colors.textMuted),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: onChanged,
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: context.l10n.keywordSearch_searchPlaceholder,
                        hintStyle: TextStyle(color: colors.textMuted),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  if (controller.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      color: colors.textMuted,
                      onPressed: onClear,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultsView extends StatelessWidget {
  final KeywordSearchResponse response;

  const _ResultsView({required this.response});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Keyword info card
          _KeywordInfoCard(
            keyword: response.keyword.keyword,
            popularity: response.keyword.popularity,
            totalResults: response.totalResults,
          ),
          const SizedBox(height: 16),
          // Results table
          _ResultsTable(results: response.results),
        ],
      ),
    );
  }
}

class _KeywordInfoCard extends StatelessWidget {
  final String keyword;
  final int? popularity;
  final int totalResults;

  const _KeywordInfoCard({
    required this.keyword,
    required this.popularity,
    required this.totalResults,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  keyword,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  context.l10n.keywordSearch_appsRanked(totalResults),
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          if (popularity != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: _getPopularityColor(context, popularity!).withAlpha(25),
                borderRadius: BorderRadius.circular(AppColors.radiusMedium),
              ),
              child: Column(
                children: [
                  Text(
                    '$popularity',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: _getPopularityColor(context, popularity!),
                    ),
                  ),
                  Text(
                    context.l10n.keywordSearch_popularity,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: _getPopularityColor(context, popularity!),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _getPopularityColor(BuildContext context, int popularity) {
    final colors = context.colors;
    if (popularity >= 70) return colors.green;
    if (popularity >= 40) return colors.yellow;
    return colors.red;
  }
}

class _ResultsTable extends ConsumerWidget {
  final List<KeywordSearchResult> results;

  const _ResultsTable({required this.results});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final selectedPlatform = ref.watch(_selectedPlatformProvider);
    final selectedCountry = ref.watch(selectedCountryProvider);

    return Container(
      decoration: BoxDecoration(
        color: colors.bgActive.withAlpha(50),
        border: Border.all(color: colors.glassBorder),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.keywordSearch_results(results.length),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: colors.bgActive.withAlpha(80),
              border: Border(
                top: BorderSide(color: colors.glassBorder),
                bottom: BorderSide(color: colors.glassBorder),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  child: Text(
                    context.l10n.keywordSearch_headerRank,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                const SizedBox(width: 52),
                Expanded(
                  child: Text(
                    context.l10n.keywordSearch_headerApp,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: Text(
                    context.l10n.keywordSearch_headerRating,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 48,
                  child: Text(
                    context.l10n.keywordSearch_headerTrack,
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
          // Results
          ...results.map((app) => _ResultRow(
            app: app,
            platform: selectedPlatform,
            country: selectedCountry.code,
          )),
        ],
      ),
    );
  }
}

class _ResultRow extends ConsumerStatefulWidget {
  final KeywordSearchResult app;
  final String platform;
  final String country;

  const _ResultRow({
    required this.app,
    required this.platform,
    required this.country,
  });

  @override
  ConsumerState<_ResultRow> createState() => _ResultRowState();
}

class _ResultRowState extends ConsumerState<_ResultRow> {
  bool _isLoading = false;
  bool _isAdded = false;
  String? _error;

  Future<void> _trackApp() async {
    if (_isLoading || _isAdded) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final notifier = ref.read(appsNotifierProvider.notifier);
      final storeId = widget.platform == 'android'
          ? widget.app.googlePlayId
          : widget.app.appleId;

      if (storeId != null) {
        await notifier.addApp(
          platform: widget.platform,
          storeId: storeId,
          country: widget.country,
        );
      }
      setState(() {
        _isAdded = true;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      setState(() {
        _error = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isTopRank = widget.app.position <= 3;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.glassBorder)),
      ),
      child: Row(
        children: [
          // Position
          SizedBox(
            width: 60,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isTopRank ? colors.greenMuted : colors.bgActive,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '#${widget.app.position}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isTopRank ? colors.green : colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppColors.getGradient(widget.app.position),
              borderRadius: BorderRadius.circular(10),
            ),
            child: widget.app.iconUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.app.iconUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Center(
                        child: Icon(Icons.apps, size: 20, color: Colors.white),
                      ),
                    ),
                  )
                : const Center(
                    child: Icon(Icons.apps, size: 20, color: Colors.white),
                  ),
          ),
          const SizedBox(width: 12),
          // App info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.app.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.app.developer != null)
                  Text(
                    widget.app.developer!,
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.textMuted,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          // Rating
          SizedBox(
            width: 70,
            child: widget.app.rating != null
                ? Row(
                    children: [
                      Icon(Icons.star_rounded, size: 16, color: colors.yellow),
                      const SizedBox(width: 4),
                      Text(
                        widget.app.rating!.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  )
                : Text(
                    '--',
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.textMuted,
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          // Track button
          SizedBox(
            width: 48,
            child: _buildTrackButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackButton() {
    final colors = context.colors;
    if (_isAdded) {
      return Icon(
        Icons.check_circle_rounded,
        size: 22,
        color: colors.green,
      );
    }

    if (_isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: colors.textMuted,
        ),
      );
    }

    if (_error != null) {
      return Tooltip(
        message: _error!,
        child: IconButton(
          icon: const Icon(Icons.error_outline_rounded, size: 22),
          color: colors.red,
          onPressed: _trackApp,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      );
    }

    return IconButton(
      icon: const Icon(Icons.add_circle_outline_rounded, size: 22),
      color: colors.textMuted,
      hoverColor: colors.green.withAlpha(30),
      onPressed: _trackApp,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      tooltip: context.l10n.keywordSearch_trackApp,
    );
  }
}
