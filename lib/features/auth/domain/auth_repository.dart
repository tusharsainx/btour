import 'package:BTour/shared/models/user_model.dart';
import 'package:BTour/features/auth/domain/session_model.dart';

abstract class AuthRepository {
  Future<UserModel?> getUser();
  Future<void> saveUser(UserModel user);
  Future<void> deleteUser();

  Future<void> saveSession(SessionModel session);
  Future<SessionModel?> getSession();
  Future<void> clearSession();

  Future<void> setBiometricEnabled(bool enabled);
  Future<bool> isBiometricEnabled();
  Future<bool> authenticateBiometric();

  Future<String> sendOtp(String contact);
  Future<bool> verifyOtp(String otp);
}
