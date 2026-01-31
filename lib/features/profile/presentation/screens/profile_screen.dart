import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/providers/providers.dart';
import 'personal_info_screen.dart';

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
                // Profile header with enhanced background
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
                  child: Stack(
                    children: [
                      // Decorative circles
                      Positioned(
                        top: -30,
                        right: -30,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -40,
                        left: -40,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.05),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 50,
                        left: 30,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                      ),
                      // Profile content
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                  child: user.photoUrl != null
                                      ? ClipOval(
                                          child: _buildProfileImage(
                                            user.photoUrl!,
                                          ),
                                        )
                                      : Icon(
                                          Icons.person,
                                          size: 50,
                                          color: AppColors.primary,
                                        ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () async {
                                      // Show image picker dialog
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) => Container(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Change Profile Picture',
                                                style:
                                                    AppTypography.titleMedium,
                                              ),
                                              const SizedBox(height: 20),
                                              ListTile(
                                                leading: const Icon(
                                                  Icons.camera_alt,
                                                ),
                                                title: const Text('Take Photo'),
                                                onTap: () async {
                                                  Navigator.pop(context);
                                                  await _pickAndSaveImage(
                                                    ref,
                                                    ImageSource.camera,
                                                    context,
                                                  );
                                                },
                                              ),
                                              ListTile(
                                                leading: const Icon(
                                                  Icons.photo_library,
                                                ),
                                                title: const Text(
                                                  'Choose from Gallery',
                                                ),
                                                onTap: () async {
                                                  Navigator.pop(context);
                                                  await _pickAndSaveImage(
                                                    ref,
                                                    ImageSource.gallery,
                                                    context,
                                                  );
                                                },
                                              ),
                                              if (user.photoUrl != null)
                                                ListTile(
                                                  leading: const Icon(
                                                    Icons.delete,
                                                    color: AppColors.error,
                                                  ),
                                                  title: const Text(
                                                    'Remove Photo',
                                                    style: TextStyle(
                                                      color: AppColors.error,
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    Navigator.pop(context);
                                                    await ref
                                                        .read(
                                                          authNotifierProvider
                                                              .notifier,
                                                        )
                                                        .updateProfilePhoto(
                                                          null,
                                                        );
                                                    if (context.mounted) {
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                            'Profile photo removed',
                                                          ),
                                                          backgroundColor:
                                                              AppColors.success,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              user.name,
                              style: AppTypography.headlineSmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
                        icon: Icons.person_outline,
                        title: 'Personal Information',
                        subtitle: 'View your account details',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PersonalInfoScreen(user: user),
                            ),
                          );
                        },
                      ),
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

// Helper function to build profile image from local file or network
Widget _buildProfileImage(String photoUrl) {
  // Check if it's a local file path
  if (photoUrl.startsWith('/') || photoUrl.contains('\\')) {
    final file = File(photoUrl);
    if (file.existsSync()) {
      return Image.file(file, width: 96, height: 96, fit: BoxFit.cover);
    }
  }

  // Otherwise, try to load as network image
  return Image.network(
    photoUrl,
    width: 96,
    height: 96,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return const Icon(Icons.person, size: 50, color: AppColors.primary);
    },
  );
}

// Helper function to pick and save image
Future<void> _pickAndSaveImage(
  WidgetRef ref,
  ImageSource source,
  BuildContext context,
) async {
  try {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (pickedFile != null) {
      // Get the application documents directory
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName =
          'profile_${DateTime.now().millisecondsSinceEpoch}${path.extension(pickedFile.path)}';
      final String localPath = path.join(appDir.path, fileName);

      // Copy the file to the local directory
      final File localFile = await File(pickedFile.path).copy(localPath);

      // Update user profile with local file path
      await ref
          .read(authNotifierProvider.notifier)
          .updateProfilePhoto(localFile.path);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile photo updated successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update photo: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
