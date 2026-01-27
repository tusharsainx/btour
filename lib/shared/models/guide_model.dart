import 'package:cloud_firestore/cloud_firestore.dart';

class Guide {
  final String id;
  final String userId;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? photoUrl;
  final String bio;
  final List<String> languages;
  final List<String> specializations;
  final String location;
  final double rating;
  final int reviewCount;
  final int totalTours;
  final int yearsOfExperience;
  final bool isVerified;
  final bool isAvailable;
  final List<String> certifications;
  final Map<String, dynamic>? availability;
  final double? hourlyRate;
  final String? governmentId;
  final bool governmentIdVerified;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Guide({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.photoUrl,
    required this.bio,
    this.languages = const ['Hindi', 'English'],
    this.specializations = const [],
    required this.location,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.totalTours = 0,
    this.yearsOfExperience = 0,
    this.isVerified = false,
    this.isAvailable = true,
    this.certifications = const [],
    this.availability,
    this.hourlyRate,
    this.governmentId,
    this.governmentIdVerified = false,
    required this.createdAt,
    this.updatedAt,
  });

  factory Guide.fromJson(Map<String, dynamic> json) {
    return Guide(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      photoUrl: json['photoUrl'] as String?,
      bio: json['bio'] as String,
      languages: List<String>.from(json['languages'] ?? ['Hindi', 'English']),
      specializations: List<String>.from(json['specializations'] ?? []),
      location: json['location'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      totalTours: json['totalTours'] as int? ?? 0,
      yearsOfExperience: json['yearsOfExperience'] as int? ?? 0,
      isVerified: json['isVerified'] as bool? ?? false,
      isAvailable: json['isAvailable'] as bool? ?? true,
      certifications: List<String>.from(json['certifications'] ?? []),
      availability: json['availability'] as Map<String, dynamic>?,
      hourlyRate: (json['hourlyRate'] as num?)?.toDouble(),
      governmentId: json['governmentId'] as String?,
      governmentIdVerified: json['governmentIdVerified'] as bool? ?? false,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'bio': bio,
      'languages': languages,
      'specializations': specializations,
      'location': location,
      'rating': rating,
      'reviewCount': reviewCount,
      'totalTours': totalTours,
      'yearsOfExperience': yearsOfExperience,
      'isVerified': isVerified,
      'isAvailable': isAvailable,
      'certifications': certifications,
      'availability': availability,
      'hourlyRate': hourlyRate,
      'governmentId': governmentId,
      'governmentIdVerified': governmentIdVerified,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  Guide copyWith({
    String? id,
    String? userId,
    String? name,
    String? email,
    String? phoneNumber,
    String? photoUrl,
    String? bio,
    List<String>? languages,
    List<String>? specializations,
    String? location,
    double? rating,
    int? reviewCount,
    int? totalTours,
    int? yearsOfExperience,
    bool? isVerified,
    bool? isAvailable,
    List<String>? certifications,
    Map<String, dynamic>? availability,
    double? hourlyRate,
    String? governmentId,
    bool? governmentIdVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Guide(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      languages: languages ?? this.languages,
      specializations: specializations ?? this.specializations,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      totalTours: totalTours ?? this.totalTours,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      isVerified: isVerified ?? this.isVerified,
      isAvailable: isAvailable ?? this.isAvailable,
      certifications: certifications ?? this.certifications,
      availability: availability ?? this.availability,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      governmentId: governmentId ?? this.governmentId,
      governmentIdVerified: governmentIdVerified ?? this.governmentIdVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get formattedLanguages => languages.join(', ');
}
