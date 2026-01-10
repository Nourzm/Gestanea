import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import '../widgets/neumorphic_section.dart';
import '../widgets/delivery_form.dart';
import '../widgets/delivery_payment_options.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bg_1,
        fontFamily: 'Lato',
      ),
      home: const CompleteOrderScreen(),
    );
  }
}

class CompleteOrderScreen extends StatefulWidget {
  const CompleteOrderScreen({super.key});

  @override
  State<CompleteOrderScreen> createState() => _CompleteOrderScreenState();
}

class _CompleteOrderScreenState extends State<CompleteOrderScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();

  String selectedPaymentMethod = 'cash';

  @override
  void initState() {
    super.initState();
    // TODO: Get user info from auth state/shared preferences
    // For now, setting a placeholder
    fullNameController.text =
        'John Doe'; // Replace with actual user name from auth
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    instructionsController.dispose();
    super.dispose();
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildPriceRow(String label, String price, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                )
              : AppTextStyles.body1.copyWith(
                  fontSize: 12,
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  _NeumorphicButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.chevron_left,
                      color: AppColors.main500,
                      size: 24,
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Complete Your Order',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          fontFamily: 'Lato',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Order Summary Section
                    NeumorphicSection(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Order Summary'),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey[300],
                                  image: const DecorationImage(
                                    image: NetworkImage(
                                      'https://images.unsplash.com/photo-1586015555751-63bb77f4322a?w=400',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Premium Pregnancy Pillow',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.main500,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Purple',
                                          style: AppTextStyles.body1.copyWith(
                                            fontSize: 12,
                                            color: AppColors.textPrimary,
                                            height: 1.4,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Text(
                                          'Size: Standard',
                                          style: AppTextStyles.body1.copyWith(
                                            fontSize: 12,
                                            color: AppColors.textPrimary,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Qty: 1',
                                          style: AppTextStyles.body1.copyWith(
                                            fontSize: 12,
                                            color: AppColors.textPrimary,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(color: Color(0xFFD0C0E0), height: 1),
                          const SizedBox(height: 12),
                          _buildPriceRow('Subtotal', '\$22.40'),
                          const SizedBox(height: 8),
                          _buildPriceRow('Delivery Fee', '\$5.00'),
                          const SizedBox(height: 12),
                          const Divider(color: Color(0xFFD0C0E0), height: 1),
                          const SizedBox(height: 12),
                          _buildPriceRow('Total', '\$27.40', isBold: true),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Delivery Information Section
                    DeliveryForm(
                      fullNameController: fullNameController,
                      phoneController: phoneController,
                      addressController: addressController,
                      cityController: cityController,
                      instructionsController: instructionsController,
                    ),

                    const SizedBox(height: 20),

                    // Payment Method Section
                    PaymentMethodSection(
                      selectedPaymentMethod: selectedPaymentMethod,
                      onPaymentMethodChanged: (method) {
                        setState(() {
                          selectedPaymentMethod = method;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    // Place Order Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.main500,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Place Order',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Lato',
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Cancel Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Lato',
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Security Note
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.main500.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 14,
                            color: AppColors.main500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Your information is secure and encrypted',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NeumorphicButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const _NeumorphicButton({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.bg_1,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(5, 3),
            ),
            const BoxShadow(
              color: Color(0xFFFFFFFF),
              blurRadius: 10,
              offset: Offset(-5, -5),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}
