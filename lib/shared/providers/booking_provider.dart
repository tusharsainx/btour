import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
// Bookings persisted in Hive
class BookingNotifier extends StateNotifier<AsyncValue<Booking?>> {
  final Ref _ref;
  Box? _box;

  BookingNotifier(this._ref) : super(const AsyncValue.data(null)) {
    _initBox();
  }

  Future<void> _initBox() async {
    if (_box != null && _box!.isOpen) return;
    _box = await Hive.openBox('bookings_v1');
    _loadBookings();
  }

  // Public method to force reload
  void loadBookings() => _loadBookings();

  void _loadBookings() {
    if (_box == null) return;
    final List<dynamic> rawList = _box!.values.toList();
    final List<Booking> bookings = rawList.map((e) {
      final map = Map<String, dynamic>.from(e);
      return Booking.fromJson(map);
    }).toList();

    _ref.read(mockBookingsListProvider.notifier).state = bookings;
  }

  Future<void> _saveBooking(Booking booking) async {
    if (_box == null) await _initBox(); // Ensure box is open
    await _box!.put(booking.id, booking.toJson());
    // Refresh list from box
    _loadBookings();
  }

  Future<void> _deleteBooking(String id) async {
    if (_box == null) await _initBox();
    await _box!.delete(id);
    _loadBookings();
  }

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

      await _saveBooking(booking);

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
      final booking = currentBookings.firstWhere(
        (b) => b.id == bookingId,
        orElse: () => throw Exception("Booking not found"),
      );

      final updatedBooking = booking.copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
      await _saveBooking(updatedBooking);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> confirmPayment(String bookingId, String paymentId) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      final currentBookings = _ref.read(mockBookingsListProvider);
      final booking = currentBookings.firstWhere(
        (b) => b.id == bookingId,
        orElse: () => throw Exception("Booking not found"),
      );

      final updatedBooking = booking.copyWith(
        status: AppConstants.bookingConfirmed,
        isPaid: true,
        paymentId: paymentId,
        updatedAt: DateTime.now(),
      );
      await _saveBooking(updatedBooking);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelBooking(String bookingId, String reason) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      final currentBookings = _ref.read(mockBookingsListProvider);
      final booking = currentBookings.firstWhere(
        (b) => b.id == bookingId,
        orElse: () => throw Exception("Booking not found"),
      );

      final updatedBooking = booking.copyWith(
        status: AppConstants.bookingCancelled,
        cancellationReason: reason,
        cancelledAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _saveBooking(updatedBooking);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> completeBooking(String bookingId) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      final currentBookings = _ref.read(mockBookingsListProvider);
      final booking = currentBookings.firstWhere(
        (b) => b.id == bookingId,
        orElse: () => throw Exception("Booking not found"),
      );

      final updatedBooking = booking.copyWith(
        status: AppConstants.bookingCompleted,
        updatedAt: DateTime.now(),
      );
      await _saveBooking(updatedBooking);
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
