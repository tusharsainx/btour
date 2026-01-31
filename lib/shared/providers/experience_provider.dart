import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';
import '../../core/constants/app_constants.dart';
import 'auth_provider.dart';
import 'city_provider.dart';

// Mock Data - Extended for all cities
final _mockExperiences = [
  // --- PATNA EXPERIENCES ---

  // Patna - Spiritual
  Experience(
    id: 'pat_spiritual_1',
    title: 'Takht Sri Patna Sahib Heritage Tour',
    description:
        'Visit one of the holiest Takhats in Sikhism, birthplace of Guru Gobind Singh Ji. Experience the spiritual atmosphere and community kitchen (Langar). Includes guided heritage walk.',
    shortDescription:
        'Guided tour of the holy birthplace of Guru Gobind Singh Ji.',
    location: 'Patna, Bihar',
    latitude: 25.61,
    longitude: 85.22,
    price: 1200.0,
    duration: 2,
    maxGroupSize: 50,
    images: [
      'https://s7ap1.scene7.com/is/image/incredibleindia/takht-sri-patna-sahib-patna2-bihar-attr-hero?qlt=82&ts=1742168018932',
    ],
    category: 'Spiritual',
    rating: 4.9,
    reviewCount: 320,
    guideId: 'host_pat_1',
    guideName: 'Gurdeep Singh',
    isFeatured: true,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 60)),
    updatedAt: DateTime.now(),
    includes: ['Guided Tour', 'Langar (Community Meal)', 'Sikh History Book'],
    requirements: ['Head covering required', 'Modest clothing'],
  ),
  Experience(
    id: 'pat_spiritual_2',
    title: 'Mahavir Mandir Special Darshan',
    description:
        'Seek blessings at the famous Mahavir Mandir, dedicated to Lord Hanuman. Includes special access and prasad package.',
    shortDescription:
        'Divine darshan at the famous Hanuman temple with special prasad.',
    location: 'Patna, Bihar',
    latitude: 25.61,
    longitude: 85.13,
    price: 1100.0,
    duration: 1,
    maxGroupSize: 50,
    images: [
      'https://s7ap1.scene7.com/is/image/incredibleindia/mahavir-mandir-patna-bihar-patna1-bihar-attr-hero?qlt=82&ts=1742174294077',
    ],
    category: 'Spiritual',
    rating: 4.8,
    reviewCount: 450,
    guideId: 'host_pat_2',
    guideName: 'Temple Trust',
    isFeatured: true,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 55)),
    updatedAt: DateTime.now(),
    includes: ['Special Queue Entry', 'Premium Prasad Box', 'Flower Garland'],
  ),
  Experience(
    id: 'pat_spiritual_3',
    title: 'Buddha Smriti Park Meditation',
    description:
        'A serene park dedicated to Lord Buddha, featuring a meditation center and holy relics. A perfect place for peace and reflection with guided session.',
    shortDescription: 'Meditation and serenity at Buddha Smriti Park.',
    location: 'Patna, Bihar',
    latitude: 25.61,
    longitude: 85.13,
    price: 1000.0,
    duration: 2,
    maxGroupSize: 20,
    images: [
      'https://s7ap1.scene7.com/is/image/incredibleindia/buddha-smriti-park-patna-bihar-1-new-attr-hero?qlt=82&ts=1742161848656',
    ],
    category: 'Spiritual',
    rating: 4.6,
    reviewCount: 120,
    guideId: 'host_pat_3',
    guideName: 'Park Guide',
    isFeatured: false,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    updatedAt: DateTime.now(),
    includes: ['Entry Ticket', 'Museum Visit', 'Meditation Guide'],
  ),

  // Patna - Heritage
  Experience(
    id: 'pat_heritage_1',
    title: 'Golghar & City Panorama Tour',
    description:
        'Climb the historic Golghar, a massive granary built by the British in 1786. Enjoy panoramic views of Patna and the Ganges from the top.',
    shortDescription: 'Panoramic views from the historic Golghar.',
    location: 'Patna, Bihar',
    latitude: 25.61,
    longitude: 85.14,
    price: 1000.0,
    duration: 2,
    maxGroupSize: 30,
    images: [
      'https://s7ap1.scene7.com/is/image/incredibleindia/gol-ghar-patna-bihar-1-attr-hero?qlt=82&ts=1742165922608',
    ],
    category: 'Heritage',
    rating: 4.5,
    reviewCount: 280,
    guideId: 'host_pat_4',
    guideName: 'Ravi Kumar',
    isFeatured: true,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 100)),
    updatedAt: DateTime.now(),
    includes: ['Entry Ticket', 'History Pamphlet', 'Binoculars Viewing'],
  ),
  Experience(
    id: 'pat_heritage_2',
    title: 'Patna Museum History Walk',
    description:
        'Explore the rich history of Bihar at the Patna Museum. See ancient artifacts, the Yakshi statue, and the fossilized tree with an expert historian.',
    shortDescription: 'Guided tour of the magnificent Patna Museum.',
    location: 'Patna, Bihar',
    latitude: 25.61,
    longitude: 85.13,
    price: 1200.0,
    duration: 3,
    maxGroupSize: 15,
    images: [
      'https://cdnbbsr.s3waas.gov.in/s337d097caf1299d9aa79c2c2b843d2d78/uploads/2019/09/2023012053.jpg',
    ],
    category: 'Heritage',
    rating: 4.6,
    reviewCount: 150,
    guideId: 'host_pat_5',
    guideName: 'Dr. A. Singh',
    isFeatured: false,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 45)),
    updatedAt: DateTime.now(),
    includes: ['Entry Ticket', 'Expert Guide', 'Audio Guide'],
  ),
  Experience(
    id: 'pat_heritage_3',
    title: 'Kumhrar Mauryan Ruins Walk',
    description:
        'Step back in time at the ruins of Pataliputra. See the remains of the 80-pillared hall from the Mauryan era with archeological insights.',
    shortDescription: 'Explore the ancient Mauryan ruins at Kumhrar.',
    location: 'Patna, Bihar',
    latitude: 25.59,
    longitude: 85.18,
    price: 1100.0,
    duration: 2,
    maxGroupSize: 25,
    images: [
      'https://images.indianexpress.com/2024/12/pillar.of-Kumhrar-Excavation-06-1.jpg',
    ],
    category: 'Heritage',
    rating: 4.3,
    reviewCount: 90,
    guideId: 'host_pat_6',
    guideName: 'ASI Guide',
    isFeatured: false,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 90)),
    updatedAt: DateTime.now(),
    includes: ['Entry Ticket', 'Park Access', 'Archeological Guide'],
  ),

  // Patna - Food
  Experience(
    id: 'pat_food_1',
    title: 'Premium Bihari Cuisine Tasting',
    description:
        'Savor the taste of Bihar with authentic Litti Chokha, baked over coal and served with ghee, baingan bharta, and tomato chutney in a traditional setting.',
    shortDescription: 'Delicious traditional Litti Chokha experience.',
    location: 'Patna, Bihar',
    latitude: 25.61,
    longitude: 85.13,
    price: 1500.0,
    duration: 1,
    maxGroupSize: 10,
    images: [
      'https://www.secondrecipe.com/wp-content/uploads/2019/11/litti-chokha-1.jpg',
    ],
    category: 'Food',
    rating: 4.9,
    reviewCount: 500,
    guideId: 'host_pat_7',
    guideName: 'Raju Litti Bhandar',
    isFeatured: true,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 20)),
    updatedAt: DateTime.now(),
    includes: ['Full 3-Course Meal', 'Unlimited Ghee', 'Traditional Drink'],
  ),
  Experience(
    id: 'pat_food_2',
    title: 'Maurya Lok Food Walk',
    description:
        'Dive into the bustling street food scene at Maurya Lok. Try Chaat, Puchka, Momos, and the famous South Indian delights with a local food blogger.',
    shortDescription: 'Evening street food tour at Maurya Lok.',
    location: 'Patna, Bihar',
    latitude: 25.61,
    longitude: 85.13,
    price: 1500.0,
    duration: 2,
    maxGroupSize: 8,
    images: [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6TAY2G2FgwGrLm67QeJLaCT-crOFjDsSrgg&s',
    ],
    category: 'Food',
    rating: 4.7,
    reviewCount: 210,
    guideId: 'host_pat_8',
    guideName: 'Foodie Priya',
    isFeatured: false,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 15)),
    updatedAt: DateTime.now(),
    includes: ['5 Food Tastings', 'Guide', 'Dessert'],
  ),
  Experience(
    id: 'pat_food_3',
    title: 'Ganga Floating Restaurant',
    description:
        'Enjoy a premium dining experience on a floating restaurant on the Ganges River. Fine dining with a view.',
    shortDescription: 'Dinner on the waves of the Ganges.',
    location: 'Patna, Bihar',
    latitude: 25.62,
    longitude: 85.14,
    price: 2000.0,
    duration: 2,
    maxGroupSize: 4,
    images: [
      "https://i0.wp.com/www.gktoday.in/wp-content/uploads/2023/02/mv-ganga-vihar.png?fit=300%2C169&ssl=1",
    ],
    category: 'Food',
    rating: 4.5,
    reviewCount: 85,
    guideId: 'host_pat_9',
    guideName: 'MV Ganga Vihar',
    isFeatured: true,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 25)),
    updatedAt: DateTime.now(),
    includes: ['Dinner Buffet', 'Cruise Ticket', 'Live Music'],
  ),

  // Patna - Nature
  Experience(
    id: 'pat_nature_1',
    title: 'Private Sunrise Boat Safari',
    description:
        'Witness the magical sunrise at the ghats of Patna. Take a private boat ride as the city wakes up, with tea and breakfast on board.',
    shortDescription: 'Peaceful sunrise experience by the Ganges.',
    location: 'Patna, Bihar',
    latitude: 25.62,
    longitude: 85.15,
    price: 2000.0,
    duration: 2,
    maxGroupSize: 6,
    images: [
      "https://tripcosmos.co/wp-content/uploads/2024/08/sunrise-boat-ride-varanasi.jpg.webp",
    ],
    category: 'Nature',
    rating: 4.8,
    reviewCount: 340,
    guideId: 'host_pat_10',
    guideName: 'Boatman Ramu',
    isFeatured: true,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
    updatedAt: DateTime.now(),
    includes: ['Private Boat', 'Morning Tea', 'Breakfast Box'],
  ),
  Experience(
    id: 'pat_nature_2',
    title: 'Patna Zoo Photography Tour',
    description:
        'Explore one of India\'s best zoos. See the rhinos, tigers, and a vast botanical garden. Perfect for families and photographers.',
    shortDescription: 'Day out at Patna Zoo and Botanical Garden.',
    location: 'Patna, Bihar',
    latitude: 25.59,
    longitude: 85.09,
    price: 1200.0,
    duration: 4,
    maxGroupSize: 100,
    images: [
      "https://www.travelbaits.in/wp-content/uploads/2019/08/Travelbaits_Patna-Zoo-600x315-cropped.jpeg",
    ],
    category: 'Nature',
    rating: 4.6,
    reviewCount: 410,
    guideId: 'host_pat_11',
    guideName: 'Zoo Guide',
    isFeatured: false,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 100)),
    updatedAt: DateTime.now(),
    includes: ['Entry Ticket', 'Toy Train Ride', 'Guide'],
  ),
  Experience(
    id: 'pat_nature_3',
    title: 'Eco Park Wellness Retreat',
    description:
        'Relax in the lush greenery of Rajdhani Vatika (Eco Park). Enjoy the lakes, sculptures, and a guided yoga session.',
    shortDescription: 'Relaxing evening at Eco Park.',
    location: 'Patna, Bihar',
    latitude: 25.60,
    longitude: 85.11,
    price: 1000.0,
    duration: 2,
    maxGroupSize: 50,
    images: [
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRgBAugE1YiIcCeweQ2ZFjc9m5N2jKxXngN5Q&s",
    ],
    category: 'Nature',
    rating: 4.5,
    reviewCount: 220,
    guideId: 'host_pat_12',
    guideName: 'Yoga Instructor',
    isFeatured: false,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 80)),
    updatedAt: DateTime.now(),
    includes: ['Entry Ticket', 'Yoga Mat Rental', 'Health Drink'],
  ),

  // Patna - Adventure
  Experience(
    id: 'pat_adventure_1',
    title: 'Exclusive Dolphin Safari',
    description:
        'Take a specialized boat ride to spot the endangered Gangetic River Dolphins. A unique wildlife adventure with a naturalist.',
    shortDescription: 'Spotting Gangetic Dolphins in the river.',
    location: 'Patna, Bihar',
    latitude: 25.62,
    longitude: 85.16,
    price: 2500.0,
    duration: 2,
    maxGroupSize: 6,
    images: [
      "https://blissfulbihar.com/wp-content/uploads/2023/09/gangetic-dolphin-watching.webp",
    ],
    category: 'Adventure',
    rating: 4.6,
    reviewCount: 75,
    guideId: 'host_pat_13',
    guideName: 'Naturalist Manoj',
    isFeatured: true,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    updatedAt: DateTime.now(),
    includes: ['Private Boat', 'Binoculars', 'Expert Guide'],
  ),
  Experience(
    id: 'pat_adventure_2',
    title: 'Funtasia Water Park VIP Package',
    description:
        'Beat the heat with exciting water slides and wave pools at Funtasia Island. Includes express entry and locker.',
    shortDescription: 'Water slides and fun at Funtasia Island.',
    location: 'Patna, Bihar',
    latitude: 25.56,
    longitude: 85.06,
    price: 1800.0,
    duration: 5,
    maxGroupSize: 20,
    images: [
      "https://d26dp53kz39178.cloudfront.net/media/uploads/products/Waterpark-2_bz297ul.jpg",
    ],
    category: 'Adventure',
    rating: 4.4,
    reviewCount: 180,
    guideId: 'host_pat_14',
    guideName: 'Park Staff',
    isFeatured: false,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 120)),
    updatedAt: DateTime.now(),
    includes: ['Express Entry Ticket', 'Locker access', 'Lunch Coupon'],
  ),
  Experience(
    id: 'pat_adventure_3',
    title: 'Grand Prix Karting Experience',
    description:
        'Experience the thrill of speed with Go-Karting tracks available in the city. Compete with friends and family in a championship format.',
    shortDescription: 'High speed Go-Karting action.',
    location: 'Patna, Bihar',
    latitude: 25.60,
    longitude: 85.10,
    price: 1500.0,
    duration: 1,
    maxGroupSize: 8,
    images: [
      "https://d3lzcn6mbbadaf.cloudfront.net/media/details/ANI-20231024061312.jpg",
    ],
    category: 'Adventure',
    rating: 4.3,
    reviewCount: 95,
    guideId: 'host_pat_15',
    guideName: 'Kart Zone',
    isFeatured: false,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 60)),
    updatedAt: DateTime.now(),
    includes: ['10 Laps', 'Safety Gear', 'Lap Timing Sheet'],
  ),

  // Patna - Cultural
  Experience(
    id: 'pat_cultural_1',
    title: 'Bihar Museum Art Tour',
    description:
        'Visit the world-class Bihar Museum, a celebration of the state\'s art and history. The architecture itself is a marvel. Curated tour included.',
    shortDescription: 'Modern art and history at Bihar Museum.',
    location: 'Patna, Bihar',
    latitude: 25.60,
    longitude: 85.11,
    price: 1500.0,
    duration: 3,
    maxGroupSize: 25,
    images: [
      "https://media.assettype.com/businessindia/2024-04/6f058680-d1c3-4be7-a2f7-5ef7c02167a0/Bihar_Museum_2_Custom_opt_AFgzvs2.jpg?w=1200&h=675&auto=format%2Ccompress&fit=max&enlarge=true",
    ],
    category: 'Cultural',
    rating: 4.8,
    reviewCount: 260,
    guideId: 'host_pat_16',
    guideName: 'Senior Curator',
    isFeatured: true,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 35)),
    updatedAt: DateTime.now(),
    includes: ['Entry Ticket', 'Curator Walk', 'Coffee Table Book'],
  ),
  Experience(
    id: 'pat_cultural_2',
    title: 'Handicraft & Souvenir Tour',
    description:
        'Explore local handicrafts, paintings, and handloom at the city\'s art center. A great place to buy souvenirs with a shopping guide.',
    shortDescription: 'Discover Bihari arts and crafts.',
    location: 'Patna, Bihar',
    latitude: 25.61,
    longitude: 85.14,
    price: 1200.0,
    duration: 2,
    maxGroupSize: 20,
    images: [
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQftRO-fEHOxJ2vSYpB0dYeZz9iNVXg-1mBjA&s",
    ],
    category: 'Cultural',
    rating: 4.4,
    reviewCount: 88,
    guideId: 'host_pat_17',
    guideName: 'Local Artisan',
    isFeatured: false,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 18)),
    updatedAt: DateTime.now(),
    includes: ['Entry', 'Discount Coupon', 'Small Souvenir'],
  ),
  Experience(
    id: 'pat_cultural_3',
    title: 'Masterclass Madhubani Workshop',
    description:
        'Learn the intricacies of the world-famous Madhubani painting style from master artists in a hands-on workshop.',
    shortDescription: 'Learn Madhubani painting from experts.',
    location: 'Patna, Bihar',
    latitude: 25.60,
    longitude: 85.13,
    price: 1500.0,
    duration: 3,
    maxGroupSize: 10,
    images: ["https://mithila-art.com/assets/img/slider/gallery-8.jpg"],
    category: 'Cultural',
    rating: 4.9,
    reviewCount: 70,
    guideId: 'host_pat_18',
    guideName: 'Suman Devi',
    isFeatured: true,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
    updatedAt: DateTime.now(),
    includes: ['Professional Art Kit', 'Canvas', 'Refreshments'],
  ),

  // --- RAJGIR EXPERIENCES ---

  // Rajgir - Spiritual
  Experience(
    id: 'raj_spiritual_1',
    title: 'Peace Pagoda & Ropeway Tour',
    description:
        'Visit the majestic World Peace Pagoda atop Ratnagiri Hill. Access it via a thrilling ropeway ride or a trek with a guide.',
    shortDescription: 'World Peace Pagoda atop the hills.',
    location: 'Rajgir, Bihar',
    latitude: 25.03,
    longitude: 85.42,
    price: 1500.0,
    duration: 3,
    maxGroupSize: 15,
    images: [
      "https://vardhmanvacations.com/blog/wp-content/uploads/2025/10/rajgir-ropeway-bihar-1-1024x640.jpg",
    ],
    category: 'Spiritual',
    rating: 4.8,
    reviewCount: 380,
    guideId: 'host_raj_1',
    guideName: 'Buddhist Monk',
    isFeatured: true,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 40)),
    updatedAt: DateTime.now(),
    includes: ['Ropeway Ticket', 'Entry', 'Guide'],
  ),
  Experience(
    id: 'raj_spiritual_2',
    title: 'Spiritual Trek to Vulture Peak',
    description:
        'Meditate at the Vulture Peak, where Lord Buddha delivered many sermons. A spiritually charged location accessible by a gentle trek.',
    shortDescription: 'Meditate at the sacred Vulture Peak.',
    location: 'Rajgir, Bihar',
    latitude: 25.03,
    longitude: 85.43,
    price: 1200.0,
    duration: 2,
    maxGroupSize: 20,
    images: [
      "https://mnmtravels.in/images/blogs/e3718cf00d8abd3210bf77c93aab7550.PNG",
    ],
    category: 'Spiritual',
    rating: 4.9,
    reviewCount: 250,
    guideId: 'host_raj_2',
    guideName: 'Spiritual Guide',
    isFeatured: true,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 35)),
    updatedAt: DateTime.now(),
    includes: ['Guided Meditation', 'Water & Fruits'],
  ),
  Experience(
    id: 'raj_spiritual_3',
    title: 'Ancient Rajgir Temple Tour',
    description:
        'Visit the mysterious Maniyar Math and other local temples. A unique spiritual site dedicated to ancient deities.',
    shortDescription: 'Ancient mysterious temple of Rajgir.',
    location: 'Rajgir, Bihar',
    latitude: 25.02,
    longitude: 85.42,
    price: 1100.0,
    duration: 2,
    maxGroupSize: 15,
    images: [
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWDLteoO5LYfvs2YcrCEKDT_iJ4yVyz2RrOQ&s",
    ],
    category: 'Spiritual',
    rating: 4.3,
    reviewCount: 90,
    guideId: 'host_raj_3',
    guideName: 'Travel Guide',
    isFeatured: false,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 100)),
    updatedAt: DateTime.now(),
    includes: ['Entry Ticket', 'Transport', 'Guide'],
  ),

  // Rajgir - Heritage
  Experience(
    id: 'raj_heritage_1',
    title: 'Cyclopean Wall Heritage Drive',
    description:
        'Marvel at the ancient Cyclopean Wall, a massive stone fortification built over 2500 years ago to protect Rajgir. A private car tour.',
    shortDescription: 'Ancient fortification wall of Rajgir.',
    location: 'Rajgir, Bihar',
    latitude: 25.01,
    longitude: 85.40,
    price: 1500.0,
    duration: 1,
    maxGroupSize: 20,
    images: [
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQxcANudnfi1-KXLFtLOLjTTGgMdlKipmYFHQ&s",
    ],
    category: 'Heritage',
    rating: 4.4,
    reviewCount: 110,
    guideId: 'host_raj_4',
    guideName: 'Historian',
    isFeatured: false,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 150)),
    updatedAt: DateTime.now(),
    includes: ['Private Car', 'History Guide'],
  ),
  Experience(
    id: 'raj_heritage_2',
    title: 'Myths of Son Bhandar Caves',
    description:
        'Enter the mysterious Son Bhandar Caves, believed to hold the treasure of King Bimbisara. Hear legends and see the Jain inscriptions.',
    shortDescription: 'Ancient caves with a legendary treasure.',
    location: 'Rajgir, Bihar',
    latitude: 25.01,
    longitude: 85.41,
    price: 1000.0,
    duration: 1,
    maxGroupSize: 25,
    images: [
      "https://static.toiimg.com/photo/msid-65200298,width-96,height-65.cms",
    ],
    category: 'Heritage',
    rating: 4.5,
    reviewCount: 300,
    guideId: 'host_raj_5',
    guideName: 'Storyteller',
    isFeatured: true,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 60)),
    updatedAt: DateTime.now(),
    includes: ['Entry Ticket', 'Storytelling Session'],
  ),
  Experience(
    id: 'raj_heritage_3',
    title: 'Nalanda Scholar\'s Tour',
    description:
        'A short drive from Rajgir, explore the UNESCO World Heritage site of the ancient Nalanda Mahavihara with an academic guide.',
    shortDescription: 'Ruins of the world\'s first residential university.',
    location: 'Nalanda, Bihar',
    latitude: 25.14,
    longitude: 85.44,
    price: 2000.0,
    duration: 3,
    maxGroupSize: 40,
    images: [
      "https://static.toiimg.com/thumb/109917883/nalanda.jpg?width=1200&height=900",
    ],
    category: 'Heritage',
    rating: 4.9,
    reviewCount: 600,
    guideId: 'host_raj_6',
    guideName: 'Certified Guide',
    isFeatured: true,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 20)),
    updatedAt: DateTime.now(),
    includes: ['Entry Ticket', 'Museum Entry', 'Transport from Rajgir'],
  ),

  // Rajgir - Food
  Experience(
    id: 'raj_food_1',
    title: 'Silao Khaja Making Workshop',
    description:
        'Taste the GI-tagged Silao Khaja, a crispy multi-layered sweet. Visit the makers in Silao and see the process.',
    shortDescription: 'Famous multi-layered sweet of Silao.',
    location: 'Rajgir, Bihar',
    latitude: 25.08,
    longitude: 85.42,
    price: 1000.0,
    duration: 1,
    maxGroupSize: 15,
    images: [
      "https://bulkorder.villkart.com/wp-content/uploads/2022/08/1-1-2-5.png",
    ],
    category: 'Food',
    rating: 4.7,
    reviewCount: 180,
    guideId: 'host_raj_7',
    guideName: 'Sweet Shop Owner',
    isFeatured: true,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 25)),
    updatedAt: DateTime.now(),
    includes: ['Workshop', 'Khaja Box (1kg)', 'Tea'],
  ),
  Experience(
    id: 'raj_food_2',
    title: 'Grand Magadha Thali Feast',
    description:
        'Enjoy a wholesome Bihari Thali at a premium local dhaba, featuring rice, dal, subzi, chokha, and pickles.',
    shortDescription: 'Authentic local lunch experience.',
    location: 'Rajgir, Bihar',
    latitude: 25.02,
    longitude: 85.42,
    price: 1200.0,
    duration: 1,
    maxGroupSize: 20,
    images: [
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/10/e3/44/3b/the-complete-thali.jpg?w=1200&h=1200&s=1",
    ],
    category: 'Food',
    rating: 4.5,
    reviewCount: 120,
    guideId: 'host_raj_8',
    guideName: 'Dhaba Owner',
    isFeatured: false,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 18)),
    updatedAt: DateTime.now(),
    includes: ['Unlimited Thali', 'Dessert', 'Beverage'],
  ),
  Experience(
    id: 'raj_food_3',
    title: 'Luxury Dinner at Indo-Hokke',
    description:
        'A premium dining experience at the Indo-Hokke hotel, offering Japanese and Indian cuisine tailored for pilgrims and tourists.',
    shortDescription: 'Fine dining with Japanese influence.',
    location: 'Rajgir, Bihar',
    latitude: 25.02,
    longitude: 85.41,
    price: 2500.0,
    duration: 2,
    maxGroupSize: 6,
    images: [
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/16/ce/49/e9/caption.jpg?w=500&h=-1&s=1",
    ],
    category: 'Food',
    rating: 4.6,
    reviewCount: 75,
    guideId: 'host_raj_9',
    guideName: 'Hotel Manager',
    isFeatured: false,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    updatedAt: DateTime.now(),
    includes: ['Dinner Buffet', 'Mocktail'],
  ),

  // Rajgir - Nature
  Experience(
    id: 'raj_nature_1',
    title: 'Brahmakund Wellness Retreat',
    description:
        'Take a dip in the therapeutic hot water springs of Brahmakund at the foot of Vaibhava Hill. A rejuvenating experience with relaxation time.',
    shortDescription: 'Therapeutic dip in natural hot springs.',
    location: 'Rajgir, Bihar',
    latitude: 25.01,
    longitude: 85.41,
    price: 1500.0,
    duration: 2,
    maxGroupSize: 50,
    images: [
      "https://www.trawell.in/admin/images/upload/125399242Rajgir_Hot_Springs_Main.jpg",
    ],
    category: 'Nature',
    rating: 4.4,
    reviewCount: 420,
    guideId: 'host_raj_10',
    guideName: 'Local Helper',
    isFeatured: true,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 90)),
    updatedAt: DateTime.now(),
    includes: ['Priority Access', 'Towel Service', 'Massage'],
  ),
  Experience(
    id: 'raj_nature_2',
    title: 'Ghora Katora Boating & Picnic',
    description:
        'Enjoy a peaceful boat ride on the scenic Ghora Katora Lake, surrounded by hills. No fuel vehicles allowed. Includes picnic basket.',
    shortDescription: 'Eco-friendly boating in a scenic lake.',
    location: 'Rajgir, Bihar',
    latitude: 25.05,
    longitude: 85.38,
    price: 1800.0,
    duration: 3,
    maxGroupSize: 10,
    images: [
      "https://blissfulbihar.com/wp-content/uploads/2023/08/Ghora_katora_lake.webp",
    ],
    category: 'Nature',
    rating: 4.7,
    reviewCount: 160,
    guideId: 'host_raj_11',
    guideName: 'Boat Club',
    isFeatured: true,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 45)),
    updatedAt: DateTime.now(),
    includes: ['Boat Ticket', 'E-Rickshaw Ride', 'Picnic Snacks'],
  ),
  Experience(
    id: 'raj_nature_3',
    title: 'Venu Vana Mindfulness Walk',
    description:
        'Walk through the Bamboo Grove (Venu Vana), the first gift of land to Lord Buddha. A tranquil garden for mindfulness.',
    shortDescription: 'Historic bamboo garden and pond.',
    location: 'Rajgir, Bihar',
    latitude: 25.02,
    longitude: 85.41,
    price: 1000.0,
    duration: 1,
    maxGroupSize: 30,
    images: [
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWPIg9VcxbYoNMZWdH0b3R8bhKSU9K3AzF8Q&s",
    ],
    category: 'Nature',
    rating: 4.5,
    reviewCount: 130,
    guideId: 'host_raj_12',
    guideName: 'Garden Keeper',
    isFeatured: false,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 70)),
    updatedAt: DateTime.now(),
    includes: ['Entry Ticket', 'Plant Sapling'],
  ),

  // Rajgir - Adventure
  Experience(
    id: 'raj_adventure_1',
    title: 'Glass Bridge Adventure Combo',
    description:
        'Walk on the thrilling Glass Bridge at Rajgir Nature Safari. Experience the adrenaline rush and explore the suspended bridge.',
    shortDescription: 'Thrilling glass bridge walk.',
    location: 'Rajgir, Bihar',
    latitude: 25.00,
    longitude: 85.35,
    price: 2500.0,
    duration: 3,
    maxGroupSize: 10,
    images: [
      "https://travelstemple.com/wp-content/uploads/2025/11/glass-bridge-rajgir-timings-ticket-price-and-online-booking.jpg",
    ],
    category: 'Adventure',
    rating: 4.8,
    reviewCount: 600,
    guideId: 'host_raj_13',
    guideName: 'Safari Guide',
    isFeatured: true,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
    updatedAt: DateTime.now(),
    includes: ['Entry Ticket', 'Glass Bridge Access', 'Zip Line'],
  ),
  Experience(
    id: 'raj_adventure_2',
    title: 'Ropeway to Peace',
    description:
        'Take the historic ropeway to the top of Ratnagiri Hill. A fun ride with great views of the valley and Cyclopean wall.',
    shortDescription: 'Aerial ropeway ride to Peace Pagoda.',
    location: 'Rajgir, Bihar',
    latitude: 25.03,
    longitude: 85.42,
    price: 1200.0,
    duration: 2,
    maxGroupSize: 4,
    images: [
      'https://upload.wikimedia.org/wikipedia/commons/c/c5/Rope_way_Rajgir.jpg', // Realistic
    ],
    category: 'Adventure',
    rating: 4.6,
    reviewCount: 520,
    guideId: 'host_raj_14',
    guideName: 'Ropeway Operator',
    isFeatured: true,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 100)),
    updatedAt: DateTime.now(),
    includes: ['Priority Ropeway Ticket', 'Binoculars'],
  ),
  Experience(
    id: 'raj_adventure_3',
    title: 'Rajgir Hills Hiking Expedition',
    description:
        'Trek through the hills of Rajgir, exploring hidden ruins and nature trails. Ideal for fitness enthusiasts.',
    shortDescription: 'Guided nature trek in Rajgir hills.',
    location: 'Rajgir, Bihar',
    latitude: 25.02,
    longitude: 85.43,
    price: 1800.0,
    duration: 4,
    maxGroupSize: 8,
    images: [
      'https://images.pexels.com/photos/238622/pexels-photo-238622.jpeg?auto=compress&cs=tinysrgb&w=800', // Hiking
    ],
    category: 'Adventure',
    rating: 4.5,
    reviewCount: 60,
    guideId: 'host_raj_15',
    guideName: 'Adventure Club',
    isFeatured: false,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 20)),
    updatedAt: DateTime.now(),
    includes: ['Expert Guide', 'First Aid', 'Energy Pack'],
  ),

  // Rajgir - Cultural
  Experience(
    id: 'raj_cultural_1',
    title: 'Rajgir Mahotsav VIP Experience',
    description:
        'If visiting in season, witness the vibrant Rajgir Mahotsav featuring classical music, dance, and local arts with VIP seating.',
    shortDescription: 'Cultural festival of music and dance.',
    location: 'Rajgir, Bihar',
    latitude: 25.02,
    longitude: 85.41,
    price: 2000.0,
    duration: 3,
    maxGroupSize: 100,
    images: [
      'https://images.pexels.com/photos/10471257/pexels-photo-10471257.jpeg?auto=compress&cs=tinysrgb&w=800', // Classical dance India
    ],
    category: 'Cultural',
    rating: 4.7,
    reviewCount: 150,
    guideId: 'host_raj_16',
    guideName: 'Tourism Dept',
    isFeatured: false,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 50)),
    updatedAt: DateTime.now(),
    includes: ['VIP Pass', 'Backstage Tour', 'Dinner'],
  ),
  Experience(
    id: 'raj_cultural_2',
    title: 'Artisan Village Life Experience',
    description:
        'Visit nearby villages to see local artisans at work, making bamboo crafts and stone carvings. Learn the craft yourself.',
    shortDescription: 'Village tour and handicraft shopping.',
    location: 'Rajgir, Bihar',
    latitude: 25.04,
    longitude: 85.40,
    price: 1500.0,
    duration: 2,
    maxGroupSize: 10,
    images: [
      'https://images.pexels.com/photos/4553366/pexels-photo-4553366.jpeg?auto=compress&cs=tinysrgb&w=800', // Artisan work
    ],
    category: 'Cultural',
    rating: 4.4,
    reviewCount: 45,
    guideId: 'host_raj_17',
    guideName: 'Village Head',
    isFeatured: false,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 15)),
    updatedAt: DateTime.now(),
    includes: ['Transport', 'Material Costs', 'Tea & Snacks'],
  ),
  Experience(
    id: 'raj_cultural_3',
    title: 'Vipassana & Monastery Visit',
    description:
        'Visit the peaceful Dhamma center. Learn about the technique and see the center. Includes visit to nearby monasteries.',
    shortDescription: 'Visit to Vipassana center and Monasteries.',
    location: 'Rajgir, Bihar',
    latitude: 25.03,
    longitude: 85.40,
    price: 1000.0,
    duration: 2,
    maxGroupSize: 5,
    images: [
      'https://images.pexels.com/photos/3823076/pexels-photo-3823076.jpeg?auto=compress&cs=tinysrgb&w=800', // Meditation
    ],
    category: 'Cultural',
    rating: 4.8,
    reviewCount: 95,
    guideId: 'host_raj_18',
    guideName: 'Center Volunteer',
    isFeatured: false,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 80)),
    updatedAt: DateTime.now(),
    includes: ['Monastery Transport', 'Guide', 'Donation'],
  ),

  // Bodh Gaya Example
  Experience(
    id: 'bodh_1',
    title: 'Mahabodhi Temple Awakening',
    description:
        'Visit the UNESCO World Heritage Mahabodhi Temple, the holiest site in Buddhism. A private spiritual awakening tour.',
    shortDescription: 'The most sacred Buddhist temple.',
    location: 'Bodh Gaya, Bihar',
    latitude: 24.69,
    longitude: 84.99,
    price: 2500.0,
    duration: 3,
    maxGroupSize: 50,
    images: [
      "https://indiaheritagesites.wordpress.com/wp-content/uploads/2013/11/401691607_4c67b40efe_b.jpg",
    ],
    category: 'Spiritual',
    rating: 5.0,
    reviewCount: 900,
    guideId: 'host_bodh_1',
    guideName: 'Temple Guide',
    isFeatured: true,
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 200)),
    updatedAt: DateTime.now(),
    includes: ['VIP Entry', 'Private Guide', 'Souvenir'],
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
  final selectedCity = ref.watch(selectedCityNameProvider);

  return allExperiences.whenData((experiences) {
    return experiences.where((exp) {
      // Filter by City first (Important)
      final expCity = _getCityFromLocation(exp.location);
      if (expCity.toLowerCase() != selectedCity.toLowerCase()) {
        return false;
      }

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
