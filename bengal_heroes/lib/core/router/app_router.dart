import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/timeline_model.dart';
import '../../features/hero_detail/hero_detail_screen.dart';
import '../../features/heroes/heroes_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/intro/intro_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/timeline_event_detail/timeline_event_detail_screen.dart';
import '../../shared/providers/settings_provider.dart';
import 'app_routes.dart';

/// Provider for GoRouter
final appRouterProvider = Provider<GoRouter>((ref) {
  final isFirstLaunch = ref.watch(isFirstLaunchProvider);
  
  return GoRouter(
    initialLocation: isFirstLaunch ? AppRoutes.intro : AppRoutes.home,
    debugLogDiagnostics: true,
    routes: [
      // Intro/Onboarding Screen
      GoRoute(
        path: AppRoutes.intro,
        name: 'intro',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const IntroScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      
      // Main Shell with Bottom Navigation
      ShellRoute(
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          // Home Screen
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const HomeScreen(),
            ),
          ),
          
          // Heroes List Screen
          GoRoute(
            path: AppRoutes.heroes,
            name: 'heroes',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const HeroesScreen(),
            ),
          ),
          
          // Search Screen
          GoRoute(
            path: AppRoutes.search,
            name: 'search',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const SearchScreen(),
            ),
          ),
          
          // Settings Screen
          GoRoute(
            path: AppRoutes.settings,
            name: 'settings',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const SettingsScreen(),
            ),
          ),
        ],
      ),
      
      // Hero Detail Screen (outside shell for full screen experience)
      GoRoute(
        path: '${AppRoutes.heroDetail}/:heroId',
        name: 'heroDetail',
        pageBuilder: (context, state) {
          final heroId = state.pathParameters['heroId']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: HeroDetailScreen(heroId: heroId),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              );
            },
          );
        },
      ),
      
      // Heroes by Era
      GoRoute(
        path: '${AppRoutes.heroesByEra}/:eraId',
        name: 'heroesByEra',
        pageBuilder: (context, state) {
          final eraId = state.pathParameters['eraId']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: HeroesScreen(eraId: eraId),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              );
            },
          );
        },
      ),
      
      // Heroes by Category
      GoRoute(
        path: '${AppRoutes.heroesByCategory}/:categoryId',
        name: 'heroesByCategory',
        pageBuilder: (context, state) {
          final categoryId = state.pathParameters['categoryId']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: HeroesScreen(categoryId: categoryId),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              );
            },
          );
        },
      ),
      
      // War Movements by Category (alias for war_movement category)
      GoRoute(
        path: '${AppRoutes.warMovements}/:categoryId',
        name: 'warMovements',
        pageBuilder: (context, state) {
          final categoryId = state.pathParameters['categoryId']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: HeroesScreen(categoryId: categoryId),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              );
            },
          );
        },
      ),

      // Timeline Event Detail Screen
      GoRoute(
        path: '${AppRoutes.timelineEventDetail}/:eventId/:type',
        name: 'timelineEventDetail',
        pageBuilder: (context, state) {
          final eventData = state.extra as Map<String, dynamic>?;
          if (eventData == null) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: Scaffold(
                body: Center(
                  child: Text('Error: Event data not found'),
                ),
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return child;
              },
            );
          }

          final event = TimelineEvent.fromJson(eventData);
          final type = state.pathParameters['type']!;

          return CustomTransitionPage(
            key: state.pageKey,
            child: TimelineEventDetailScreen(event: event, type: type),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              );
            },
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.uri.toString()),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});

/// Main Shell with Bottom Navigation Bar
class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const MainBottomNavBar(),
    );
  }
}

/// Bottom Navigation Bar widget with enhanced UX/UI
class MainBottomNavBar extends StatelessWidget {
  const MainBottomNavBar({super.key});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(AppRoutes.settings)) return 3;
    if (location.startsWith(AppRoutes.search)) return 2;
    if (location.startsWith(AppRoutes.heroes)) return 1;
    if (location == AppRoutes.home) return 0;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    final theme = Theme.of(context);

    return Material(
      elevation: 12,
      child: NavigationBar(
        selectedIndex: selectedIndex,
        indicatorColor: theme.colorScheme.primary.withValues(alpha: 0.15),
        animationDuration: const Duration(milliseconds: 500),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.home);
              break;
            case 1:
              context.go(AppRoutes.heroes);
              break;
            case 2:
              context.go(AppRoutes.search);
              break;
            case 3:
              context.go(AppRoutes.settings);
              break;
          }
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: theme.colorScheme.primary),
            label: 'Home',
            tooltip: 'Home',
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people, color: theme.colorScheme.primary),
            label: 'Heroes',
            tooltip: 'Explore Heroes',
          ),
          NavigationDestination(
            icon: const Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search, color: theme.colorScheme.primary),
            label: 'Search',
            tooltip: 'Search',
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: theme.colorScheme.primary),
            label: 'Settings',
            tooltip: 'Settings',
          ),
        ],
      ),
    );
  }
}
