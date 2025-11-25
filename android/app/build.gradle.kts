plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.football_firebase"
    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.example.football_firebase"
        minSdk = flutter.minSdkVersion
        targetSdk =36
        versionCode = 1
        versionName = "1.0.0"
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

// এইটা সবচেয়ে নিচে থাকবে (Kotlin DSL এ dependencies ব্লক আলাদা ফাইলে থাকে না)
dependencies {
    // Firebase BOM (সব Firebase লাইব্রেরির ভার্সন একসাথে ম্যানেজ করবে)
    implementation(platform("com.google.firebase:firebase-bom:33.5.1"))

    // Firebase Services
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")
    implementation("com.google.firebase:firebase-storage")
}
