import 'tour_color.dart';

/// 리뷰 모델
class Review {
  final String reviewId;
  final String bookingId;
  final String tourId;
  final String guestId;
  final TourColor selectedColor;  // 게스트가 선택한 컬러
  final double rating;  // 별점 (1~5)
  final String comment;  // 리뷰 텍스트
  final List<String> tags;  // #친절해요 #설명이알차요 등
  final DateTime createdAt;

  Review({
    required this.reviewId,
    required this.bookingId,
    required this.tourId,
    required this.guestId,
    required this.selectedColor,
    required this.rating,
    this.comment = '',
    this.tags = const [],
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'reviewId': reviewId,
        'bookingId': bookingId,
        'tourId': tourId,
        'guestId': guestId,
        'selectedColor': selectedColor.name,
        'rating': rating,
        'comment': comment,
        'tags': tags,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        reviewId: json['reviewId'] as String,
        bookingId: json['bookingId'] as String,
        tourId: json['tourId'] as String,
        guestId: json['guestId'] as String,
        selectedColor: TourColor.values.firstWhere(
          (e) => e.name == json['selectedColor'],
        ),
        rating: (json['rating'] as num).toDouble(),
        comment: json['comment'] as String? ?? '',
        tags: (json['tags'] as List?)?.cast<String>() ?? [],
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  Review copyWith({
    String? reviewId,
    String? bookingId,
    String? tourId,
    String? guestId,
    TourColor? selectedColor,
    double? rating,
    String? comment,
    List<String>? tags,
    DateTime? createdAt,
  }) {
    return Review(
      reviewId: reviewId ?? this.reviewId,
      bookingId: bookingId ?? this.bookingId,
      tourId: tourId ?? this.tourId,
      guestId: guestId ?? this.guestId,
      selectedColor: selectedColor ?? this.selectedColor,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
