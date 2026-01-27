import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../shared/providers/providers.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/services/payment_service.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final String experienceId;

  const BookingScreen({super.key, required this.experienceId});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  DateTime? _selectedDate;
  int _numberOfPeople = 1;
  final _specialRequestsController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _specialRequestsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _handleBooking(Experience experience, UserModel user) async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a date')));
      return;
    }

    setState(() => _isLoading = true);

    // 1. Create initial booking
    final booking = await ref
        .read(bookingNotifierProvider.notifier)
        .createBooking(
          experience: experience,
          user: user,
          experienceDate: _selectedDate!,
          numberOfPeople: _numberOfPeople,
          specialRequests: _specialRequestsController.text,
        );

    if (booking == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    // 2. Initialize Payment
    if (mounted) {
      final paymentService = ref.read(paymentServiceProvider);

      paymentService.initialize(
        onSuccess: (paymentId) async {
          // 3. Confirm booking on backend
          await ref
              .read(bookingNotifierProvider.notifier)
              .confirmPayment(booking.id, paymentId);

          if (mounted) {
            setState(() => _isLoading = false);
            context.go('/booking-confirmation/${booking.id}');
          }
        },
        onFailure: (errorMessage) {
          if (mounted) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Payment Failed: $errorMessage')),
            );
          }
        },
      );

      // 3. Start Checkout
      paymentService.openCheckout(
        amount: booking.totalPrice,
        name: 'Bihar Tourism',
        description: 'Booking for ${experience.title}',
        contact: user.phoneNumber ?? '',
        email: user.email,
        orderId: '', // Generate order ID on backend if needed
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final experienceAsync = ref.watch(experienceProvider(widget.experienceId));
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Book Experience')),
      body: experienceAsync.when(
        data: (experience) {
          if (experience == null) {
            return const Center(child: Text('Experience not found'));
          }
          final total = experience.price * _numberOfPeople;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Experience summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedImage(
                          imageUrl: experience.primaryImage,
                          width: 80,
                          height: 80,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              experience.title,
                              style: AppTypography.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              experience.location,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Date selection
                Text('Select Date', style: AppTypography.titleMedium),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _selectedDate != null
                              ? DateFormat(
                                  'EEEE, d MMMM yyyy',
                                ).format(_selectedDate!)
                              : 'Choose a date',
                          style: AppTypography.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Number of people
                Text('Number of People', style: AppTypography.titleMedium),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: _numberOfPeople > 1
                            ? () => setState(() => _numberOfPeople--)
                            : null,
                      ),
                      Text(
                        '$_numberOfPeople',
                        style: AppTypography.headlineSmall,
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        color: AppColors.primary,
                        onPressed: _numberOfPeople < experience.maxGroupSize
                            ? () => setState(() => _numberOfPeople++)
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Special requests
                Text(
                  'Special Requests (Optional)',
                  style: AppTypography.titleMedium,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _specialRequestsController,
                  hint: 'Any special requirements?',
                  maxLines: 3,
                ),
                const SizedBox(height: 32),
                // Price breakdown
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${experience.formattedPrice} x $_numberOfPeople people',
                            style: AppTypography.bodyMedium,
                          ),
                          Text(
                            '₹${total.toStringAsFixed(0)}',
                            style: AppTypography.bodyMedium,
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total', style: AppTypography.titleMedium),
                          Text(
                            '₹${total.toStringAsFixed(0)}',
                            style: AppTypography.headlineSmall.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Confirm button
                currentUser.when(
                  data: (user) => GradientButton(
                    text: 'Confirm Booking',
                    isLoading: _isLoading,
                    onPressed: user != null
                        ? () => _handleBooking(experience, user)
                        : null,
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Text('Please login to book'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
