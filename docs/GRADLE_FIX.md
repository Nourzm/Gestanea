# Gradle Build Fix - Unresolved Reference: incremental

## Problem

When running `flutter run`, you may encounter the following error:

```
e: file:///D:/Gestanea/android/app/build.gradle.kts:22:5: Unresolved reference: incremental

FAILURE: Build failed with an exception.

* Where:
Build file 'D:\Gestanea\android\app\build.gradle.kts' line: 22

* What went wrong:
Script compilation error:

  Line 22:     incremental = false
               ^ Unresolved reference: incremental

1 error
```

## Root Cause

The `incremental` property is a Kotlin compilation option that **must** be placed within the `kotlinOptions` block. Placing it anywhere else (such as in `defaultConfig` or at the top level) will cause an "Unresolved reference" error.

## Solution

### Incorrect ❌

```kotlin
android {
    defaultConfig {
        applicationId = "com.example.first"
        incremental = false  // ❌ WRONG - causes "Unresolved reference: incremental"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
    }
}
```

### Correct ✅

If you need to set the `incremental` property, it should be in the `kotlinOptions` block:

```kotlin
android {
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
        // This is the correct place for incremental if needed
        // However, it's usually not necessary to set this explicitly
    }

    defaultConfig {
        applicationId = "com.example.first"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
    }
}
```

### Note on `incremental` Property

In most Flutter projects, you **do not need** to set the `incremental` property explicitly. The current configuration in `android/app/build.gradle.kts` is correct and follows Flutter best practices:

```kotlin
kotlinOptions {
    jvmTarget = JavaVersion.VERSION_11.toString()
    // No need to set incremental - default is fine
}
```

## Current Configuration

The repository's Gradle configuration is already correct and does not have this issue. The files are properly structured:

- ✅ `android/app/build.gradle.kts` - Correctly configured
- ✅ `android/build.gradle.kts` - Properly set up
- ✅ `android/settings.gradle.kts` - Correctly configured
- ✅ `android/gradle.properties` - Proper JVM arguments
- ✅ `android/gradle/wrapper/gradle-wrapper.properties` - Using Gradle 8.12

## Prevention

To prevent this issue:

1. **Never add `incremental` outside of `kotlinOptions` block**
2. Only modify `kotlinOptions` if you have a specific reason
3. Follow the existing structure in the build files
4. Test builds after making any Gradle changes

## References

- [Kotlin Gradle Plugin Documentation](https://kotlinlang.org/docs/gradle.html)
- [Flutter Android Build Configuration](https://flutter.dev/docs/deployment/android)
