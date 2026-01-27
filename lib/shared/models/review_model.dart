import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String experienceId;
  final String userId;
  final String userName;
  final String? userPhotoUrl;
  final String bookingId;
  final double rating;
  final String? title;
  final String comment;
  final List<String>? photos;
  final String? guideResponse;
  final DateTime? guideResponseDate;
  final bool isVerified;
  final int helpfulCount;
  final List<String> helpfulBy;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Review({
    required this.id,
    required this.experienceId,
    required this.userId,
    required this.userName,
    this.userPhotoUrl,
    required this.bookingId,
    required this.rating,
    this.title,
    required this.comment,
    this.photos,
    this.guideResponse,
    this.guideResponseDate,
    this.isVerified = false,
    this.helpfulCount = 0,
    this.helpfulBy = const [],
    required this.createdAt,
    this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      experienceId: json['experienceId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userPhotoUrl: json['userPhotoUrl'] as String?,
      bookingId: json['bookingId'] as String,
      rating: (json['rating'] as num).toDouble(),
      title: json['title'] as String?,
      comment: json['comment'] as String,
      photos: json['photos'] != null ? List<String>.from(json['photos']) : null,
      guideResponse: json['guideResponse'] as String?,
      guideResponseDate: json['guideResponseDate'] != null
          ? (json['guideResponseDate'] as Timestamp).toDate()
          : null,
      isVerified: json['isVerified'] as bool? ?? false,
      helpfulCount: json['helpfulCount'] as int? ?? 0,
      helpfulBy: List<String>.from(json['helpfulBy'] ?? []),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'experienceId': experienceId,
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'bookingId': bookingId,
      'rating': rating,
      'title': title,
      'comment': comment,
      'photos': photos,
      'guideResponse': guideResponse,
      'guideResponseDate': guideResponseDate != null
          ? Timestamp.fromDate(guideResponseDate!)
          : null,
      'isVerified': isVerified,
      'helpfulCount': helpfulCount,
      'helpfulBy': helpfulBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  Review copyWith({
    String? id,
    String? experienceId,
    String? userId,
    String? userName,
    String? userPhotoUrl,
    String? bookingId,
    double? rating,
    String? title,
    String? comment,
    List<String>? photos,
    String? guideResponse,
    DateTime? guideResponseDate,
    bool? isVerified,
    int? helpfulCount,
    List<String>? helpfulBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Review(
      id: id ?? this.id,
      experienceId: experienceId ?? this.experienceId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
      bookingId: bookingId ?? this.bookingId,
      rating: rating ?? this.rating,
      title: title ?? this.title,
      comment: comment ?? this.comment,
      photos: photos ?? this.photos,
      guideResponse: guideResponse ?? this.guideResponse,
      guideResponseDate: guideResponseDate ?? this.guideResponseDate,
      isVerified: isVerified ?? this.isVerified,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      helpfulBy: helpfulBy ?? this.helpfulBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
