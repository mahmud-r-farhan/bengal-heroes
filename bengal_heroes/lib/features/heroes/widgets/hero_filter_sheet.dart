import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/hero_repository.dart';
import '../../../shared/providers/hero_provider.dart';
import '../../../shared/widgets/widgets.dart';

/// Bottom sheet for filtering heroes
class HeroFilterSheet extends ConsumerStatefulWidget {
  final VoidCallback onFilterApplied;

  const HeroFilterSheet({
    super.key,
    required this.onFilterApplied,
  });

  @override
  ConsumerState<HeroFilterSheet> createState() => _HeroFilterSheetState();
}

class _HeroFilterSheetState extends ConsumerState<HeroFilterSheet> {
  late Set<String> _selectedEras;
  late Set<String> _selectedCategories;
  late String? _selectedLocation;

  @override
  void initState() {
    super.initState();
    final currentFilter = ref.read(heroFilterProvider);
    _selectedEras = Set.from(currentFilter.eraIds ?? []);
    _selectedCategories = Set.from(currentFilter.categoryIds ?? []);
    _selectedLocation = currentFilter.locationId;
  }

  void _applyFilter() {
    ref.read(heroFilterProvider.notifier).state = HeroFilter(
      eraIds: _selectedEras.isEmpty ? null : _selectedEras.toList(),
      categoryIds: _selectedCategories.isEmpty ? null : _selectedCategories.toList(),
      locationId: _selectedLocation,
    );
    widget.onFilterApplied();
    Navigator.pop(context);
  }

  void _clearFilter() {
    setState(() {
      _selectedEras.clear();
      _selectedCategories.clear();
      _selectedLocation = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final eras = ref.watch(allErasProvider);
    final categories = ref.watch(allCategoriesProvider);
    final locations = ref.watch(allLocationsProvider);
    final hasSelection = _selectedEras.isNotEmpty || _selectedCategories.isNotEmpty || _selectedLocation != null;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter Heroes',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (hasSelection)
                      TextButton(
                        onPressed: _clearFilter,
                        child: const Text('Clear All'),
                      ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Era filters
                      Text(
                        'Era',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      eras.when(
                        data: (eraList) => Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: eraList.map((era) {
                            final isSelected = _selectedEras.contains(era.id);
                            return EraFilterChip(
                              era: era,
                              locale: locale,
                              isSelected: isSelected,
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedEras.remove(era.id);
                                  } else {
                                    _selectedEras.add(era.id);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (_, _) => const Text('Error loading eras'),
                      ),

                      const SizedBox(height: 24),

                      // Category filters
                      Text(
                        'Category',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      categories.when(
                        data: (categoryList) => Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: categoryList.map((category) {
                            final isSelected = _selectedCategories.contains(category.id);
                            return CategoryChip(
                              category: category,
                              locale: locale,
                              isSelected: isSelected,
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedCategories.remove(category.id);
                                  } else {
                                    _selectedCategories.add(category.id);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (_, _) => const Text('Error loading categories'),
                      ),

                      const SizedBox(height: 24),

                      // Location filters
                      Text(
                        'Location',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      locations.when(
                        data: (locationList) {
                          if (locationList.isEmpty) {
                            return const Text('No locations available');
                          }
                          return DropdownButton<String?>(
                            value: _selectedLocation,
                            isExpanded: true,
                            hint: const Text('Select a location...'),
                            underline: Container(
                              height: 1,
                              color: theme.colorScheme.outline.withValues(alpha: 0.2),
                            ),
                            items: [
                              DropdownMenuItem<String?>(
                                value: null,
                                child: const Text('All Locations'),
                              ),
                              ...locationList.map((location) {
                                return DropdownMenuItem<String?>(
                                  value: location.id,
                                  child: Text(
                                    location.getName(locale),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedLocation = value;
                              });
                            },
                          );
                        },
                        loading: () => const CircularProgressIndicator(),
                        error: (_, _) => const Text('Error loading locations'),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // Apply button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _applyFilter,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        hasSelection
                            ? 'Apply Filters (${_selectedEras.length + _selectedCategories.length + (_selectedLocation != null ? 1 : 0)})'
                            : 'Show All Heroes',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
