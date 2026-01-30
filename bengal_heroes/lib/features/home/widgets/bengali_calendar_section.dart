import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/utils/bengali_calendar_utils.dart';
import '../../../shared/models/bengali_date_model.dart';

/// Bengali Calendar Section
/// Displays the current date in Bengali calendar format
/// Auto-refreshes at midnight
class BengaliCalendarSection extends StatefulWidget {
  const BengaliCalendarSection({super.key});

  @override
  State<BengaliCalendarSection> createState() => _BengaliCalendarSectionState();
}

class _BengaliCalendarSectionState extends State<BengaliCalendarSection> {
  late BengaliDate _bengaliDate;
  late Timer _midnightTimer;

  @override
  void initState() {
    super.initState();
    _updateBengaliDate();
    _scheduleNextUpdate();
  }

  @override
  void dispose() {
    _midnightTimer.cancel();
    super.dispose();
  }

  void _updateBengaliDate() {
    setState(() {
      _bengaliDate = BengaliCalendarUtils.now();
    });
  }

  void _scheduleNextUpdate() {
    // Calculate time until next midnight
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final durationUntilMidnight = tomorrow.difference(now);

    _midnightTimer = Timer(durationUntilMidnight, () {
      _updateBengaliDate();
      _scheduleNextUpdate(); // Schedule next update
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final gregorianDateString =
        DateFormat('MMMM dd, yyyy').format(now);

    return Padding(
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
                  AppColors.primaryGold,
                  AppColors.primaryGold.withValues(alpha: 0),
                ],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            'home.bengali_calendar_title'.tr(),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: AppColors.primaryGold,
            ),
          ),
          const SizedBox(height: 4),

          // Subtitle
          Text(
            'home.bengali_calendar_subtitle'.tr(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Calendar Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryGold.withValues(alpha: 0.08),
                  AppColors.primaryMaroon.withValues(alpha: 0.05),
                ],
              ),
              border: Border.all(
                color: AppColors.primaryGold.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGold.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Bengali Date (Large)
                Text(
                  _bengaliDate.bengaliDay,
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),

                // Month and Year in Bengali
                Text(
                  '${_bengaliDate.monthName} ${_bengaliDate.bengaliYearString}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),

                // Divider
                Container(
                  height: 1,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryGold.withValues(alpha: 0),
                        AppColors.primaryGold.withValues(alpha: 0.3),
                        AppColors.primaryGold.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Gregorian Date and Day Name
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'gregorian_date'.tr(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          gregorianDateString,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'day_name'.tr(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _bengaliDate.dayName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryGold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 500.ms)
              .scale(
                begin: const Offset(0.95, 0.95),
                end: const Offset(1, 1),
                duration: 500.ms,
              ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.1, end: 0);
  }
}

