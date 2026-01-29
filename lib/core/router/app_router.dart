import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:BTour/shared/providers/providers.dart';
import 'package:BTour/shared/models/models.dart';

// Auth screens
import 'package:BTour/features/auth/presentation/screens/splash_screen.dart';
import 'package:BTour/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:BTour/features/auth/presentation/screens/login_screen.dart';
import 'package:BTour/features/auth/presentation/screens/register_screen.dart';
// import 'package:BTour/features/auth/presentation/screens/phone_login_screen.dart';
// import 'package:BTour/features/auth/presentation/screens/otp_verify_screen.dart';
import 'package:BTour/features/auth/presentation/screens/location_permission_screen.dart';

// Main app screens
import 'package:BTour/features/home/presentation/screens/main_shell.dart';
import 'package:BTour/features/home/presentation/screens/home_screen.dart';
import 'package:BTour/features/home/presentation/screens/city_selector_screen.dart';
import 'package:BTour/features/experiences/presentation/screens/explore_screen.dart';
import 'package:BTour/features/experiences/presentation/screens/experience_detail_screen.dart';
import 'package:BTour/features/experiences/presentation/screens/write_review_screen.dart';
import 'package:BTour/features/booking/presentation/screens/booking_screen.dart';
import 'package:BTour/features/booking/presentation/screens/my_bookings_screen.dart';
import 'package:BTour/features/booking/presentation/screens/booking_confirmation_screen.dart';
import 'package:BTour/features/profile/presentation/screens/profile_screen.dart';
import 'package:BTour/features/profile/presentation/screens/wishlist_screen.dart';
import 'package:BTour/features/profile/presentation/screens/settings_screen.dart';

// Admin screens
import 'package:BTour/features/admin/presentation/screens/admin_dashboard_screen.dart';

// Guide screens
import 'package:BTour/features/guide/presentation/screens/guide_dashboard_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<AsyncValue<UserModel?>>(
      authNotifierProvider,
      (_, __) => notifyListeners(),
    );
    _ref.listen<bool>(isGuestModeProvider, (_, __) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final routerNotifier = RouterNotifier(ref);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    refreshListenable: routerNotifier,
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final isGuest = ref.read(isGuestModeProvider);

      // Handle loading state
      if (authState.isLoading) {
        return null;
      }

      final isLoggedIn = authState.value != null;
      final isAuthRoute =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/onboarding' ||
          state.matchedLocation == '/splash' ||
          state.matchedLocation == '/location-permission';

      if (state.matchedLocation == '/splash' ||
          state.matchedLocation == '/onboarding') {
        return null;
      }

      // If guest, allow access
      if (isGuest) {
        // If trying to go to login/register while guest, allow it?
        // Or if they are at splash/onboarding, send to home.
        if (state.matchedLocation == '/splash' ||
            state.matchedLocation == '/onboarding') {
          return '/home';
        }
        return null;
      }

      if (!isLoggedIn && !isAuthRoute) {
        return '/login';
      }

      if (isLoggedIn && isAuthRoute && state.matchedLocation != '/splash') {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/location-permission',
        builder: (context, state) => const LocationPermissionScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      // GoRoute(
      //   path: '/phone-login',
      //   builder: (context, state) => const PhoneLoginScreen(),
      // ),
      // GoRoute(
      //   path: '/otp-verify',
      //   builder: (context, state) => const OtpVerifyScreen(),
      // ),
      GoRoute(
        path: '/city-selector',
        builder: (context, state) => const CitySelectorScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) =>
                NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: '/explore',
            pageBuilder: (context, state) =>
                NoTransitionPage(child: ExploreScreen()),
          ),
          GoRoute(
            path: '/bookings',
            pageBuilder: (context, state) =>
                NoTransitionPage(child: MyBookingsScreen()),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) =>
                NoTransitionPage(child: ProfileScreen()),
          ),
        ],
      ),
      GoRoute(
        path: '/experience/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ExperienceDetailScreen(experienceId: id);
        },
      ),
      GoRoute(
        path: '/book/:experienceId',
        builder: (context, state) {
          final id = state.pathParameters['experienceId']!;
          return BookingScreen(experienceId: id);
        },
      ),
      GoRoute(
        path: '/booking-confirmation/:bookingId',
        builder: (context, state) {
          final id = state.pathParameters['bookingId']!;
          return BookingConfirmationScreen(bookingId: id);
        },
      ),
      GoRoute(
        path: '/write-review/:experienceId/:bookingId',
        builder: (context, state) {
          final experienceId = state.pathParameters['experienceId']!;
          final bookingId = state.pathParameters['bookingId']!;
          return WriteReviewScreen(
            experienceId: experienceId,
            bookingId: bookingId,
          );
        },
      ),
      GoRoute(
        path: '/wishlist',
        builder: (context, state) => const WishlistScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/guide',
        builder: (context, state) => const GuideDashboardScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Page not found: ${state.uri.path}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
