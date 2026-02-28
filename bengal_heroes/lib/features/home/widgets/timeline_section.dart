import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/timeline_repository.dart';
import '../../../shared/widgets/widget_build_arrow.dart';

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
                    width: 280,
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
                    'home.timeline_title'.tr(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: AppColors.primaryMaroon,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'home.timeline_subtitle'.tr(),
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
                        top: 20,
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
        BuildArrow(
        onPressed: _scrollLeft,
        icon: Icons.arrow_back_ios_new,
        isLeft: true,
        theme: widget.theme,
      ),

      BuildArrow(
        onPressed: _scrollRight,
        icon: Icons.arrow_forward_ios,
        isLeft: false,
        theme: widget.theme,
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

    return GestureDetector(
      onTap: () {
        context.push(
          '${AppRoutes.timelineEventDetail}/${widget.event.id}/timeline',
          extra: widget.event.toJson(),
        );
      },
      child: MouseRegion(
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
              width: 160,
              height: 130,
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
                        Flexible(
                          child: Text(
                            _getCategoryLabel(widget.event.category),
                            style: widget.theme.textTheme.labelSmall?.copyWith(
                              color: categoryColor,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
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
          return const Color(0xFF8B5A00);
        case 'war':
          return AppColors.primaryMaroon;
        case 'revolution':
          return const Color(0xFFD4AF37);
        case 'suffering':
          return const Color(0xFF424242);
        case 'event':
          return AppColors.secondaryOlive;
        case 'independence':
          return const Color(0xFF2E7D32);

        // NEW
        case 'state_violence':
          return const Color(0xFFB71C1C); // Deep Blood Red
        case 'state_conspiracy':
          return const Color(0xFF4A148C); // Dark Purple
        case 'border_clash':
          return const Color(0xFFBF360C); // Burnt Orange
        case 'protect':
          return const Color(0xFF1565C0); // Strong Blue

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

        // NEW
        case 'state_violence':
          return 'gavel';
        case 'state_conspiracy':
          return 'visibility_off';
        case 'border_clash':
          return 'security';
        case 'protect':
          return 'shield';

        default:
          return 'history';
      }
    }

 String _getCategoryLabel(String category) {
  switch (category) {
    case 'empire':
      return 'timeline.empire'.tr();
    case 'war':
      return 'timeline.war'.tr();
    case 'revolution':
      return 'timeline.revolution'.tr();
    case 'suffering':
      return 'timeline.crisis'.tr();
    case 'event':
      return 'timeline.event'.tr();
    case 'independence':
      return 'timeline.freedom'.tr();

    // NEW
    case 'violence':
      return 'timeline.state_violence'.tr();
    case 'conspiracy':
      return 'timeline.state_conspiracy'.tr();
    case 'clash':
      return 'timeline.border_clash'.tr();
    case 'protect':
      return 'timeline.protect'.tr();

    default:
      return 'timeline.history'.tr();
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

    // NEW
    case 'gavel':
      return Icons.gavel;
    case 'visibility_off':
      return Icons.visibility_off;
    case 'security':
      return Icons.security;
    case 'shield':
      return Icons.shield;

    default:
      return Icons.history;
  }
}
}
