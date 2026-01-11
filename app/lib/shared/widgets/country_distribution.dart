import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A country entry for the distribution list.
class CountryData {
  final String code; // ISO country code, e.g., 'us'
  final String name;
  final double percent;
  final String? flagEmoji;

  const CountryData({
    required this.code,
    required this.name,
    required this.percent,
    this.flagEmoji,
  });
}

/// A list showing distribution by country with flag, name, bar, and percentage.
class CountryDistribution extends StatelessWidget {
  final List<CountryData> countries;
  final int maxItems;
  final double barHeight;

  const CountryDistribution({
    super.key,
    required this.countries,
    this.maxItems = 5,
    this.barHeight = 6,
  });

  @override
  Widget build(BuildContext context) {
    final displayCountries = countries.take(maxItems).toList();
    final maxPercent = displayCountries.isNotEmpty
        ? displayCountries.map((c) => c.percent).reduce((a, b) => a > b ? a : b)
        : 100.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: displayCountries.asMap().entries.map((entry) {
        final index = entry.key;
        final country = entry.value;
        return Padding(
          padding: EdgeInsets.only(bottom: index < displayCountries.length - 1 ? 12 : 0),
          child: _CountryRow(
            country: country,
            maxPercent: maxPercent,
            barHeight: barHeight,
          ),
        );
      }).toList(),
    );
  }
}

class _CountryRow extends StatelessWidget {
  final CountryData country;
  final double maxPercent;
  final double barHeight;

  const _CountryRow({
    required this.country,
    required this.maxPercent,
    required this.barHeight,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fraction = maxPercent > 0 ? country.percent / maxPercent : 0.0;

    return Row(
      children: [
        // Flag
        Text(
          country.flagEmoji ?? _getFlag(country.code),
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 8),
        // Country name
        Expanded(
          flex: 2,
          child: Text(
            country.name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: colors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),
        // Bar
        Expanded(
          flex: 3,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: colors.bgHover,
                      borderRadius: BorderRadius.circular(barHeight / 2),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    width: constraints.maxWidth * fraction,
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: colors.accent,
                      borderRadius: BorderRadius.circular(barHeight / 2),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        // Percentage
        SizedBox(
          width: 45,
          child: Text(
            '${country.percent.toStringAsFixed(1)}%',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  String _getFlag(String countryCode) {
    // Convert country code to flag emoji
    final code = countryCode.toUpperCase();
    if (code.length != 2) return '\u{1F3F3}\u{FE0F}';

    final first = code.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final second = code.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCodes([first, second]);
  }
}
