class Review {
  final int id;
  final String author;
  final String? title;
  final String content;
  final int rating;
  final String? version;
  final DateTime reviewedAt;

  Review({
    required this.id,
    required this.author,
    this.title,
    required this.content,
    required this.rating,
    this.version,
    required this.reviewedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as int,
      author: json['author'] as String,
      title: json['title'] as String?,
      content: json['content'] as String? ?? '',
      rating: json['rating'] as int,
      version: json['version'] as String?,
      reviewedAt: DateTime.parse(json['reviewed_at'] as String),
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
