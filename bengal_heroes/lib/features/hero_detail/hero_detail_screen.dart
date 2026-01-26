import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/models.dart' as models;
import '../../shared/providers/hero_provider.dart';
import '../../shared/providers/settings_provider.dart';
import '../../shared/widgets/widgets.dart';

/// Hero detail screen showing full biography and information
class HeroDetailScreen extends ConsumerWidget {
  final String heroId;

  const HeroDetailScreen({super.key, required this.heroId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;
    final heroAsync = ref.watch(heroByIdProvider(heroId));

    return heroAsync.when(
      data: (hero) {
        if (hero == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const EmptyState(
              icon: Icons.person_off,
              title: 'Hero not found',
              subtitle: 'This hero may have been removed',
            ),
          );
        }
        return _HeroDetailContent(hero: hero, locale: locale);
      },
      loading: () => Scaffold(
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: ErrorState(
          message: error.toString(),
          onRetry: () => ref.refresh(heroByIdProvider(heroId)),
        ),
      ),
    );
  }
}

class _HeroDetailContent extends ConsumerWidget {
  final models.Hero hero;
  final String locale;

  const _HeroDetailContent({
    required this.hero,
    required this.locale,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final content = hero.getContent(locale);
    final era = ref.watch(eraByIdProvider(hero.eraId));
    final isFavorite = ref.watch(favoriteHeroesProvider).contains(hero.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero Header with Image
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.primaryMaroon,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  ref
                      .read(favoriteHeroesProvider.notifier)
                      .toggleFavorite(hero.id);
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  // Share functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share coming soon!')),
                  );
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share, color: Colors.white),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Hero image
                  _buildHeroImage(),

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
                        stops: const [0.5, 1.0],
                      ),
                    ),
                  ),

                  // Hero name and basic info at bottom
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Era badge
                        era.when(
                          data: (eraData) => eraData != null
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.getEraColor(eraData.id)
                                        .withValues(alpha: 0.9),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    eraData.getName(locale),
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          loading: () => const SizedBox.shrink(),
                          error: (_, _) => const SizedBox.shrink(),
                        ),
                        const SizedBox(height: 12),

                        // Name
                        Text(
                          content.name,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Life span
                        Text(
                          hero.dates.lifeSpan,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
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
                  // Categories
                  _buildCategories(context, ref),

                  const SizedBox(height: 24),

                  // Quote (if available)
                  if (content.quote != null && content.quote!.isNotEmpty)
                    _buildQuote(context, content.quote!)
                        .animate()
                        .fadeIn(delay: 100.ms)
                        .slideY(begin: 0.1, end: 0),

                  // Short bio
                  _buildSection(
                    context,
                    title: 'Overview',
                    content: content.shortBio,
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 24),

                  // Full biography
                  _buildSection(
                    context,
                    title: 'Biography',
                    content: content.fullBiography,
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),

                  // Birth place (if available)
                  if (content.birthPlace != null &&
                      content.birthPlace!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildInfoCard(
                      context,
                      icon: Icons.place,
                      title: 'Birth Place',
                      content: content.birthPlace!,
                    ).animate().fadeIn(delay: 400.ms),
                  ],

                  // Achievements (if available)
                  if (content.achievements != null &&
                      content.achievements!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildSection(
                      context,
                      title: 'Achievements',
                      content: content.achievements!,
                    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1, end: 0),
                  ],

                  // Related heroes
                  const SizedBox(height: 32),
                  _buildRelatedHeroes(context, ref)
                      .animate()
                      .fadeIn(delay: 600.ms),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    if (hero.primaryImage.isEmpty) {
      return Container(
        color: AppColors.primaryMaroon,
        child: const Center(
          child: Icon(
            Icons.person,
            color: Colors.white30,
            size: 100,
          ),
        ),
      );
    }

    return Image.asset(
      hero.primaryImage,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: AppColors.primaryMaroon,
          child: const Center(
            child: Icon(
              Icons.person,
              color: Colors.white30,
              size: 100,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategories(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: hero.categoryIds.map((categoryId) {
        final category = ref.watch(categoryByIdProvider(categoryId));
        return category.when(
          data: (cat) {
            if (cat == null) return const SizedBox.shrink();
            final color = AppColors.getCategoryColor(cat.id);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Text(
                cat.getName(locale),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
        );
      }).toList(),
    );
  }

  Widget _buildQuote(BuildContext context, String quote) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGold.withValues(alpha: 0.1),
            AppColors.primaryMaroon.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            color: AppColors.primaryGold,
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.format_quote,
            color: AppColors.primaryGold,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            quote,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.7,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryGold,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  content,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedHeroes(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final relatedHeroes = ref.watch(relatedHeroesProvider(hero));

    return relatedHeroes.when(
      data: (heroes) {
        if (heroes.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Related Heroes',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: heroes.length,
                itemBuilder: (context, index) {
                  return HeroCardHorizontal(
                    hero: heroes[index],
                    width: 250,
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
