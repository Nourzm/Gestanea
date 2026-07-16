import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/services/profile_picture_service.dart';

/// Reusable profile avatar widget with offline-first caching support
/// Displays profile picture from Supabase Storage with local fallback
class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String userId;
  final double radius;
  final BoxShape shape;
  final Color? backgroundColor;
  final Widget? placeholder;
  final Widget? errorWidget;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    required this.userId,
    this.radius = 24.0,
    this.shape = BoxShape.circle,
    this.backgroundColor,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final profilePictureService = ProfilePictureService();

    return FutureBuilder<String?>(
      future: profilePictureService.getLocalCachedPath(userId),
      builder: (context, localSnapshot) {
        // Try local cache first (works offline)
        if (localSnapshot.hasData && localSnapshot.data != null) {
          final localFile = File(localSnapshot.data!);
          if (localFile.existsSync()) {
            return _buildAvatarFromFile(localFile);
          }
        }

        // Fallback to network image if URL exists
        if (imageUrl != null && imageUrl!.isNotEmpty) {
          return _buildNetworkAvatar();
        }

        // Final fallback: default placeholder
        return _buildDefaultAvatar();
      },
    );
  }

  Widget _buildAvatarFromFile(File file) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: shape,
        color: backgroundColor ?? Colors.grey.shade300,
      ),
      child: ClipOval(
        child: Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultAvatar();
          },
        ),
      ),
    );
  }

  Widget _buildNetworkAvatar() {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: shape,
        color: backgroundColor ?? Colors.grey.shade300,
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              placeholder ?? _buildLoadingPlaceholder(),
          errorWidget: (context, url, error) =>
              errorWidget ?? _buildDefaultAvatar(),
          // Cache the image for offline access
          // The image will be automatically cached by cached_network_image
          // We also cache it locally via ProfilePictureService on first load
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? Colors.grey.shade300,
      child: Image.asset(
        'assets/images/pfp.png',
        width: radius * 1.5,
        height: radius * 1.5,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.person,
            size: radius,
            color: AppColors.main500,
          );
        },
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      width: radius * 2,
      height: radius * 2,
      color: backgroundColor ?? Colors.grey.shade300,
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }
}

/// Profile avatar with edit button overlay
class EditableProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String userId;
  final double radius;
  final VoidCallback onTap;

  const EditableProfileAvatar({
    super.key,
    this.imageUrl,
    required this.userId,
    this.radius = 50.0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        ProfileAvatar(
          imageUrl: imageUrl,
          userId: userId,
          radius: radius,
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 38,
            width: 38,
            margin: const EdgeInsets.only(right: 4, bottom: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.edit,
              color: AppColors.main500,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
