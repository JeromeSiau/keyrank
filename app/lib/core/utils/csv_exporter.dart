import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/keywords/domain/keyword_model.dart';
import '../../features/reviews/domain/review_model.dart';
import '../../features/analytics/domain/analytics_summary_model.dart';

/// Utility class for exporting data to CSV format
class CsvExporter {
  /// Export keywords to CSV
  static Future<ExportResult> exportKeywords({
    required List<Keyword> keywords,
    required String appName,
    required ExportOptions options,
  }) async {
    final csv = StringBuffer();

    // Build header based on selected columns
    final headers = <String>[];
    if (options.includeKeyword) headers.add('Keyword');
    if (options.includePosition) headers.add('Position');
    if (options.includeChange) headers.add('Change');
    if (options.includePopularity) headers.add('Popularity');
    if (options.includeDifficulty) headers.add('Difficulty');
    if (options.includeTags) headers.add('Tags');
    if (options.includeNotes) headers.add('Notes');
    if (options.includeTrackedSince) headers.add('Tracked Since');

    csv.writeln(headers.join(','));

    // Data rows
    for (final kw in keywords) {
      final row = <String>[];
      if (options.includeKeyword) row.add(_escapeCsv(kw.keyword));
      if (options.includePosition) row.add(kw.position?.toString() ?? '-');
      if (options.includeChange) row.add(_formatChange(kw.change));
      if (options.includePopularity) row.add(kw.popularity?.toString() ?? '-');
      if (options.includeDifficulty) {
        row.add(kw.difficulty != null ? '${kw.difficulty} (${kw.difficultyLabel ?? ''})' : '-');
      }
      if (options.includeTags) {
        row.add(_escapeCsv(kw.tags.map((t) => t.name).join('; ')));
      }
      if (options.includeNotes) row.add(_escapeCsv(kw.note ?? ''));
      if (options.includeTrackedSince) {
        row.add(kw.trackedSince != null
            ? DateFormat('yyyy-MM-dd').format(kw.trackedSince!)
            : '-');
      }

      csv.writeln(row.join(','));
    }

    final filename = _generateFilename(appName, 'keywords');
    return _saveAndShare(csv.toString(), filename);
  }

  /// Export reviews to CSV
  static Future<ExportResult> exportReviews({
    required List<Review> reviews,
    required String appName,
    required ReviewExportOptions options,
  }) async {
    final csv = StringBuffer();

    // Build header
    final headers = <String>[];
    if (options.includeDate) headers.add('Date');
    if (options.includeRating) headers.add('Rating');
    if (options.includeAuthor) headers.add('Author');
    if (options.includeTitle) headers.add('Title');
    if (options.includeContent) headers.add('Content');
    if (options.includeCountry) headers.add('Country');
    if (options.includeVersion) headers.add('Version');
    if (options.includeSentiment) headers.add('Sentiment');
    if (options.includeResponse) headers.add('Our Response');
    if (options.includeResponseDate) headers.add('Response Date');

    csv.writeln(headers.join(','));

    // Data rows
    for (final review in reviews) {
      final row = <String>[];
      if (options.includeDate) {
        row.add(DateFormat('yyyy-MM-dd HH:mm').format(review.reviewedAt));
      }
      if (options.includeRating) row.add(review.rating.toString());
      if (options.includeAuthor) row.add(_escapeCsv(review.author));
      if (options.includeTitle) row.add(_escapeCsv(review.title ?? ''));
      if (options.includeContent) row.add(_escapeCsv(review.content));
      if (options.includeCountry) row.add(review.country);
      if (options.includeVersion) row.add(review.version ?? '-');
      if (options.includeSentiment) row.add(review.sentiment ?? '-');
      if (options.includeResponse) row.add(_escapeCsv(review.ourResponse ?? ''));
      if (options.includeResponseDate) {
        row.add(review.respondedAt != null
            ? DateFormat('yyyy-MM-dd HH:mm').format(review.respondedAt!)
            : '-');
      }

      csv.writeln(row.join(','));
    }

    final filename = _generateFilename(appName, 'reviews');
    return _saveAndShare(csv.toString(), filename);
  }

  /// Export analytics summary to CSV
  static Future<ExportResult> exportAnalytics({
    required AnalyticsSummary summary,
    required List<DownloadsDataPoint> downloads,
    required List<RevenueDataPoint> revenue,
    required List<CountryAnalytics> countries,
    required String appName,
    required String period,
  }) async {
    final csv = StringBuffer();

    // Summary section
    csv.writeln('# Analytics Summary - $appName');
    csv.writeln('Period,$period');
    csv.writeln('');
    csv.writeln('Metric,Value,Change %');
    csv.writeln('Downloads,${summary.totalDownloads},${_formatPercent(summary.downloadsChangePct)}');
    csv.writeln('Revenue,\$${summary.totalRevenue.toStringAsFixed(2)},${_formatPercent(summary.revenueChangePct)}');
    csv.writeln('Proceeds,\$${summary.totalProceeds.toStringAsFixed(2)},-');
    csv.writeln('Active Subscribers,${summary.activeSubscribers},${_formatPercent(summary.subscribersChangePct)}');
    csv.writeln('');

    // Downloads over time
    if (downloads.isNotEmpty) {
      csv.writeln('# Downloads Over Time');
      csv.writeln('Date,Downloads');
      for (final dp in downloads) {
        csv.writeln('${dp.date},${dp.downloads}');
      }
      csv.writeln('');
    }

    // Revenue over time
    if (revenue.isNotEmpty) {
      csv.writeln('# Revenue Over Time');
      csv.writeln('Date,Revenue');
      for (final rp in revenue) {
        csv.writeln('${rp.date},${rp.revenue.toStringAsFixed(2)}');
      }
      csv.writeln('');
    }

    // By country
    if (countries.isNotEmpty) {
      csv.writeln('# By Country');
      csv.writeln('Country,Downloads,Revenue');
      for (final c in countries) {
        csv.writeln('${c.countryCode},${c.downloads},${c.revenue.toStringAsFixed(2)}');
      }
    }

    final filename = _generateFilename(appName, 'analytics');
    return _saveAndShare(csv.toString(), filename);
  }

  /// Escape special characters for CSV
  static String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n') || value.contains('\r')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  static String _formatChange(int? change) {
    if (change == null) return '-';
    if (change > 0) return '+$change';
    return change.toString();
  }

  static String _formatPercent(double? value) {
    if (value == null) return '-';
    final sign = value >= 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(1)}%';
  }

  static String _generateFilename(String appName, String type) {
    final sanitizedName = appName.replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(' ', '_');
    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return '${sanitizedName}_${type}_$date.csv';
  }

  static Future<ExportResult> _saveAndShare(String content, String filename) async {
    try {
      if (kIsWeb) {
        // Web: trigger download via browser
        return ExportResult(
          success: true,
          filename: filename,
          content: content,
          isWeb: true,
        );
      } else {
        // Desktop/Mobile: save to Downloads directory
        final directory = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$filename');
        await file.writeAsString(content);

        return ExportResult(
          success: true,
          filename: filename,
          filePath: file.path,
        );
      }
    } catch (e) {
      return ExportResult(
        success: false,
        filename: filename,
        error: e.toString(),
      );
    }
  }
}

/// Result of an export operation
class ExportResult {
  final bool success;
  final String filename;
  final String? filePath;
  final String? content;
  final String? error;
  final bool isWeb;

  ExportResult({
    required this.success,
    required this.filename,
    this.filePath,
    this.content,
    this.error,
    this.isWeb = false,
  });
}

/// Options for keyword export
class ExportOptions {
  final bool includeKeyword;
  final bool includePosition;
  final bool includeChange;
  final bool includePopularity;
  final bool includeDifficulty;
  final bool includeTags;
  final bool includeNotes;
  final bool includeTrackedSince;

  const ExportOptions({
    this.includeKeyword = true,
    this.includePosition = true,
    this.includeChange = true,
    this.includePopularity = true,
    this.includeDifficulty = true,
    this.includeTags = false,
    this.includeNotes = false,
    this.includeTrackedSince = false,
  });

  ExportOptions copyWith({
    bool? includeKeyword,
    bool? includePosition,
    bool? includeChange,
    bool? includePopularity,
    bool? includeDifficulty,
    bool? includeTags,
    bool? includeNotes,
    bool? includeTrackedSince,
  }) {
    return ExportOptions(
      includeKeyword: includeKeyword ?? this.includeKeyword,
      includePosition: includePosition ?? this.includePosition,
      includeChange: includeChange ?? this.includeChange,
      includePopularity: includePopularity ?? this.includePopularity,
      includeDifficulty: includeDifficulty ?? this.includeDifficulty,
      includeTags: includeTags ?? this.includeTags,
      includeNotes: includeNotes ?? this.includeNotes,
      includeTrackedSince: includeTrackedSince ?? this.includeTrackedSince,
    );
  }
}

/// Options for review export
class ReviewExportOptions {
  final bool includeDate;
  final bool includeRating;
  final bool includeAuthor;
  final bool includeTitle;
  final bool includeContent;
  final bool includeCountry;
  final bool includeVersion;
  final bool includeSentiment;
  final bool includeResponse;
  final bool includeResponseDate;

  const ReviewExportOptions({
    this.includeDate = true,
    this.includeRating = true,
    this.includeAuthor = true,
    this.includeTitle = true,
    this.includeContent = true,
    this.includeCountry = true,
    this.includeVersion = true,
    this.includeSentiment = true,
    this.includeResponse = false,
    this.includeResponseDate = false,
  });

  ReviewExportOptions copyWith({
    bool? includeDate,
    bool? includeRating,
    bool? includeAuthor,
    bool? includeTitle,
    bool? includeContent,
    bool? includeCountry,
    bool? includeVersion,
    bool? includeSentiment,
    bool? includeResponse,
    bool? includeResponseDate,
  }) {
    return ReviewExportOptions(
      includeDate: includeDate ?? this.includeDate,
      includeRating: includeRating ?? this.includeRating,
      includeAuthor: includeAuthor ?? this.includeAuthor,
      includeTitle: includeTitle ?? this.includeTitle,
      includeContent: includeContent ?? this.includeContent,
      includeCountry: includeCountry ?? this.includeCountry,
      includeVersion: includeVersion ?? this.includeVersion,
      includeSentiment: includeSentiment ?? this.includeSentiment,
      includeResponse: includeResponse ?? this.includeResponse,
      includeResponseDate: includeResponseDate ?? this.includeResponseDate,
    );
  }
}
