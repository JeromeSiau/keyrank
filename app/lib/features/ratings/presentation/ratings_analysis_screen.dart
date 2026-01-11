import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class RatingsAnalysisScreen extends StatelessWidget {
  const RatingsAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      body: Center(
        child: Text(
          'Ratings Analysis - Coming Soon',
          style: TextStyle(color: colors.textPrimary),
        ),
      ),
    );
  }
}
