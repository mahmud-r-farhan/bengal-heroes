import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/providers/search_provider.dart';
import '../../shared/widgets/widgets.dart';

/// Search screen with fuzzy search functionality
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto focus on search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    ref.read(searchQueryProvider.notifier).state = query;
    if (query.isNotEmpty) {
      ref.read(searchHistoryProvider.notifier).addToHistory(query);
    }
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(searchQueryProvider.notifier).state = '';
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final searchQuery = ref.watch(searchQueryProvider);
    final searchResults = ref.watch(searchResultsProvider);
    final isSearching = ref.watch(isSearchingProvider);
    final searchHistory = ref.watch(searchHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: _buildSearchField(context),
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        actions: [
          if (searchQuery.isNotEmpty)
            IconButton(
              onPressed: _clearSearch,
              icon: const Icon(Icons.close),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: searchQuery.isEmpty
                ? _buildSearchSuggestions(context, searchHistory)
                : _buildSearchResults(context, searchResults, isSearching, locale),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(left: 16),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: 'Search heroes...',
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: false,
          contentPadding: EdgeInsets.zero,
          prefixIcon: Icon(
            Icons.search,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        style: theme.textTheme.bodyLarge,
        textInputAction: TextInputAction.search,
        onChanged: (value) {
          // Debounce search
          Future.delayed(const Duration(milliseconds: 300), () {
            if (_searchController.text == value) {
              _performSearch(value);
            }
          });
        },
        onSubmitted: _performSearch,
      ),
    );
  }

  Widget _buildSearchSuggestions(
    BuildContext context,
    List<String> searchHistory,
  ) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent searches
          if (searchHistory.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Searches',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(searchHistoryProvider.notifier).clearHistory();
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: searchHistory.map((query) {
                return GestureDetector(
                  onTap: () {
                    _searchController.text = query;
                    _performSearch(query);
                  },
                  child: Chip(
                    label: Text(query),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () {
                      ref
                          .read(searchHistoryProvider.notifier)
                          .removeFromHistory(query);
                    },
                    backgroundColor: theme.colorScheme.surface,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
          ],

          // Search suggestions
          Text(
            'Popular Searches',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _buildSearchSuggestionItem(context, 'Titumir', Icons.trending_up),
          _buildSearchSuggestionItem(context, 'Begum Rokeya', Icons.trending_up),
          _buildSearchSuggestionItem(context, 'Martyrs', Icons.category),
          _buildSearchSuggestionItem(context, 'Liberation War', Icons.history),
          _buildSearchSuggestionItem(context, 'Language Movement', Icons.event),

          const SizedBox(height: 32),

          // Tips
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primaryGold.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.primaryGold,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Search Tips',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'You can search by name, era, or even in Bengali!',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSuggestionItem(
    BuildContext context,
    String suggestion,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      title: Text(suggestion),
      trailing: const Icon(Icons.north_west, size: 18),
      onTap: () {
        _searchController.text = suggestion;
        _performSearch(suggestion);
      },
    );
  }

  Widget _buildSearchResults(
    BuildContext context,
    AsyncValue searchResults,
    bool isSearching,
    String locale,
  ) {
    final theme = Theme.of(context);

    if (isSearching) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return searchResults.when(
      data: (results) {
        if (results.isEmpty) {
          return EmptyState(
            icon: Icons.search_off,
            title: 'No results found',
            subtitle: 'Try different keywords or check spelling',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final result = results[index];
            final hero = result.hero;
            final content = hero.getContent(locale);

            return GestureDetector(
              onTap: () => context.push(AppRoutes.getHeroDetailPath(hero.id)),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    // Hero image
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.primaryMaroon.withValues(alpha: 0.1),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: hero.primaryImage.isNotEmpty
                          ? Image.asset(
                              hero.primaryImage,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => const Icon(
                                Icons.person,
                                color: AppColors.primaryMaroon,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              color: AppColors.primaryMaroon,
                            ),
                    ),
                    const SizedBox(width: 16),

                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            content.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            hero.dates.lifeSpan,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Match indicator
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getMatchColor(result.matchedField)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Matched in ${result.matchedField}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: _getMatchColor(result.matchedField),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: Duration(milliseconds: 50 * index));
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => ErrorState(message: error.toString()),
    );
  }

  Color _getMatchColor(String matchedField) {
    switch (matchedField) {
      case 'name':
        return AppColors.primaryMaroon;
      case 'bio':
        return AppColors.secondaryOlive;
      case 'era':
        return AppColors.secondaryNavy;
      default:
        return AppColors.primaryGold;
    }
  }
}
