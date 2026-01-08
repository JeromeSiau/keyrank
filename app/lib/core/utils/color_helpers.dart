import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Get color based on rating value (0-5 scale)
Color getRatingColor(double? rating) {
  if (rating == null) return AppColors.textMuted;
  if (rating >= 4.5) return AppColors.green;
  if (rating >= 4.0) return AppColors.yellow;
  if (rating >= 3.0) return AppColors.orange;
  return AppColors.red;
}

/// Get color based on ranking position
Color getRankingColor(int? position) {
  if (position == null) return AppColors.textMuted;
  if (position <= 10) return AppColors.green;
  if (position <= 50) return AppColors.yellow;
  if (position <= 100) return AppColors.orange;
  return AppColors.red;
}

/// Get color for position change (positive = good, negative = bad)
Color getChangeColor(int change) {
  if (change > 0) return AppColors.green;
  if (change < 0) return AppColors.red;
  return AppColors.textMuted;
}
