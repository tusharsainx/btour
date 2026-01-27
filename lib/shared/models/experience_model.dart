import 'package:cloud_firestore/cloud_firestore.dart';

class Experience {
  final String id;
  final String title;
  final String description;
  final String shortDescription;
  final String category;
  final String location;
  final double latitude;
  final double longitude;
  final double price;
  final int duration; // in hours
  final int maxGroupSize;
  final List<String> images;
  final String? videoUrl;
  final String guideId;
  final String guideName;
  final String? guidePhotoUrl;
  final double rating;
  final int reviewCount;
  final List<String> highlights;
  final List<String> includes;
  final List<String> excludes;
  final List<String> requirements;
  final List<DateTime> availableDates;
  final Map<String, String>? schedule;
  final bool isActive;
  final bool isFeatured;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? metadata;

  Experience({
    required this.id,
    required this.title,
    required this.description,
    required this.shortDescription,
    required this.category,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.price,
    required this.duration,
    required this.maxGroupSize,
    required this.images,
    this.videoUrl,
    required this.guideId,
    required this.guideName,
    this.guidePhotoUrl,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.highlights = const [],
    this.includes = const [],
    this.excludes = const [],
    this.requirements = const [],
    this.availableDates = const [],
    this.schedule,
    this.isActive = true,
    this.isFeatured = false,
    required this.createdAt,
    this.updatedAt,
    this.metadata,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      shortDescription: json['shortDescription'] as String? ?? '',
      category: json['category'] as String,
      location: json['location'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      duration: json['duration'] as int,
      maxGroupSize: json['maxGroupSize'] as int? ?? 10,
      images: List<String>.from(json['images'] ?? []),
      videoUrl: json['videoUrl'] as String?,
      guideId: json['guideId'] as String,
      guideName: json['guideName'] as String,
      guidePhotoUrl: json['guidePhotoUrl'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      highlights: List<String>.from(json['highlights'] ?? []),
      includes: List<String>.from(json['includes'] ?? []),
      excludes: List<String>.from(json['excludes'] ?? []),
      requirements: List<String>.from(json['requirements'] ?? []),
      availableDates: (json['availableDates'] as List?)
              ?.map((e) => (e as Timestamp).toDate())
              .toList() ??
          [],
      schedule: json['schedule'] != null
          ? Map<String, String>.from(json['schedule'])
          : null,
      isActive: json['isActive'] as bool? ?? true,
      isFeatured: json['isFeatured'] as bool? ?? false,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'shortDescription': shortDescription,
      'category': category,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'price': price,
      'duration': duration,
      'maxGroupSize': maxGroupSize,
      'images': images,
      'videoUrl': videoUrl,
      'guideId': guideId,
      'guideName': guideName,
      'guidePhotoUrl': guidePhotoUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'highlights': highlights,
      'includes': includes,
      'excludes': excludes,
      'requirements': requirements,
      'availableDates':
          availableDates.map((e) => Timestamp.fromDate(e)).toList(),
      'schedule': schedule,
      'isActive': isActive,
      'isFeatured': isFeatured,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'metadata': metadata,
    };
  }

  Experience copyWith({
    String? id,
    String? title,
    String? description,
    String? shortDescription,
    String? category,
    String? location,
    double? latitude,
    double? longitude,
    double? price,
    int? duration,
    int? maxGroupSize,
    List<String>? images,
    String? videoUrl,
    String? guideId,
    String? guideName,
    String? guidePhotoUrl,
    double? rating,
    int? reviewCount,
    List<String>? highlights,
    List<String>? includes,
    List<String>? excludes,
    List<String>? requirements,
    List<DateTime>? availableDates,
    Map<String, String>? schedule,
    bool? isActive,
    bool? isFeatured,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return Experience(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      category: category ?? this.category,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      maxGroupSize: maxGroupSize ?? this.maxGroupSize,
      images: images ?? this.images,
      videoUrl: videoUrl ?? this.videoUrl,
      guideId: guideId ?? this.guideId,
      guideName: guideName ?? this.guideName,
      guidePhotoUrl: guidePhotoUrl ?? this.guidePhotoUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      highlights: highlights ?? this.highlights,
      includes: includes ?? this.includes,
      excludes: excludes ?? this.excludes,
      requirements: requirements ?? this.requirements,
      availableDates: availableDates ?? this.availableDates,
      schedule: schedule ?? this.schedule,
      isActive: isActive ?? this.isActive,
      isFeatured: isFeatured ?? this.isFeatured,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  String get formattedPrice => '₹${price.toStringAsFixed(0)}';
  String get formattedDuration =>
      duration >= 24 ? '${(duration / 24).floor()} days' : '$duration hours';
  String get primaryImage => images.isNotEmpty ? images.first : '';
}
