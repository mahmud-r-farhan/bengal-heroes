# Bengal Heroes App - ProGuard Rules
# Keep Flutter and app classes to prevent crashes

# ===== CRITICAL: Keep MainActivity and Activities =====
-keep public class com.bengalbytes.bengalheroes.MainActivity {
    public <init>();
}
-keep public class * extends android.app.Activity {
    public <init>();
}

# ===== Keep All App Classes =====
-keep class com.bengalbytes.bengalheroes.** { *; }

# ===== Keep Flutter Framework =====
-keep class io.flutter.** { *; }
-keep class io.flutter.app.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }

# ===== Keep Kotlin =====
-keep class kotlin.** { *; }
-keepclassmembers class kotlin.** { *; }

# ===== Keep Android Components =====
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.content.Service

# ===== Keep Application Class =====
-keep class * extends android.app.Application {
    void onCreate();
}

# ===== Keep Reflection Support =====
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable

# ===== Suppress All Warnings =====
-dontwarn **
-ignorewarnings
