import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/hero_repository.dart';
import 'hero_provider.dart';

/// Provider for current date (can be mocked for testing)
final currentDateProvider = Provider<DateTime>((ref) {
  return DateTime.now();
});

/// Provider for "On This Day" data
final onThisDayProvider = FutureProvider<OnThisDayData>((ref) async {
  final repository = ref.watch(heroRepositoryProvider);
  final currentDate = ref.watch(currentDateProvider);
  return repository.getOnThisDayData(currentDate);
});

/// Provider for checking if there's data for today
final hasOnThisDayDataProvider = Provider<AsyncValue<bool>>((ref) {
  return ref.watch(onThisDayProvider).whenData((data) => data.isNotEmpty);
});
