# Bengal Heroes App - Basic ProGuard Rules
# Simple rules to prevent crashes while maintaining functionality

# Keep all classes and members in our package
-keep class com.bengalbytes.bengalheroes.** { *; }

# Keep Flutter framework
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep Kotlin
-keep class kotlin.** { *; }
-keepclassmembers class kotlin.** { *; }

# Keep Android components
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider

# Keep reflection support
-keepattributes Signature
-keepattributes *Annotation*

# Keep custom application class
-keep class * extends android.app.Application { 
    void onCreate();
}

# Remove logging in release builds
-assumenosideeffects class android.util.Log {
    public static int v(...);
    public static int d(...);
    public static int i(...);
    public static int w(...);
}

# Suppress warnings
-dontwarn **
-ignorewarnings
