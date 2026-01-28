import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../shared/providers/providers.dart';

class BookingConfirmationScreen extends ConsumerWidget {
  final String bookingId;

  const BookingConfirmationScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingAsync = ref.watch(bookingProvider(bookingId));

    return Scaffold(
      body: SafeArea(
        child: bookingAsync.when(
          data: (booking) {
            if (booking == null) {
              return const Center(child: Text('Booking not found'));
            }

            // Check if this is a confirmed booking or just viewing details
            final isConfirmed = booking.isConfirmed || booking.isPaid;
            final title = isConfirmed
                ? 'Booking Confirmed!'
                : 'Booking Details';
            final subtitle = isConfirmed
                ? 'Your booking has been successfully placed'
                : 'View your booking information below';

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Success icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color:
                          (isConfirmed ? AppColors.success : AppColors.primary)
                              .withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isConfirmed ? Icons.check_circle : Icons.info_outline,
                      color: isConfirmed
                          ? AppColors.success
                          : AppColors.primary,
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    title,
                    style: AppTypography.headlineMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    subtitle,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  // Booking details card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _DetailRow(
                          label: 'Experience',
                          value: booking.experienceTitle,
                        ),
                        const Divider(height: 24),
                        _DetailRow(
                          label: 'Date',
                          value: DateFormat(
                            'EEEE, d MMMM yyyy',
                          ).format(booking.experienceDate),
                        ),
                        const Divider(height: 24),
                        _DetailRow(
                          label: 'Travelers',
                          value: '${booking.numberOfPeople} people',
                        ),
                        const Divider(height: 24),
                        _DetailRow(
                          label: 'Total',
                          value: booking.formattedPrice,
                          isHighlighted: true,
                        ),
                      ],
                    ),
                  ),
                  // Travelers info section
                  if (booking.metadata != null &&
                      booking.metadata!['travelers'] != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.people,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Travelers',
                                style: AppTypography.titleSmall,
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          ...((booking.metadata!['travelers'] as List)
                              .asMap()
                              .entries
                              .map((entry) {
                                final index = entry.key;
                                final traveler =
                                    entry.value as Map<String, dynamic>;
                                return Padding(
                                  padding: EdgeInsets.only(
                                    top: index > 0 ? 12 : 0,
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 14,
                                        backgroundColor: AppColors.primary
                                            .withValues(alpha: 0.1),
                                        child: Text(
                                          '${index + 1}',
                                          style: AppTypography.labelSmall
                                              .copyWith(
                                                color: AppColors.primary,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              traveler['name'] as String,
                                              style: AppTypography.bodyMedium,
                                            ),
                                            Text(
                                              '${traveler['age']} yrs • ${traveler['gender']}',
                                              style: AppTypography.bodySmall
                                                  .copyWith(
                                                    color: AppColors.textMuted,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              })
                              .toList()),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    'Booking ID: ${booking.id.substring(0, 8).toUpperCase()}',
                    style: AppTypography.caption,
                  ),
                  const Spacer(),
                  GradientButton(
                    text: 'View My Bookings',
                    onPressed: () {
                      ref.read(navigationIndexProvider.notifier).state = 2;
                      context.go('/bookings');
                    },
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    text: 'Back to Home',
                    isOutlined: true,
                    onPressed: () {
                      ref.read(navigationIndexProvider.notifier).state = 0;
                      context.go('/home');
                    },
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlighted;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: isHighlighted
                ? AppTypography.titleMedium.copyWith(color: AppColors.primary)
                : AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
