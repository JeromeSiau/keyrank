import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keyrank/shared/widgets/star_histogram.dart';
import 'package:keyrank/core/theme/app_theme.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(body: Center(child: SizedBox(width: 300, child: child))),
    );
  }

  group('StarHistogram', () {
    testWidgets('renders all 5 bars', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const StarHistogram(
          fiveStars: 9300000,
          fourStars: 965000,
          threeStars: 389000,
          twoStars: 156000,
          oneStar: 539000,
        ),
      ));

      // Should have 5 rows (one for each star level)
      expect(find.byIcon(Icons.star), findsWidgets);
    });

    testWidgets('formats large numbers correctly', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const StarHistogram(
          fiveStars: 9300000,
          fourStars: 965000,
          threeStars: 389000,
          twoStars: 156000,
          oneStar: 539000,
        ),
      ));

      expect(find.text('9.3M'), findsOneWidget);
      expect(find.text('965.0K'), findsOneWidget);
    });

    testWidgets('handles zero values', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const StarHistogram(
          fiveStars: 100,
          fourStars: 0,
          threeStars: 0,
          twoStars: 0,
          oneStar: 0,
        ),
      ));

      expect(find.byType(StarHistogram), findsOneWidget);
    });
  });

  group('RatingSummary', () {
    testWidgets('displays rating and count', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const RatingSummary(averageRating: 4.61, totalRatings: 11400000),
      ));

      expect(find.text('4.61'), findsOneWidget);
      expect(find.text('11.4M Ratings'), findsOneWidget);
    });
  });
}
