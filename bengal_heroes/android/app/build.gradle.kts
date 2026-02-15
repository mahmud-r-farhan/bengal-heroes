import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// Load key.properties only for release builds
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")

android {
    namespace = "com.bengalbytes.bengalheroes"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlin {
        compilerOptions {
            jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
        }
    }

    defaultConfig {
        applicationId = "com.bengalbytes.bengalheroes"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Only configure signing for release if keystore exists
    signingConfigs {
        getByName("debug") {
            // Use default debug keystore
        }
        
        if (keystorePropertiesFile.exists()) {
            try {
                keystoreProperties.load(FileInputStream(keystorePropertiesFile))
                create("release") {
                    keyAlias = keystoreProperties["keyAlias"] as String
                    keyPassword = keystoreProperties["keyPassword"] as String
                    storeFile = file(keystoreProperties["storeFile"] as String)
                    storePassword = keystoreProperties["storePassword"] as String
                }
            } catch (e: Exception) {
                println("⚠️  Could not load release signing config: ${e.message}")
            }
        }
    }

    buildTypes {
        release {
            // Release: Apply code shrinking with safe rules
            isMinifyEnabled = true
            isShrinkResources = false
            // Use basic proguard rules, not aggressive optimization
            proguardFiles(
                getDefaultProguardFile("proguard-android.txt"),
                "proguard-rules.pro"
            )
            
            // Use release signing if available
            if (keystorePropertiesFile.exists() && signingConfigs.findByName("release") != null) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                signingConfig = signingConfigs.getByName("debug")
            }
        }
        
        debug {
            // Debug build: Absolutely NO minification, NO optimization, NO anything
            isMinifyEnabled = false
            isShrinkResources = false
            
            // Ensure no ProGuard rules are applied
            // Don't call proguardFiles at all for debug
            
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    buildFeatures {
        buildConfig = true
    }

    bundle {
        language {
            enableSplit = true
        }
        density {
            enableSplit = true
        }
        abi {
            enableSplit = true
        }
    }
}

flutter {
    source = "../.."
}
