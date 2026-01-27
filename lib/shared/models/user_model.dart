import 'package:cloud_firestore/cloud_firestore.dart';

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
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String?,
      role: json['role'] as String? ?? 'tourist',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
      isActive: json['isActive'] as bool? ?? true,
      wishlist: List<String>.from(json['wishlist'] ?? []),
      preferences: json['preferences'] as Map<String, dynamic>?,
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
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'isActive': isActive,
      'wishlist': wishlist,
      'preferences': preferences,
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
    );
  }

  bool get isGuide => role == 'guide';
  bool get isAdmin => role == 'admin';
  bool get isTourist => role == 'tourist';
}
