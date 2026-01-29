import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/text_fields.dart';
import '../../../../shared/providers/providers.dart';
import '../../../../shared/models/user_model.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _otpController = TextEditingController();
  final _phoneController = TextEditingController(); // Added for manual input
  bool _isLoading = false;
  bool _isCheckingUser = true;
  UserModel? _localUser;
  bool _showOtpInput = false;

  @override
  void initState() {
    super.initState();
    _checkLocalUser();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _checkLocalUser() async {
    final user = await ref.read(authNotifierProvider.notifier).getLocalUser();

    if (mounted) {
      // Don't auto-redirect. Just set state.
      setState(() {
        _localUser = user;
        _isCheckingUser = false;
      });

      if (user != null) {
        if (user.biometricEnabled) {
          _handleBiometricLogin();
        } else {
          setState(() {
            _showOtpInput = true;
          });
        }
      } else {
        // If no user, we naturally show the "Enter Phone" UI below
      }
    }
  }

  Future<void> _handleBiometricLogin() async {
    setState(() => _isLoading = true);
    try {
      final success = await ref
          .read(authNotifierProvider.notifier)
          .loginWithBiometrics();

      if (mounted) {
        if (success) {
          context.go('/home');
        } else {
          // Failed or canceled, show OTP fallback
          setState(() {
            _showOtpInput = true;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _showOtpInput = true;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Biometric failed: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _handleOtpLogin() async {
    setState(() => _isLoading = true);
    try {
      final success = await ref
          .read(authNotifierProvider.notifier)
          .verifyOtp(_otpController.text);
      if (success) {
        // If we have a local user, use their number.
        // If not (manual entry), use the entered phone number logic?
        // Actually, for local-first single-user, we MUST match the stored user.

        final user = await ref
            .read(authNotifierProvider.notifier)
            .getLocalUser();

        if (user == null) {
          throw Exception("Account not found on this device.");
        }

        // If we manually entered a phone, maybe check if it matches?
        // But for now, if the OTP validates (mocked), and a user exists, we log them in.

        await ref
            .read(authNotifierProvider.notifier)
            .loginWithOtp(user.phoneNumber ?? '');

        if (mounted) context.go('/home');
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Invalid OTP')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Handle "Find Account" / Manual Login flow
  Future<void> _handleManualLoginCheck() async {
    // Since this is a local-only app, checking "if user exists" is just checking local storage.
    // If _localUser is null, subsequent checks will also be null unless we pulled from cloud (which we don't).

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // Mock network

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No account found. Please Register.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingUser) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Determine what to show based on if we found a user
    final hasUser = _localUser != null;
    final userName = hasUser ? _localUser!.name : "Traveler";
    final phoneNumber = hasUser
        ? (_localUser!.phoneNumber ?? _localUser!.email)
        : null;

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              FadeInDown(
                child: Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: SvgPicture.asset(
                        'assets/icons/app_icon.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FadeInDown(
                delay: const Duration(milliseconds: 100),
                child: Center(
                  child: Text(
                    hasUser ? 'Welcome Back,' : 'Welcome,',
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.getTextSecondary(context),
                    ),
                  ),
                ),
              ),
              FadeInDown(
                delay: const Duration(milliseconds: 200),
                child: Center(
                  child: Text(
                    userName,
                    style: AppTypography.headlineLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              if (hasUser) ...[
                // Exisiting User Flow
                if (_showOtpInput) ...[
                  FadeInUp(
                    child: Column(
                      children: [
                        Text(
                          "Enter OTP sent to $phoneNumber",
                          style: AppTypography.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _otpController,
                          hint: 'Enter 6-digit OTP',
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.lock_clock,
                        ),
                        const SizedBox(height: 24),
                        GradientButton(
                          text: 'Verify & Login',
                          isLoading: _isLoading,
                          onPressed: _handleOtpLogin,
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Center(
                    child: Column(
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          "Authenticating...",
                          style: AppTypography.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            setState(() => _showOtpInput = true);
                          },
                          child: const Text("Use OTP instead"),
                        ),
                      ],
                    ),
                  ),
                ],
              ] else ...[
                // No Local User Found Flow
                FadeInUp(
                  child: Column(
                    children: [
                      Text(
                        "Please log in to continue",
                        style: AppTypography.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _phoneController,
                        hint: 'Phone Number',
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone,
                      ),
                      const SizedBox(height: 24),
                      GradientButton(
                        text: 'Login',
                        isLoading: _isLoading,
                        onPressed: _handleManualLoginCheck,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              context.go('/register');
                            },
                            child: const Text("Create Account"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback? onPressed;

  const _SocialLoginButton({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(color: AppColors.getBorder(context)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                icon,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.getTextPrimary(context),
            ),
          ),
        ],
      ),
    );
  }
}
