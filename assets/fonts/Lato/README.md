# Lato Font Files

This directory should contain the Lato font files required by the application.

## Required Font Files

Place the following font files in this directory:

1. **Lato-Regular.ttf** - Regular weight (400)
2. **Lato-Bold.ttf** - Bold weight (700)
3. **Lato-Black.ttf** - Black weight (900)
4. **Lato-Light.ttf** - Light weight (300)
5. **Lato-Italic.ttf** - Italic style

## Download Instructions

### Option 1: Download from Google Fonts (Recommended)

1. Visit: https://fonts.google.com/specimen/Lato
2. Click the "Download family" button (top right corner)
3. Extract the downloaded ZIP file
4. Copy the 5 font files listed above from the extracted folder to this directory

### Option 2: Use Google Fonts Package (Alternative)

If you prefer not to download font files manually, you can use the `google_fonts` package which is already included in `pubspec.yaml`. This approach downloads fonts automatically at runtime:

```dart
import 'package:google_fonts/google_fonts.dart';

// In your theme configuration:
textTheme: GoogleFonts.latoTextTheme()
```

However, the current implementation expects local font files for:
- Better offline support
- Faster initial load times
- Reduced runtime dependencies

## Verification

After placing the font files, verify they are in the correct location:

```
assets/fonts/Lato/
├── Lato-Regular.ttf
├── Lato-Bold.ttf
├── Lato-Black.ttf
├── Lato-Light.ttf
└── Lato-Italic.ttf
```

Then run:
```bash
flutter pub get
flutter run
```

The app will use the Lato font family throughout the UI.
