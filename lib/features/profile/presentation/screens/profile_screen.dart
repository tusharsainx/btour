import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/providers/providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      body: currentUser.when(
        data: (user) {
          if (user == null) {
            return Center(
              child: ElevatedButton(
                onPressed: () => context.go('/login'),
                child: const Text('Login'),
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile header
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 20,
                    bottom: 30,
                    left: 20,
                    right: 20,
                  ),
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: user.photoUrl != null
                            ? ClipOval(
                                child: Image.network(
                                  user.photoUrl!,
                                  width: 96,
                                  height: 96,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Text(
                                user.name[0].toUpperCase(),
                                style: AppTypography.displaySmall.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.name,
                        style: AppTypography.headlineSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: AppTypography.bodyMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Menu items
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _ProfileMenuItem(
                        icon: Icons.favorite_outline,
                        title: 'Wishlist',
                        subtitle: 'Your saved experiences',
                        onTap: () => context.push('/wishlist'),
                      ),
                      _ProfileMenuItem(
                        icon: Icons.history,
                        title: 'Booking History',
                        subtitle: 'View past experiences',
                        onTap: () {
                          ref.read(navigationIndexProvider.notifier).state = 2;
                          context.go('/bookings');
                        },
                      ),
                      _ProfileMenuItem(
                        icon: Icons.star_outline,
                        title: 'My Reviews',
                        subtitle: 'Reviews you have written',
                        onTap: () {},
                      ),
                      _ProfileMenuItem(
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        subtitle: 'App preferences',
                        onTap: () => context.push('/settings'),
                      ),
                      _ProfileMenuItem(
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        subtitle: 'Get assistance',
                        onTap: () {},
                      ),
                      if (user.isAdmin)
                        _ProfileMenuItem(
                          icon: Icons.admin_panel_settings_outlined,
                          title: 'Admin Panel',
                          subtitle: 'Manage experiences',
                          onTap: () => context.push('/admin'),
                        ),
                      if (user.isGuide)
                        _ProfileMenuItem(
                          icon: Icons.tour_outlined,
                          title: 'Guide Dashboard',
                          subtitle: 'Manage your tours',
                          onTap: () => context.push('/guide'),
                        ),
                      const SizedBox(height: 16),
                      _ProfileMenuItem(
                        icon: Icons.logout,
                        title: 'Logout',
                        subtitle: 'Sign out of your account',
                        iconColor: AppColors.error,
                        onTap: () async {
                          await ref
                              .read(authNotifierProvider.notifier)
                              .signOut();
                          if (context.mounted) context.go('/login');
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
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

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.isDark(context)
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor ?? AppColors.primary),
        ),
        title: Text(title, style: AppTypography.titleSmall),
        subtitle: Text(
          subtitle,
          style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
      ),
    );
  }
}
