import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Navigation index for the bottom navigation bar
/// 0 = Home, 1 = Explore, 2 = Bookings, 3 = Profile
final navigationIndexProvider = StateProvider<int>((ref) => 0);
