class SessionModel {
  final bool isLoggedIn;
  final DateTime? lastLoginTime;

  SessionModel({required this.isLoggedIn, this.lastLoginTime});

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      isLoggedIn: json['isLoggedIn'] as bool? ?? false,
      lastLoginTime: json['lastLoginTime'] != null
          ? DateTime.parse(json['lastLoginTime'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isLoggedIn': isLoggedIn,
      'lastLoginTime': lastLoginTime?.toIso8601String(),
    };
  }

  SessionModel copyWith({bool? isLoggedIn, DateTime? lastLoginTime}) {
    return SessionModel(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      lastLoginTime: lastLoginTime ?? this.lastLoginTime,
    );
  }
}
