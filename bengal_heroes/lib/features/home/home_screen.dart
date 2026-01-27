import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/providers/hero_provider.dart';
import '../../shared/widgets/widgets.dart';
import 'widgets/on_this_day_section.dart';
import 'widgets/era_carousel.dart';
import 'widgets/featured_heroes_section.dart';
import 'widgets/war_collection_section.dart';
import 'widgets/timeline_section.dart';

/// Home screen with "On This Day" and featured content
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            stretch: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bengal Heroes',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primaryGold.withValues(alpha: 0.1),
                      theme.scaffoldBackgroundColor,
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => context.push(AppRoutes.search),
                icon: const Icon(Icons.search),
                tooltip: 'Search',
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // On This Day Section
                const OnThisDaySection()
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.1, end: 0),

                const SizedBox(height: 24),

                // Featured Heroes
                const FeaturedHeroesSection()
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 400.ms)
                    .slideY(begin: 0.1, end: 0),

                const SizedBox(height: 24),

                // Explore by Era
                SectionHeader(
                  title: 'Explore by Era',
                  subtitle: 'Discover heroes from different periods',
                  actionText: 'See All',
                  onActionTap: () => context.go(AppRoutes.heroes),
                ),
                const SizedBox(height: 8),

                const EraCarousel()
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 400.ms)
                    .slideY(begin: 0.1, end: 0),

                const SizedBox(height: 24),

                // War & Political Movements Collection
                const WarCollectionSection()
                    .animate()
                    .fadeIn(delay: 500.ms, duration: 400.ms)
                    .slideY(begin: 0.1, end: 0),

                const SizedBox(height: 24),

                // Bengal Timeline
                const TimelineSection()
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 400.ms)
                    .slideY(begin: 0.1, end: 0),

                const SizedBox(height: 24),

                // Quick Stats
                _buildQuickStats(context, ref, locale),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, WidgetRef ref, String locale) {
    final theme = Theme.of(context);
    final heroCount = ref.watch(totalHeroCountProvider);
    final eras = ref.watch(allErasProvider);
    final categories = ref.watch(allCategoriesProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryMaroon.withValues(alpha: 0.05),
            AppColors.primaryGold.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryGold.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Collection Overview',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                context,
                icon: Icons.people,
                value: heroCount.when(
                  data: (count) => '$count',
                  loading: () => '...',
                  error: (_, _) => '0',
                ),
                label: 'Heroes',
                color: AppColors.primaryMaroon,
              ),
              _buildStatItem(
                context,
                icon: Icons.history,
                value: eras.when(
                  data: (list) => '${list.length}',
                  loading: () => '...',
                  error: (_, _) => '0',
                ),
                label: 'Eras',
                color: AppColors.secondaryOlive,
              ),
              _buildStatItem(
                context,
                icon: Icons.category,
                value: categories.when(
                  data: (list) => '${list.length}',
                  loading: () => '...',
                  error: (_, _) => '0',
                ),
                label: 'Categories',
                color: AppColors.secondaryTeal,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms, duration: 400.ms);
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
