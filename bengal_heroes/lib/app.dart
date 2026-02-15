import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'shared/providers/settings_provider.dart';

/// The root application widget for Bengal Heroes
class BengalHeroesApp extends ConsumerWidget {
  const BengalHeroesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    try {
      final router = ref.watch(appRouterProvider);
      final themeMode = ref.watch(themeModeProvider);

      return MaterialApp.router(
        title: 'Bengal Heroes',
        debugShowCheckedModeBanner: false,
        
        // Localization
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        
        // Theme
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        
        // Router
        routerConfig: router,
      );
    } catch (e, stackTrace) {
      debugPrint('Error in app build: $e');
      debugPrintStack(stackTrace: stackTrace);
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text('App Build Error'),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(e.toString(), textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
