import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/database/models/notification_model.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/l10n/app_localizations.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  //final NotificationService _notificationService = NotificationService();
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;
  Map<String, bool> expandedStates = {};
  Map<String, bool> draggingStates = {};
  StreamSubscription<NotificationModel>? _notifSub;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    
  }

  @override
  void dispose() {
    _notifSub?.cancel();
    super.dispose();
  }

  /// Load notifications from database
  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get current user ID if available
      String? userId;
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        userId = authState.user.id;
      }

      // Fetch notifications from database
      

      
    } catch (e) {
      print('Error loading notifications: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Format timestamp to relative time (e.g., "2 hours ago", "1 day ago")
  String _formatTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return DateFormat('MMM d, yyyy').format(dateTime);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  /// Delete notification
  Future<void> _deleteNotification(NotificationModel notification, int index) async {
    try {
      if (mounted) {
        setState(() {
          _notifications.removeAt(index);
          expandedStates.remove(notification.id);
          draggingStates.remove(notification.id);
        });
      }
    } catch (e) {
      print('Error deleting notification: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete notification'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Mark notification as read
  Future<void> _markAsRead(NotificationModel notification) async {
    if (notification.isRead) return;

    try {
      if (mounted) {
        setState(() {
          final index = _notifications.indexWhere((n) => n.id == notification.id);
          if (index != -1) {
            _notifications[index] = notification.copyWith(
              isRead: true,
              readAt: DateTime.now(),
            );
          }
        });
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.bg_1,
      appBar: AppBar(
        backgroundColor: AppColors.bg_1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.main500,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          t.notifications,
          style: AppTextStyles.headline1.copyWith(
            color: AppColors.main500,
            fontSize: 32,
            fontFamily: 'Lato',
            letterSpacing: -0.40,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? _buildEmptyState()
              : _buildNotificationList(),
    );
  }

  Widget _buildEmptyState() {
    // Wrap empty state in a scrollable so pull-to-refresh always works.
    return RefreshIndicator(
      onRefresh: _loadNotifications,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.75,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/no_notif.svg",
                  fit: BoxFit.fitWidth,
                  width: MediaQuery.of(context).size.width,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black.withValues(alpha: 0.3),
                ),
                Positioned(
                  bottom: 140,
                  left: 16,
                  right: 16,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        "You're all caught up",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colors.black12,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "No new notifications at this time.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black26,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList() {
    return RefreshIndicator(
      onRefresh: _loadNotifications,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: _notifications.length,
        separatorBuilder: (_, __) => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(height: 24),
        ),
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          bool isExpanded = expandedStates[notification.id] ?? false;

          // Mark as read when viewed
          if (!notification.isRead) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _markAsRead(notification);
            });
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Dismissible(
              key: ValueKey(notification.id),
              direction: DismissDirection.endToStart,
              onUpdate: (details) {
                setState(() {
                  draggingStates[notification.id] = details.progress > 0;
                });
              },
              onDismissed: (_) {
                _deleteNotification(notification, index);
              },
              background: Container(
                decoration: BoxDecoration(
                  color: const Color(0xffFF6C6E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/delete.svg',
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            AppColors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Delete",
                          style: TextStyle(
                            color: Color(0xFFECECEC),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              child: GestureDetector(
                onTapDown: (_) => setState(() => draggingStates[notification.id] = true),
                onTapUp: (_) => setState(() => draggingStates[notification.id] = false),
                onTapCancel: () => setState(() => draggingStates[notification.id] = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    boxShadow: AppColors.shadow1,
                    borderRadius: draggingStates[notification.id] ?? false
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          )
                        : BorderRadius.circular(12),
                    color: notification.isRead
                        ? AppColors.main300
                        : AppColors.main300.withOpacity(0.8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 92,
                        height: 92,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: notification.imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  notification.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset("assets/images/fetus.png");
                                  },
                                ),
                              )
                            : Image.asset("assets/images/fetus.png"),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    notification.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (!notification.isRead)
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColors.main600,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            ClipRect(
                              child: AnimatedSize(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notification.body,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xff1C2229),
                                      ),
                                      maxLines: isExpanded ? null : 3,
                                      overflow: isExpanded
                                          ? TextOverflow.visible
                                          : TextOverflow.ellipsis,
                                    ),
                                    if (notification.body.length > 120)
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            expandedStates[notification.id] =
                                                !isExpanded;
                                          });
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              isExpanded ? "Show less" : "Show more",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: AppColors.main600,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Icon(
                                              isExpanded
                                                  ? Icons.arrow_drop_up
                                                  : Icons.arrow_drop_down,
                                              size: 18,
                                              color: AppColors.main600,
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatTimestamp(notification.receivedAt),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.main600,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
