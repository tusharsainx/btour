import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import '../../core/constants/app_constants.dart';

// Firebase providers
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn.instance;
});

// Auth state provider (Mocked)
final authStateProvider = StreamProvider<User?>((ref) {
  // In mock mode, we don't have a Firebase User object stream.
  // We can return a stream that emits null.
  // Or better, we can listen to our AuthNotifier state.
  return const Stream.empty();
});

// Current user provider
final currentUserProvider = Provider<AsyncValue<UserModel?>>((ref) {
  return ref.watch(authNotifierProvider);
});

// Guest mode provider
final isGuestModeProvider = StateProvider<bool>((ref) => false);

// Auth notifier for authentication actions
class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(const AsyncValue.data(null));

  // Continue as guest
  void continueAsGuest() {
    _ref.read(isGuestModeProvider.notifier).state = true;
  }

  // Exit guest mode (e.g. when logging in)
  void exitGuestMode() {
    _ref.read(isGuestModeProvider.notifier).state = false;
  }

  // Sign up with email and password
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AsyncValue.loading();
    try {
      // Mock delay
      await Future.delayed(const Duration(seconds: 1));

      final user = UserModel(
        id: 'mock_user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        createdAt: DateTime.now(),
        role: 'tourist',
      );

      state = AsyncValue.data(user);
      exitGuestMode();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Sign in with email and password
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      // Mock delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock login success
      final user = UserModel(
        id: 'mock_user_123',
        email: email,
        name: 'Mock User',
        createdAt: DateTime.now(),
        role: 'tourist',
      );

      state = AsyncValue.data(user);
      exitGuestMode();
    } catch (e, st) {
      state = AsyncValue.error('Invalid credentials', st);
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      await Future.delayed(const Duration(seconds: 1));

      final user = UserModel(
        id: 'mock_google_user_123',
        email: 'google@example.com',
        name: 'Google User',
        createdAt: DateTime.now(),
        role: 'tourist',
        photoUrl: 'https://via.placeholder.com/150',
      );

      state = AsyncValue.data(user);
      exitGuestMode();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    state = const AsyncValue.data(null);
    exitGuestMode();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  // Update user profile
  Future<void> updateProfile({
    required String userId,
    String? name,
    String? photoUrl,
    String? phoneNumber,
  }) async {
    try {
      if (state.value != null) {
        state = AsyncValue.data(
          state.value!.copyWith(
            name: name ?? state.value!.name,
            photoUrl: photoUrl ?? state.value!.photoUrl,
            phoneNumber: phoneNumber ?? state.value!.phoneNumber,
            updatedAt: DateTime.now(),
          ),
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
      return AuthNotifier(ref);
    });
