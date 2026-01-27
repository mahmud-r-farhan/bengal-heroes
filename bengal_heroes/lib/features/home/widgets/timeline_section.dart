import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/timeline_repository.dart';

/// Timeline Section showing Bengal's historical timeline
class TimelineSection extends ConsumerWidget {
  const TimelineSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final timelineEvents = ref.watch(allTimelineEventsProvider);

    return timelineEvents.when(
      data: (events) {
        if (events.isEmpty) {
          return const SizedBox.shrink();
        }

        // Sort events by year
        final sortedEvents = List<TimelineEvent>.from(events)
          ..sort((a, b) => a.year.compareTo(b.year));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
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
                    'Bengal Through Time',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: AppColors.primaryMaroon,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'A journey through empires, revolutions, and independence',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Timeline
            _TimelineVisualization(
              events: sortedEvents,
              locale: locale,
              theme: theme,
            ),

            const SizedBox(height: 24),
          ],
        )
            .animate()
            .fadeIn(delay: 600.ms, duration: 400.ms)
            .slideY(begin: 0.1, end: 0);
      },
      loading: () {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryMaroon,
            ),
          ),
        );
      },
      error: (error, _) {
        return const SizedBox.shrink();
      },
    );
  }
}

/// Vertical timeline visualization
class _TimelineVisualization extends StatefulWidget {
  final List<TimelineEvent> events;
  final String locale;
  final ThemeData theme;

  const _TimelineVisualization({
    required this.events,
    required this.locale,
    required this.theme,
  });

  @override
  State<_TimelineVisualization> createState() => _TimelineVisualizationState();
}

class _TimelineVisualizationState extends State<_TimelineVisualization> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 200,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 200,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Row(
              children: [
                SizedBox(
                  width: widget.events.length * 160,
                  child: Stack(
                    children: [
                      // Timeline line
                      Positioned(
                        top: 40,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryMaroon.withValues(alpha: 0.3),
                                AppColors.primaryMaroon.withValues(alpha: 0),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Timeline items
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          widget.events.length,
                          (index) {
                            final event = widget.events[index];
                            return Expanded(
                              child: _TimelineItem(
                                event: event,
                                locale: widget.locale,
                                theme: widget.theme,
                                index: index,
                                total: widget.events.length,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Left Arrow
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: widget.theme.colorScheme.surface.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: _scrollLeft,
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  color: AppColors.primaryMaroon,
                  tooltip: 'Scroll Left',
                ),
              ),
            ),
          ),

          // Right Arrow
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: widget.theme.colorScheme.surface.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: _scrollRight,
                  icon: const Icon(Icons.arrow_forward_ios, size: 20),
                  color: AppColors.primaryMaroon,
                  tooltip: 'Scroll Right',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual timeline item
class _TimelineItem extends StatefulWidget {
  final TimelineEvent event;
  final String locale;
  final ThemeData theme;
  final int index;
  final int total;

  const _TimelineItem({
    required this.event,
    required this.locale,
    required this.theme,
    required this.index,
    required this.total,
  });

  @override
  State<_TimelineItem> createState() => _TimelineItemState();
}

class _TimelineItemState extends State<_TimelineItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(widget.event.category);
    final categoryIcon = _getCategoryIcon(widget.event.category);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Timeline dot
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _isHovered ? 20 : 16,
              height: _isHovered ? 20 : 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: categoryColor,
                border: Border.all(
                  color: _isHovered ? categoryColor : Colors.white,
                  width: _isHovered ? 2 : 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: categoryColor.withValues(
                      alpha: _isHovered ? 0.4 : 0.2,
                    ),
                    blurRadius: _isHovered ? 12 : 8,
                    spreadRadius: _isHovered ? 2 : 1,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Event card
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 140,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.theme.colorScheme.surface,
                border: Border.all(
                  color: _isHovered
                      ? categoryColor
                      : categoryColor.withValues(alpha: 0.2),
                  width: _isHovered ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered
                        ? categoryColor.withValues(alpha: 0.2)
                        : Colors.black.withValues(alpha: 0.05),
                    blurRadius: _isHovered ? 12 : 6,
                    offset: _isHovered ? const Offset(0, 4) : const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Year
                  Text(
                    '${widget.event.year}',
                    style: widget.theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: categoryColor,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getIconData(categoryIcon),
                          size: 12,
                          color: categoryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getCategoryLabel(widget.event.category),
                          style: widget.theme.textTheme.labelSmall?.copyWith(
                            color: categoryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Title
                  Text(
                    widget.event.title.getByLocale(widget.locale),
                    style: widget.theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(
                  duration: 2000.ms,
                  color: categoryColor.withValues(alpha: 0.1),
                ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(
          duration: 400.ms,
          delay: Duration(milliseconds: 100 + (widget.index * 50)),
        )
        .slideY(
          begin: 0.2,
          end: 0,
          duration: 400.ms,
          delay: Duration(milliseconds: 100 + (widget.index * 50)),
        );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'empire':
        return const Color(0xFF8B5A00); // Brown for empires
      case 'war':
        return AppColors.primaryMaroon; // Red for wars
      case 'revolution':
        return const Color(0xFFD4AF37); // Gold for revolutions
      case 'suffering':
        return const Color(0xFF424242); // Dark gray for suffering
      case 'event':
        return AppColors.secondaryOlive; // Olive for events
      case 'independence':
        return const Color(0xFF2E7D32); // Green for independence
      default:
        return AppColors.secondaryTeal;
    }
  }

  String _getCategoryIcon(String category) {
    switch (category) {
      case 'empire':
        return 'crown';
      case 'war':
        return 'local_fire_department';
      case 'revolution':
        return 'groups';
      case 'suffering':
        return 'sentiment_very_dissatisfied';
      case 'event':
        return 'trending_down';
      case 'independence':
        return 'flag';
      default:
        return 'history';
    }
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'empire':
        return 'Empire';
      case 'war':
        return 'War';
      case 'revolution':
        return 'Revolution';
      case 'suffering':
        return 'Crisis';
      case 'event':
        return 'Event';
      case 'independence':
        return 'Freedom';
      default:
        return 'History';
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'crown':
        return Icons.dashboard_customize;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'groups':
        return Icons.groups;
      case 'sentiment_very_dissatisfied':
        return Icons.sentiment_very_dissatisfied;
      case 'trending_down':
        return Icons.trending_down;
      case 'flag':
        return Icons.flag;
      default:
        return Icons.history;
    }
  }
}
