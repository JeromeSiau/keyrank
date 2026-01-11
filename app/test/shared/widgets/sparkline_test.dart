import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keyrank/shared/widgets/sparkline.dart';
import 'package:keyrank/core/theme/app_theme.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(body: child),
    );
  }

  group('Sparkline', () {
    testWidgets('renders with valid data', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Sparkline(data: [1, 2, 3, 4, 5]),
      ));

      expect(find.byType(Sparkline), findsOneWidget);
      expect(find.descendant(
        of: find.byType(Sparkline),
        matching: find.byType(CustomPaint),
      ), findsOneWidget);
    });

    testWidgets('handles empty data gracefully', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Sparkline(data: []),
      ));

      expect(find.byType(Sparkline), findsOneWidget);
    });

    testWidgets('handles single data point', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Sparkline(data: [5]),
      ));

      expect(find.byType(Sparkline), findsOneWidget);
    });

    testWidgets('respects custom dimensions', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        const Sparkline(data: [1, 2, 3], width: 120, height: 32),
      ));

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, 120);
      expect(sizedBox.height, 32);
    });
  });
}
