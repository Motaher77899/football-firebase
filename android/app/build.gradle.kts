plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.football_firebase"
    compileSdk = 36  // ✅ 36 থেকে 34 করো (stable version)

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.example.football_firebase"
        minSdk = flutter.minSdkVersion  // ✅ Explicit করে দাও
        targetSdk = 36  // ✅ 36 থেকে 34 করো
        versionCode = 1
        versionName = "1.0.0"
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Firebase BOM
    implementation(platform("com.google.firebase:firebase-bom:33.5.1"))

    // Firebase Services
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")
    implementation("com.google.firebase:firebase-storage")

    // ✅ MultiDex support যোগ করো
    implementation("androidx.multidex:multidex:2.0.1")
}

// ✅ এটা একদম শেষে যোগ করো
apply(plugin = "com.google.gms.google-services")
