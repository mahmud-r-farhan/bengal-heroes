import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/models.dart' as models;
import '../../data/repositories/hero_repository.dart';
import '../../shared/providers/hero_provider.dart';
import '../../shared/widgets/widgets.dart';
import 'widgets/hero_filter_sheet.dart';

/// Heroes list screen with filtering and pagination
class HeroesScreen extends ConsumerStatefulWidget {
  final String? eraId;
  final String? categoryId;

  const HeroesScreen({
    super.key,
    this.eraId,
    this.categoryId,
  });

  @override
  ConsumerState<HeroesScreen> createState() => _HeroesScreenState();
}

class _HeroesScreenState extends ConsumerState<HeroesScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  final List<models.Hero> _loadedHeroes = [];
  bool _isLoadingMore = false;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Set initial filter if era or category provided
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.eraId != null) {
        ref.read(heroFilterProvider.notifier).state = HeroFilter(
          eraIds: [widget.eraId!],
        );
      } else if (widget.categoryId != null) {
        ref.read(heroFilterProvider.notifier).state = HeroFilter(
          categoryIds: [widget.categoryId!],
        );
      }
      _loadHeroes();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMoreData) {
      _loadMoreHeroes();
    }
  }

  Future<void> _loadHeroes() async {
    setState(() {
      _currentPage = 0;
      _loadedHeroes.clear();
      _hasMoreData = true;
    });
    await _loadMoreHeroes();
  }

  Future<void> _loadMoreHeroes() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() => _isLoadingMore = true);

    try {
      final repository = ref.read(heroRepositoryProvider);
      final filter = ref.read(heroFilterProvider);
      final heroes = await repository.getHeroesPaginated(
        page: _currentPage,
        filter: filter,
      );

      setState(() {
        _loadedHeroes.addAll(heroes);
        _currentPage++;
        _isLoadingMore = false;
        _hasMoreData = heroes.length >= 20; // less than page size means no more
      });
    } catch (e) {
      setState(() => _isLoadingMore = false);
    }
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => HeroFilterSheet(
        onFilterApplied: () {
          _loadHeroes();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final filter = ref.watch(heroFilterProvider);
    final hasActiveFilter = !filter.isEmpty;

    // Determine title based on context
    String title = 'Heroes';
    if (widget.eraId != null) {
      final era = ref.watch(eraByIdProvider(widget.eraId!));
      era.whenData((e) {
        if (e != null) title = e.getName(locale);
      });
    } else if (widget.categoryId != null) {
      final category = ref.watch(categoryByIdProvider(widget.categoryId!));
      category.whenData((c) {
        if (c != null) title = c.getName(locale);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          // Filter button
          Stack(
            children: [
              IconButton(
                onPressed: _showFilterSheet,
                icon: const Icon(Icons.tune),
                tooltip: 'Filter',
              ),
              if (hasActiveFilter)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryGold,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: _buildBody(context, locale),
    );
  }

  Widget _buildBody(BuildContext context, String locale) {
    if (_loadedHeroes.isEmpty && _isLoadingMore) {
      return const HeroListShimmer(itemCount: 5);
    }

    if (_loadedHeroes.isEmpty && !_isLoadingMore) {
      return EmptyState(
        icon: Icons.people_outline,
        title: 'No heroes found',
        subtitle: 'Try adjusting your filters',
        actionText: 'Clear Filters',
        onActionTap: () {
          ref.read(heroFilterProvider.notifier).state = const HeroFilter();
          _loadHeroes();
        },
      );
    }

    return RefreshIndicator(
      onRefresh: _loadHeroes,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: _loadedHeroes.length + (_hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _loadedHeroes.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: HeroCard(hero: _loadedHeroes[index])
                .animate()
                .fadeIn(delay: Duration(milliseconds: 50 * (index % 10)))
                .slideY(begin: 0.1, end: 0),
          );
        },
      ),
    );
  }
}
