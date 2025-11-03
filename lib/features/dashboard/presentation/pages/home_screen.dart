import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/features/dashboard/presentation/pages/notificationsPage.dart';
import 'package:gestanea/features/dashboard/presentation/widgets/notificationsCard.dart';
import 'package:gestanea/features/profile/presentation/pages/profile_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.02,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 👤 Profile section (tap -> Profile page)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilePage(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.grey.shade300,
                            child: Icon(
                              Icons.person,
                              color: Colors.grey.shade600,
                              size: 28,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          Text(
                            'Hello Sara!',
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 🔔 Notification icon (tap -> Notifications page)
                    GestureDetector(
                      onTap: () {
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
              ),

              Image.asset(
                "assets/images/tobefixed.png",
                width: double.infinity,
              ),

              // // Progress Card
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              //   child: Container(
              //     width: double.infinity,
              //     padding: EdgeInsets.symmetric(
              //       horizontal: screenWidth * 0.08,
              //       vertical: screenHeight * 0.04,
              //     ),
              //     decoration: BoxDecoration(
              //       gradient: const LinearGradient(
              //         begin: Alignment.topLeft,
              //         end: Alignment.bottomRight,
              //         colors: [Color(0xFFE1BEE7), Color(0xFFF3E5F5)],
              //       ),
              //       borderRadius: BorderRadius.circular(30),
              //       boxShadow: [
              //         BoxShadow(
              //           color: const Color(0xFFE1BEE7).withOpacity(0.5),
              //           blurRadius: 20,
              //           offset: const Offset(0, 10),
              //         ),
              //       ],
              //     ),
              //     child: Column(
              //       children: [
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             // Left - Progress percentage
              //             Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Text(
              //                   '18.9%',
              //                   style: TextStyle(
              //                     fontSize: screenWidth * 0.08,
              //                     fontWeight: FontWeight.bold,
              //                     color: const Color(0xFF9C27B0),
              //                   ),
              //                 ),
              //                 Text(
              //                   'DONE',
              //                   style: TextStyle(
              //                     fontSize: screenWidth * 0.03,
              //                     fontWeight: FontWeight.w500,
              //                     color: const Color(
              //                       0xFF9C27B0,
              //                     ).withOpacity(0.7),
              //                     letterSpacing: 1,
              //                   ),
              //                 ),
              //               ],
              //             ),

              //             // Center - Week circle
              //             Container(
              //               width: screenWidth * 0.32,
              //               height: screenWidth * 0.32,
              //               decoration: BoxDecoration(
              //                 shape: BoxShape.circle,
              //                 border: Border.all(
              //                   color: const Color(0xFF9C27B0),
              //                   width: 4,
              //                 ),
              //               ),
              //               child: Column(
              //                 mainAxisAlignment: MainAxisAlignment.center,
              //                 children: [
              //                   Text(
              //                     'WEEK',
              //                     style: TextStyle(
              //                       fontSize: screenWidth * 0.028,
              //                       fontWeight: FontWeight.w500,
              //                       color: const Color(
              //                         0xFF9C27B0,
              //                       ).withOpacity(0.7),
              //                       letterSpacing: 1.5,
              //                     ),
              //                   ),
              //                   Text(
              //                     '7',
              //                     style: TextStyle(
              //                       fontSize: screenWidth * 0.15,
              //                       fontWeight: FontWeight.bold,
              //                       color: const Color(0xFF9C27B0),
              //                       height: 1,
              //                     ),
              //                   ),
              //                   Text(
              //                     '+3 day',
              //                     style: TextStyle(
              //                       fontSize: screenWidth * 0.032,
              //                       fontWeight: FontWeight.w500,
              //                       color: const Color(
              //                         0xFF9C27B0,
              //                       ).withOpacity(0.7),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),

              //             // Right - Days to go
              //             Column(
              //               crossAxisAlignment: CrossAxisAlignment.end,
              //               children: [
              //                 Text(
              //                   '228',
              //                   style: TextStyle(
              //                     fontSize: screenWidth * 0.08,
              //                     fontWeight: FontWeight.bold,
              //                     color: const Color(0xFF9C27B0),
              //                   ),
              //                 ),
              //                 Text(
              //                   'DAYS TO GO',
              //                   style: TextStyle(
              //                     fontSize: screenWidth * 0.025,
              //                     fontWeight: FontWeight.w500,
              //                     color: const Color(
              //                       0xFF9C27B0,
              //                     ).withOpacity(0.7),
              //                     letterSpacing: 0.5,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ],
              //         ),

              //         SizedBox(height: screenHeight * 0.03),

              //         // More button
              //         Container(
              //           padding: EdgeInsets.symmetric(
              //             horizontal: screenWidth * 0.06,
              //             vertical: screenHeight * 0.01,
              //           ),
              //           decoration: BoxDecoration(
              //             color: Colors.white,
              //             borderRadius: BorderRadius.circular(20),
              //           ),
              //           child: Row(
              //             mainAxisSize: MainAxisSize.min,
              //             children: [
              //               Text(
              //                 'More',
              //                 style: TextStyle(
              //                   fontSize: screenWidth * 0.035,
              //                   fontWeight: FontWeight.w600,
              //                   color: const Color(0xFF9C27B0),
              //                 ),
              //               ),
              //               const SizedBox(width: 4),
              //               const Icon(
              //                 Icons.arrow_forward_ios,
              //                 color: Color(0xFF9C27B0),
              //                 size: 14,
              //               ),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              // SizedBox(height: screenHeight * 0.025),

              // Tips and Doctors Cards
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  children: [
                    // Our Tips Card
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(screenWidth * 0.045),
                        decoration: BoxDecoration(
                          color: AppColors.main500,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF000000).withOpacity(0.25),
                              blurRadius: 8,
                              offset: const Offset(5, 3),
                            ),
                            BoxShadow(
                              color: const Color(0xFFffffff),
                              blurRadius: 10,
                              offset: const Offset(-5, -5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/stars.svg",
                              width: 32,
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            Text(
                              'Our Tips',
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              'follow best practices',
                              style: TextStyle(
                                fontSize: screenWidth * 0.032,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(width: screenWidth * 0.04),

                    // Our Doctors Card
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(screenWidth * 0.045),
                        decoration: BoxDecoration(
                          color: AppColors.homeCards,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF000000).withOpacity(0.25),
                              blurRadius: 8,
                              offset: const Offset(5, 3),
                            ),
                            BoxShadow(
                              color: const Color(0xFFffffff),
                              blurRadius: 10,
                              offset: const Offset(-5, -5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/Stethoscope.svg",
                              color: Color(0xFF9C27B0),
                              width: 32,
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            Text(
                              'Our Doctors',
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF9C27B0),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              'find the best doctor',
                              style: TextStyle(
                                fontSize: screenWidth * 0.032,
                                color: const Color(0xFF9C27B0).withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // Up coming section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Up coming',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'see all',
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w600,
                        color: AppColors.main500,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.015),

              // Upcoming items
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  children: [
                    // Doctor Checkup
                    Container(
                      margin: EdgeInsets.only(bottom: screenHeight * 0.015),
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      decoration: BoxDecoration(
                        color: AppColors.homeCards,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.main500, // border color
                          width: 1, // border thickness
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF000000).withOpacity(0.25),
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.main500,
                            ),
                            child: SvgPicture.asset(
                              "assets/icons/heartplus.svg",
                              color: Colors.white,
                              width: 30,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.04),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Doctor Checkup',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.042,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.005),
                                Text(
                                  'Today at 2:00PM',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SvgPicture.asset(
                            "assets/icons/Calendar_1.svg",
                            color: Color(0xFF9C27B0),
                            width: 28,
                          ),
                        ],
                      ),
                    ),

                    // Vitamin D
                    Container(
                      margin: EdgeInsets.only(bottom: screenHeight * 0.015),
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      decoration: BoxDecoration(
                        color: AppColors.homeCards,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.main500, // border color
                          width: 1, // border thickness
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF000000).withOpacity(0.25),
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.main500,
                            ),
                            child: SvgPicture.asset(
                              "assets/icons/pills.svg",
                              color: Colors.white,
                              width: 28,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.04),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Vitamin D',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.042,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.005),
                                Text(
                                  'In 2 hours',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SvgPicture.asset(
                            "assets/icons/Calendar_1.svg",
                            color: Color(0xFF9C27B0),
                            width: 28,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
