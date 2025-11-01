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

The `incremental` property is **not a valid property** in the Android Gradle DSL (for `kotlinOptions`, `defaultConfig`, or any other block). This error occurs when someone mistakenly tries to add `incremental = false` to the build.gradle.kts file.

**Important:** The `incremental` property should not be used in Flutter Android Gradle configuration files. Incremental compilation is handled automatically by the Kotlin Gradle plugin.

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

**Do NOT add the `incremental` property anywhere in your Flutter Android Gradle configuration.** The error occurs because `incremental` is not a valid property for `android` DSL blocks.

The `incremental` property is a Kotlin compiler task option, not a property that should be set in `kotlinOptions`, `defaultConfig`, or any other Android Gradle DSL block. Flutter and modern Kotlin Gradle plugins handle incremental compilation automatically.

Your `android/app/build.gradle.kts` should look like this (without any `incremental` property):

```kotlin
android {
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
        // Do NOT add incremental here - it's not a valid kotlinOptions property
    }

    defaultConfig {
        applicationId = "com.example.first"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Do NOT add incremental here either
    }
}
```

### Note on `incremental` Property

**In Flutter projects, you should NEVER manually set the `incremental` property.** Incremental compilation is handled automatically by the Kotlin Gradle plugin. The current configuration in `android/app/build.gradle.kts` is correct and follows Flutter best practices:

```kotlin
kotlinOptions {
    jvmTarget = JavaVersion.VERSION_11.toString()
    // Incremental compilation is handled automatically - DO NOT add it here
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

1. **NEVER add the `incremental` property to build.gradle.kts files** - it's not a valid Android Gradle DSL property
2. Let the Kotlin Gradle plugin handle incremental compilation automatically
3. Only modify `kotlinOptions` for valid properties like `jvmTarget`
4. Follow the existing structure in the build files
5. Test builds after making any Gradle changes

## References

- [Kotlin Gradle Plugin Documentation](https://kotlinlang.org/docs/gradle.html)
- [Flutter Android Build Configuration](https://flutter.dev/docs/deployment/android)

## Validation Script

You can validate your Gradle configuration with this script:

```bash
#!/bin/bash
# Save as validate_gradle.sh and run: bash validate_gradle.sh

echo "=== Validating Gradle Configuration Files ==="
echo ""

# Check for misplaced 'incremental' property
echo "1. Checking for 'incremental' property (should NOT exist)..."
# Check in app-level and project-level build files
if grep -q "incremental" android/app/build.gradle.kts android/build.gradle.kts 2>/dev/null; then
    echo "   ❌ ERROR: Found 'incremental' property - this should NOT be in your Gradle files!"
    echo "   The 'incremental' property is not valid in Android Gradle DSL."
    grep -n "incremental" android/app/build.gradle.kts android/build.gradle.kts 2>/dev/null
else
    echo "   ✅ No 'incremental' property found (correct)"
fi
echo ""

# Check kotlinOptions structure
echo "2. Checking kotlinOptions block structure..."
if [ -f android/app/build.gradle.kts ] && grep -A2 "kotlinOptions" android/app/build.gradle.kts 2>/dev/null | grep -q "jvmTarget"; then
    echo "   ✅ kotlinOptions block is properly configured"
else
    echo "   ⚠️  WARNING: kotlinOptions may not be properly configured"
fi
echo ""

# Check defaultConfig structure
echo "3. Checking defaultConfig block..."
if [ -f android/app/build.gradle.kts ] && grep -A10 "defaultConfig" android/app/build.gradle.kts 2>/dev/null | grep -qE "(applicationId|minSdk|targetSdk)"; then
    echo "   ✅ defaultConfig block contains expected properties"
else
    echo "   ⚠️  WARNING: defaultConfig may be missing standard properties"
fi
echo ""

# Check for required plugins in app-level build.gradle.kts
echo "4. Checking required plugins in app-level build file..."
if [ -f android/app/build.gradle.kts ] && \
   grep -q 'id("com.android.application")' android/app/build.gradle.kts 2>/dev/null && \
   grep -q 'id("kotlin-android")' android/app/build.gradle.kts 2>/dev/null && \
   grep -q 'id("dev.flutter.flutter-gradle-plugin")' android/app/build.gradle.kts 2>/dev/null; then
    echo "   ✅ All required app-level plugins are present"
else
    echo "   ⚠️  WARNING: Some required plugins may be missing from app/build.gradle.kts"
fi
echo ""

# Check Gradle version
echo "5. Checking Gradle version..."
if [ -f android/gradle/wrapper/gradle-wrapper.properties ] && grep -q "gradle-8" android/gradle/wrapper/gradle-wrapper.properties 2>/dev/null; then
    echo "   ✅ Using Gradle 8.x (compatible with latest Flutter)"
else
    echo "   ⚠️  WARNING: Gradle version may need updating"
fi
echo ""

echo "=== Validation Complete ==="
```

Run this script from the project root to validate your Gradle configuration.
