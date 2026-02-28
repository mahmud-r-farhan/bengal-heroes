import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../shared/providers/hero_provider.dart';
import '../../../shared/widgets/widgets.dart';

/// Featured heroes section for home screen
class FeaturedHeroesSection extends ConsumerWidget {
  const FeaturedHeroesSection({super.key});

  /// Get today's date as a seed for consistent randomization throughout the day
  static int _getDailyRandomSeed() {
    final now = DateTime.now();
    return now.year * 10000 + now.month * 100 + now.day;
  }

  /// Get randomly selected featured heroes that change daily
  static List<T> _getRandomFeaturedHeroes<T>(
    List<T> heroes,
    int count, {
    required bool Function(T) filter,
  }) {
    final random = Random(_getDailyRandomSeed());
    
    // Filter heroes by criteria (importance >= 4)
    final filtered = heroes.where(filter).toList();
    
    // If not enough filtered heroes, add more from the full list
    if (filtered.length < count) {
      final remaining = heroes
          .where((h) => !filtered.contains(h))
          .toList();
      filtered.addAll(remaining);
    }
    
    // Shuffle with daily seed and take top count
    filtered.shuffle(random);
    return filtered.take(count).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heroes = ref.watch(allHeroesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'home.featured_heroes'.tr(),
          subtitle: 'home.featured_heroes_subtitle'.tr(),
          actionText: 'common.view_all'.tr(),
          onActionTap: () => context.go(AppRoutes.heroes),
        ),
        const SizedBox(height: 8),
        heroes.when(
          data: (heroList) {
            // Get randomly selected featured heroes (changes daily)
            final featured = _getRandomFeaturedHeroes(
              heroList,
              5,
              filter: (h) => (h.importance ?? 0) >= 4,
            );

            if (featured.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: EmptyState(
                  icon: Icons.people_outline,
                  title: 'No heroes yet',
                  subtitle: 'Heroes will appear here once added',
                ),
              );
            }

            return SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: featured.length,
                itemBuilder: (context, index) {
                  return HeroCardHorizontal(
                    hero: featured[index],
                    width: 280,
                  );
                },
              ),
            );
          },
          loading: () => const HeroCarouselShimmer(
            itemCount: 3,
            itemWidth: 280,
            height: 180,
          ),
          error: (error, _) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ErrorState(
              message: error.toString(),
              onRetry: () => ref.refresh(allHeroesProvider),
            ),
          ),
        ),
      ],
    );
  }
}