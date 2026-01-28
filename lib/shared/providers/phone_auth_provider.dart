import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';

/// Mock OTP for testing
const String mockOtp = '123456';

/// Phone auth state
enum PhoneAuthStatus {
  initial,
  sendingOtp,
  otpSent,
  verifying,
  verified,
  error,
}

class PhoneAuthState {
  final PhoneAuthStatus status;
  final String? phoneNumber;
  final String? generatedOtp;
  final String? error;
  final int resendCountdown;

  const PhoneAuthState({
    this.status = PhoneAuthStatus.initial,
    this.phoneNumber,
    this.generatedOtp,
    this.error,
    this.resendCountdown = 0,
  });

  PhoneAuthState copyWith({
    PhoneAuthStatus? status,
    String? phoneNumber,
    String? generatedOtp,
    String? error,
    int? resendCountdown,
  }) {
    return PhoneAuthState(
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      generatedOtp: generatedOtp ?? this.generatedOtp,
      error: error,
      resendCountdown: resendCountdown ?? this.resendCountdown,
    );
  }

  bool get canResend =>
      resendCountdown == 0 && status == PhoneAuthStatus.otpSent;
  bool get isLoading =>
      status == PhoneAuthStatus.sendingOtp ||
      status == PhoneAuthStatus.verifying;
}

/// Phone auth notifier for mock OTP authentication
class PhoneAuthNotifier extends StateNotifier<PhoneAuthState> {
  final Ref _ref;

  PhoneAuthNotifier(this._ref) : super(const PhoneAuthState());

  /// Send OTP to phone number (mock implementation)
  Future<bool> sendOtp(String phoneNumber) async {
    if (phoneNumber.length < 10) {
      state = state.copyWith(
        status: PhoneAuthStatus.error,
        error: 'Please enter a valid phone number',
      );
      return false;
    }

    state = state.copyWith(
      status: PhoneAuthStatus.sendingOtp,
      phoneNumber: phoneNumber,
      error: null,
    );

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Generate mock OTP (always 123456 for MVP)
    state = state.copyWith(
      status: PhoneAuthStatus.otpSent,
      generatedOtp: mockOtp,
      resendCountdown: 30,
    );

    // Start countdown for resend
    _startResendCountdown();

    return true;
  }

  void _startResendCountdown() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (state.resendCountdown > 0) {
        state = state.copyWith(resendCountdown: state.resendCountdown - 1);
        return true;
      }
      return false;
    });
  }

  /// Verify OTP (mock implementation)
  Future<UserModel?> verifyOtp(String otp) async {
    state = state.copyWith(status: PhoneAuthStatus.verifying, error: null);

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Check if OTP matches
    if (otp == mockOtp || otp == state.generatedOtp) {
      final user = UserModel(
        id: const Uuid().v4(),
        email: '${state.phoneNumber}@phone.local',
        phoneNumber: state.phoneNumber,
        name:
            'User ${state.phoneNumber?.substring(state.phoneNumber!.length - 4)}',
        createdAt: DateTime.now(),
        role: 'tourist',
      );

      // Save session
      await _saveSession(user);

      state = state.copyWith(status: PhoneAuthStatus.verified);
      return user;
    } else {
      state = state.copyWith(
        status: PhoneAuthStatus.error,
        error: 'Invalid OTP. Please try again.',
      );
      return null;
    }
  }

  /// Resend OTP
  Future<bool> resendOtp() async {
    if (!state.canResend || state.phoneNumber == null) return false;
    return sendOtp(state.phoneNumber!);
  }

  /// Save user session locally
  Future<void> _saveSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', user.id);
    await prefs.setString('user_phone', user.phoneNumber ?? '');
    await prefs.setString('user_name', user.name);
    await prefs.setBool('is_logged_in', true);
  }

  /// Check for existing session
  Future<UserModel?> checkExistingSession() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    if (!isLoggedIn) return null;

    final userId = prefs.getString('user_id');
    final userPhone = prefs.getString('user_phone');
    final userName = prefs.getString('user_name');

    if (userId == null) return null;

    return UserModel(
      id: userId,
      email: '${userPhone ?? 'user'}@phone.local',
      phoneNumber: userPhone,
      name: userName ?? 'User',
      createdAt: DateTime.now(),
      role: 'tourist',
    );
  }

  /// Clear session (logout)
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_phone');
    await prefs.remove('user_name');
    await prefs.setBool('is_logged_in', false);
    state = const PhoneAuthState();
  }

  /// Reset state
  void reset() {
    state = const PhoneAuthState();
  }
}

final phoneAuthProvider =
    StateNotifierProvider<PhoneAuthNotifier, PhoneAuthState>((ref) {
      return PhoneAuthNotifier(ref);
    });
