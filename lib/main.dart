import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'features/profile/presentation/screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (Disabled for Mock Mode)
  // try {
  //   await Firebase.initializeApp();
  // } catch (e) {
  //   debugPrint(
  //     "Firebase initialization failed (expected if google-services.json is missing): $e",
  //   );
  // }

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Set system UI overlay style handled by AppTheme
  // SystemChrome.setSystemUIOverlayStyle(...)

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ProviderScope(child: BiharTourismApp()));
}

class BiharTourismApp extends ConsumerWidget {
  const BiharTourismApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Bihar Tourism',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
