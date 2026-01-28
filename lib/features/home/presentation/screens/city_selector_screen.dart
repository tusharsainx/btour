import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/providers/city_provider.dart';

class CitySelectorScreen extends ConsumerWidget {
  const CitySelectorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cityState = ref.watch(cityProvider);
    final availableCities = ref.watch(availableCitiesProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: FadeInDown(
                  child: Column(
                    children: [
                      const Text('📍', style: TextStyle(fontSize: 64)),
                      const SizedBox(height: 16),
                      Text(
                        'Select Your City',
                        style: AppTypography.headlineMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Choose a city to explore amazing experiences',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyLarge.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Cities list
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(24),
                      itemCount: availableCities.length,
                      itemBuilder: (context, index) {
                        final city = availableCities[index];
                        final isSelected = cityState.selectedCity == city;

                        return FadeInUp(
                          delay: Duration(milliseconds: 100 * index),
                          child: _CityCard(
                            city: city,
                            isSelected: isSelected,
                            onTap: () async {
                              await ref
                                  .read(cityProvider.notifier)
                                  .selectCity(city);
                              await ref
                                  .read(cityProvider.notifier)
                                  .completeFirstLaunch();
                              if (context.mounted) {
                                Navigator.of(context).pop(city);
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CityCard extends StatelessWidget {
  final String city;
  final bool isSelected;
  final VoidCallback onTap;

  const _CityCard({
    required this.city,
    required this.isSelected,
    required this.onTap,
  });

  String get _cityEmoji {
    switch (city) {
      case 'Patna':
        return '🏛️';
      case 'Bodh Gaya':
        return '🙏';
      case 'Rajgir':
        return '⛰️';
      case 'Nalanda':
        return '📚';
      case 'Vaishali':
        return '🏺';
      default:
        return '📍';
    }
  }

  String get _cityDescription {
    switch (city) {
      case 'Patna':
        return 'Capital city with rich history';
      case 'Bodh Gaya':
        return 'Spiritual center of Buddhism';
      case 'Rajgir':
        return 'Ancient city with hot springs';
      case 'Nalanda':
        return 'Historic university town';
      case 'Vaishali':
        return 'Ancient democratic republic';
      default:
        return 'Explore this beautiful city';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      _cityEmoji,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        city,
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppColors.primary : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _cityDescription,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 18,
                    ),
                  )
                else
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.textMuted,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Show city selector as a modal bottom sheet
Future<String?> showCitySelectorBottomSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) => const CitySelectorScreen(),
    ),
  );
}
