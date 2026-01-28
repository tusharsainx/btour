/// Model representing a traveler's information
class TravelerInfo {
  final String name;
  final int age;
  final String gender;
  final String? idType;
  final String? idNumber;

  TravelerInfo({
    required this.name,
    required this.age,
    required this.gender,
    this.idType,
    this.idNumber,
  });

  factory TravelerInfo.fromJson(Map<String, dynamic> json) {
    return TravelerInfo(
      name: json['name'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
      idType: json['idType'] as String?,
      idNumber: json['idNumber'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'idType': idType,
      'idNumber': idNumber,
    };
  }

  TravelerInfo copyWith({
    String? name,
    int? age,
    String? gender,
    String? idType,
    String? idNumber,
  }) {
    return TravelerInfo(
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      idType: idType ?? this.idType,
      idNumber: idNumber ?? this.idNumber,
    );
  }

  /// Returns age category string
  String get ageCategory {
    if (age < 5) return 'Infant';
    if (age < 12) return 'Child';
    if (age < 60) return 'Adult';
    return 'Senior';
  }

  /// Check if traveler info is valid
  bool get isValid => name.isNotEmpty && age > 0 && gender.isNotEmpty;
}
