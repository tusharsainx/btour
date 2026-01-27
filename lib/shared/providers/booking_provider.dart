import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../../core/constants/app_constants.dart';
import 'auth_provider.dart';

// Mock Bookings
final _mockBookings = <Booking>[];

// User bookings provider
final userBookingsProvider = StreamProvider<List<Booking>>((ref) {
  // In mock mode, return an empty list or filter from _mockBookings
  return Stream.value(_mockBookings);
});

// Guide bookings provider
final guideBookingsProvider = StreamProvider<List<Booking>>((ref) {
  return Stream.value([]);
});

// Upcoming bookings for guide
final upcomingGuideBookingsProvider = Provider<AsyncValue<List<Booking>>>((
  ref,
) {
  final bookings = ref.watch(guideBookingsProvider);

  return bookings.whenData((list) {
    final now = DateTime.now();
    return list
        .where(
          (b) =>
              b.experienceDate.isAfter(now) && (b.isConfirmed || b.isPending),
        )
        .toList()
      ..sort((a, b) => a.experienceDate.compareTo(b.experienceDate));
  });
});

// All bookings provider (admin)
final allBookingsProvider = StreamProvider<List<Booking>>((ref) {
  return Stream.value(_mockBookings);
});

// Single booking provider
final bookingProvider = FutureProvider.family<Booking?, String>((
  ref,
  id,
) async {
  await Future.delayed(const Duration(milliseconds: 500));
  try {
    return _mockBookings.firstWhere((b) => b.id == id);
  } catch (_) {
    return null;
  }
});

// Booking form state
class BookingFormState {
  final DateTime? selectedDate;
  final int numberOfPeople;
  final String? specialRequests;
  final bool isLoading;
  final String? error;

  BookingFormState({
    this.selectedDate,
    this.numberOfPeople = 1,
    this.specialRequests,
    this.isLoading = false,
    this.error,
  });

  BookingFormState copyWith({
    DateTime? selectedDate,
    int? numberOfPeople,
    String? specialRequests,
    bool? isLoading,
    String? error,
  }) {
    return BookingFormState(
      selectedDate: selectedDate ?? this.selectedDate,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      specialRequests: specialRequests ?? this.specialRequests,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  double calculateTotal(double pricePerPerson) {
    return pricePerPerson * numberOfPeople;
  }
}

class BookingFormNotifier extends StateNotifier<BookingFormState> {
  BookingFormNotifier() : super(BookingFormState());

  void setDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void setNumberOfPeople(int count) {
    state = state.copyWith(numberOfPeople: count);
  }

  void setSpecialRequests(String? requests) {
    state = state.copyWith(specialRequests: requests);
  }

  void reset() {
    state = BookingFormState();
  }
}

final bookingFormProvider =
    StateNotifierProvider<BookingFormNotifier, BookingFormState>((ref) {
      return BookingFormNotifier();
    });

// Booking notifier for CRUD operations (Mocked)
class BookingNotifier extends StateNotifier<AsyncValue<Booking?>> {
  BookingNotifier() : super(const AsyncValue.data(null));

  Future<Booking?> createBooking({
    required Experience experience,
    required UserModel user,
    required DateTime experienceDate,
    required int numberOfPeople,
    String? specialRequests,
  }) async {
    state = const AsyncValue.loading();
    try {
      await Future.delayed(const Duration(seconds: 1)); // Mock delay

      final uuid = const Uuid();
      final bookingId = uuid.v4();

      final totalPrice = experience.price * numberOfPeople;

      final booking = Booking(
        id: bookingId,
        experienceId: experience.id,
        experienceTitle: experience.title,
        experienceImage: experience.primaryImage,
        userId: user.id,
        userName: user.name,
        userEmail: user.email,
        userPhone: user.phoneNumber,
        guideId: experience.guideId,
        guideName: experience.guideName,
        bookingDate: DateTime.now(),
        experienceDate: experienceDate,
        numberOfPeople: numberOfPeople,
        pricePerPerson: experience.price,
        totalPrice: totalPrice,
        finalPrice: totalPrice, // Can add discounts later
        status: AppConstants.bookingPending,
        specialRequests: specialRequests,
        createdAt: DateTime.now(),
      );

      _mockBookings.add(booking);

      state = AsyncValue.data(booking);
      return booking;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final index = _mockBookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        _mockBookings[index] = _mockBookings[index].copyWith(status: status);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> confirmPayment(String bookingId, String paymentId) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final index = _mockBookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        _mockBookings[index] = _mockBookings[index].copyWith(
          status: AppConstants.bookingConfirmed,
          isPaid: true,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelBooking(String bookingId, String reason) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final index = _mockBookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        _mockBookings[index] = _mockBookings[index].copyWith(
          status: AppConstants.bookingCancelled,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> completeBooking(String bookingId) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final index = _mockBookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        _mockBookings[index] = _mockBookings[index].copyWith(
          status: AppConstants.bookingCompleted,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}

final bookingNotifierProvider =
    StateNotifierProvider<BookingNotifier, AsyncValue<Booking?>>((ref) {
      return BookingNotifier();
    });

// Booking statistics (for admin)
// Booking statistics (for admin)
final bookingStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  // Use mock data
  final bookings = _mockBookings;

  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);

  final totalBookings = bookings.length;
  final monthlyBookings = bookings
      .where((b) => b.createdAt.isAfter(startOfMonth))
      .length;
  final confirmedBookings = bookings
      .where((b) => b.status == AppConstants.bookingConfirmed)
      .length;

  double totalRevenue = 0;
  for (var b in bookings) {
    if (b.isPaid) {
      totalRevenue += b.finalPrice;
    }
  }

  return {
    'totalBookings': totalBookings,
    'monthlyBookings': monthlyBookings,
    'confirmedBookings': confirmedBookings,
    'totalRevenue': totalRevenue,
  };
});
