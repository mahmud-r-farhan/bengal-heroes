import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/models.dart' as models;
import '../../../data/repositories/hero_repository.dart';
import '../../../shared/providers/on_this_day_provider.dart';
import '../../../shared/widgets/widgets.dart';

/// "On This Day" section showing historical events for today with enhanced historical aesthetic
class OnThisDaySection extends ConsumerWidget {
  const OnThisDaySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;
    final onThisDayData = ref.watch(onThisDayProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Enhanced Header with vintage aesthetic
        _buildEnhancedHeader(context, locale),

        const SizedBox(height: 16),

        // Content with loading state
        onThisDayData.when(
          data: (data) {
            if (data.isEmpty) {
              return _buildEnhancedEmptyState(context, locale);
            }
            return _buildEnhancedContent(context, data, locale);
          },
          loading: () => const HeroCarouselShimmer(
            itemCount: 2,
            itemWidth: 300,
            height: 200,
          ),
          error: (error, _) => _buildErrorState(context, error),
        ),
      ],
    );
  }

  Widget _buildEnhancedHeader(BuildContext context, String locale) {
    final theme = Theme.of(context);
    final today = DateTime.now();
    final formattedDate = DateFormat('MMMM d', locale).format(today);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Decorative top line
          Container(
            height: 2,
            width: 40,
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          // Main header with icon
          Row(
            children: [
              // Ornamental icon container
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGold.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.history,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main title with serif-like styling
                    Text(
                      'home.on_this_day'.tr(),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Date with decorative elements
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.primaryGold,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          formattedDate,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.primaryGold,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Decorative bottom line
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryGold,
                  AppColors.primaryGold.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedEmptyState(BuildContext context, String locale) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryGold.withValues(alpha: 0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Large decorative icon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.book,
              size: 56,
              color: AppColors.primaryGold.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'on_this_day_events.no_records'.tr(),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            'on_this_day_events.no_records_desc'.tr(),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedContent(
    BuildContext context,
    OnThisDayData data,
    String locale,
  ) {
    final items = <Widget>[];

    // Add birth cards with animation
    for (int i = 0; i < data.births.length; i++) {
      items.add(_EnhancedOnThisDayCard(
        hero: data.births[i],
        locale: locale,
        eventType: OnThisDayEventType.birth,
        animationDelay: i,
      ));
    }

    // Add death cards with animation
    for (int i = 0; i < data.deaths.length; i++) {
      items.add(_EnhancedOnThisDayCard(
        hero: data.deaths[i],
        locale: locale,
        eventType: OnThisDayEventType.death,
        animationDelay: data.births.length + i,
      ));
    }

    // Add event cards with animation
    for (int i = 0; i < data.events.length; i++) {
      items.add(_EnhancedOnThisDayEventCard(
        event: data.events[i],
        locale: locale,
        animationDelay: data.births.length + data.deaths.length + i,
      ));
    }

    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return items[index]
              .animate()
              .fadeIn(
                duration: const Duration(milliseconds: 600),
                delay: Duration(milliseconds: 100 * (index % 3)),
              )
              .slideX(
                begin: 0.2,
                end: 0,
                duration: const Duration(milliseconds: 600),
                delay: Duration(milliseconds: 100 * (index % 3)),
              );
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.error,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'common.error'.tr(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum OnThisDayEventType { birth, death }

class _EnhancedOnThisDayCard extends StatefulWidget {
  final models.Hero hero;
  final String locale;
  final OnThisDayEventType eventType;
  final int animationDelay;

  const _EnhancedOnThisDayCard({
    required this.hero,
    required this.locale,
    required this.eventType,
    required this.animationDelay,
  });

  @override
  State<_EnhancedOnThisDayCard> createState() => _EnhancedOnThisDayCardState();
}

class _EnhancedOnThisDayCardState extends State<_EnhancedOnThisDayCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = widget.hero.getContent(widget.locale);
    final isBirth = widget.eventType == OnThisDayEventType.birth;
    final color = isBirth ? AppColors.success : AppColors.primaryMaroon;
    final year = isBirth ? widget.hero.dates.birthYear : widget.hero.dates.deathYear;
    final icon = isBirth ? Icons.cake : Icons.local_florist;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
          width: 300,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: theme.colorScheme.surface,
            border: Border.all(
              color: _isHovered ? color : color.withValues(alpha: 0.2),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered ? color.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.08),
                blurRadius: _isHovered ? 20 : 12,
                offset: _isHovered ? const Offset(0, 8) : const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background decorative element
              Positioned(
                top: -40,
                right: -40,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Main content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event type badge with icon
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: color.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            icon,
                            size: 14,
                            color: color,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isBirth ? 'on_this_day_events.born'.tr() : 'on_this_day_events.remembered'.tr(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: color,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Hero name
                    Text(
                      content.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Year with styling
                    if (year != null)
                      Row(
                        children: [
                          Container(
                            width: 3,
                            height: 3,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            year,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: color,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),

                    const Spacer(),

                    // Short bio with fade effect
                    Text(
                      content.shortBio,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 12),

                    // Bottom accent line
                    Container(
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color,
                            color.withValues(alpha: 0),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
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

class _EnhancedOnThisDayEventCard extends StatefulWidget {
  final models.GlobalEvent event;
  final String locale;
  final int animationDelay;

  const _EnhancedOnThisDayEventCard({
    required this.event,
    required this.locale,
    required this.animationDelay,
  });

  @override
  State<_EnhancedOnThisDayEventCard> createState() => _EnhancedOnThisDayEventCardState();
}

class _EnhancedOnThisDayEventCardState extends State<_EnhancedOnThisDayEventCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = AppColors.secondaryNavy;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: theme.colorScheme.surface,
          border: Border.all(
            color: _isHovered ? color : color.withValues(alpha: 0.2),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered ? color.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.08),
              blurRadius: _isHovered ? 20 : 12,
              offset: _isHovered ? const Offset(0, 8) : const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative corner element
            Positioned(
              bottom: -30,
              left: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.04),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Main content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: color.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.flag,
                          size: 14,
                          color: color,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'on_this_day_events.historical_event'.tr(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Event title
                  Text(
                    widget.event.getTitle(widget.locale),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Year with styling
                  if (widget.event.year != null) ...[
                    Row(
                      children: [
                        Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.event.year!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],

                  const Spacer(),

                  // Description
                  Text(
                    widget.event.getDescription(widget.locale),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),

                  // Bottom accent line
                  Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color,
                          color.withValues(alpha: 0),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
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