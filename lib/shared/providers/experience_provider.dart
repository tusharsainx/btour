import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';
import '../../core/constants/app_constants.dart';
import 'auth_provider.dart';

// Mock Data
final _mockExperiences = [
  Experience(
    id: '1',
    title: 'Sunrise Boat Tour at Ganges',
    description:
        'Experience the spiritual sunrise at the holy Ganges river in Patna.',
    shortDescription: 'Spiritual sunrise boat ride on the Ganges.',
    location: 'Patna, Bihar',
    latitude: 25.61,
    longitude: 85.14,
    price: 1200.0,
    duration: 2,
    maxGroupSize: 10,
    images: [
      'https://images.unsplash.com/photo-1598324789736-4861f89564a0?w=800',
      'https://images.unsplash.com/photo-1563725694-857c70ae1653?w=800',
    ],
    category: 'Adventure',
    rating: 4.8,
    reviewCount: 124,
    guideId: 'host1',
    guideName: 'Ramesh Kumar',
    isFeatured: true,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    updatedAt: DateTime.now(),
    includes: ['Boat ride', 'Tea/Coffee', 'Guide'],
    requirements: ['Comfortable clothing'],
  ),
  Experience(
    id: '2',
    title: 'Heritage Walk of Rajgir',
    description:
        'Walk through the ancient ruins of Rajgir and learn about its rich history.',
    shortDescription: 'Guided heritage walk through ancient Rajgir ruins.',
    location: 'Rajgir, Bihar',
    latitude: 25.03,
    longitude: 85.42,
    price: 800.0,
    duration: 3,
    maxGroupSize: 15,
    images: [
      'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?w=800',
    ],
    category: 'Heritage',
    rating: 4.6,
    reviewCount: 89,
    guideId: 'host2',
    guideName: 'Sita Devi',
    isFeatured: true,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 20)),
    updatedAt: DateTime.now(),
    includes: ['Guide', 'Water bottle'],
  ),
  Experience(
    id: '3',
    title: 'Bodh Gaya Spiritual Retreat',
    description: 'A day of meditation and visiting the Mahabodhi Temple.',
    shortDescription: 'Full day meditation and temple visit in Bodh Gaya.',
    location: 'Bodh Gaya, Bihar',
    latitude: 24.69,
    longitude: 84.99,
    price: 2500.0,
    duration: 6,
    maxGroupSize: 8,
    images: ['https://images.unsplash.com/photo-1545378889-a8e6e2df4738?w=800'],
    category: 'Spiritual',
    rating: 4.9,
    reviewCount: 210,
    guideId: 'host3',
    guideName: 'Monk Tenzin',
    isFeatured: true,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 60)),
    updatedAt: DateTime.now(),
    includes: ['Lunch', 'Entry fees', 'Meditation session'],
  ),
  Experience(
    id: '4',
    title: 'Madhubani Art Workshop',
    description:
        'Learn the traditional art of Madhubani painting from local artisans.',
    shortDescription: 'Hands-on Madhubani painting workshop.',
    location: 'Madhubani, Bihar',
    latitude: 26.35,
    longitude: 86.08,
    price: 1500.0,
    duration: 4,
    maxGroupSize: 5,
    images: [
      'https://images.unsplash.com/photo-1628155930542-41314a58c61c?w=800',
    ],
    category: 'Art & Culture',
    rating: 4.7,
    reviewCount: 65,
    guideId: 'host4',
    guideName: 'Tara Jha',
    isFeatured: false,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 15)),
    updatedAt: DateTime.now(),
    includes: ['Art supplies', 'Snacks', 'Painting to take home'],
  ),
];

// Experience list provider
final experiencesProvider = StreamProvider<List<Experience>>((ref) {
  // Mock data stream
  return Stream.value(_mockExperiences);
});

// Featured experiences provider
final featuredExperiencesProvider = StreamProvider<List<Experience>>((ref) {
  return Stream.value(_mockExperiences.where((e) => e.isFeatured).toList());
});

// Experiences by category provider
final experiencesByCategoryProvider =
    StreamProvider.family<List<Experience>, String>((ref, category) {
      return Stream.value(
        _mockExperiences.where((e) => e.category == category).toList(),
      );
    });

// Single experience provider
final experienceProvider = FutureProvider.family<Experience?, String>((
  ref,
  id,
) async {
  await Future.delayed(const Duration(milliseconds: 500)); // Mock network delay
  try {
    return _mockExperiences.firstWhere((e) => e.id == id);
  } catch (e) {
    return null;
  }
});

// Search experiences provider
final searchQueryProvider = StateProvider<String>((ref) => '');
final selectedCategoryProvider = StateProvider<String?>((ref) => null);
final priceRangeProvider = StateProvider<RangeValues>(
  (ref) => const RangeValues(0, 50000),
);
final ratingFilterProvider = StateProvider<double>((ref) => 0);

final searchedExperiencesProvider = Provider<AsyncValue<List<Experience>>>((
  ref,
) {
  final allExperiences = ref.watch(experiencesProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final category = ref.watch(selectedCategoryProvider);
  final priceRange = ref.watch(priceRangeProvider);
  final minRating = ref.watch(ratingFilterProvider);

  return allExperiences.whenData((experiences) {
    return experiences.where((exp) {
      // Search query filter
      if (query.isNotEmpty) {
        final matchesQuery =
            exp.title.toLowerCase().contains(query) ||
            exp.description.toLowerCase().contains(query) ||
            exp.location.toLowerCase().contains(query);
        if (!matchesQuery) return false;
      }

      // Category filter
      if (category != null &&
          exp.category.toLowerCase() != category.toLowerCase()) {
        return false;
      }

      // Price filter
      if (exp.price < priceRange.start || exp.price > priceRange.end) {
        return false;
      }

      // Rating filter
      if (exp.rating < minRating) {
        return false;
      }

      return true;
    }).toList();
  });
});

// Experience notifier for CRUD operations (Mocked)
class ExperienceNotifier extends StateNotifier<AsyncValue<void>> {
  ExperienceNotifier() : super(const AsyncValue.data(null));

  Future<String?> createExperience(Experience experience) async {
    state = const AsyncValue.loading();
    try {
      await Future.delayed(const Duration(seconds: 1));
      _mockExperiences.add(
        experience.copyWith(
          id: 'mock_new_${DateTime.now().millisecondsSinceEpoch}',
        ),
      );
      state = const AsyncValue.data(null);
      return 'mock_new_id';
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<void> updateExperience(Experience experience) async {
    state = const AsyncValue.loading();
    try {
      await Future.delayed(const Duration(seconds: 1));
      final index = _mockExperiences.indexWhere((e) => e.id == experience.id);
      if (index != -1) {
        _mockExperiences[index] = experience.copyWith(
          updatedAt: DateTime.now(),
        );
      }
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteExperience(String id) async {
    state = const AsyncValue.loading();
    try {
      await Future.delayed(const Duration(seconds: 1));
      _mockExperiences.removeWhere((e) => e.id == id);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleFeatured(String id, bool isFeatured) async {
    try {
      final index = _mockExperiences.indexWhere((e) => e.id == id);
      if (index != -1) {
        _mockExperiences[index] = _mockExperiences[index].copyWith(
          isFeatured: isFeatured,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}

final experienceNotifierProvider =
    StateNotifierProvider<ExperienceNotifier, AsyncValue<void>>((ref) {
      return ExperienceNotifier();
    });

// Categories provider
final categoriesProvider = Provider<List<Category>>((ref) {
  return Category.defaultCategories;
});
