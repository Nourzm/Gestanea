import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/features/dashboard/presentation/pages/notificationsPage.dart';
import 'package:gestanea/core/widgets/notificationsCard.dart';

class Header extends StatelessWidget {
  final String title;
  final VoidCallback? onNotificationTapped;

  const Header({super.key, required this.title, this.onNotificationTapped});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.02,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 48, height: 48),

          Expanded(
            child: Center(
              child: Text(
                title,
                style: AppTextStyles.headline1.copyWith(
                  color: AppColors.main500,
                  fontSize: 40,
                  fontFamily: 'Lato',
                  letterSpacing: -0.40,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          GestureDetector(
            onTap:
                onNotificationTapped ??
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsPage(),
                    ),
                  );
                },
            child: NotificationIcon(
              icon: Icon(Icons.notifications, color: Colors.purple),
            ),
          ),
        ],
      ),
    );
  }
}
