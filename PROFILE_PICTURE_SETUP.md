# Profile Picture Feature - Setup Guide

This document provides complete setup instructions for the profile picture feature implemented in Gestanea.

## Overview

The profile picture feature provides:
- ✅ Upload/change profile pictures via camera or gallery
- ✅ Automatic sync to Supabase Storage
- ✅ Offline-first caching for instant display
- ✅ Real-time updates across Home and Profile pages
- ✅ Integration with existing sync system
- ✅ Production-ready implementation

## Architecture

### Components

1. **ProfilePictureService** (`lib/core/services/profile_picture_service.dart`)
   - Handles upload to Supabase Storage
   - Manages local caching
   - Integrates with connectivity service

2. **ProfileAvatar Widget** (`lib/core/widgets/profile_avatar.dart`)
   - Reusable avatar widget with offline support
   - Automatic fallback to cached/local images
   - Loading and error states

3. **Database Schema**
   - SQLite: `profile_picture_path` column in `users` table
   - Supabase: `profile_picture_url` column in `users` table

4. **State Management**
   - AuthBloc handles profile picture updates
   - Automatic state propagation across app

## Setup Instructions

### Step 1: Install Dependencies

Run the following command to install the new dependency:

```bash
flutter pub get
```

This will install `cached_network_image` for efficient image caching.

### Step 2: Database Migration

The SQLite database will automatically migrate when you run the app (version 8).

To manually verify:
```sql
-- Check if column exists
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'users' 
AND column_name = 'profile_picture_path';
```

### Step 3: Supabase Setup

#### 3.1 Run SQL Script

1. Open your Supabase Dashboard
2. Go to SQL Editor
3. Copy and run the contents of `supabase_profile_picture_setup.sql`

This will:
- Add `profile_picture_url` column to `users` table
- Create index for faster lookups
- Set up Row Level Security (RLS) policies

#### 3.2 Create Storage Bucket

1. Go to Storage in Supabase Dashboard
2. Click "New bucket"
3. Configure:
   - **Name**: `profile-pictures`
   - **Public**: ✅ Yes (for public URL access)
   - **File size limit**: 5242880 (5MB)
   - **Allowed MIME types**: 
     - `image/jpeg`
     - `image/png`
     - `image/webp`

#### 3.3 Create Storage Policies

Go to Storage > Policies > profile-pictures and create:

**Policy 1: SELECT (Read)**
- Name: `Users can view profile pictures`
- Allowed operation: `SELECT`
- Target roles: `authenticated`, `anon`
- Policy definition:
```sql
bucket_id = 'profile-pictures'
```

**Policy 2: INSERT (Upload)**
- Name: `Users can upload own profile picture`
- Allowed operation: `INSERT`
- Target roles: `authenticated`
- Policy definition:
```sql
bucket_id = 'profile-pictures'
AND (regexp_match(name, '^' || auth.uid()::text || '\.(jpg|jpeg|png|webp)$')) IS NOT NULL
```

**Policy 3: UPDATE (Replace)**
- Name: `Users can replace own profile picture`
- Allowed operation: `UPDATE`
- Target roles: `authenticated`
- Policy definition:
```sql
bucket_id = 'profile-pictures'
AND (regexp_match(name, '^' || auth.uid()::text || '\.(jpg|jpeg|png|webp)$')) IS NOT NULL
```

**Policy 4: DELETE**
- Name: `Users can delete own profile picture`
- Allowed operation: `DELETE`
- Target roles: `authenticated`
- Policy definition:
```sql
bucket_id = 'profile-pictures'
AND (regexp_match(name, '^' || auth.uid()::text || '\.(jpg|jpeg|png|webp)$')) IS NOT NULL
```

**Important**: The file name must match exactly: `{userId}.{extension}`. For example: `550e8400-e29b-41d4-a716-446655440000.jpg`

### Step 4: Verify Setup

1. Run the app
2. Navigate to Profile > Edit Profile
3. Tap the camera icon on the profile picture
4. Select an image from gallery or take a photo
5. Save changes
6. Verify the image appears on:
   - Home page (top-left avatar)
   - Profile page (header)

## File Naming Convention

Profile pictures are stored with the naming pattern:
```
{userId}.jpg
```

Example: `550e8400-e29b-41d4-a716-446655440000.jpg`

The app automatically converts all images to JPEG format for consistency.

## Storage Structure

### Supabase Storage
```
profile-pictures/
  └── {userId}.jpg
```

### Local Cache (SQLite + File System)
```
Documents/
  └── profile_pictures/
      └── {userId}.jpg

SQLite: users.profile_picture_path
```

## Offline Behavior

- ✅ **Offline**: Profile pictures display from local cache instantly
- ✅ **Online**: New uploads sync immediately
- ✅ **Coming Online**: Automatic sync when connection restored
- ✅ **No Loading Spinners**: Cached images appear instantly

## Code Usage Examples

### Display Profile Avatar

```dart
ProfileAvatar(
  imageUrl: user.profilePictureUrl,
  userId: user.id,
  radius: 24,
)
```

### Editable Avatar (with edit button)

```dart
EditableProfileAvatar(
  imageUrl: user.profilePictureUrl,
  userId: user.id,
  radius: 50,
  onTap: () {
    // Navigate to edit profile
  },
)
```

### Upload Profile Picture

```dart
context.read<AuthBloc>().add(
  UpdateProfilePictureRequested(
    userId: user.id,
    imageFilePath: selectedImage.path,
  ),
);
```

## Troubleshooting

### Image Not Uploading

1. Check internet connection
2. Verify Supabase Storage bucket exists and is public
3. Check Storage policies are correctly configured
4. Verify user is authenticated

### Image Not Displaying

1. Check if image URL exists in user profile
2. Verify local cache directory permissions
3. Check network connectivity
4. Look for errors in console

### Permission Errors

For camera/gallery access, ensure permissions are granted:

**Android**: `AndroidManifest.xml` already includes camera permissions
**iOS**: Add to `Info.plist`:
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photo library to set your profile picture</string>
<key>NSCameraUsageDescription</key>
<string>We need access to your camera to take a profile picture</string>
```

## Testing Checklist

- [ ] Upload profile picture from gallery
- [ ] Upload profile picture from camera
- [ ] Profile picture appears on Home page
- [ ] Profile picture appears on Profile page
- [ ] Profile picture persists after app restart
- [ ] Profile picture displays offline (from cache)
- [ ] Profile picture syncs when coming online
- [ ] Replace existing profile picture works
- [ ] Error handling for failed uploads

## Performance Considerations

- Images are compressed to 85% quality
- Maximum dimensions: 800x800px
- Local cache prevents unnecessary network requests
- CachedNetworkImage provides efficient memory management

## Security Notes

- ✅ RLS policies enforce user isolation
- ✅ Only authenticated users can upload
- ✅ Users can only modify their own pictures
- ✅ File type validation (JPEG, PNG, WebP only)
- ✅ File size limits enforced (5MB)

## Future Enhancements

Potential improvements:
- Image cropping/editing before upload
- Multiple image size variants (thumbnails)
- Profile picture deletion functionality
- Batch sync for multiple users (admin)

## Support

For issues or questions:
1. Check console logs for error messages
2. Verify Supabase configuration
3. Review Storage policies
4. Check network connectivity

---

**Implementation Date**: 2024
**Version**: 1.0.0
**Status**: Production Ready ✅
