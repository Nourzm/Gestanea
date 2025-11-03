import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.02),

                // Profile image
                Container(
                  decoration: BoxDecoration(
                    gradient:
                        LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: const [
                            Color.fromRGBO(
                              156,
                              119,
                              190,
                              0.4,
                            ), // rgba(156,119,190,0.4)
                            Color.fromRGBO(156, 119, 190, 0.4), // overlay layer
                          ],
                        ).lerpTo(
                          const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFFFFFFF),
                              Color(0xFFBAA0D2),
                              Color(0xFFB599CE),
                            ],
                            stops: [0.0, 0.5529, 1.0],
                          ),
                          1.0,
                        )!,
                    boxShadow: const [
                      // outer shadow
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.3),
                        offset: Offset(0, 6),
                        blurRadius: 10,
                      ),
                      // inner shadow (simulated)
                      BoxShadow(
                        color: Color.fromRGBO(255, 255, 255, 0.3),
                        offset: Offset(0, -5),
                        blurRadius: 10,
                        spreadRadius: -3,
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),

                  child: Column(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: screenWidth * 0.2,
                            height: screenWidth * 0.2,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, -5),
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/pfp.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey.shade300,
                                    child: Icon(
                                      Icons.person,
                                      size: screenWidth * 0.2,
                                      color: Colors.grey.shade600,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.02),

                      // Name
                      Text(
                        'islem gcm',
                        style: TextStyle(
                          fontSize: screenWidth * 0.065,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.04),

                // Settings cards
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                    children: [
                      // First card - Notifications, Language, IDK
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E5F5),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE1BEE7).withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildListTile(
                              icon: Icons.notifications_outlined,
                              title: 'Notifications',
                              onTap: () {},
                            ),
                            _buildDivider(),
                            _buildListTile(
                              icon: Icons.language,
                              title: 'Language',
                              onTap: () {},
                            ),
                            _buildDivider(),
                            _buildListTile(
                              icon: Icons.notifications_outlined,
                              title: 'IDK',
                              onTap: () {},
                              isLast: true,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Status card
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.025,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E5F5),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE1BEE7).withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'I gave birth',
                              style: TextStyle(
                                fontSize: screenWidth * 0.048,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF9C27B0),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.025),
                            Text(
                              'No longer pregnant',
                              style: TextStyle(
                                fontSize: screenWidth * 0.048,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFE57373),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Support card
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E5F5),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE1BEE7).withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildListTile(
                              icon: Icons.help_outline,
                              title: 'Help & Support',
                              onTap: () {},
                            ),
                            _buildDivider(),
                            _buildListTile(
                              icon: Icons.chat_bubble_outline,
                              title: 'Contact us',
                              onTap: () {},
                            ),
                            _buildDivider(),
                            _buildListTile(
                              icon: Icons.lock_outline,
                              title: 'Privacy policy',
                              onTap: () {},
                              isLast: true,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // Log out button
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xFFEF9A9A), Color(0xFFF48FB1)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFEF9A9A).withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 24,
                            ),
                            SizedBox(width: screenWidth * 0.03),
                            Text(
                              'Log out',
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: isLast ? Radius.zero : Radius.zero,
          bottom: isLast ? const Radius.circular(20) : Radius.zero,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.black87, size: 24),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black54, size: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.white.withOpacity(0.5),
      ),
    );
  }
}
