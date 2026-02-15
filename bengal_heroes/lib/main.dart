import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/constants/app_constants.dart';
import 'shared/providers/settings_provider.dart';

Future<void> main() async {
  // Ensure bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Setup error handlers FIRST
  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('❌ Flutter Error: ${details.exception}');
    debugPrintStack(stackTrace: details.stack);
  };

  try {
    debugPrint('🚀 Bengal Heroes - Initialization Starting...');
    
    // Initialize SharedPreferences FIRST - this is critical
    debugPrint('📝 Initializing SharedPreferences...');
    final prefs = await SharedPreferences.getInstance();
    debugPrint('✅ SharedPreferences initialized successfully');

    // Initialize localization
    debugPrint('🌍 Initializing localization...');
    await EasyLocalization.ensureInitialized();
    debugPrint('✅ Localization initialized successfully');

    // Set preferred orientations
    try {
      debugPrint('📱 Setting device orientations...');
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      debugPrint('✅ Device orientations set successfully');
    } catch (e) {
      // Some devices may not support all orientations
      debugPrint('⚠️ Error setting orientations: $e');
    }

    // Set system UI overlay style
    try {
      debugPrint('🎨 Setting system UI overlay style...');
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );
      debugPrint('✅ System UI overlay style set successfully');
    } catch (e) {
      debugPrint('⚠️ Error setting system UI overlay: $e');
    }

    debugPrint('🎯 All initialization steps completed. Starting app...');
    
    runApp(
      EasyLocalization(
        supportedLocales: AppConstants.supportedLocales,
        path: AppConstants.translationsPath,
        fallbackLocale: AppConstants.defaultLocale,
        startLocale: AppConstants.defaultLocale,
        child: ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const BengalHeroesApp(),
        ),
      ),
    );
  } catch (e, stackTrace) {
    debugPrint('❌ Fatal error during app initialization: $e');
    debugPrintStack(stackTrace: stackTrace);
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text('Initialization Error'),
                const SizedBox(height: 8),
                Text(e.toString(), textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}