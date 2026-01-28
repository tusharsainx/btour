import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../shared/providers/providers.dart';
import 'city_selector_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final categories = ref.watch(categoriesProvider);
    final featuredExperiences = ref.watch(featuredExperiencesProvider);
    final cityState = ref.watch(cityProvider);

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(featuredExperiencesProvider);
          },
          child: CustomScrollView(
            slivers: [
              // City Selector Header
              SliverToBoxAdapter(
                child: FadeInDown(
                  child: _CitySelector(
                    selectedCity: cityState.selectedCity ?? 'Patna',
                    onTap: () async {
                      final result = await Navigator.of(context).push<String>(
                        MaterialPageRoute(
                          builder: (_) => const CitySelectorScreen(),
                        ),
                      );
                      if (result != null) {
                        // City changed, experiences will auto-update via provider
                      }
                    },
                  ),
                ),
              ),
              // Header with greeting
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: FadeInDown(
                    delay: const Duration(milliseconds: 100),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: FadeInDown(
                    delay: const Duration(milliseconds: 200),
                    child: SearchTextField(
                      hint:
                          'Search experiences in ${cityState.selectedCity ?? "Bihar"}...',
                      readOnly: true,
                      onTap: () => context.go('/explore'),
                    ),
                  ),
                ),
              ),
              // Categories
              SliverToBoxAdapter(
                child: _buildCategoriesSection(context, ref, categories),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              // Featured experiences
              SliverToBoxAdapter(
                child: _buildFeaturedSection(
                  context,
                  featuredExperiences,
                  cityState.selectedCity ?? 'Patna',
                ),
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
      delay: const Duration(milliseconds: 300),
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

  Widget _buildFeaturedSection(
    BuildContext context,
    AsyncValue experiences,
    String city,
  ) {
    return FadeInUp(
      delay: const Duration(milliseconds: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Featured in $city', style: AppTypography.titleLarge),
                TextButton(
                  onPressed: () => context.go('/explore'),
                  child: Text(
                    'See All',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 320,
            child: experiences.when(
              data: (list) {
                if (list.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('🔍', style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 12),
                          Text(
                            'No featured experiences in $city yet',
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.builder(
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
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

/// City selector widget for the top of home screen
class _CitySelector extends StatelessWidget {
  final String selectedCity;
  final VoidCallback onTap;

  const _CitySelector({required this.selectedCity, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.1),
                AppColors.primary.withValues(alpha: 0.05),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Location',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    Text(
                      selectedCity,
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
