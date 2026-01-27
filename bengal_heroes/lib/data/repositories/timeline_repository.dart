import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/local_data_source.dart';
import '../../data/models/timeline_model.dart';

class TimelineRepository {
  final LocalDataSource _dataSource;

  TimelineRepository(this._dataSource);

  Future<List<TimelineEvent>> getAllTimelineEvents() async {
    return _dataSource.getTimelineEvents();
  }

  Future<List<TimelineEvent>> getTimelineEventsByCategory(
    String category,
  ) async {
    final events = await _dataSource.getTimelineEvents();
    return events.where((event) => event.category == category).toList();
  }

  Future<List<TimelineEvent>> getTimelineEventsByPeriod(
    int startYear,
    int endYear,
  ) async {
    final events = await _dataSource.getTimelineEvents();
    return events
        .where((event) => event.year >= startYear && event.year <= endYear)
        .toList();
  }
}

final timelineRepositoryProvider = Provider<TimelineRepository>((ref) {
  return TimelineRepository(LocalDataSource.instance);
});

final allTimelineEventsProvider = FutureProvider<List<TimelineEvent>>((ref) {
  final repository = ref.watch(timelineRepositoryProvider);
  return repository.getAllTimelineEvents();
});

final timelineEventsByCategoryProvider =
    FutureProvider.family<List<TimelineEvent>, String>((ref, category) {
  final repository = ref.watch(timelineRepositoryProvider);
  return repository.getTimelineEventsByCategory(category);
});

final timelineEventsByPeriodProvider =
    FutureProvider.family<List<TimelineEvent>, (int, int)>((ref, period) {
  final repository = ref.watch(timelineRepositoryProvider);
  return repository.getTimelineEventsByPeriod(period.$1, period.$2);
});
