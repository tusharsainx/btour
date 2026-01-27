import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../shared/models/models.dart';
import '../../shared/providers/providers.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'cached_image.dart';

class ExperienceCard extends ConsumerWidget {
  final Experience experience;
  final VoidCallback? onTap;
  final bool isCompact;

  const ExperienceCard({
    super.key,
    required this.experience,
    this.onTap,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInWishlist = ref.watch(isInWishlistProvider(experience.id));

    return FadeInUp(
      duration: const Duration(milliseconds: 400),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: isCompact ? 280 : double.infinity,
          decoration: BoxDecoration(
            color: AppColors.cardLight,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    child: CachedImage(
                      imageUrl: experience.primaryImage,
                      width: double.infinity,
                      height: isCompact ? 160 : 200,
                    ),
                  ),
                  // Category badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.getCategoryColor(experience.category)
                            .withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        experience.category,
                        style: AppTypography.labelSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // Wishlist button
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () {
                        ref
                            .read(wishlistNotifierProvider.notifier)
                            .toggleWishlist(experience.id);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isInWishlist
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                              isInWishlist ? AppColors.error : AppColors.textMuted,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                  // Duration badge
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.schedule,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            experience.formattedDuration,
                            style: AppTypography.labelSmall.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Content section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      experience.title,
                      style: AppTypography.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Location
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            experience.location,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Rating and price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Rating
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 18,
                              color: AppColors.accent,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              experience.rating.toStringAsFixed(1),
                              style: AppTypography.labelLarge.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${experience.reviewCount})',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        // Price
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              experience.formattedPrice,
                              style: AppTypography.price,
                            ),
                            Text(
                              'per person',
                              style: AppTypography.caption,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Horizontal scrollable experience card
class ExperienceCardSmall extends ConsumerWidget {
  final Experience experience;
  final VoidCallback? onTap;

  const ExperienceCardSmall({
    super.key,
    required this.experience,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: AppColors.cardLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: CachedImage(
                imageUrl: experience.primaryImage,
                width: 200,
                height: 120,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    experience.title,
                    style: AppTypography.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: AppColors.accent),
                      const SizedBox(width: 2),
                      Text(
                        experience.rating.toStringAsFixed(1),
                        style: AppTypography.labelSmall,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          experience.formattedPrice,
                          style: AppTypography.priceSmall,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
