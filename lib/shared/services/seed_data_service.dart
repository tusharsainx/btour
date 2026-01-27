import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';
import '../../core/constants/app_constants.dart';

/// Service to seed sample data into Firestore for testing
class SeedDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> seedExperiences() async {
    final experiences = [
      Experience(
        id: 'exp_1',
        title: 'Bodh Gaya Spiritual Journey',
        description:
            'Experience the profound spirituality of Bodh Gaya, where Buddha attained enlightenment. Visit the Mahabodhi Temple, meditate under the Bodhi Tree, and explore ancient monasteries from various Buddhist traditions.',
        shortDescription:
            'Walk in the footsteps of Buddha at the enlightenment site',
        category: 'Spiritual',
        location: 'Bodh Gaya',
        latitude: 24.6961,
        longitude: 84.9869,
        price: 2500,
        duration: 8,
        maxGroupSize: 15,
        images: [
          'https://images.unsplash.com/photo-1545378889-a8e6e2df4738?w=800',
          'https://images.unsplash.com/photo-1544735716-392fe2489ffa?w=800',
        ],
        guideId: 'guide_1',
        guideName: 'Rajesh Kumar',
        rating: 4.8,
        reviewCount: 124,
        highlights: [
          'Visit the sacred Mahabodhi Temple',
          'Meditate under the Bodhi Tree',
          'Explore international monasteries',
          'Learn about Buddhist philosophy',
        ],
        includes: [
          'Guide service',
          'Temple entry fees',
          'Lunch',
          'Transportation',
        ],
        excludes: ['Personal expenses', 'Tips'],
        isFeatured: true,
        createdAt: DateTime.now(),
      ),
      Experience(
        id: 'exp_2',
        title: 'Nalanda University Heritage Walk',
        description:
            'Explore the ruins of the ancient Nalanda University, one of the world\'s first residential universities. Walk through the archaeological site and learn about the rich academic history of ancient India.',
        shortDescription: 'Discover the ancient seat of learning',
        category: 'Heritage',
        location: 'Nalanda',
        latitude: 25.1357,
        longitude: 85.4438,
        price: 1800,
        duration: 5,
        maxGroupSize: 20,
        images: [
          'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?w=800',
        ],
        guideId: 'guide_2',
        guideName: 'Amit Sharma',
        rating: 4.6,
        reviewCount: 89,
        highlights: [
          'Walk through ancient university ruins',
          'Visit the Nalanda Museum',
          'Learn about Xuanzang\'s journey',
        ],
        includes: ['Expert guide', 'Entry tickets', 'Snacks'],
        isFeatured: true,
        createdAt: DateTime.now(),
      ),
      Experience(
        id: 'exp_3',
        title: 'Patna Street Food Trail',
        description:
            'Taste the authentic flavors of Bihar on this culinary adventure through Patna\'s bustling streets. Sample litti chokha, sattu paratha, khaja, and other local delicacies.',
        shortDescription: 'A gastronomic journey through Bihar cuisine',
        category: 'Food',
        location: 'Patna',
        latitude: 25.5941,
        longitude: 85.1376,
        price: 1200,
        duration: 4,
        maxGroupSize: 10,
        images: [
          'https://images.unsplash.com/photo-1567337710282-00832b415979?w=800',
        ],
        guideId: 'guide_3',
        guideName: 'Priya Singh',
        rating: 4.9,
        reviewCount: 156,
        highlights: [
          'Taste authentic litti chokha',
          'Visit local sweet shops',
          'Learn about Bihari cuisine history',
          'Meet local food vendors',
        ],
        includes: ['All food tastings', 'Water', 'Local guide'],
        isFeatured: true,
        createdAt: DateTime.now(),
      ),
      Experience(
        id: 'exp_4',
        title: 'Rajgir Hills Trek & Hot Springs',
        description:
            'Trek through the scenic hills of Rajgir and experience the natural hot springs. Visit the ancient ruins and enjoy panoramic views from the Griddhakuta Peak.',
        shortDescription: 'Adventure meets spirituality in ancient Rajgir',
        category: 'Nature',
        location: 'Rajgir',
        latitude: 25.0285,
        longitude: 85.4177,
        price: 2000,
        duration: 6,
        maxGroupSize: 12,
        images: [
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
        ],
        guideId: 'guide_1',
        guideName: 'Rajesh Kumar',
        rating: 4.7,
        reviewCount: 78,
        highlights: [
          'Trek to Griddhakuta Peak',
          'Bathe in natural hot springs',
          'Ropeway ride with panoramic views',
        ],
        includes: ['Trekking guide', 'Entry fees', 'Ropeway ticket'],
        isFeatured: false,
        createdAt: DateTime.now(),
      ),
      Experience(
        id: 'exp_5',
        title: 'Ganga Aarti at Patna Ghat',
        description:
            'Witness the mesmerizing Ganga Aarti ceremony at Gandhi Ghat in Patna. Experience the spiritual ambiance as priests perform the ancient ritual with fire lamps.',
        shortDescription: 'Experience the divine evening ceremony',
        category: 'Spiritual',
        location: 'Patna',
        latitude: 25.6093,
        longitude: 85.1376,
        price: 800,
        duration: 2,
        maxGroupSize: 25,
        images: [
          'https://images.unsplash.com/photo-1533669955142-6a73332af4db?w=800',
        ],
        guideId: 'guide_2',
        guideName: 'Amit Sharma',
        rating: 4.5,
        reviewCount: 201,
        highlights: [
          'Watch the Ganga Aarti ceremony',
          'Boat ride on the Ganges',
          'Learn about Hindu rituals',
        ],
        includes: ['Boat ride', 'Aarti materials', 'Guide'],
        isFeatured: true,
        createdAt: DateTime.now(),
      ),
      Experience(
        id: 'exp_6',
        title: 'Village Homestay Experience',
        description:
            'Immerse yourself in authentic rural Bihar life with a homestay in a traditional village. Experience farming activities, local cuisine, and warm hospitality.',
        shortDescription: 'Live the authentic rural Bihar life',
        category: 'Cultural',
        location: 'Vaishali',
        latitude: 25.9854,
        longitude: 85.1282,
        price: 3500,
        duration: 24,
        maxGroupSize: 6,
        images: [
          'https://images.unsplash.com/photo-1530866495561-507c9faab2ed?w=800',
        ],
        guideId: 'guide_3',
        guideName: 'Priya Singh',
        rating: 4.9,
        reviewCount: 45,
        highlights: [
          'Stay in a traditional mud house',
          'Participate in farming activities',
          'Cook local dishes with the family',
          'Evening folk music and dance',
        ],
        includes: [
          'Accommodation',
          'All meals',
          'Activities',
          'Transportation',
        ],
        isFeatured: false,
        createdAt: DateTime.now(),
      ),
    ];

    for (final exp in experiences) {
      await _firestore
          .collection(AppConstants.experiencesCollection)
          .doc(exp.id)
          .set(exp.toJson());
    }
  }

  Future<void> seedGuides() async {
    final guides = [
      Guide(
        id: 'guide_1',
        userId: 'user_guide_1',
        name: 'Rajesh Kumar',
        email: 'rajesh@bihartour.com',
        phoneNumber: '+91 9876543210',
        bio:
            'Born and raised in Bihar, I have been guiding tourists for over 15 years. My specialty is Buddhist heritage sites.',
        languages: ['Hindi', 'English', 'Japanese'],
        specializations: ['Spiritual', 'Heritage'],
        location: 'Bodh Gaya',
        rating: 4.8,
        reviewCount: 203,
        totalTours: 450,
        yearsOfExperience: 15,
        isVerified: true,
        createdAt: DateTime.now(),
      ),
      Guide(
        id: 'guide_2',
        userId: 'user_guide_2',
        name: 'Amit Sharma',
        email: 'amit@bihartour.com',
        phoneNumber: '+91 9876543211',
        bio:
            'History enthusiast and certified heritage guide. I love sharing stories of ancient Bihar with travelers.',
        languages: ['Hindi', 'English'],
        specializations: ['Heritage', 'Spiritual'],
        location: 'Patna',
        rating: 4.6,
        reviewCount: 156,
        totalTours: 320,
        yearsOfExperience: 10,
        isVerified: true,
        createdAt: DateTime.now(),
      ),
      Guide(
        id: 'guide_3',
        userId: 'user_guide_3',
        name: 'Priya Singh',
        email: 'priya@bihartour.com',
        phoneNumber: '+91 9876543212',
        bio:
            'Food blogger turned tour guide. I specialize in culinary tours and cultural experiences.',
        languages: ['Hindi', 'English', 'Bengali'],
        specializations: ['Food', 'Cultural'],
        location: 'Patna',
        rating: 4.9,
        reviewCount: 189,
        totalTours: 280,
        yearsOfExperience: 8,
        isVerified: true,
        createdAt: DateTime.now(),
      ),
    ];

    for (final guide in guides) {
      await _firestore
          .collection(AppConstants.guidesCollection)
          .doc(guide.id)
          .set(guide.toJson());
    }
  }
}
