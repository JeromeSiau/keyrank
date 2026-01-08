import 'package:flutter_riverpod/flutter_riverpod.dart';

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

String getFlagForStorefront(String storefront) {
  final code = storefront.toLowerCase();
  final country = availableCountries.cast<Country?>().firstWhere(
    (c) => c?.code == code,
    orElse: () => null,
  );
  return country?.flag ?? storefront.toUpperCase();
}

Country? getCountryByCode(String? code) {
  if (code == null) return null;
  final lowerCode = code.toLowerCase();
  return availableCountries.cast<Country?>().firstWhere(
    (c) => c?.code == lowerCode,
    orElse: () => null,
  );
}
