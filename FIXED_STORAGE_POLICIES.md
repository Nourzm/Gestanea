# FIXED Supabase Storage Policies for Profile Pictures

The issue is that the storage policies were checking for folder paths, but files are uploaded directly at the bucket root. Use these **corrected policies** instead.

## Corrected Storage Policies

Go to **Supabase Dashboard > Storage > Policies > profile-pictures** and **DELETE the old policies**, then create these new ones:

---

### Policy 1: SELECT (Read/View) - Make it Public

**Name**: `Public read access for profile pictures`

**Allowed operation**: `SELECT`

**Target roles**: `authenticated`, `anon`

**Policy definition** (using SQL):
```sql
bucket_id = 'profile-pictures'
```

**OR** if using the visual policy builder, just leave it empty (no conditions) since the bucket should be public.

---

### Policy 2: INSERT (Upload) - Users upload their own

**Name**: `Users can upload own profile picture`

**Allowed operation**: `INSERT`

**Target roles**: `authenticated`

**Policy definition**:
```sql
bucket_id = 'profile-pictures'
AND (
  regexp_replace(name, '\.[^.]+$', '') = auth.uid()::text
)
AND (
  (storage.extension(name)) IN ('jpg', 'jpeg', 'png', 'webp')
)
```

**Explanation**: 
- `regexp_replace(name, '\.[^.]+$', '')` removes the file extension
- This matches the filename (without extension) to the user's UUID
- Ensures only `.jpg`, `.jpeg`, `.png`, `.webp` files can be uploaded

---

### Policy 3: UPDATE (Replace existing) - Users update their own

**Name**: `Users can update own profile picture`

**Allowed operation**: `UPDATE`

**Target roles**: `authenticated`

**Policy definition**:
```sql
bucket_id = 'profile-pictures'
AND (
  regexp_replace(name, '\.[^.]+$', '') = auth.uid()::text
)
```

---

### Policy 4: DELETE - Users delete their own

**Name**: `Users can delete own profile picture`

**Allowed operation**: `DELETE`

**Target roles**: `authenticated`

**Policy definition**:
```sql
bucket_id = 'profile-pictures'
AND (
  regexp_replace(name, '\.[^.]+$', '') = auth.uid()::text
)
```

---

## Alternative: Simpler Regex Match Policy

If the above doesn't work, use this **simpler version** that uses regex match:

### For INSERT:
```sql
bucket_id = 'profile-pictures'
AND (
  (regexp_match(name, '^' || auth.uid()::text || '\.(jpg|jpeg|png|webp)$')) IS NOT NULL
)
```

### For UPDATE:
```sql
bucket_id = 'profile-pictures'
AND (
  (regexp_match(name, '^' || auth.uid()::text || '\.(jpg|jpeg|png|webp)$')) IS NOT NULL
)
```

### For DELETE:
```sql
bucket_id = 'profile-pictures'
AND (
  (regexp_match(name, '^' || auth.uid()::text || '\.(jpg|jpeg|png|webp)$')) IS NOT NULL
)
```

---

## Quick Fix: Testing Policy

If you want to test quickly, you can create a **temporary permissive policy** (for testing only):

**Name**: `Test: Allow authenticated uploads`

**Operation**: `INSERT`

**Roles**: `authenticated`

**Policy**:
```sql
bucket_id = 'profile-pictures'
AND auth.role() = 'authenticated'
```

⚠️ **WARNING**: This allows any authenticated user to upload any file. Remove after testing!

---

## Verification Steps

1. **Delete all existing policies** for the `profile-pictures` bucket
2. **Create the 4 policies above** (SELECT, INSERT, UPDATE, DELETE)
3. **Make sure the bucket is Public** (Storage > profile-pictures > Settings > Public bucket: ON)
4. **Test the upload** again

---

## Why the Original Policies Failed

The original policies used:
```sql
auth.uid()::text = (regexp_split_to_array(name, '/'))[1]
```

This assumes files are in folders like `{userId}/{filename}`, but our files are uploaded directly as `{userId}.jpg` at the root level. The `[1]` index doesn't work for root-level files.

The fix extracts the filename without extension and matches it directly to the user ID.

---

## Still Having Issues?

1. **Check bucket is public**: Storage > profile-pictures > Settings
2. **Verify user is authenticated**: Check `auth.uid()` in Supabase SQL Editor
3. **Check file name format**: Should be exactly `{userId}.jpg` (e.g., `550e8400-e29b-41d4-a716-446655440000.jpg`)
4. **Try the simpler regex match version** above
5. **Check Supabase logs**: Dashboard > Logs > API for detailed error messages
