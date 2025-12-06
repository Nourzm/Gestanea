import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/database/models/medicine_model.dart';
import 'package:gestanea/core/database/models/medicine_logged_model.dart';

class MedicineCard extends StatelessWidget {
  final MedicineModel medicine;
  final MedicineLoggedModel? log;
  final String scheduledTime;
  final double screenWidth;
  final double screenHeight;
  final VoidCallback? onTakeMedicine;

  const MedicineCard({
    Key? key,
    required this.medicine,
    this.log,
    required this.scheduledTime,
    required this.screenWidth,
    required this.screenHeight,
    this.onTakeMedicine,
  }) : super(key: key);

  bool get isTaken => log?.status == 'taken';
  bool get isMissed => log?.status == 'missed';

  String get buttonText {
    if (isTaken) return 'Taken';
    if (isMissed) return 'Missed';
    return 'Take';
  }

  Color get buttonColor {
    if (isTaken) return Colors.green;
    if (isMissed) return Colors.red.shade300;
    return AppColors.main500;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: AppColors.bg_1,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(4, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0xFFFFFFFF),
            blurRadius: 10,
            offset: Offset(-6, -6),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                width: screenWidth * 0.2,
                height: screenWidth * 0.2,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.bg_1,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(3, 3),
                      spreadRadius: -2,
                    ),
                    const BoxShadow(
                      color: Color(0xFFFFFFFF),
                      blurRadius: 6,
                      offset: Offset(-3, -3),
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: medicine.medicineImageUrl != null
                    ? Image.network(
                        medicine.medicineImageUrl!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.medication,
                            size: 40,
                            color: Colors.grey,
                          );
                        },
                      )
                    : Icon(Icons.medication, size: 40, color: Colors.grey),
              ),
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine.medicineName,
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      medicine.dosage,
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          scheduledTime,
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          ' | ',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        Text(
                          medicine.frequencyType,
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.012),
                    GestureDetector(
                      onTap: isTaken ? null : onTakeMedicine,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: buttonColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          buttonText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: screenWidth * 0.038,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isMissed)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.error1,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.error1.withOpacity(0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  'Missed',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
