import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../shared/providers/providers.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistAsync = ref.watch(wishlistExperiencesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Wishlist')),
      body: wishlistAsync.when(
        data: (experiences) {
          if (experiences.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('❤️', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  Text(
                    'Your wishlist is empty',
                    style: AppTypography.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Save experiences you love',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    text: 'Explore Experiences',
                    width: 200,
                    onPressed: () => context.go('/explore'),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: experiences.length,
            itemBuilder: (context, index) {
              final experience = experiences[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ExperienceCard(
                  experience: experience,
                  onTap: () => context.go('/experience/${experience.id}'),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
