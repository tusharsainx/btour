import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';
import '../../core/constants/app_constants.dart';
import 'auth_provider.dart';
import 'experience_provider.dart';

// Mock Wishlist
final _mockWishlist = <String>{};

// Wishlist provider
final wishlistProvider = StreamProvider<List<String>>((ref) {
  // Mock data: just stream the current list
  // Ideally this would be updateable, but for StreamProvider we might need a StreamController or just use the Notifier state if we refactor.
  // For now, let's just return what we have (it won't update automatically unless we invalidate).
  return Stream.value(_mockWishlist.toList());
});

// Wishlist experiences provider
final wishlistExperiencesProvider = FutureProvider<List<Experience>>((
  ref,
) async {
  final wishlistIds = ref.watch(wishlistProvider).value ?? [];
  if (wishlistIds.isEmpty) return [];

  final allExperiencesState = ref.watch(experiencesProvider);

  // We need to wait for experiences to load if they are async
  return allExperiencesState.when(
    data: (experiences) {
      return experiences.where((e) => wishlistIds.contains(e.id)).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Check if experience is in wishlist
final isInWishlistProvider = Provider.family<bool, String>((ref, experienceId) {
  final wishlist = ref.watch(wishlistProvider).value ?? [];
  return wishlist.contains(experienceId);
});

// Wishlist notifier
class WishlistNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  WishlistNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> toggleWishlist(String experienceId) async {
    final user = _ref.read(authNotifierProvider).value;
    if (user == null) return;

    try {
      if (_mockWishlist.contains(experienceId)) {
        _mockWishlist.remove(experienceId);
      } else {
        _mockWishlist.add(experienceId);
      }
      // Force refresh of the stream provider is tricky with Stream.value.
      // In a real app we'd use a StreamController.
      // For this mock, functionality might be limited unless we invalidate.
      _ref.invalidate(wishlistProvider);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addToWishlist(String experienceId) async {
    final user = _ref.read(authNotifierProvider).value;
    if (user == null) return;
    _mockWishlist.add(experienceId);
    _ref.invalidate(wishlistProvider);
  }

  Future<void> removeFromWishlist(String experienceId) async {
    final user = _ref.read(authNotifierProvider).value;
    if (user == null) return;
    _mockWishlist.remove(experienceId);
    _ref.invalidate(wishlistProvider);
  }

  Future<void> clearWishlist() async {
    final user = _ref.read(authNotifierProvider).value;
    if (user == null) return;
    _mockWishlist.clear();
    _ref.invalidate(wishlistProvider);
  }
}

final wishlistNotifierProvider =
    StateNotifierProvider<WishlistNotifier, AsyncValue<void>>((ref) {
      return WishlistNotifier(ref);
    });
