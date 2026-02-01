# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in the Android SDK directory proguard-android.txt file.

# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-dontwarn io.flutter.embedding.**

# Keep model classes from being obfuscated (if using JSON serialization)
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep Kotlin metadata
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**

# Google Fonts
-keep class com.google.fonts.** { *; }

# Disable excessive logging in release
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int i(...);
    public static int w(...);
    public static int d(...);
}

# Remove debug information
-dontobfuscate

# Don't warn about missing classes that aren't used
-dontnote **
-dontwarn **
