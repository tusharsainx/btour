import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/text_fields.dart';
import '../../../../shared/providers/providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await ref
        .read(authNotifierProvider.notifier)
        .signInWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (mounted) {
      setState(() => _isLoading = false);

      final authState = ref.read(authNotifierProvider);
      authState.when(
        data: (user) {
          if (user != null) {
            ref.read(navigationIndexProvider.notifier).state = 0;
            context.go('/home');
          }
        },
        loading: () {},
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: AppColors.error,
            ),
          );
        },
      );
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    await ref.read(authNotifierProvider.notifier).signInWithGoogle();

    if (mounted) {
      setState(() => _isLoading = false);

      final authState = ref.read(authNotifierProvider);
      if (authState.value != null) {
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Logo
                FadeInDown(
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('🏛️', style: TextStyle(fontSize: 48)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Welcome text
                FadeInDown(
                  delay: const Duration(milliseconds: 100),
                  child: Text(
                    'Welcome Back',
                    style: AppTypography.headlineLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FadeInDown(
                  delay: const Duration(milliseconds: 200),
                  child: Text(
                    'Sign in to continue exploring Bihar',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Email field
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: CustomTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Password field
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: CustomTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Enter your password',
                    obscureText: true,
                    prefixIcon: Icons.lock_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 12),
                // Forgot password
                FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        _showForgotPasswordDialog();
                      },
                      child: Text(
                        'Forgot Password?',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Login button
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: GradientButton(
                    text: 'Sign In',
                    isLoading: _isLoading,
                    onPressed: _handleLogin,
                  ),
                ),
                const SizedBox(height: 24),
                // Or divider
                FadeInUp(
                  delay: const Duration(milliseconds: 700),
                  child: Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'or continue with',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Social login buttons
                FadeInUp(
                  delay: const Duration(milliseconds: 800),
                  child: _SocialLoginButton(
                    icon: 'G',
                    label: 'Continue with Google',
                    onPressed: _isLoading ? null : _handleGoogleSignIn,
                  ),
                ),
                const SizedBox(height: 12),
                // Phone login button
                FadeInUp(
                  delay: const Duration(milliseconds: 850),
                  child: _SocialLoginButton(
                    icon: '📱',
                    label: 'Continue with Phone',
                    onPressed: _isLoading
                        ? null
                        : () => context.push('/phone-login'),
                  ),
                ),
                const SizedBox(height: 32),
                // Guest Login
                FadeInUp(
                  delay: const Duration(milliseconds: 850),
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        ref
                            .read(authNotifierProvider.notifier)
                            .continueAsGuest();
                        context.go('/home');
                      },
                      child: Text(
                        'Continue as Guest',
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.textSecondary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Register link
                FadeInUp(
                  delay: const Duration(milliseconds: 900),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go('/register'),
                        child: Text(
                          'Sign Up',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your email to receive a password reset link.'),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(hintText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (emailController.text.isNotEmpty) {
                await ref
                    .read(authNotifierProvider.notifier)
                    .resetPassword(emailController.text.trim());
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password reset email sent!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              }
            },
            child: const Text('Send'),
          ),
        ],
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
        side: const BorderSide(color: AppColors.border),
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
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
