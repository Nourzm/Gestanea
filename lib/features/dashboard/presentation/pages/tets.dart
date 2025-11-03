import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 393,
          height: 852,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: const Color(0xFFFDF5FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 329,
                top: 702,
                child: Container(
                  width: 28,
                  height: 28,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 32,
                top: 686,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF9C41E7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x2600AA5B),
                        blurRadius: 20,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 15,
                        top: 15,
                        child: Container(
                          width: 30,
                          height: 30,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Stack(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 97,
                top: 690,
                child: SizedBox(
                  width: 194,
                  height: 26,
                  child: Text(
                    'Vitamin D',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.18,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 97,
                top: 714,
                child: SizedBox(
                  width: 194,
                  height: 26,
                  child: Text(
                    'In 2 hours',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.12,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 89.45,
                top: 89.79,
                child: Container(
                  width: 211.41,
                  height: 27.97,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(),
                      top: BorderSide(),
                      right: BorderSide(),
                      bottom: BorderSide(width: 0.20),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 99,
                top: 171,
                child: Container(
                  width: 193.93,
                  height: 100.35,
                  decoration: BoxDecoration(border: Border.all(width: 0.61)),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 81.06,
                        top: 23.24,
                        child: SizedBox(
                          width: 24.37,
                          height: 34.79,
                          child: Text(
                            '7',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF9C77BE),
                              fontSize: 40,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w500,
                              height: 0.59,
                              letterSpacing: 0.57,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 76.41,
                        top: -4.25,
                        child: SizedBox(
                          width: 35,
                          height: 27,
                          child: Text(
                            'WEEK',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF9C77BE),
                              fontSize: 11,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w600,
                              height: 2.14,
                              letterSpacing: 0.57,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 72.83,
                        top: 56.56,
                        child: SizedBox(
                          width: 43,
                          height: 34.79,
                          child: Text(
                            '+3 day',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF9C77BE),
                              fontSize: 11,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w600,
                              height: 2.14,
                              letterSpacing: 0.57,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 185.41,
                        top: 39.75,
                        child: SizedBox(
                          width: 75,
                          height: 20,
                          child: Text(
                            'DAYS TO GO',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF9C77BE),
                              fontSize: 10,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w600,
                              height: 1.38,
                              letterSpacing: 0.57,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 200,
                        top: 20,
                        child: SizedBox(
                          width: 39,
                          height: 21,
                          child: Text(
                            '228',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFB077E4),
                              fontSize: 20,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w600,
                              height: 0.69,
                              letterSpacing: 0.57,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: -51.59,
                        top: 42.75,
                        child: SizedBox(
                          width: 32,
                          height: 20,
                          child: Text(
                            'DONE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF9C77BE),
                              fontSize: 10,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w600,
                              height: 1.38,
                              letterSpacing: 0.57,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: -65.59,
                        top: 24.75,
                        child: SizedBox(
                          width: 64,
                          height: 21,
                          child: Text(
                            '18.9%',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFB077E4),
                              fontSize: 20,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w600,
                              height: 0.69,
                              letterSpacing: 0.57,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 164,
                top: 301,
                child: Container(
                  width: 63,
                  height: 22,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 0.61,
                        color: const Color(0xFF9C77BE),
                      ),
                      borderRadius: BorderRadius.circular(11.04),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x4C000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 11.85,
                        top: 3.50,
                        child: SizedBox(
                          width: 25,
                          height: 15,
                          child: Text(
                            'More',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF9C77BE),
                              fontSize: 8.59,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              height: 1.43,
                              letterSpacing: 0.06,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 42.85,
                        top: 7.63,
                        child: Container(
                          width: 6.75,
                          height: 6.75,
                          child: Stack(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 89.45,
                top: 89.79,
                child: Container(
                  width: 211.41,
                  height: 27.97,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(),
                      top: BorderSide(),
                      right: BorderSide(),
                      bottom: BorderSide(width: 0.20),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 99,
                top: 171,
                child: Container(
                  width: 193.93,
                  height: 100.35,
                  decoration: BoxDecoration(border: Border.all(width: 0.61)),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 81.06,
                        top: 23.24,
                        child: SizedBox(
                          width: 24.37,
                          height: 34.79,
                          child: Text(
                            '7',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF9C77BE),
                              fontSize: 40,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w500,
                              height: 0.59,
                              letterSpacing: 0.57,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 76.41,
                        top: -4.25,
                        child: SizedBox(
                          width: 35,
                          height: 27,
                          child: Text(
                            'WEEK',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF9C77BE),
                              fontSize: 11,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w600,
                              height: 2.14,
                              letterSpacing: 0.57,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 72.83,
                        top: 56.56,
                        child: SizedBox(
                          width: 43,
                          height: 34.79,
                          child: Text(
                            '+3 day',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF9C77BE),
                              fontSize: 11,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w600,
                              height: 2.14,
                              letterSpacing: 0.57,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 185.41,
                        top: 39.75,
                        child: SizedBox(
                          width: 75,
                          height: 20,
                          child: Text(
                            'DAYS TO GO',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF9C77BE),
                              fontSize: 10,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w600,
                              height: 1.38,
                              letterSpacing: 0.57,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 200,
                        top: 20,
                        child: SizedBox(
                          width: 39,
                          height: 21,
                          child: Text(
                            '228',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFB077E4),
                              fontSize: 20,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w600,
                              height: 0.69,
                              letterSpacing: 0.57,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: -51.59,
                        top: 42.75,
                        child: SizedBox(
                          width: 32,
                          height: 20,
                          child: Text(
                            'DONE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF9C77BE),
                              fontSize: 10,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w600,
                              height: 1.38,
                              letterSpacing: 0.57,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: -65.59,
                        top: 24.75,
                        child: SizedBox(
                          width: 64,
                          height: 21,
                          child: Text(
                            '18.9%',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFB077E4),
                              fontSize: 20,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w600,
                              height: 0.69,
                              letterSpacing: 0.57,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 164,
                top: 301,
                child: Container(
                  width: 63,
                  height: 22,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 0.61,
                        color: const Color(0xFF9C77BE),
                      ),
                      borderRadius: BorderRadius.circular(11.04),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x4C000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 11.85,
                        top: 3.50,
                        child: SizedBox(
                          width: 25,
                          height: 15,
                          child: Text(
                            'More',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF9C77BE),
                              fontSize: 8.59,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              height: 1.43,
                              letterSpacing: 0.06,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 42.85,
                        top: 7.63,
                        child: Container(
                          width: 6.75,
                          height: 6.75,
                          child: Stack(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 24,
                top: 22,
                child: Container(
                  width: 356,
                  height: 39,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 56,
                        top: 10,
                        child: SizedBox(
                          width: 111,
                          height: 20,
                          child: Text(
                            'Hello Sara !',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 40,
                        top: -19,
                        child: Container(
                          width: 100,
                          height: 100,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Stack(
                            children: [
                              Positioned(
                                left: -1,
                                top: -7,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 338,
                top: 24,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF9E3FF),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 0.61,
                        color: const Color(0xFF9C77BE),
                      ),
                      borderRadius: BorderRadius.circular(11.04),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x4C000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 6,
                        top: 7,
                        child: Container(
                          width: 22,
                          height: 22,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Stack(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: -27,
                top: 788,
                child: Container(
                  width: 393,
                  height: 64,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 107,
                        top: 0,
                        child: Container(
                          width: 78.60,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white /* Background-Main-bg */,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 4,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: -0.30,
                                      top: 0.50,
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(),
                                        child: Stack(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Track',
                                style: TextStyle(
                                  color: const Color(0xFF999EA7),
                                  fontSize: 14,
                                  fontFamily: 'Figtree',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 185,
                        top: 0,
                        child: Container(
                          width: 78.60,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white /* Background-Main-bg */,
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 18,
                                top: 37,
                                child: Text(
                                  'Health',
                                  style: TextStyle(
                                    color: const Color(0xFF999EA7),
                                    fontSize: 14,
                                    fontFamily: 'Figtree',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 26.90,
                                top: 11,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(),
                                  child: Stack(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 29,
                        top: -38,
                        child: Container(
                          width: 78,
                          height: 102,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(12)),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 9.30,
                                top: 4,
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFB077E4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    shadows: [
                                      BoxShadow(
                                        color: Color(0x2600AA5B),
                                        blurRadius: 20,
                                        offset: Offset(0, 4),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 12,
                                        top: 12,
                                        child: Container(
                                          width: 36,
                                          height: 36,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(),
                                          child: Stack(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 18.30,
                                top: 75,
                                child: Text(
                                  'Home',
                                  style: TextStyle(
                                    color: const Color(0xFFB077E4),
                                    fontSize: 14,
                                    fontFamily: 'Figtree',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 263,
                        top: 0,
                        child: Container(
                          width: 78.60,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white /* Background-Main-bg */,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 4,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                ),
                                child: Stack(),
                              ),
                              Text(
                                'Plan',
                                style: TextStyle(
                                  color: const Color(0xFF999EA7),
                                  fontSize: 14,
                                  fontFamily: 'Figtree',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 339,
                        top: 0,
                        child: Container(
                          width: 81,
                          height: 64,
                          decoration: ShapeDecoration(
                            color: Colors.white /* Background-Main-bg */,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(12)),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 4,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(),
                                child: Stack(),
                              ),
                              Text(
                                'Market',
                                style: TextStyle(
                                  color: const Color(0xFF999EA7),
                                  fontSize: 14,
                                  fontFamily: 'Figtree',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 15,
                top: 372,
                child: Container(
                  width: 170,
                  height: 118,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFB077E4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0xFFFFFFFF),
                        blurRadius: 10,
                        offset: Offset(-5, -5),
                        spreadRadius: 0,
                      ),BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 8,
                        offset: Offset(5, 3),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 12,
                        top: 10,
                        child: Container(
                          width: 40,
                          height: 40,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Stack(),
                        ),
                      ),
                      Positioned(
                        left: 15,
                        top: 50,
                        child: SizedBox(
                          width: 75,
                          height: 26,
                          child: Text(
                            'Our Tips',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 203,
                top: 372,
                child: Container(
                  width: 170,
                  height: 118,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF5D4FB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 8,
                        offset: Offset(5, 3),
                        spreadRadius: 0,
                      ),BoxShadow(
                        color: Color(0xFFFFFFFF),
                        blurRadius: 10,
                        offset: Offset(-5, -5),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 9,
                        top: 51,
                        child: SizedBox(
                          width: 109,
                          height: 26,
                          child: Text(
                            'Our Doctors',
                            style: TextStyle(
                              color: const Color(0xFFB077E4),
                              fontSize: 20,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.20,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        top: 13,
                        child: Container(
                          width: 35,
                          height: 35,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 23.33,
                                top: 18.96,
                                child: Container(
                                  width: 8.75,
                                  height: 8.75,
                                  decoration: ShapeDecoration(
                                    shape: OvalBorder(
                                      side: BorderSide(
                                        width: 2.50,
                                        strokeAlign: BorderSide.strokeAlignCenter,
                                        color: const Color(0xFFB077E4),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 514,
                child: Container(
                  width: 360,
                  height: 26,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: SizedBox(
                          width: 178,
                          height: 26,
                          child: Text(
                            'Up coming',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.16,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 322,
                        top: 5,
                        child: Text(
                          'see all',
                          style: TextStyle(
                            color: const Color(0xFFB077E4),
                            fontSize: 14,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 30,
                top: 448,
                child: SizedBox(
                  width: 178,
                  height: 26,
                  child: Text(
                    'follow best practices',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.14,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 213,
                top: 448,
                child: SizedBox(
                  width: 178,
                  height: 26,
                  child: Text(
                    'find the best doctor',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.14,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 329,
                top: 590,
                child: Container(
                  width: 28,
                  height: 28,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 32,
                top: 574,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF9C41E7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x2600AA5B),
                        blurRadius: 20,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 15,
                        top: 15,
                        child: Container(
                          width: 30,
                          height: 30,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Stack(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 97,
                top: 578,
                child: SizedBox(
                  width: 194,
                  height: 26,
                  child: Text(
                    'Doctor Checkup',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.18,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 97,
                top: 602,
                child: SizedBox(
                  width: 194,
                  height: 26,
                  child: Text(
                    'Today at 2:00PM',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}