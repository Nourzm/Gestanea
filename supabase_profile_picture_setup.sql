-- =====================================================
-- Profile Picture Feature - Supabase Setup Script
-- =====================================================
-- This script sets up the database schema, storage bucket,
-- and security policies for the profile picture feature.
--
-- Run this in your Supabase SQL Editor to enable profile pictures.
-- =====================================================

-- Step 1: Add profile_picture_url column to users table
-- This column stores the public URL of the user's profile picture
-- from Supabase Storage
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS profile_picture_url TEXT;

-- Add comment for documentation
COMMENT ON COLUMN users.profile_picture_url IS 
'Public URL of the user profile picture stored in Supabase Storage bucket "profile-pictures"';

-- Step 2: Create index for faster lookups (optional but recommended)
CREATE INDEX IF NOT EXISTS idx_users_profile_picture_url 
ON users(profile_picture_url) 
WHERE profile_picture_url IS NOT NULL;

-- =====================================================
-- STORAGE SETUP
-- =====================================================

-- Step 3: Create storage bucket for profile pictures
-- Note: This must be done via Supabase Dashboard or API
-- SQL doesn't support bucket creation directly
-- 
-- Manual steps:
-- 1. Go to Storage > New bucket
-- 2. Name: "profile-pictures"
-- 3. Public: YES (to enable public URL access)
-- 4. File size limit: 5MB (recommended)
-- 5. Allowed MIME types: image/jpeg, image/png, image/webp
--
-- Alternatively, use Supabase Management API:
-- POST /storage/v1/bucket
-- {
--   "name": "profile-pictures",
--   "public": true,
--   "file_size_limit": 5242880,
--   "allowed_mime_types": ["image/jpeg", "image/png", "image/webp"]
-- }

-- =====================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =====================================================

-- Step 4: Enable RLS on users table (if not already enabled)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Step 5: Policy: Users can view their own profile picture URL
-- This allows users to read their own profile_picture_url
CREATE POLICY IF NOT EXISTS "Users can view own profile picture URL"
ON users
FOR SELECT
USING (auth.uid()::text = id);

-- Step 6: Policy: Users can update their own profile picture URL
-- This allows users to update their own profile_picture_url
CREATE POLICY IF NOT EXISTS "Users can update own profile picture URL"
ON users
FOR UPDATE
USING (auth.uid()::text = id)
WITH CHECK (auth.uid()::text = id);

-- =====================================================
-- STORAGE BUCKET POLICIES
-- =====================================================

-- Step 7: Enable RLS on profile-pictures bucket (if not already)
-- Note: Storage policies must be created via Supabase Dashboard
-- or Storage Management API, not SQL
--
-- Storage Policies to create in Dashboard:
--
-- POLICY 1: SELECT (Read/View)
--   Name: "Users can view profile pictures"
--   Allowed operation: SELECT
--   Target roles: authenticated, anon
--   Policy definition:
--     bucket_id = 'profile-pictures'
--     AND (true) -- Public bucket, anyone can read
--
-- POLICY 2: INSERT (Upload)
--   Name: "Users can upload their own profile picture"
--   Allowed operation: INSERT
--   Target roles: authenticated
--   Policy definition:
--     bucket_id = 'profile-pictures'
--     AND (regexp_match(name, '^' || auth.uid()::text || '\.(jpg|jpeg|png|webp)$')) IS NOT NULL
--
-- POLICY 3: UPDATE (Replace)
--   Name: "Users can replace their own profile picture"
--   Allowed operation: UPDATE
--   Target roles: authenticated
--   Policy definition:
--     bucket_id = 'profile-pictures'
--     AND (regexp_match(name, '^' || auth.uid()::text || '\.(jpg|jpeg|png|webp)$')) IS NOT NULL
--
-- POLICY 4: DELETE
--   Name: "Users can delete their own profile picture"
--   Allowed operation: DELETE
--   Target roles: authenticated
--   Policy definition:
--     bucket_id = 'profile-pictures'
--     AND (regexp_match(name, '^' || auth.uid()::text || '\.(jpg|jpeg|png|webp)$')) IS NOT NULL

-- =====================================================
-- ALTERNATIVE: More Restrictive Storage Policies
-- =====================================================
-- If you want stricter file naming validation:
--
-- For INSERT/UPDATE/DELETE policies, use:
--   AND (regexp_match(name, '^' || auth.uid()::text || '\.(jpg|jpeg|png|webp)$')) IS NOT NULL
--
-- This ensures the file name is exactly: {userId}.{extension}
-- Example: "550e8400-e29b-41d4-a716-446655440000.jpg"

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================

-- Check if column exists
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'users' 
AND column_name = 'profile_picture_url';

-- Check RLS policies on users table
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies
WHERE tablename = 'users';

-- =====================================================
-- NOTES
-- =====================================================
-- 1. Storage bucket creation must be done via Dashboard or API
-- 2. Storage policies must be created via Dashboard or Storage API
-- 3. File naming convention: {userId}.jpg
-- 4. The app handles automatic file replacement (upsert)
-- 5. Images are cached locally for offline access
-- 6. Maximum recommended file size: 5MB
-- 7. Supported formats: JPEG, PNG, WebP
-- =====================================================
