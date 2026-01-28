import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/models.dart' as models;
import '../../../shared/providers/hero_provider.dart';

/// War & Political Movements Collection Section
class WarCollectionSection extends ConsumerWidget {
  const WarCollectionSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final heroRepository = ref.watch(heroRepositoryProvider);

    return FutureBuilder<List<models.Category>>(
      future: heroRepository.getAllCategories(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        // Find war_movement category
        models.Category? warCategory;
        for (final cat in snapshot.data ?? []) {
          if (cat.id == 'war_movement') {
            warCategory = cat;
            break;
          }
        }

        if (warCategory == null) {
          return const SizedBox.shrink();
        }

        return FutureBuilder<List<models.Hero>>(
          future: heroRepository.getHeroesByCategory('war_movement'),
          builder: (context, heroSnapshot) {
            if (!heroSnapshot.hasData || heroSnapshot.data!.isEmpty) {
              return const SizedBox.shrink();
            }

            final warHeroes = heroSnapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Decorative line
                      Container(
                        height: 3,
                        width: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryMaroon,
                              AppColors.primaryMaroon.withValues(alpha: 0),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'home.war_title'.tr(),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          color: AppColors.primaryMaroon,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'home.war_subtitle'.tr(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Timeline/War events carousel
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: warHeroes.length,
                    itemBuilder: (context, index) {
                      final hero = warHeroes[index];
                      return _WarEventCard(
                        hero: hero,
                        locale: locale,
                        onTap: () {
                          // Navigate to war heroes list filtered by war_movement category
                          context.push(
                            AppRoutes.getWarMovementsPath('war_movement'),
                          );
                        },
                      )
                          .animate()
                          .fadeIn(
                            duration: 400.ms,
                            delay: Duration(milliseconds: 100 * index),
                          )
                          .slideX(
                            begin: 0.2,
                            end: 0,
                            duration: 400.ms,
                            delay: Duration(milliseconds: 100 * index),
                          );
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // View All button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.push(
                          AppRoutes.getWarMovementsPath('war_movement'),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: Text(
                        'home.war_explore'.tr(),
                        style: theme.textTheme.labelLarge,
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: AppColors.primaryMaroon,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )
                .animate()
                .fadeIn(delay: 200.ms, duration: 400.ms)
                .slideY(begin: 0.1, end: 0);
          },
        );
      },
    );
  }
}

/// Individual war event card
class _WarEventCard extends StatefulWidget {
  final models.Hero hero;
  final String locale;
  final VoidCallback onTap;

  const _WarEventCard({
    required this.hero,
    required this.locale,
    required this.onTap,
  });

  @override
  State<_WarEventCard> createState() => _WarEventCardState();
}

class _WarEventCardState extends State<_WarEventCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = widget.hero.getContent(widget.locale);
    final birthYear = widget.hero.dates.birthYear;
    final deathYear = widget.hero.dates.deathYear;

    final timeRange = _getTimeRange(birthYear, deathYear);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(right: 12),
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: theme.colorScheme.surface,
            border: Border.all(
              color: _isHovered
                  ? AppColors.primaryMaroon
                  : AppColors.primaryMaroon.withValues(alpha: 0.2),
              width: _isHovered ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.primaryMaroon.withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: _isHovered ? 16 : 8,
                offset: _isHovered ? const Offset(0, 6) : const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative background element
              Positioned(
                top: -30,
                right: -30,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primaryMaroon.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Year badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryMaroon.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primaryMaroon.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        timeRange,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryMaroon,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Hero name
                    Text(
                      content.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Spacer(),

                    // Short bio
                    Text(
                      content.shortBio,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Tap to view indicator
                    Row(
                      children: [
                        Icon(
                          Icons.arrow_forward,
                          size: 14,
                          color: AppColors.primaryMaroon.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'common.view_details'.tr(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.primaryMaroon.withValues(alpha: 0.7),
                            ),
                            overflow: TextOverflow.ellipsis,
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
      ),
    );
  }

  String _getTimeRange(String? birthYear, String? deathYear) {
    if (birthYear != null && deathYear != null) {
      return '$birthYear - $deathYear';
    } else if (birthYear != null) {
      return '${'common.born_abbr'.tr()} $birthYear';
    } else if (deathYear != null) {
      return '${'common.died_abbr'.tr()} $deathYear';
    }
    return 'filter.era'.tr();
  }
}
