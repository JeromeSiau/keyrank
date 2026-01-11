import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TopChartsScreen extends StatelessWidget {
  const TopChartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      body: Center(
        child: Text(
          'Top Charts - Coming Soon',
          style: TextStyle(color: colors.textPrimary),
        ),
      ),
    );
  }
}
