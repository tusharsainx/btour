import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:BTour/features/auth/domain/auth_repository.dart';
import 'package:BTour/features/auth/domain/session_model.dart';
import 'package:BTour/shared/models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FlutterSecureStorage _secureStorage;
  final LocalAuthentication _localAuth;
  Box? _authBox;

  AuthRepositoryImpl({
    FlutterSecureStorage? secureStorage,
    LocalAuthentication? localAuth,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
       _localAuth = localAuth ?? LocalAuthentication();

  Future<Box> get _box async {
    if (_authBox != null && _authBox!.isOpen) return _authBox!;
    _authBox = await Hive.openBox('auth_v1');
    return _authBox!;
  }

  @override
  Future<UserModel?> getUser() async {
    final box = await _box;
    final userMap = box.get('user');
    if (userMap != null) {
      // Cast to Map<String, dynamic> manually to be safe with Hive
      final map = Map<String, dynamic>.from(userMap);
      return UserModel.fromJson(map);
    }
    return null;
  }

  @override
  Future<void> saveUser(UserModel user) async {
    final box = await _box;
    await box.put('user', user.toJson());
  }

  @override
  Future<void> deleteUser() async {
    final box = await _box;
    await box.delete('user');
  }

  @override
  Future<SessionModel?> getSession() async {
    final box = await _box;
    final sessionMap = box.get('session');
    if (sessionMap != null) {
      final map = Map<String, dynamic>.from(sessionMap);
      return SessionModel.fromJson(map);
    }
    return null;
  }

  @override
  Future<void> saveSession(SessionModel session) async {
    final box = await _box;
    await box.put('session', session.toJson());
  }

  @override
  Future<void> clearSession() async {
    final box = await _box;
    await box.delete('session');
  }

  @override
  Future<bool> isBiometricEnabled() async {
    // Check local storage preference
    final box = await _box;
    bool pref = box.get('biometric_enabled', defaultValue: false);

    // Also check if device supports it
    bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    bool isDeviceSupported = await _localAuth.isDeviceSupported();

    return pref && canCheckBiometrics && isDeviceSupported;
  }

  @override
  Future<void> setBiometricEnabled(bool enabled) async {
    final box = await _box;
    await box.put('biometric_enabled', enabled);

    if (enabled) {
      // If enabling, we might want to store a secret or token in SecureStorage
      // to rely on for actual cryptographic login, but for this flow:
      // "If biometric fails or is disabled -> show OTP login"
      // we assume simple local auth check is sufficient for "logging in" to the local app.
      await _secureStorage.write(key: 'biometric_active', value: 'true');
    } else {
      await _secureStorage.delete(key: 'biometric_active');
    }
  }

  @override
  Future<bool> authenticateBiometric() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Please authenticate to login',
      );
    } on PlatformException catch (_) {
      return false;
    }
  }

  @override
  Future<String> sendOtp(String contact) async {
    // Mock OTP logic
    await Future.delayed(const Duration(seconds: 1)); // simulate network
    return "123456";
  }

  @override
  Future<bool> verifyOtp(String otp) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return otp == "123456";
  }
}
