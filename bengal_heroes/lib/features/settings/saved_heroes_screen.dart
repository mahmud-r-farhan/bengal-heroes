import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/providers/hero_provider.dart';
import '../../shared/providers/settings_provider.dart';
import '../../shared/widgets/widgets.dart';

/// Screen to view all saved (favorite) heroes
class SavedHeroesScreen extends ConsumerWidget {
  const SavedHeroesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteHeroIds = ref.watch(favoriteHeroesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Heroes'),
        elevation: 0,
      ),
      body: favoriteHeroIds.isEmpty
          ? Center(
              child: EmptyState(
                icon: Icons.favorite_border,
                title: 'No Saved Heroes',
                subtitle: 'Heroes you save will appear here',
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Header with count
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'You have ${favoriteHeroIds.length} saved hero${favoriteHeroIds.length > 1 ? 's' : ''}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryMaroon,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Grid of saved heroes
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: favoriteHeroIds.length,
                    itemBuilder: (context, index) {
                      final heroId = favoriteHeroIds.elementAt(index);
                      return _SavedHeroCard(heroId: heroId);
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}

/// Card widget for individual saved hero
class _SavedHeroCard extends ConsumerWidget {
  final String heroId;

  const _SavedHeroCard({required this.heroId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heroAsync = ref.watch(heroByIdProvider(heroId));
    final theme = Theme.of(context);

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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: theme.colorScheme.surface,
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Hero image
                if (hero.primaryImage.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
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
                    ),
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
                        Colors.black.withValues(alpha: 0.6),
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
                        hero.getName(Localizations.localeOf(context).languageCode),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        hero.dates.lifeSpan,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                // Remove from favorites button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      ref
                          .read(favoriteHeroesProvider.notifier)
                          .toggleFavorite(heroId);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Removed from saved heroes'),
                          duration: const Duration(milliseconds: 1500),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: const HeroCardShimmer(isCompact: true),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
