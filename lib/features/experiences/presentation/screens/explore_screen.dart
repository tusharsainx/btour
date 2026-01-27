import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:btour/core/theme/app_colors.dart';
import 'package:btour/core/theme/app_typography.dart';
import 'package:btour/core/widgets/widgets.dart';
import 'package:btour/shared/providers/providers.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final searchedExperiences = ref.watch(searchedExperiencesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Explore', style: AppTypography.headlineMedium),
                  const SizedBox(height: 16),
                  SearchTextField(
                    controller: _searchController,
                    hint: 'Search experiences...',
                    onChanged: (value) {
                      ref.read(searchQueryProvider.notifier).state = value;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: CategoryChip(
                        name: 'All',
                        icon: '✨',
                        isSelected: selectedCategory == null,
                        onTap: () {
                          ref.read(selectedCategoryProvider.notifier).state =
                              null;
                        },
                      ),
                    );
                  }
                  final category = categories[index - 1];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CategoryChip(
                      name: category.name,
                      icon: category.icon,
                      isSelected: selectedCategory == category.id,
                      onTap: () {
                        ref.read(selectedCategoryProvider.notifier).state =
                            category.id;
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: searchedExperiences.when(
                data: (experiences) {
                  if (experiences.isEmpty) {
                    return _buildEmptyState();
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: experiences.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ExperienceCard(
                          experience: experiences[index],
                          onTap: () => context.go(
                            '/experience/${experiences[index].id}',
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔍', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text('No experiences found', style: AppTypography.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
