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

## Validation Script

You can validate your Gradle configuration with this script:

```bash
#!/bin/bash
# Save as validate_gradle.sh and run: bash validate_gradle.sh

echo "=== Validating Gradle Configuration Files ==="
echo ""

# Check for misplaced 'incremental' property
echo "1. Checking for misplaced 'incremental' property..."
if grep -q "incremental" android/app/build.gradle.kts android/build.gradle.kts android/settings.gradle.kts 2>/dev/null; then
    echo "   ⚠️  WARNING: Found 'incremental' property - verify it's in kotlinOptions block"
    grep -n "incremental" android/app/build.gradle.kts android/build.gradle.kts android/settings.gradle.kts
else
    echo "   ✅ No misplaced 'incremental' property found"
fi
echo ""

# Check kotlinOptions structure
echo "2. Checking kotlinOptions block structure..."
if grep -A2 "kotlinOptions" android/app/build.gradle.kts | grep -q "jvmTarget"; then
    echo "   ✅ kotlinOptions block is properly configured"
else
    echo "   ⚠️  WARNING: kotlinOptions may not be properly configured"
fi
echo ""

# Check defaultConfig structure
echo "3. Checking defaultConfig block..."
if grep -A10 "defaultConfig" android/app/build.gradle.kts | grep -qE "(applicationId|minSdk|targetSdk)"; then
    echo "   ✅ defaultConfig block contains expected properties"
else
    echo "   ⚠️  WARNING: defaultConfig may be missing standard properties"
fi
echo ""

# Check for required plugins
echo "4. Checking required plugins..."
if grep -q 'id("com.android.application")' android/app/build.gradle.kts && \
   grep -q 'id("kotlin-android")' android/app/build.gradle.kts && \
   grep -q 'id("dev.flutter.flutter-gradle-plugin")' android/app/build.gradle.kts; then
    echo "   ✅ All required plugins are present"
else
    echo "   ⚠️  WARNING: Some required plugins may be missing"
fi
echo ""

# Check Gradle version
echo "5. Checking Gradle version..."
if grep -q "gradle-8" android/gradle/wrapper/gradle-wrapper.properties; then
    echo "   ✅ Using Gradle 8.x (compatible with latest Flutter)"
else
    echo "   ⚠️  WARNING: Gradle version may need updating"
fi
echo ""

echo "=== Validation Complete ==="
```

Run this script from the project root to validate your Gradle configuration.
