import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/models.dart' as models;
import '../providers/hero_provider.dart';
import '../providers/settings_provider.dart';

/// Hero card widget for list display
class HeroCard extends ConsumerWidget {
  final models.Hero hero;
  final bool isCompact;
  final VoidCallback? onTap;

  const HeroCard({
    super.key,
    required this.hero,
    this.isCompact = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final content = hero.getContent(locale);
    final era = ref.watch(eraByIdProvider(hero.eraId));
    final isFavorite = ref.watch(favoriteHeroesProvider).contains(hero.id);

    return GestureDetector(
      onTap: onTap ?? () => context.push(AppRoutes.getHeroDetailPath(hero.id)),
      child: Container(
        height: isCompact ? 120 : 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              _buildBackgroundImage(),

              // Gradient overlay
              Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.heroCardGradient,
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Era badge
                    era.when(
                      data: (eraData) => eraData != null
                          ? _buildEraBadge(context, eraData, locale)
                          : const SizedBox.shrink(),
                      loading: () => const SizedBox.shrink(),
                      error: (_, _) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 8),

                    // Name
                    Text(
                      content.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    if (!isCompact) ...[
                      const SizedBox(height: 4),
                      // Life span
                      Text(
                        _getLifeSpan(hero.dates),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Short bio (truncated)
                      Text(
                        content.shortBio,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Favorite button
              Positioned(
                top: 8,
                right: 8,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      ref
                          .read(favoriteHeroesProvider.notifier)
                          .toggleFavorite(hero.id);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                        size: 20,
                      ),
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

  Widget _buildBackgroundImage() {
    if (hero.primaryImage.isEmpty) {
      return Container(
        color: AppColors.primaryMaroon,
        child: const Center(
          child: Icon(
            Icons.person,
            color: Colors.white54,
            size: 48,
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
              color: Colors.white54,
              size: 48,
            ),
          ),
        );
      },
    );
  }

  Widget _buildEraBadge(BuildContext context, models.Era era, String locale) {
    final eraColor = AppColors.getEraColor(era.id);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: eraColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        era.getName(locale),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

/// Horizontal hero card for carousel display
class HeroCardHorizontal extends ConsumerWidget {
  final models.Hero hero;
  final double width;

  const HeroCardHorizontal({
    super.key,
    required this.hero,
    this.width = 280,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final content = hero.getContent(locale);

    return GestureDetector(
      onTap: () => context.push(AppRoutes.getHeroDetailPath(hero.id)),
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background
              _buildBackgroundImage(),

              // Gradient overlay
              Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.heroCardGradient,
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      content.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getLifeSpan(hero.dates),
                      style: theme.textTheme.bodySmall?.copyWith(
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
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.1, end: 0);
  }

  Widget _buildBackgroundImage() {
    if (hero.primaryImage.isEmpty) {
      return Container(
        color: AppColors.primaryMaroon,
        child: const Center(
          child: Icon(Icons.person, color: Colors.white54, size: 40),
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
            child: Icon(Icons.person, color: Colors.white54, size: 40),
          ),
        );
      },
    );
  }
}

String _getLifeSpan(models.HeroDates dates) {
  final birth = dates.birthYear;
  final death = dates.deathYear;
  if (birth != null && death != null) {
    return '$birth - $death';
  } else if (birth != null) {
    return '${'common.born_abbr'.tr()} $birth';
  } else if (death != null) {
    return '${'common.died_abbr'.tr()} $death';
  }
  return '';
}
