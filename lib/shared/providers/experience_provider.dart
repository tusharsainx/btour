import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';
import '../../core/constants/app_constants.dart';
import 'auth_provider.dart';
import 'city_provider.dart';

// Mock Data - Extended for all cities
final _mockExperiences = [
  // Patna Experiences
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
    id: '5',
    title: 'Patna Museum Heritage Tour',
    description:
        'Explore the rich artifacts at Patna Museum including Buddhist sculptures.',
    shortDescription: 'Guided tour of Patna Museum.',
    location: 'Patna, Bihar',
    latitude: 25.61,
    longitude: 85.15,
    price: 600.0,
    duration: 3,
    maxGroupSize: 20,
    images: [
      'https://images.unsplash.com/photo-1566127444979-b3d2b654e3d7?w=800',
    ],
    category: 'Heritage',
    rating: 4.5,
    reviewCount: 89,
    guideId: 'host5',
    guideName: 'Ashok Sharma',
    isFeatured: false,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
    updatedAt: DateTime.now(),
    includes: ['Entry ticket', 'Guide', 'Audio guide'],
  ),
  Experience(
    id: '6',
    title: 'Patna Street Food Walk',
    description:
        'Taste the authentic flavors of Bihar with litti chokha and more.',
    shortDescription: 'Evening street food tour in Patna.',
    location: 'Patna, Bihar',
    latitude: 25.60,
    longitude: 85.13,
    price: 800.0,
    duration: 3,
    maxGroupSize: 8,
    images: [
      'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800',
    ],
    category: 'Food',
    rating: 4.7,
    reviewCount: 156,
    guideId: 'host6',
    guideName: 'Radha Kumari',
    isFeatured: true,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    updatedAt: DateTime.now(),
    includes: ['All food tastings', 'Guide', 'Water'],
  ),
  // Rajgir Experiences
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
    id: '7',
    title: 'Rajgir Hot Springs Experience',
    description:
        'Relax in the natural hot springs with therapeutic properties.',
    shortDescription: 'Hot springs and spa experience in Rajgir.',
    location: 'Rajgir, Bihar',
    latitude: 25.02,
    longitude: 85.41,
    price: 500.0,
    duration: 2,
    maxGroupSize: 10,
    images: [
      'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=800',
    ],
    category: 'Nature',
    rating: 4.4,
    reviewCount: 234,
    guideId: 'host7',
    guideName: 'Vikram Singh',
    isFeatured: false,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 25)),
    updatedAt: DateTime.now(),
    includes: ['Entry fee', 'Towels', 'Refreshments'],
  ),
  Experience(
    id: '8',
    title: 'Vishwa Shanti Stupa Trek',
    description:
        'Trek to the Peace Pagoda and witness stunning views of Rajgir.',
    shortDescription: 'Ropeway and trek to World Peace Stupa.',
    location: 'Rajgir, Bihar',
    latitude: 25.04,
    longitude: 85.43,
    price: 1000.0,
    duration: 4,
    maxGroupSize: 12,
    images: ['https://images.unsplash.com/photo-1551632811-561732d1e306?w=800'],
    category: 'Adventure',
    rating: 4.8,
    reviewCount: 178,
    guideId: 'host8',
    guideName: 'Priya Gupta',
    isFeatured: true,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 12)),
    updatedAt: DateTime.now(),
    includes: ['Guide', 'Ropeway ticket', 'Snacks'],
  ),
  // Bodh Gaya Experiences
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
    id: '9',
    title: 'Mahabodhi Temple Tour',
    description:
        'Explore the UNESCO World Heritage Site where Buddha attained enlightenment.',
    shortDescription: 'Guided tour of the sacred Mahabodhi Temple.',
    location: 'Bodh Gaya, Bihar',
    latitude: 24.70,
    longitude: 85.00,
    price: 800.0,
    duration: 3,
    maxGroupSize: 15,
    images: ['https://images.unsplash.com/photo-1544735716-392fe2489ffa?w=800'],
    category: 'Spiritual',
    rating: 4.9,
    reviewCount: 456,
    guideId: 'host9',
    guideName: 'Ananda Bhikkhu',
    isFeatured: true,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 45)),
    updatedAt: DateTime.now(),
    includes: ['Guide', 'Temple entry', 'Prasad'],
  ),
  Experience(
    id: '10',
    title: 'Buddhist Monastery Trail',
    description:
        'Visit international monasteries representing Buddhist cultures worldwide.',
    shortDescription: 'Tour of international monasteries in Bodh Gaya.',
    location: 'Bodh Gaya, Bihar',
    latitude: 24.68,
    longitude: 84.98,
    price: 1200.0,
    duration: 5,
    maxGroupSize: 12,
    images: [
      'https://images.unsplash.com/photo-1591018653367-7ec9d1a4d6c5?w=800',
    ],
    category: 'Cultural',
    rating: 4.7,
    reviewCount: 123,
    guideId: 'host10',
    guideName: 'Dr. Surya Das',
    isFeatured: false,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 35)),
    updatedAt: DateTime.now(),
    includes: ['Guide', 'Transport', 'Lunch'],
  ),
  // Nalanda Experiences
  Experience(
    id: '11',
    title: 'Nalanda University Ruins Exploration',
    description:
        'Walk through the ancient Nalanda University, a center of learning.',
    shortDescription: 'Explore the ruins of ancient Nalanda University.',
    location: 'Nalanda, Bihar',
    latitude: 25.14,
    longitude: 85.44,
    price: 700.0,
    duration: 3,
    maxGroupSize: 20,
    images: [
      'https://images.unsplash.com/photo-1582719508461-905c673771fd?w=800',
    ],
    category: 'Heritage',
    rating: 4.6,
    reviewCount: 345,
    guideId: 'host11',
    guideName: 'Prof. Kumar',
    isFeatured: true,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 50)),
    updatedAt: DateTime.now(),
    includes: ['Entry ticket', 'Guide', 'Museum visit'],
  ),
  Experience(
    id: '12',
    title: 'Nalanda Archaeological Museum',
    description: 'Discover ancient Buddhist artifacts and manuscripts.',
    shortDescription: 'Comprehensive museum tour in Nalanda.',
    location: 'Nalanda, Bihar',
    latitude: 25.13,
    longitude: 85.45,
    price: 400.0,
    duration: 2,
    maxGroupSize: 25,
    images: [
      'https://images.unsplash.com/photo-1580477667995-2b94f01c9516?w=800',
    ],
    category: 'Heritage',
    rating: 4.5,
    reviewCount: 189,
    guideId: 'host12',
    guideName: 'Dr. Maya Singh',
    isFeatured: false,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 40)),
    updatedAt: DateTime.now(),
    includes: ['Entry ticket', 'Audio guide'],
  ),
  // Vaishali Experiences
  Experience(
    id: '13',
    title: 'Vaishali Historical Tour',
    description:
        'Visit the birthplace of democracy and important Buddhist sites.',
    shortDescription: 'Full day historical tour of Vaishali.',
    location: 'Vaishali, Bihar',
    latitude: 25.98,
    longitude: 85.13,
    price: 1500.0,
    duration: 6,
    maxGroupSize: 15,
    images: [
      'https://images.unsplash.com/photo-1599030989927-a97c2a0ee8a3?w=800',
    ],
    category: 'Heritage',
    rating: 4.7,
    reviewCount: 98,
    guideId: 'host13',
    guideName: 'Historians Team',
    isFeatured: true,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 22)),
    updatedAt: DateTime.now(),
    includes: ['Guide', 'Transport', 'Lunch', 'All entries'],
  ),
  Experience(
    id: '14',
    title: 'Ashoka Pillar Visit',
    description:
        'See the famous Ashoka Pillar and learn about Mauryan history.',
    shortDescription: 'Visit to the Ashoka Pillar in Vaishali.',
    location: 'Vaishali, Bihar',
    latitude: 25.99,
    longitude: 85.12,
    price: 500.0,
    duration: 2,
    maxGroupSize: 20,
    images: ['https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800'],
    category: 'Heritage',
    rating: 4.4,
    reviewCount: 156,
    guideId: 'host14',
    guideName: 'Local Guide',
    isFeatured: false,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 18)),
    updatedAt: DateTime.now(),
    includes: ['Guide', 'Entry fee'],
  ),
  // Madhubani (Additional)
  Experience(
    id: '4',
    title: 'Madhubani Art Workshop',
    description:
        'Learn the traditional art of Madhubani painting from local artisans.',
    shortDescription: 'Hands-on Madhubani painting workshop.',
    location: 'Patna, Bihar', // Changed to Patna for availability
    latitude: 25.60,
    longitude: 85.13,
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

/// Helper function to extract city name from location string
String _getCityFromLocation(String location) {
  // Location format is "City, Bihar"
  final parts = location.split(',');
  if (parts.isNotEmpty) {
    return parts[0].trim();
  }
  return location;
}

// Experience list provider (all experiences)
final experiencesProvider = StreamProvider<List<Experience>>((ref) {
  // Mock data stream
  return Stream.value(_mockExperiences);
});

// Filtered experiences by selected city
final filteredExperiencesProvider = Provider<AsyncValue<List<Experience>>>((
  ref,
) {
  final allExperiences = ref.watch(experiencesProvider);
  final selectedCity = ref.watch(selectedCityNameProvider);

  return allExperiences.whenData((experiences) {
    return experiences.where((exp) {
      final expCity = _getCityFromLocation(exp.location);
      return expCity.toLowerCase() == selectedCity.toLowerCase();
    }).toList();
  });
});

// Featured experiences provider (filtered by city)
final featuredExperiencesProvider = StreamProvider<List<Experience>>((ref) {
  final selectedCity = ref.watch(selectedCityNameProvider);

  final filtered = _mockExperiences.where((e) {
    final expCity = _getCityFromLocation(e.location);
    return e.isFeatured && expCity.toLowerCase() == selectedCity.toLowerCase();
  }).toList();

  return Stream.value(filtered);
});

// All featured experiences (not filtered by city)
final allFeaturedExperiencesProvider = StreamProvider<List<Experience>>((ref) {
  return Stream.value(_mockExperiences.where((e) => e.isFeatured).toList());
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
