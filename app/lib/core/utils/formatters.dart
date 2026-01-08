import 'package:intl/intl.dart';

/// Format large numbers with K/M suffixes
String formatCount(num? count) {
  if (count == null) return '-';
  if (count >= 1000000) {
    return '${(count / 1000000).toStringAsFixed(1)}M';
  }
  if (count >= 1000) {
    return '${(count / 1000).toStringAsFixed(1)}K';
  }
  return count.toString();
}

/// Format date as "Jan 8, 2026"
String formatDate(DateTime date) {
  return DateFormat('MMM d, y').format(date);
}

/// Format date as "08/01/2026"
String formatDateShort(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

/// Safely parse a double from dynamic value
double? safeParseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

/// Safely parse an int from dynamic value
int? safeParseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
