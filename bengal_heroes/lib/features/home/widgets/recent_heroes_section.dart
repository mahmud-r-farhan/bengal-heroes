import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/hero_provider.dart';
import '../../../shared/providers/settings_provider.dart';
import '../../../shared/widgets/widgets.dart';

/// Recently viewed heroes section for home screen
class RecentHeroesSection extends ConsumerWidget {
  const RecentHeroesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentlyViewed = ref.watch(recentlyViewedHeroesProvider);

    if (recentlyViewed.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Recently Viewed',
          subtitle: 'Continue reading your heroes',
          actionText: 'common.view_all'.tr(),
          onActionTap: () => context.go(AppRoutes.heroes),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: recentlyViewed.length,
            itemBuilder: (context, index) {
              final heroId = recentlyViewed[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _RecentHeroCard(heroId: heroId),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Individual recent hero card
class _RecentHeroCard extends ConsumerWidget {
  final String heroId;

  const _RecentHeroCard({required this.heroId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heroAsync = ref.watch(heroByIdProvider(heroId));
    final locale = Localizations.localeOf(context).languageCode;

    return heroAsync.when(
      data: (hero) {
        if (hero == null) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          onTap: () {
            context.push(AppRoutes.getHeroDetailPath(heroId));
          },
          child: Container(
            width: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Hero image
                  if (hero.primaryImage.isNotEmpty)
                    Image.asset(
                      hero.primaryImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.primaryMaroon,
                          child: const Center(
                            child: Icon(
                              Icons.person,
                              color: Colors.white30,
                              size: 48,
                            ),
                          ),
                        );
                      },
                    )
                  else
                    Container(
                      color: AppColors.primaryMaroon,
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          color: Colors.white30,
                          size: 48,
                        ),
                      ),
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
                        stops: const [0.4, 1.0],
                      ),
                    ),
                  ),

                  // Name and info at bottom
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          hero.getName(locale),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),

                  // Badge for "recently viewed"
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGold.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Recent',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const HeroCardHorizontalShimmer(width: 160),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
