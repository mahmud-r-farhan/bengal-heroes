# Bengal Heroes App - Production ProGuard Rules
# ==============================================
# Optimization for Google Play Store Release Build
# These rules ensure proper obfuscation while maintaining app functionality

# ============= Flutter & Dart Configuration =============
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.embedding.engine.** { *; }
-dontwarn io.flutter.embedding.**

# ============= Kotlin Configuration =============
-keep class kotlin.** { *; }
-keep class kotlinx.** { *; }
-keep class kotlin.Metadata { *; }
-keepclassmembers class ** {
    ** INSTANCE;
}
-dontwarn kotlin.**
-dontwarn kotlinx.**

# ============= Riverpod State Management =============
-keep class riverpod.** { *; }
-keep class flutter_riverpod.** { *; }
-dontwarn riverpod.**
-dontwarn flutter_riverpod.**

# ============= Easy Localization =============
-keep class easy_localization.** { *; }
-keepclassmembers class ** {
    @easy_localization.** <fields>;
}

# ============= Google Fonts =============
-keep class com.google.fonts.** { *; }
-dontwarn com.google.fonts.**

# ============= Shared Preferences =============
-keep class android.content.SharedPreferences { *; }

# ============= Cached Network Image =============
-keep class com.bumptech.glide.** { *; }
-dontwarn com.bumptech.glide.**

# ============= JSON Serialization =============
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**

# ============= Remove Excessive Logging in Release =============
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int i(...);
    public static int w(...);
    public static int d(...);
}

# ============= Keep Custom Classes =============
# Keep model and data classes
-keep class com.bengalbytes.** { *; }
-keepclassmembers class com.bengalbytes.** {
  *;
}

# ============= General Optimization Flags =============
-optimizationpasses 5
-optimizations !code/simplification/cast,!field/*,!class/merging/*
-allowaccessmodification
-repackageclasses ''

# ============= Suppress Warnings =============
-dontnote **
-ignorewarnings
