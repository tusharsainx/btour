import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/providers/providers.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(bookingStatsProvider);
    final allBookings = ref.watch(allBookingsProvider);
    final allExperiences = ref.watch(experiencesProvider);

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats cards
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Total Bookings',
                    value: '${stats['totalBookings'] ?? 0}',
                    icon: Icons.calendar_today,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: 'Revenue',
                    value:
                        '₹${((stats['totalRevenue'] ?? 0) / 1000).toStringAsFixed(1)}K',
                    icon: Icons.currency_rupee,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: allExperiences.when(
                    data: (exp) => _StatCard(
                      title: 'Experiences',
                      value: '${exp.length}',
                      icon: Icons.explore,
                      color: AppColors.secondary,
                    ),
                    loading: () => const _StatCard(
                      title: 'Experiences',
                      value: '-',
                      icon: Icons.explore,
                      color: AppColors.secondary,
                    ),
                    error: (_, __) => const SizedBox(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: 'This Month',
                    value: '${stats['monthlyBookings'] ?? 0}',
                    icon: Icons.trending_up,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Quick actions
            Text('Quick Actions', style: AppTypography.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ActionCard(
                    icon: Icons.add_circle_outline,
                    title: 'Add Experience',
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionCard(
                    icon: Icons.person_add_outlined,
                    title: 'Add Guide',
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Recent bookings
            Text('Recent Bookings', style: AppTypography.titleMedium),
            const SizedBox(height: 12),
            ...allBookings.when(
              data: (bookings) => bookings
                  .take(5)
                  .map(
                    (booking) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  booking.experienceTitle,
                                  style: AppTypography.titleSmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  booking.userName,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(
                                booking.status,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              booking.status.toUpperCase(),
                              style: AppTypography.labelSmall.copyWith(
                                color: _getStatusColor(booking.status),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              loading: () => [const Center(child: CircularProgressIndicator())],
              error: (e, _) => [Center(child: Text('Error: $e'))],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.textMuted;
    }
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTypography.headlineSmall.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 32),
            const SizedBox(height: 8),
            Text(title, style: AppTypography.labelMedium),
          ],
        ),
      ),
    );
  }
}
