import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../../core/constants/app_constants.dart';
import 'auth_provider.dart';

// Global mock bookings list that can be updated
final mockBookingsListProvider = StateProvider<List<Booking>>((ref) => []);

// User bookings provider - now reactive
final userBookingsProvider = Provider<AsyncValue<List<Booking>>>((ref) {
  final bookings = ref.watch(mockBookingsListProvider);
  return AsyncValue.data(bookings);
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
final allBookingsProvider = Provider<AsyncValue<List<Booking>>>((ref) {
  final bookings = ref.watch(mockBookingsListProvider);
  return AsyncValue.data(bookings);
});

// Single booking provider - now reactive
final bookingProvider = Provider.family<AsyncValue<Booking?>, String>((
  ref,
  id,
) {
  final bookings = ref.watch(mockBookingsListProvider);
  try {
    final booking = bookings.firstWhere((b) => b.id == id);
    return AsyncValue.data(booking);
  } catch (_) {
    return const AsyncValue.data(null);
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
  final Ref _ref;

  BookingNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<Booking?> createBooking({
    required Experience experience,
    required UserModel user,
    required DateTime experienceDate,
    required int numberOfPeople,
    String? specialRequests,
    List<TravelerInfo>? travelers,
  }) async {
    state = const AsyncValue.loading();
    try {
      await Future.delayed(const Duration(seconds: 1)); // Mock delay

      final uuid = const Uuid();
      final bookingId = uuid.v4();

      final totalPrice = experience.price * numberOfPeople;

      // Store travelers info in metadata
      final metadata = <String, dynamic>{};
      if (travelers != null && travelers.isNotEmpty) {
        metadata['travelers'] = travelers.map((t) => t.toJson()).toList();
      }

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
        metadata: metadata.isNotEmpty ? metadata : null,
        createdAt: DateTime.now(),
      );

      // Add to reactive list
      final currentBookings = _ref.read(mockBookingsListProvider);
      _ref.read(mockBookingsListProvider.notifier).state = [
        ...currentBookings,
        booking,
      ];

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
      final currentBookings = _ref.read(mockBookingsListProvider);
      final index = currentBookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        final updatedList = [...currentBookings];
        updatedList[index] = updatedList[index].copyWith(status: status);
        _ref.read(mockBookingsListProvider.notifier).state = updatedList;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> confirmPayment(String bookingId, String paymentId) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final currentBookings = _ref.read(mockBookingsListProvider);
      final index = currentBookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        final updatedList = [...currentBookings];
        updatedList[index] = updatedList[index].copyWith(
          status: AppConstants.bookingConfirmed,
          isPaid: true,
        );
        _ref.read(mockBookingsListProvider.notifier).state = updatedList;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelBooking(String bookingId, String reason) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final currentBookings = _ref.read(mockBookingsListProvider);
      final index = currentBookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        final updatedList = [...currentBookings];
        updatedList[index] = updatedList[index].copyWith(
          status: AppConstants.bookingCancelled,
        );
        _ref.read(mockBookingsListProvider.notifier).state = updatedList;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> completeBooking(String bookingId) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final currentBookings = _ref.read(mockBookingsListProvider);
      final index = currentBookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        final updatedList = [...currentBookings];
        updatedList[index] = updatedList[index].copyWith(
          status: AppConstants.bookingCompleted,
        );
        _ref.read(mockBookingsListProvider.notifier).state = updatedList;
      }
    } catch (e) {
      rethrow;
    }
  }
}

final bookingNotifierProvider =
    StateNotifierProvider<BookingNotifier, AsyncValue<Booking?>>((ref) {
      return BookingNotifier(ref);
    });

// Booking statistics (for admin)
final bookingStatsProvider = Provider<Map<String, dynamic>>((ref) {
  // Use reactive mock data
  final bookings = ref.watch(mockBookingsListProvider);

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
