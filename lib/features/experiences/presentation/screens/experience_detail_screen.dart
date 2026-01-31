import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../shared/providers/providers.dart';

class ExperienceDetailScreen extends ConsumerWidget {
  final String experienceId;

  const ExperienceDetailScreen({super.key, required this.experienceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final experienceAsync = ref.watch(experienceProvider(experienceId));
    final isInWishlist = ref.watch(isInWishlistProvider(experienceId));
    final reviews = ref.watch(experienceReviewsProvider(experienceId));

    return experienceAsync.when(
      data: (experience) {
        if (experience == null) {
          return const Scaffold(body: Center(child: Text('Not found')));
        }
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // Hero image
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                leading: IconButtonCustom(
                  icon: Icons.arrow_back_ios_new,
                  onPressed: () => context.pop(),
                ),
                actions: [
                  IconButtonCustom(
                    icon: isInWishlist ? Icons.favorite : Icons.favorite_border,
                    iconColor: isInWishlist ? AppColors.error : null,
                    onPressed: () {
                      ref
                          .read(wishlistNotifierProvider.notifier)
                          .toggleWishlist(experienceId);
                    },
                  ),
                  const SizedBox(width: 8),
                  IconButtonCustom(
                    icon: Icons.share_outlined,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 16),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedImage(imageUrl: experience.primaryImage),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.5),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category & Duration
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.getCategoryColor(
                                experience.category,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              experience.category,
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.getCategoryColor(
                                  experience.category,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.schedule,
                            size: 16,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            experience.formattedDuration,
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Title
                      Text(
                        experience.title,
                        style: AppTypography.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      // Location with Google Maps
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 18,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              experience.location,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () {
                              final mapsUrl =
                                  'https://www.google.com/maps/dir/?api=1&destination=${experience.latitude},${experience.longitude}';
                              launchGoogleMaps(mapsUrl);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.directions,
                                    size: 16,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Directions',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Rating
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: experience.rating,
                            itemSize: 20,
                            itemBuilder: (_, __) =>
                                const Icon(Icons.star, color: AppColors.accent),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${experience.rating.toStringAsFixed(1)} '
                            '(${experience.reviewCount} reviews)',
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Description
                      Text('About', style: AppTypography.titleMedium),
                      const SizedBox(height: 8),
                      Text(
                        experience.description,
                        style: AppTypography.bodyMedium.copyWith(height: 1.6),
                      ),
                      const SizedBox(height: 24),
                      // Highlights
                      if (experience.highlights.isNotEmpty) ...[
                        Text('Highlights', style: AppTypography.titleMedium),
                        const SizedBox(height: 12),
                        ...experience.highlights.map(
                          (h) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: AppColors.success,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    h,
                                    style: AppTypography.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                      // Guide info
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: AppColors.primary.withValues(
                                alpha: 0.1,
                              ),
                              child: Text(
                                experience.guideName[0],
                                style: AppTypography.titleLarge.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Your Guide',
                                    style: AppTypography.caption,
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          experience.guideName,
                                          style: AppTypography.titleMedium,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.verified,
                                        color: AppColors.primary,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      RatingBarIndicator(
                                        rating: experience.rating,
                                        itemSize: 14,
                                        itemBuilder: (_, __) => const Icon(
                                          Icons.star,
                                          color: AppColors.accent,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        experience.rating.toStringAsFixed(1),
                                        style: AppTypography.caption.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: FaIcon(
                                FontAwesomeIcons.whatsapp,
                                color: Color(
                                  0xFF25D366,
                                ), // Official WhatsApp green
                                size: 28,
                              ),
                              onPressed: () {
                                // Open WhatsApp - using a generic tourism number for demo
                                // In production, you'd get this from the guide's profile
                                final phone =
                                    '916005418713'; // Replace with actual guide phone
                                final message = Uri.encodeComponent(
                                  'Hi ${experience.guideName}, I\'m interested in "${experience.title}" experience.',
                                );
                                final whatsappUrl =
                                    'https://wa.me/$phone?text=$message';
                                // Launch URL (note: you'll need url_launcher package)
                                launchWhatsApp(whatsappUrl);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Reviews section
                      Text('Reviews', style: AppTypography.titleMedium),
                      const SizedBox(height: 12),
                      reviews.when(
                        data: (list) => list.isEmpty
                            ? Text(
                                'No reviews yet',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              )
                            : Column(
                                children: list
                                    .take(3)
                                    .map((r) => _ReviewCard(review: r))
                                    .toList(),
                              ),
                        loading: () => const CircularProgressIndicator(),
                        error: (e, _) => Text('Error: $e'),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _BottomBookingBar(
            price: experience.formattedPrice,
            onBook: () => context.go('/book/$experienceId'),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final dynamic review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 20, child: Text(review.userName[0])),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.userName, style: AppTypography.titleSmall),
                    RatingBarIndicator(
                      rating: review.rating,
                      itemSize: 14,
                      itemBuilder: (_, __) =>
                          const Icon(Icons.star, color: AppColors.accent),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(review.comment, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}

class _BottomBookingBar extends StatelessWidget {
  final String price;
  final VoidCallback onBook;

  const _BottomBookingBar({required this.price, required this.onBook});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                price,
                style: AppTypography.headlineSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('per person', style: AppTypography.caption),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: 160,
            child: GradientButton(text: 'Book Now', onPressed: onBook),
          ),
        ],
      ),
    );
  }
}

// Helper function to launch WhatsApp
Future<void> launchWhatsApp(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    // If WhatsApp is not installed, open in browser
    await launchUrl(
      Uri.parse('https://web.whatsapp.com'),
      mode: LaunchMode.externalApplication,
    );
  }
}

// Helper function to launch Google Maps
Future<void> launchGoogleMaps(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
