import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/providers/providers.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/cached_image.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      image: 'https://images.unsplash.com/photo-1545378889-a8e6e2df4738?w=800',
      title: 'Discover Spiritual Bihar',
      description:
          'Explore ancient Buddhist sites, temples, and spiritual journeys in the land of enlightenment.',
      icon: '🙏',
    ),
    OnboardingData(
      image:
          'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?w=800',
      title: 'Heritage Walks',
      description:
          'Walk through the ruins of Nalanda University and ancient Rajgir, where history comes alive.',
      icon: '🏛️',
    ),
    OnboardingData(
      image:
          'https://images.unsplash.com/photo-1567337710282-00832b415979?w=800',
      title: 'Authentic Cuisine',
      description:
          'Taste the flavors of Bihar with local food trails and traditional Bihari delicacies.',
      icon: '🍛',
    ),
    OnboardingData(
      image:
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
      title: 'Book with Local Guides',
      description:
          'Connect with verified local guides who know Bihar like the back of their hand.',
      icon: '👤',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Page view
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return _OnboardingPage(data: _pages[index]);
            },
          ),
          // Skip button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 20,
            child: TextButton(
              onPressed: () {
                ref.read(authNotifierProvider.notifier).continueAsGuest();
                context.go('/home');
              },
              child: Text(
                'Skip',
                style: AppTypography.labelLarge.copyWith(color: Colors.white),
              ),
            ),
          ),
          // Bottom section
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).padding.bottom + 24,
                top: 24,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _pages.length,
                    effect: const ExpandingDotsEffect(
                      dotWidth: 8,
                      dotHeight: 8,
                      activeDotColor: AppColors.accent,
                      dotColor: Colors.white38,
                      expansionFactor: 4,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Next/Get Started button
                  PrimaryButton(
                    text: _currentPage == _pages.length - 1
                        ? 'Get Started'
                        : 'Next',
                    onPressed: _nextPage,
                    icon: _currentPage == _pages.length - 1
                        ? Icons.arrow_forward
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        CachedImage(imageUrl: data.image, fit: BoxFit.cover),
        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.3),
                Colors.black.withValues(alpha: 0.7),
              ],
            ),
          ),
        ),
        // Content
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                FadeInUp(
                  child: Text(data.icon, style: const TextStyle(fontSize: 80)),
                ),
                const SizedBox(height: 24),
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: Text(
                    data.title,
                    style: AppTypography.headlineLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: Text(
                    data.description,
                    style: AppTypography.bodyLarge.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                const SizedBox(height: 140), // Space for bottom controls
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingData {
  final String image;
  final String title;
  final String description;
  final String icon;

  OnboardingData({
    required this.image,
    required this.title,
    required this.description,
    required this.icon,
  });
}
