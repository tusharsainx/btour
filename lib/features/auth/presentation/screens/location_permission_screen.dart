import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../shared/providers/city_provider.dart';
import '../../../home/presentation/screens/city_selector_screen.dart';

class LocationPermissionScreen extends ConsumerStatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  ConsumerState<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState
    extends ConsumerState<LocationPermissionScreen> {
  bool _isLoading = false;

  Future<void> _requestLocation() async {
    setState(() => _isLoading = true);

    final success = await ref
        .read(cityProvider.notifier)
        .requestLocationAndDetectCity();

    setState(() => _isLoading = false);

    if (success && mounted) {
      // Location detected successfully
      await ref.read(cityProvider.notifier).completeFirstLaunch();
      context.go('/onboarding');
    } else if (mounted) {
      // Location denied, show city selector
      _showCitySelector();
    }
  }

  Future<void> _showCitySelector() async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const CitySelectorScreen()),
    );

    if (result != null && mounted) {
      await ref.read(cityProvider.notifier).completeFirstLaunch();
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary.withValues(alpha: 0.1), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                // Illustration
                FadeInDown(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 40,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Animated rings
                        ...List.generate(3, (index) {
                          return FadeIn(
                            delay: Duration(milliseconds: 500 + (index * 300)),
                            child: Container(
                              width: 200.0 + (index * 40),
                              height: 200.0 + (index * 40),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.2 - (index * 0.05),
                                  ),
                                  width: 2,
                                ),
                              ),
                            ),
                          );
                        }),
                        const Text('📍', style: TextStyle(fontSize: 80)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                // Title
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: Text(
                    'Enable Location',
                    style: AppTypography.headlineLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Description
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: Text(
                    'Allow location access to automatically discover experiences near you in Bihar',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Features list
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _buildFeatureItem(
                          icon: Icons.explore,
                          title: 'Nearby Experiences',
                          subtitle: 'Find experiences in your city',
                        ),
                        const Divider(height: 24),
                        _buildFeatureItem(
                          icon: Icons.navigation,
                          title: 'Easy Navigation',
                          subtitle: 'Get directions to locations',
                        ),
                        const Divider(height: 24),
                        _buildFeatureItem(
                          icon: Icons.notifications_active,
                          title: 'Local Updates',
                          subtitle: 'Receive relevant notifications',
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                // Buttons
                FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  child: GradientButton(
                    text: 'Allow Location Access',
                    isLoading: _isLoading,
                    onPressed: _requestLocation,
                  ),
                ),
                const SizedBox(height: 16),
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: TextButton(
                    onPressed: _showCitySelector,
                    child: Text(
                      'Select City Manually',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
