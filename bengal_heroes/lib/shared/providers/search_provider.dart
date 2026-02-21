import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/hero_repository.dart';
import 'hero_provider.dart';

/// Provider for search query
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Provider for unified search results (heroes, timeline, travelers, events)
final unifiedSearchResultsProvider = FutureProvider<List<BaseSearchResult>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return [];

  final repository = ref.watch(heroRepositoryProvider);
  return repository.searchAll(query);
});

/// Provider for search results (legacy - heroes only)
final searchResultsProvider = FutureProvider<List<SearchResult>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return [];

  final repository = ref.watch(heroRepositoryProvider);
  return repository.searchHeroes(query);
});

/// Provider for search loading state
final isSearchingProvider = Provider<bool>((ref) {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return false;
  
  final results = ref.watch(unifiedSearchResultsProvider);
  return results.isLoading;
});

/// Search history provider
final searchHistoryProvider = StateNotifierProvider<SearchHistoryNotifier, List<String>>((ref) {
  return SearchHistoryNotifier();
});

/// Search history notifier
class SearchHistoryNotifier extends StateNotifier<List<String>> {
  SearchHistoryNotifier() : super([]);
  
  static const int maxHistoryItems = 10;
  
  void addToHistory(String query) {
    if (query.trim().isEmpty) return;
    
    final newHistory = List<String>.from(state);
    // Remove if already exists
    newHistory.remove(query);
    // Add to beginning
    newHistory.insert(0, query);
    // Limit size
    if (newHistory.length > maxHistoryItems) {
      newHistory.removeLast();
    }
    state = newHistory;
  }
  
  void removeFromHistory(String query) {
    state = state.where((q) => q != query).toList();
  }
  
  void clearHistory() {
    state = [];
  }
}
