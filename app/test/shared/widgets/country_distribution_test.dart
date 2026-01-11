import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keyrank/shared/widgets/country_distribution.dart';
import 'package:keyrank/core/theme/app_theme.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(body: Center(child: SizedBox(width: 300, child: child))),
    );
  }

  final testCountries = [
    const CountryData(code: 'us', name: 'United States', percent: 24.3),
    const CountryData(code: 'au', name: 'Australia', percent: 8.9),
    const CountryData(code: 'ca', name: 'Canada', percent: 8.7),
    const CountryData(code: 'gb', name: 'United Kingdom', percent: 8.7),
    const CountryData(code: 'fr', name: 'France', percent: 8.5),
  ];

  group('CountryDistribution', () {
    testWidgets('displays all countries up to maxItems', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        CountryDistribution(countries: testCountries),
      ));

      expect(find.text('United States'), findsOneWidget);
      expect(find.text('Australia'), findsOneWidget);
      expect(find.text('24.3%'), findsOneWidget);
    });

    testWidgets('respects maxItems limit', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        CountryDistribution(countries: testCountries, maxItems: 3),
      ));

      expect(find.text('United States'), findsOneWidget);
      expect(find.text('Canada'), findsOneWidget);
      expect(find.text('United Kingdom'), findsNothing);
    });

    testWidgets('handles empty list', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const CountryDistribution(countries: []),
      ));

      expect(find.byType(CountryDistribution), findsOneWidget);
    });
  });
}
