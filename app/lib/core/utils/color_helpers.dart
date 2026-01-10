import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Get color based on rating value (0-5 scale)
Color getRatingColor(double? rating, AppColorsExtension colors) {
  if (rating == null) return colors.textMuted;
  if (rating >= 4.5) return colors.green;
  if (rating >= 4.0) return colors.yellow;
  if (rating >= 3.0) return colors.orange;
  return colors.red;
}

/// Get color based on ranking position
Color getRankingColor(int? position, AppColorsExtension colors) {
  if (position == null) return colors.textMuted;
  if (position <= 10) return colors.green;
  if (position <= 50) return colors.yellow;
  if (position <= 100) return colors.orange;
  return colors.red;
}

/// Get color for position change (positive = good, negative = bad)
Color getChangeColor(int change, AppColorsExtension colors) {
  if (change > 0) return colors.green;
  if (change < 0) return colors.red;
  return colors.textMuted;
}
