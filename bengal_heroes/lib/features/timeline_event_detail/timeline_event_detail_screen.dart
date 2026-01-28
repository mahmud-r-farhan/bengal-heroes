import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/timeline_model.dart';
import '../../shared/widgets/icon_picker.dart';

/// Screen for displaying detailed information about a specific timeline/traveler event
class TimelineEventDetailScreen extends StatelessWidget {
  final TimelineEvent event;
  final String type; // 'timeline' or 'travelers'

  const TimelineEventDetailScreen({
    super.key,
    required this.event,
    required this.type,
  });

  Color _getCategoryColor() {
    switch (event.category) {
      case 'empire':
        return AppColors.primaryMaroon;
      case 'war':
        return const Color(0xFFD84315);
      case 'revolution':
        return const Color(0xFF6A1B9A);
      case 'crisis':
        return const Color(0xFFF57F17);
      case 'freedom':
        return const Color(0xFF00897B);
      case 'event':
        return AppColors.primaryGold;
      case 'diplomat':
        return const Color(0xFF0277BD);
      case 'pilgrim':
        return const Color(0xFF7B1FA2);
      case 'explorer':
        return const Color(0xFF00838F);
      case 'trader':
        return const Color(0xFF5D4037);
      case 'scholar':
        return const Color(0xFF3E2723);
      default:
        return AppColors.primaryMaroon;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final categoryColor = _getCategoryColor();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 260,
            floating: false,
            pinned: true,
            stretch: true,
            backgroundColor: categoryColor.withValues(alpha: 0.1),
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: categoryColor,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      categoryColor.withValues(alpha: 0.25),
                      categoryColor.withValues(alpha: 0.05),
                    ],
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 40,
                      right: -30,
                      child: Icon(
                        IconPicker.getIconData(event.icon),
                        size: 140,
                        color: categoryColor.withValues(alpha: 0.15),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 24,
                      right: 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: categoryColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: categoryColor.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Text(
                              event.period,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: categoryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              collapseMode: CollapseMode.parallax,
              stretchModes: const [StretchMode.zoomBackground],
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Decorative line
                      Container(
                        height: 4,
                        width: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              categoryColor,
                              categoryColor.withValues(alpha: 0),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        event.title.get(locale),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: categoryColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: categoryColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: categoryColor.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              event.category.replaceFirst(
                                event.category[0],
                                event.category[0].toUpperCase(),
                              ),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: categoryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (event.significance != 'low')
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGold.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.primaryGold.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: Text(
                                event.significance.toUpperCase(),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: AppColors.primaryGold,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Main Description Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          categoryColor.withValues(alpha: 0.08),
                          categoryColor.withValues(alpha: 0.03),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: categoryColor.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: categoryColor.withValues(alpha: 0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: categoryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          event.description.get(locale),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.8,
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Year Badge Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primaryGold.withValues(alpha: 0.12),
                          AppColors.primaryGold.withValues(alpha: 0.04),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primaryGold.withValues(alpha: 0.25),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGold.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.calendar_month,
                            color: AppColors.primaryGold,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Year',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              event.year <= 0
                                  ? '${-event.year} BC'
                                  : '${event.year} AD',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryGold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Historical Context
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          categoryColor.withValues(alpha: 0.06),
                          categoryColor.withValues(alpha: 0.02),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: categoryColor.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: categoryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Part of Bengal\'s rich historical heritage, this event shaped the culture and identity of the region.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
