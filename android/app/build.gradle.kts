plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    // تفعيل الفايربيس
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.untitled11"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.untitled11"
        // رفعنا النسخة لـ 23 عشان مكتبات جوجل الجديدة
        minSdk = flutter.minSdkVersion 
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
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
    // مكتبات أندرويد الأساسية
    implementation(platform("com.google.firebase:firebase-bom:32.8.0"))
}
