import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/providers/country_provider.dart';
import '../../core/utils/country_names.dart';
import '../../core/utils/l10n_extension.dart';

/// A compact country picker button that opens a searchable modal
class CountryPickerButton extends StatelessWidget {
  final Country selectedCountry;
  final ValueChanged<Country> onCountryChanged;
  final List<Country> countries;

  const CountryPickerButton({
    super.key,
    required this.selectedCountry,
    required this.onCountryChanged,
    required this.countries,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showCountryPicker(context),
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
              Text(selectedCountry.flag, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                selectedCountry.code.toUpperCase(),
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

  void _showCountryPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CountryPickerModal(
        countries: countries,
        selectedCountry: selectedCountry,
        onCountrySelected: onCountryChanged,
      ),
    );
  }
}

/// Modal dialog with searchable country list
class CountryPickerModal extends StatefulWidget {
  final List<Country> countries;
  final Country selectedCountry;
  final ValueChanged<Country> onCountrySelected;

  const CountryPickerModal({
    super.key,
    required this.countries,
    required this.selectedCountry,
    required this.onCountrySelected,
  });

  @override
  State<CountryPickerModal> createState() => _CountryPickerModalState();
}

class _CountryPickerModalState extends State<CountryPickerModal> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  List<Country> _filteredCountries = [];

  @override
  void initState() {
    super.initState();
    _filteredCountries = widget.countries;
    // Auto-focus search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _filterCountries(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCountries = widget.countries;
      } else {
        _filteredCountries = widget.countries.where((country) {
          final name = getLocalizedCountryName(context, country.code).toLowerCase();
          final code = country.code.toLowerCase();
          return name.contains(lowerQuery) || code.contains(lowerQuery);
        }).toList();
      }
    });
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
          maxWidth: 320,
          maxHeight: 400,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: colors.glassBorder),
                ),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                onChanged: _filterCountries,
                style: TextStyle(
                  fontSize: 14,
                  color: colors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: l10n.common_search,
                  hintStyle: TextStyle(color: colors.textMuted),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: colors.textMuted,
                  ),
                  filled: true,
                  fillColor: colors.bgActive,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppColors.radiusSmall),
                    borderSide: BorderSide(color: colors.accent, width: 1),
                  ),
                ),
              ),
            ),
            // Country list
            Flexible(
              child: _filteredCountries.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          l10n.common_noResults,
                          style: TextStyle(
                            color: colors.textMuted,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: _filteredCountries.length,
                      itemBuilder: (context, index) {
                        final country = _filteredCountries[index];
                        final isSelected = country.code == widget.selectedCountry.code;
                        final countryName = getLocalizedCountryName(context, country.code);

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              widget.onCountrySelected(country);
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              color: isSelected ? colors.bgActive : null,
                              child: Row(
                                children: [
                                  Text(
                                    country.flag,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      countryName,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: colors.textPrimary,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    country.code.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colors.textMuted,
                                    ),
                                  ),
                                  if (isSelected) ...[
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.check_rounded,
                                      size: 18,
                                      color: colors.accent,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
