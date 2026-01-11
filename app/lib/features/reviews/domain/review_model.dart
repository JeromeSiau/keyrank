import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_model.freezed.dart';
part 'review_model.g.dart';

@freezed
class Review with _$Review {
  const Review._();

  const factory Review({
    required int id,
    required String author,
    String? title,
    required String content,
    required int rating,
    String? version,
    required String country,
    String? sentiment,
    @JsonKey(name: 'our_response') String? ourResponse,
    @JsonKey(name: 'responded_at') DateTime? respondedAt,
    @JsonKey(name: 'reviewed_at') required DateTime reviewedAt,
    @JsonKey(name: 'can_reply') @Default(false) bool canReply,
    ReviewApp? app,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  bool get isAnswered => ourResponse != null && ourResponse!.isNotEmpty;
}

@freezed
class ReviewApp with _$ReviewApp {
  const factory ReviewApp({
    required int id,
    required String name,
    @JsonKey(name: 'icon_url') String? iconUrl,
    required String platform,
    @JsonKey(name: 'is_owned') @Default(false) bool isOwned,
  }) = _ReviewApp;

  factory ReviewApp.fromJson(Map<String, dynamic> json) =>
      _$ReviewAppFromJson(json);
}

@freezed
class PaginatedReviews with _$PaginatedReviews {
  const factory PaginatedReviews({
    required List<Review> reviews,
    required int currentPage,
    required int lastPage,
    required int perPage,
    required int total,
  }) = _PaginatedReviews;

  factory PaginatedReviews.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as List<dynamic>?) ?? [];
    final meta = (json['meta'] as Map<String, dynamic>?) ?? {};

    // Helper to parse int from either int or string
    int parseIntOrDefault(dynamic value, int defaultValue) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? defaultValue;
      return defaultValue;
    }

    return PaginatedReviews(
      reviews:
          data.map((e) => Review.fromJson(e as Map<String, dynamic>)).toList(),
      currentPage: parseIntOrDefault(meta['current_page'], 1),
      lastPage: parseIntOrDefault(meta['last_page'], 1),
      perPage: parseIntOrDefault(meta['per_page'], 20),
      total: parseIntOrDefault(meta['total'], 0),
    );
  }
}

class ReviewsResponse {
  final int appId;
  final String country;
  final List<Review> reviews;
  final int total;

  ReviewsResponse({
    required this.appId,
    required this.country,
    required this.reviews,
    required this.total,
  });

  factory ReviewsResponse.fromJson(Map<String, dynamic> json) {
    return ReviewsResponse(
      appId: json['app_id'] as int,
      country: json['country'] as String,
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] as int? ?? 0,
    );
  }
}

class CountryReviewSummary {
  final String country;
  final int reviewCount;
  final double avgRating;
  final String? latestReview;

  CountryReviewSummary({
    required this.country,
    required this.reviewCount,
    required this.avgRating,
    this.latestReview,
  });

  factory CountryReviewSummary.fromJson(Map<String, dynamic> json) {
    return CountryReviewSummary(
      country: json['country'] as String,
      reviewCount: json['review_count'] as int? ?? 0,
      avgRating: (json['avg_rating'] as num?)?.toDouble() ?? 0.0,
      latestReview: json['latest_review'] as String?,
    );
  }
}
