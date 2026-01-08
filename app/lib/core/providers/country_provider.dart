import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import '../constants/api_constants.dart';

class Country {
  final String code;
  final String name;
  final String flag;

  const Country({required this.code, required this.name, required this.flag});
}

const List<Country> availableCountries = [
  Country(code: 'us', name: 'États-Unis', flag: '🇺🇸'),
  Country(code: 'fr', name: 'France', flag: '🇫🇷'),
  Country(code: 'gb', name: 'Royaume-Uni', flag: '🇬🇧'),
  Country(code: 'de', name: 'Allemagne', flag: '🇩🇪'),
  Country(code: 'es', name: 'Espagne', flag: '🇪🇸'),
  Country(code: 'it', name: 'Italie', flag: '🇮🇹'),
  Country(code: 'ca', name: 'Canada', flag: '🇨🇦'),
  Country(code: 'au', name: 'Australie', flag: '🇦🇺'),
  Country(code: 'jp', name: 'Japon', flag: '🇯🇵'),
  Country(code: 'kr', name: 'Corée du Sud', flag: '🇰🇷'),
  Country(code: 'cn', name: 'Chine', flag: '🇨🇳'),
  Country(code: 'br', name: 'Brésil', flag: '🇧🇷'),
  Country(code: 'mx', name: 'Mexique', flag: '🇲🇽'),
  Country(code: 'nl', name: 'Pays-Bas', flag: '🇳🇱'),
  Country(code: 'be', name: 'Belgique', flag: '🇧🇪'),
  Country(code: 'ch', name: 'Suisse', flag: '🇨🇭'),
];

final selectedCountryProvider = StateProvider<Country>((ref) {
  return availableCountries.firstWhere((c) => c.code == 'us');
});

final countriesProvider = FutureProvider<List<Country>>((ref) async {
  final dio = ref.watch(dioProvider);
  try {
    final response = await dio.get(ApiConstants.countries);
    final data = response.data['data'] as Map<String, dynamic>;
    return data.entries
        .map((entry) => Country(
              code: entry.key.toLowerCase(),
              name: entry.value as String,
              flag: _flagFromCountryCode(entry.key),
            ))
        .toList();
  } catch (_) {
    return availableCountries;
  }
});

String getFlagForStorefront(String storefront) {
  final code = storefront.toLowerCase();
  final country = availableCountries.cast<Country?>().firstWhere(
    (c) => c?.code == code,
    orElse: () => null,
  );
  return country?.flag ?? _flagFromCountryCode(code);
}

Country? getCountryByCode(String? code) {
  if (code == null) return null;
  final lowerCode = code.toLowerCase();
  final match = availableCountries.cast<Country?>().firstWhere(
    (c) => c?.code == lowerCode,
    orElse: () => null,
  );
  if (match != null) return match;

  return Country(
    code: lowerCode,
    name: code.toUpperCase(),
    flag: _flagFromCountryCode(lowerCode),
  );
}

String _flagFromCountryCode(String code) {
  if (code.length != 2) {
    return code.toUpperCase();
  }
  final upper = code.toUpperCase();
  final first = upper.codeUnitAt(0) - 0x41 + 0x1F1E6;
  final second = upper.codeUnitAt(1) - 0x41 + 0x1F1E6;
  return String.fromCharCodes([first, second]);
}
