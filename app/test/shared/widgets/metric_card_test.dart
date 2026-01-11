// app/test/shared/widgets/metric_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keyrank/shared/widgets/metric_card.dart';
import 'package:keyrank/core/theme/app_theme.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(body: child),
    );
  }

  group('MetricCard', () {
    testWidgets('displays label and value', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const MetricCard(label: 'Downloads', value: '36.7K'),
      ));

      expect(find.text('Downloads'), findsOneWidget);
      expect(find.text('36.7K'), findsOneWidget);
    });

    testWidgets('displays positive trend with green color', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const MetricCard(label: 'Downloads', value: '36.7K', change: 29.0),
      ));

      expect(find.text('+29%'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
    });

    testWidgets('displays negative trend with red color', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const MetricCard(label: 'Downloads', value: '36.7K', change: -15.0),
      ));

      expect(find.text('-15%'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(buildTestWidget(
        MetricCard(
          label: 'Downloads',
          value: '36.7K',
          onTap: () => tapped = true,
        ),
      ));

      await tester.tap(find.byType(MetricCard));
      expect(tapped, isTrue);
    });
  });

  group('TrendBadge', () {
    testWidgets('displays zero change correctly', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const TrendBadge(change: 0),
      ));

      expect(find.text('0%'), findsOneWidget);
    });
  });
}
