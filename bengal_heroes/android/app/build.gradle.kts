plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.bengalbytes.bengalheroes"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.bengalbytes.bengalheroes"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            // Configure keystore properties from local.properties
            // Path: ~/.android/debug.keystore (for testing) or your production keystore
            // Use production keystore path for Google Play Store
            val keystorePath = System.getenv("KEYSTORE_PATH") ?: "${System.getProperty("user.home")}/.android/debug.keystore"
            val keystorePassword = System.getenv("KEYSTORE_PASSWORD") ?: "android"
            val keyAlias = System.getenv("KEY_ALIAS") ?: "androiddebugkey"
            val keyPassword = System.getenv("KEY_PASSWORD") ?: "android"
            
            storeFile = File(keystorePath)
            storePassword = keystorePassword
            keyAlias = keyAlias
            keyPassword = keyPassword
        }
        getByName("debug") {
            storeFile = file("debug.jks")
            storePassword = "android"
            keyAlias = "androiddebugkey"
            keyPassword = "android"
        }
    }

    buildTypes {
        release {
            // Enable code shrinking and optimization using R8
            isMinifyEnabled = true
            // Enable resource shrinking to remove unused resources
            isShrinkResources = true
            // ProGuard rules for optimization
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            // Production signing configuration for Google Play Store
            signingConfig = signingConfigs.getByName("release")
            
            // Disable debug logging in release builds
            buildConfigField("boolean", "DEBUG_MODE", "false")
        }
        debug {
            // Disable shrinking for debug builds for faster build times
            isMinifyEnabled = false
            isShrinkResources = false
            // Enable debug features for development
            buildConfigField("boolean", "DEBUG_MODE", "true")
        }
    }

    // Enable build cache for faster builds
    buildFeatures {
        buildConfig = true
    }
}

flutter {
    source = "../.."
}
