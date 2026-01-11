import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class CompetitorsScreen extends StatelessWidget {
  const CompetitorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      body: Center(
        child: Text(
          'Competitors - Coming Soon',
          style: TextStyle(color: colors.textPrimary),
        ),
      ),
    );
  }
}
