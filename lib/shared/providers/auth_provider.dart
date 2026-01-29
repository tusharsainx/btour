import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

// Auth Repository Provider
import 'package:BTour/features/auth/data/auth_repository_impl.dart';
import 'package:BTour/features/auth/domain/auth_repository.dart';
import 'package:BTour/features/auth/domain/session_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

// Auth state provider (Mocked)
final authStateProvider = StreamProvider<User?>((ref) {
  return const Stream.empty();
});

// Current user provider
final currentUserProvider = Provider<AsyncValue<UserModel?>>((ref) {
  return ref.watch(authNotifierProvider);
});

// Guest mode provider
final isGuestModeProvider = StateProvider<bool>((ref) => false);

// Biometric checks provider
final isBiometricEnabledProvider = FutureProvider<bool>((ref) async {
  final repo = ref.watch(authRepositoryProvider);
  return await repo.isBiometricEnabled();
});

// Auth notifier for authentication actions
class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthRepository _repository;
  final Ref _ref;

  AuthNotifier(this._repository, this._ref)
    : super(const AsyncValue.loading()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      // Force user to login again on app launch to verify biometric/otp
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<UserModel?> signUp({
    required String name,
    required String email,
    required String phone,
    bool shouldUpdateState = true,
  }) async {
    if (shouldUpdateState) state = const AsyncValue.loading();
    try {
      final newUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        phoneNumber: phone,
        createdAt: DateTime.now(),
        emailVerified: true,
        phoneVerified: true,
        biometricEnabled: false,
      );

      await _repository.saveUser(newUser);

      if (shouldUpdateState) {
        await _repository.saveSession(
          SessionModel(isLoggedIn: true, lastLoginTime: DateTime.now()),
        );
        state = AsyncValue.data(newUser);
      }
      return newUser;
    } catch (e, st) {
      if (shouldUpdateState) state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<void> completeSignup(UserModel user) async {
    await _repository.saveSession(
      SessionModel(isLoggedIn: true, lastLoginTime: DateTime.now()),
    );
    state = AsyncValue.data(user);
  }

  Future<void> enableBiometrics({UserModel? user}) async {
    final currentUser = user ?? state.value;
    if (currentUser == null) return;

    try {
      // Authenticate first just to be sure (os-level)
      final success = await _repository.authenticateBiometric();
      if (success) {
        final updatedUser = currentUser.copyWith(biometricEnabled: true);
        await _repository.saveUser(updatedUser);
        await _repository.setBiometricEnabled(true);

        // Save session
        await _repository.saveSession(
          SessionModel(isLoggedIn: true, lastLoginTime: DateTime.now()),
        );

        state = AsyncValue.data(updatedUser);
      }
    } catch (e) {
      // Ignore or handle
    }
  }

  Future<bool> loginWithBiometrics() async {
    state = const AsyncValue.loading();
    try {
      final success = await _repository.authenticateBiometric();
      if (success) {
        final user = await _repository.getUser();
        await _repository.saveSession(
          SessionModel(isLoggedIn: true, lastLoginTime: DateTime.now()),
        );
        state = AsyncValue.data(user);
        return true;
      } else {
        // Biometric failed/cancelled, revert to not logged in
        state = const AsyncValue.data(null);
        return false;
      }
    } catch (e, st) {
      // On error, also revert to not logged in (to allow OTP fallback)
      // state = AsyncValue.error(e, st);
      // Actually, cleaner to just be "not logged in" for the UI's sake
      state = const AsyncValue.data(null);
      return false;
    }
  }

  Future<void> loginWithOtp(String contact) async {
    state = const AsyncValue.loading();
    try {
      // Assume OTP verified by UI/Repository calls before this final login step
      final user = await _repository.getUser();
      // Ensure the user matches the contact if needed, but for local-first single user:
      if (user != null) {
        await _repository.saveSession(
          SessionModel(isLoggedIn: true, lastLoginTime: DateTime.now()),
        );
        state = AsyncValue.data(user);
      } else {
        throw Exception("User not found");
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    await _repository.clearSession();
    // We don't delete the user on sign out, just session
    state = const AsyncValue.data(
      null,
    ); // Wait, if we set null, app might redirect to Signup?
    // "If no user exists -> go to Signup Flow".
    // If user exists but logged out -> Login Flow.
    // So we should probably keep the user in state but maybe mark as not logged in?
    // But AsyncValue<UserModel?> usually implies "Current Logged In User".
    // If I set it to null, router sees "!isLoggedIn" (auth_provider.dart line 69: value != null).
    // And "If no user exists -> go to Signup Flow" vs "If user exists... Login Flow".
    // The Router logic currently checks `isLoggedIn`.

    // Implementation Detail:
    // If I return `null` here, Router sends to `/login` (because `!isLoggedIn`).
    // The `/login` screen should then check if a User exists in Repository to decide
    // whether to show "Welcome back, [Name]" or "Create Account"?
    // OR the Router redirects to `/signup` if no user exists in Repo?

    // I will set state to null to trigger "Logged Out" state.
    state = const AsyncValue.data(null);
  }

  // Methods for OTP
  Future<String> sendOtp(String contact) => _repository.sendOtp(contact);
  Future<bool> verifyOtp(String otp) => _repository.verifyOtp(otp);
  Future<UserModel?> getLocalUser() => _repository.getUser();
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
      final repo = ref.watch(authRepositoryProvider);
      return AuthNotifier(repo, ref);
    });
