import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/widgets.dart';

/// Auto-scrolling hero carousel for the home screen
class HeroCarousel extends StatefulWidget {
  final List<CarouselItem> items;
  final double height;
  final Duration autoScrollDuration;
  final void Function(CarouselItem item)? onItemTap;

  const HeroCarousel({
    super.key,
    required this.items,
    this.height = 200,
    this.autoScrollDuration = const Duration(seconds: 4),
    this.onItemTap,
  });

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    if (widget.items.length > 1) {
      _autoScrollTimer = Timer.periodic(widget.autoScrollDuration, (_) {
        if (_pageController.hasClients) {
          int nextPage = _currentPage + 1;
          if (nextPage >= widget.items.length) {
            nextPage = 0;
          }
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: GestureDetector(
                  onTap: () => widget.onItemTap?.call(item),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Background image
                          CachedImage(
                            imageUrl: item.imageUrl,
                            width: double.infinity,
                            height: widget.height,
                          ),
                          // Gradient overlay
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.7),
                                ],
                                stops: const [0.3, 1.0],
                              ),
                            ),
                          ),
                          // Content
                          Positioned(
                            left: 20,
                            right: 20,
                            bottom: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (item.tag != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      item.tag!,
                                      style: AppTypography.labelSmall.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                if (item.tag != null) const SizedBox(height: 8),
                                Text(
                                  item.title,
                                  style: AppTypography.headlineSmall.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (item.subtitle != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    item.subtitle!,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // Page indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.items.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentPage == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Data model for carousel items
class CarouselItem {
  final String id;
  final String title;
  final String? subtitle;
  final String imageUrl;
  final String? tag;
  final String? route;

  const CarouselItem({
    required this.id,
    required this.title,
    this.subtitle,
    required this.imageUrl,
    this.tag,
    this.route,
  });
}
