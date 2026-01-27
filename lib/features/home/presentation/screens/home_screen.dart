import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../shared/providers/providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final categories = ref.watch(categoriesProvider);
    final featuredExperiences = ref.watch(featuredExperiencesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(featuredExperiencesProvider);
          },
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: FadeInDown(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getGreeting(),
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              currentUser.when(
                                data: (user) => Text(
                                  user?.name ?? 'Explorer',
                                  style: AppTypography.headlineSmall.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                loading: () => const SizedBox.shrink(),
                                error: (_, __) => const Text('Explorer'),
                              ),
                            ],
                          ),
                        ),
                        IconButtonCustom(
                          icon: Icons.notifications_outlined,
                          onPressed: () {},
                          hasShadow: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Search bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FadeInDown(
                    delay: const Duration(milliseconds: 100),
                    child: SearchTextField(
                      hint: 'Search experiences in Bihar...',
                      readOnly: true,
                      onTap: () => context.go('/explore'),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              // Categories
              SliverToBoxAdapter(
                child: _buildCategoriesSection(context, ref, categories),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              // Featured experiences
              SliverToBoxAdapter(
                child: _buildFeaturedSection(context, featuredExperiences),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning 🌅';
    if (hour < 17) return 'Good Afternoon ☀️';
    return 'Good Evening 🌙';
  }

  Widget _buildCategoriesSection(
    BuildContext context,
    WidgetRef ref,
    List categories,
  ) {
    return FadeInUp(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Categories', style: AppTypography.titleLarge),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: CategoryCard(
                    id: category.id,
                    name: category.name,
                    icon: category.icon,
                    image: category.image,
                    color: category.color,
                    count: category.experienceCount,
                    onTap: () {
                      ref.read(selectedCategoryProvider.notifier).state =
                          category.id;
                      context.go('/explore');
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedSection(BuildContext context, AsyncValue experiences) {
    return FadeInUp(
      delay: const Duration(milliseconds: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Featured Experiences',
              style: AppTypography.titleLarge,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 320,
            child: experiences.when(
              data: (list) => ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: list.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ExperienceCard(
                    experience: list[index],
                    isCompact: true,
                    onTap: () => context.go('/experience/${list[index].id}'),
                  ),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
