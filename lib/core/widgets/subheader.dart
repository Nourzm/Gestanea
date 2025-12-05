import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';

class SubHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const SubHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.bg_1,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: AppColors.main500,
          size: 24, // change size
        ),
        onPressed: () {
          Navigator.pop(context); // back action
        },
      ),
      title: Text(
        'Languages',
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
