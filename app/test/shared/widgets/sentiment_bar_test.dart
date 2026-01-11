import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keyrank/shared/widgets/sentiment_bar.dart';
import 'package:keyrank/core/theme/app_theme.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(body: Center(child: SizedBox(width: 200, child: child))),
    );
  }

  group('SentimentBar', () {
    testWidgets('displays correct percentages', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const SentimentBar(positivePercent: 89),
      ));

      expect(find.text('89%'), findsOneWidget);
      expect(find.text('11%'), findsOneWidget);
    });

    testWidgets('displays tooltip text when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const SentimentBar(
          positivePercent: 89,
          tooltipText: 'Based on 1,847 reviews',
        ),
      ));

      expect(find.text('Based on 1,847 reviews'), findsOneWidget);
    });

    testWidgets('hides labels when showLabels is false', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const SentimentBar(positivePercent: 89, showLabels: false),
      ));

      expect(find.text('89%'), findsNothing);
    });
  });

  group('SentimentIndicator', () {
    testWidgets('shows positive sentiment correctly', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const SentimentIndicator(positivePercent: 75),
      ));

      expect(find.text('75%'), findsOneWidget);
    });
  });
}
