import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../shared/providers/providers.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/widgets/fake_payment_screen.dart';

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

  // Traveler info controllers - one set per traveler
  List<_TravelerFormData> _travelers = [];

  @override
  void initState() {
    super.initState();
    _initializeTravelers();
  }

  void _initializeTravelers() {
    _travelers = List.generate(_numberOfPeople, (index) => _TravelerFormData());
  }

  void _updateTravelerCount(int newCount) {
    setState(() {
      _numberOfPeople = newCount;
      // Add or remove travelers
      if (newCount > _travelers.length) {
        _travelers.addAll(
          List.generate(
            newCount - _travelers.length,
            (_) => _TravelerFormData(),
          ),
        );
      } else if (newCount < _travelers.length) {
        // Dispose removed controllers
        for (int i = newCount; i < _travelers.length; i++) {
          _travelers[i].dispose();
        }
        _travelers = _travelers.sublist(0, newCount);
      }
    });
  }

  @override
  void dispose() {
    _specialRequestsController.dispose();
    for (var traveler in _travelers) {
      traveler.dispose();
    }
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

  Future<void> _handleBooking(Experience experience, UserModel? user) async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a date')));
      return;
    }

    // Validate all travelers have complete info
    final invalidTravelers = _travelers.where((t) => !t.isValid).toList();
    if (invalidTravelers.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in details for all travelers'),
          backgroundColor: Colors.orange,
        ),
      );
      // Expand the first invalid traveler
      final firstInvalidIndex = _travelers.indexWhere((t) => !t.isValid);
      if (firstInvalidIndex != -1) {
        setState(() {
          _travelers[firstInvalidIndex].isExpanded = true;
        });
      }
      return;
    }

    // If no user, create a mock guest user for MVP
    final bookingUser =
        user ??
        UserModel(
          id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
          email: 'guest@btour.com',
          name: 'Guest User',
          role: 'tourist',
          createdAt: DateTime.now(),
        );

    // Collect traveler info
    final travelersInfo = _travelers.map((t) => t.toTravelerInfo()).toList();

    setState(() => _isLoading = true);

    // Show fake payment screen
    showFakePaymentScreen(
      context: context,
      amount: experience.price * _numberOfPeople,
      title: experience.title,
      description: 'Booking for $_numberOfPeople travelers',
      onSuccess: (paymentId) async {
        // Create booking after successful payment
        final booking = await ref
            .read(bookingNotifierProvider.notifier)
            .createBooking(
              experience: experience,
              user: bookingUser,
              experienceDate: _selectedDate!,
              numberOfPeople: _numberOfPeople,
              specialRequests: _specialRequestsController.text,
              travelers: travelersInfo,
            );

        if (booking != null) {
          // Confirm payment
          await ref
              .read(bookingNotifierProvider.notifier)
              .confirmPayment(booking.id, paymentId);

          if (mounted) {
            setState(() => _isLoading = false);
            context.go('/booking-confirmation/${booking.id}');
          }
        } else {
          if (mounted) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to create booking')),
            );
          }
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
                Text('Number of Travelers', style: AppTypography.titleMedium),
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
                            ? () => _updateTravelerCount(_numberOfPeople - 1)
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
                            ? () => _updateTravelerCount(_numberOfPeople + 1)
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Traveler Information Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Traveler Details', style: AppTypography.titleMedium),
                    Text(
                      '(All fields required)',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Traveler forms
                ...List.generate(_travelers.length, (index) {
                  final traveler = _travelers[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        initiallyExpanded: traveler.isExpanded,
                        onExpansionChanged: (expanded) {
                          setState(() => traveler.isExpanded = expanded);
                        },
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        title: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColors.primary.withValues(
                                alpha: 0.1,
                              ),
                              child: Text(
                                '${index + 1}',
                                style: AppTypography.labelMedium.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                traveler.nameController.text.isNotEmpty
                                    ? traveler.nameController.text
                                    : 'Traveler ${index + 1}',
                                style: AppTypography.titleSmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (traveler.isValid)
                              const Icon(
                                Icons.check_circle,
                                color: AppColors.success,
                                size: 20,
                              ),
                          ],
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name field
                                Text(
                                  'Full Name',
                                  style: AppTypography.labelMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: traveler.nameController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter full name',
                                    prefixIcon: const Icon(
                                      Icons.person_outline,
                                      size: 20,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ),
                                const SizedBox(height: 16),
                                // Age and Gender row
                                Row(
                                  children: [
                                    // Age field
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Age',
                                            style: AppTypography.labelMedium
                                                .copyWith(
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                          ),
                                          const SizedBox(height: 8),
                                          TextFormField(
                                            controller: traveler.ageController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              hintText: 'Age',
                                              prefixIcon: const Icon(
                                                Icons.cake_outlined,
                                                size: 20,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 12,
                                                  ),
                                            ),
                                            onChanged: (_) => setState(() {}),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    // Gender dropdown
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Gender',
                                            style: AppTypography.labelMedium
                                                .copyWith(
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: AppColors.border,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child:
                                                DropdownButtonFormField<String>(
                                                  value: traveler.gender,
                                                  decoration:
                                                      const InputDecoration(
                                                        prefixIcon: Icon(
                                                          Icons.wc_outlined,
                                                          size: 20,
                                                        ),
                                                        border:
                                                            InputBorder.none,
                                                        contentPadding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 8,
                                                            ),
                                                      ),
                                                  items:
                                                      [
                                                            'Male',
                                                            'Female',
                                                            'Other',
                                                          ]
                                                          .map(
                                                            (g) =>
                                                                DropdownMenuItem(
                                                                  value: g,
                                                                  child: Text(
                                                                    g,
                                                                  ),
                                                                ),
                                                          )
                                                          .toList(),
                                                  onChanged: (value) {
                                                    if (value != null) {
                                                      setState(
                                                        () => traveler.gender =
                                                            value,
                                                      );
                                                    }
                                                  },
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
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
                // Confirm button - Always enabled for MVP
                currentUser.when(
                  data: (user) => GradientButton(
                    text: 'Confirm Booking',
                    isLoading: _isLoading,
                    onPressed: () => _handleBooking(experience, user),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, __) => GradientButton(
                    text: 'Confirm Booking',
                    isLoading: _isLoading,
                    onPressed: () => _handleBooking(experience, null),
                  ),
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

/// Helper class to manage form data for each traveler
class _TravelerFormData {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String gender = 'Male';
  bool isExpanded = true;

  void dispose() {
    nameController.dispose();
    ageController.dispose();
  }

  bool get isValid {
    return nameController.text.trim().isNotEmpty &&
        ageController.text.isNotEmpty &&
        int.tryParse(ageController.text) != null &&
        int.parse(ageController.text) > 0;
  }

  TravelerInfo toTravelerInfo() {
    return TravelerInfo(
      name: nameController.text.trim(),
      age: int.tryParse(ageController.text) ?? 0,
      gender: gender,
    );
  }
}
