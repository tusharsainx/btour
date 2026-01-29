class Booking {
  final String id;
  final String experienceId;
  final String experienceTitle;
  final String experienceImage;
  final String userId;
  final String userName;
  final String userEmail;
  final String? userPhone;
  final String guideId;
  final String guideName;
  final DateTime bookingDate;
  final DateTime experienceDate;
  final int numberOfPeople;
  final double pricePerPerson;
  final double totalPrice;
  final double? discount;
  final double finalPrice;
  final String status; // pending, confirmed, cancelled, completed
  final String? paymentId;
  final String? paymentMethod;
  final bool isPaid;
  final String? cancellationReason;
  final DateTime? cancelledAt;
  final String? specialRequests;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Booking({
    required this.id,
    required this.experienceId,
    required this.experienceTitle,
    required this.experienceImage,
    required this.userId,
    required this.userName,
    required this.userEmail,
    this.userPhone,
    required this.guideId,
    required this.guideName,
    required this.bookingDate,
    required this.experienceDate,
    required this.numberOfPeople,
    required this.pricePerPerson,
    required this.totalPrice,
    this.discount,
    required this.finalPrice,
    this.status = 'pending',
    this.paymentId,
    this.paymentMethod,
    this.isPaid = false,
    this.cancellationReason,
    this.cancelledAt,
    this.specialRequests,
    this.metadata,
    required this.createdAt,
    this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      experienceId: json['experienceId'] as String,
      experienceTitle: json['experienceTitle'] as String,
      experienceImage: json['experienceImage'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userEmail: json['userEmail'] as String,
      userPhone: json['userPhone'] as String?,
      guideId: json['guideId'] as String,
      guideName: json['guideName'] as String,
      bookingDate: DateTime.parse(json['bookingDate'].toString()),
      experienceDate: DateTime.parse(json['experienceDate'].toString()),
      numberOfPeople: json['numberOfPeople'] as int,
      pricePerPerson: (json['pricePerPerson'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
      finalPrice: (json['finalPrice'] as num).toDouble(),
      status: json['status'] as String? ?? 'pending',
      paymentId: json['paymentId'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      isPaid: json['isPaid'] as bool? ?? false,
      cancellationReason: json['cancellationReason'] as String?,
      cancelledAt: json['cancelledAt'] != null
          ? DateTime.parse(json['cancelledAt'].toString())
          : null,
      specialRequests: json['specialRequests'] as String?,
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'] as Map)
          : null,
      createdAt: DateTime.parse(json['createdAt'].toString()),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'experienceId': experienceId,
      'experienceTitle': experienceTitle,
      'experienceImage': experienceImage,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'guideId': guideId,
      'guideName': guideName,
      'bookingDate': bookingDate.toIso8601String(),
      'experienceDate': experienceDate.toIso8601String(),
      'numberOfPeople': numberOfPeople,
      'pricePerPerson': pricePerPerson,
      'totalPrice': totalPrice,
      'discount': discount,
      'finalPrice': finalPrice,
      'status': status,
      'paymentId': paymentId,
      'paymentMethod': paymentMethod,
      'isPaid': isPaid,
      'cancellationReason': cancellationReason,
      'cancelledAt': cancelledAt?.toIso8601String(),
      'specialRequests': specialRequests,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Booking copyWith({
    String? id,
    String? experienceId,
    String? experienceTitle,
    String? experienceImage,
    String? userId,
    String? userName,
    String? userEmail,
    String? userPhone,
    String? guideId,
    String? guideName,
    DateTime? bookingDate,
    DateTime? experienceDate,
    int? numberOfPeople,
    double? pricePerPerson,
    double? totalPrice,
    double? discount,
    double? finalPrice,
    String? status,
    String? paymentId,
    String? paymentMethod,
    bool? isPaid,
    String? cancellationReason,
    DateTime? cancelledAt,
    String? specialRequests,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Booking(
      id: id ?? this.id,
      experienceId: experienceId ?? this.experienceId,
      experienceTitle: experienceTitle ?? this.experienceTitle,
      experienceImage: experienceImage ?? this.experienceImage,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPhone: userPhone ?? this.userPhone,
      guideId: guideId ?? this.guideId,
      guideName: guideName ?? this.guideName,
      bookingDate: bookingDate ?? this.bookingDate,
      experienceDate: experienceDate ?? this.experienceDate,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      pricePerPerson: pricePerPerson ?? this.pricePerPerson,
      totalPrice: totalPrice ?? this.totalPrice,
      discount: discount ?? this.discount,
      finalPrice: finalPrice ?? this.finalPrice,
      status: status ?? this.status,
      paymentId: paymentId ?? this.paymentId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isPaid: isPaid ?? this.isPaid,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      specialRequests: specialRequests ?? this.specialRequests,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isCancelled => status == 'cancelled';
  bool get isCompleted => status == 'completed';

  String get formattedPrice => '₹${finalPrice.toStringAsFixed(0)}';
}
