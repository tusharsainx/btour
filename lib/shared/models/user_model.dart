// import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String? phoneNumber;
  final String name;
  final String? photoUrl;
  final String role; // tourist, guide, admin
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final List<String> wishlist;
  final Map<String, dynamic>? preferences;
  final bool emailVerified;
  final bool phoneVerified;
  final bool biometricEnabled;

  UserModel({
    required this.id,
    required this.email,
    this.phoneNumber,
    required this.name,
    this.photoUrl,
    this.role = 'tourist',
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
    this.wishlist = const [],
    this.preferences,
    this.emailVerified = false,
    this.phoneVerified = false,
    this.biometricEnabled = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String?,
      role: json['role'] as String? ?? 'tourist',
      createdAt: json['createdAt'] is String
          ? DateTime.parse(json['createdAt'])
          : (json['createdAt'] as dynamic)
                .toDate(), // Handle legacy Timestamp if needed
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] is String
                ? DateTime.parse(json['updatedAt'])
                : (json['updatedAt'] as dynamic).toDate())
          : null,
      isActive: json['isActive'] as bool? ?? true,
      wishlist: List<String>.from(json['wishlist'] ?? []),
      preferences: json['preferences'] != null
          ? Map<String, dynamic>.from(json['preferences'] as Map)
          : null,
      emailVerified: json['emailVerified'] as bool? ?? false,
      phoneVerified: json['phoneVerified'] as bool? ?? false,
      biometricEnabled: json['biometricEnabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phoneNumber': phoneNumber,
      'name': name,
      'photoUrl': photoUrl,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
      'wishlist': wishlist,
      'preferences': preferences,
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
      'biometricEnabled': biometricEnabled,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? phoneNumber,
    String? name,
    String? photoUrl,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    List<String>? wishlist,
    Map<String, dynamic>? preferences,
    bool? emailVerified,
    bool? phoneVerified,
    bool? biometricEnabled,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      wishlist: wishlist ?? this.wishlist,
      preferences: preferences ?? this.preferences,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    );
  }

  bool get isGuide => role == 'guide';
  bool get isAdmin => role == 'admin';
  bool get isTourist => role == 'tourist';
}
