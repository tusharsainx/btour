import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/text_fields.dart';
import '../../../../shared/providers/providers.dart';
import '../../../../shared/models/user_model.dart';

enum RegisterStep { details, emailOtp, phoneOtp, biometric }

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  RegisterStep _currentStep = RegisterStep.details;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _nextStep() {
    _otpController.clear();
    setState(() {
      if (_currentStep == RegisterStep.details) {
        _currentStep = RegisterStep.emailOtp;
      } else if (_currentStep == RegisterStep.emailOtp) {
        _currentStep = RegisterStep.phoneOtp;
      } else if (_currentStep == RegisterStep.phoneOtp) {
        _currentStep = RegisterStep.biometric;
      }
    });
  }

  Future<void> _submitDetails() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // Simulate sending Email OTP
    await ref
        .read(authNotifierProvider.notifier)
        .sendOtp(_emailController.text);

    setState(() => _isLoading = false);
    _nextStep();
  }

  Future<void> _verifyEmailOtp() async {
    if (_otpController.text.length != 6) return;
    setState(() => _isLoading = true);

    final valid = await ref
        .read(authNotifierProvider.notifier)
        .verifyOtp(_otpController.text);
    if (valid) {
      // Send Phone OTP
      await ref
          .read(authNotifierProvider.notifier)
          .sendOtp(_phoneController.text);
      if (mounted) {
        setState(() => _isLoading = false);
        _nextStep();
      }
    } else {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Invalid OTP")));
      }
    }
  }

  UserModel? _createdUser;

  Future<void> _verifyPhoneOtp() async {
    if (_otpController.text.length != 6) return;
    setState(() => _isLoading = true);

    final valid = await ref
        .read(authNotifierProvider.notifier)
        .verifyOtp(_otpController.text);
    if (valid) {
      // Create User but DON'T update global state yet to prevent redirect
      _createdUser = await ref
          .read(authNotifierProvider.notifier)
          .signUp(
            name: _nameController.text,
            email: _emailController.text,
            phone: _phoneController.text,
            shouldUpdateState: false, // Prevents auto-redirect
          );

      if (mounted) {
        setState(() => _isLoading = false);
        if (_createdUser != null) {
          _nextStep();
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Signup Failed")));
        }
      }
    } else {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Invalid OTP")));
      }
    }
  }

  Future<void> _enableBiometric() async {
    if (_createdUser == null) return;
    setState(() => _isLoading = true);

    // Enable biometrics and update state (Logging in)
    await ref
        .read(authNotifierProvider.notifier)
        .enableBiometrics(user: _createdUser);

    if (mounted) {
      final currentUser = ref.read(authNotifierProvider).value;
      if (currentUser != null && currentUser.biometricEnabled) {
        context.go('/home');
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Biometric setup failed")));
      }
    }
  }

  void _skipBiometric() async {
    if (_createdUser == null) return;
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    // Just complete signup (update state)
    await ref.read(authNotifierProvider.notifier).completeSignup(_createdUser!);

    if (mounted) {
      context.go('/home');
    }
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case RegisterStep.details:
        return Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _nameController,
                label: "Full Name",
                hint: "John Doe",
                prefixIcon: Icons.person,
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _emailController,
                label: "Email",
                hint: "john@example.com",
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email,
                validator: (v) => v!.contains("@") ? null : "Invalid email",
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _phoneController,
                label: "Phone",
                hint: "+91 9876543210",
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone,
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 32),
              GradientButton(
                text: "Continue",
                onPressed: _submitDetails,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      context.go('/login');
                    },
                    child: const Text("Log In"),
                  ),
                ],
              ),
            ],
          ),
        );
      case RegisterStep.emailOtp:
        return Column(
          children: [
            Text(
              "Enter OTP sent to ${_emailController.text}",
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: 24),
            Pinput(
              controller: _otpController,
              length: 6,
              defaultPinTheme: PinTheme(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.offWhite,
                ),
                textStyle: AppTypography.headlineMedium,
              ),
              onCompleted: (pin) => _verifyEmailOtp(),
            ),
            const SizedBox(height: 32),
            GradientButton(
              text: "Verify Email",
              onPressed: () => _verifyEmailOtp(),
              isLoading: _isLoading,
            ),
            TextButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                // Resend logic
              },
              child: const Text("Resend OTP (30s)"),
            ),
          ],
        );
      case RegisterStep.phoneOtp:
        return Column(
          children: [
            Text(
              "Enter OTP sent to ${_phoneController.text}",
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: 24),
            Pinput(
              controller: _otpController,
              length: 6,
              onCompleted: (pin) => _verifyPhoneOtp(),
              defaultPinTheme: PinTheme(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.offWhite,
                ),
                textStyle: AppTypography.headlineMedium,
              ),
            ),
            const SizedBox(height: 32),
            GradientButton(
              text: "Verify Phone",
              onPressed: () => _verifyPhoneOtp(),
              isLoading: _isLoading,
            ),
            TextButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
              },
              child: const Text("Resend OTP (30s)"),
            ),
          ],
        );
      case RegisterStep.biometric:
        return Column(
          children: [
            const Icon(Icons.fingerprint, size: 80, color: AppColors.primary),
            const SizedBox(height: 24),
            Text("Enable Biometric Login?", style: AppTypography.headlineSmall),
            const SizedBox(height: 16),
            const Text(
              "Use FaceID or Fingerprint for faster and secure access.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            GradientButton(
              text: "Enable Biometrics",
              onPressed: _enableBiometric,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _skipBiometric,
              child: const Text("Maybe Later"),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = "Create Account";
    if (_currentStep == RegisterStep.emailOtp) title = "Verify Email";
    if (_currentStep == RegisterStep.phoneOtp) title = "Verify Phone";
    if (_currentStep == RegisterStep.biometric) title = "Setup Security";

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading:
            (_currentStep != RegisterStep.details &&
                _currentStep != RegisterStep.biometric)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  setState(() {
                    if (_currentStep == RegisterStep.emailOtp)
                      _currentStep = RegisterStep.details;
                    else if (_currentStep == RegisterStep.phoneOtp)
                      _currentStep = RegisterStep.emailOtp;
                  });
                },
              )
            : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInDown(
                child: Text(
                  title,
                  style: AppTypography.headlineLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              FadeInUp(child: _buildStepContent()),
            ],
          ),
        ),
      ),
    );
  }
}
