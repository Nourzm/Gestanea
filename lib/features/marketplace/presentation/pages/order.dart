import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:gestanea/core/utils/box_shadow.dart';
import 'package:gestanea/core/utils/box_decoration.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/features/auth/logic/auth_bloc.dart';
import 'package:gestanea/features/auth/logic/auth_state.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import '../../logic/order_bloc.dart';
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

  @override
  void initState() {
    super.initState();

    // Get the current user's name from AuthBloc
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      fullNameController.text = authState.user.name;
      // Also update the phone if available
      if (authState.user.phone != null && authState.user.phone!.isNotEmpty) {
        phoneController.text = authState.user.phone!;
      }
    }

    fullNameController.addListener(() {
      context.read<OrderBloc>().add(UpdateFullName(fullNameController.text));
    });
    phoneController.addListener(() {
      context.read<OrderBloc>().add(UpdatePhone(phoneController.text));
    });
    addressController.addListener(() {
      context.read<OrderBloc>().add(UpdateAddress(addressController.text));
    });
    cityController.addListener(() {
      context.read<OrderBloc>().add(UpdateCity(cityController.text));
    });
    instructionsController.addListener(() {
      context.read<OrderBloc>().add(
        UpdateInstructions(instructionsController.text),
      );
    });
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
                  Expanded(
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.completeYourOrder,
                        style: const TextStyle(
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
                    BlocBuilder<OrderBloc, OrderState>(
                      builder: (context, orderState) {
                        final state = orderState is OrderInitial
                            ? orderState
                            : orderState is OrderFormValid
                            ? orderState.orderData
                            : orderState is OrderFormInvalid
                            ? orderState.orderData
                            : const OrderInitial();

                        return NeumorphicSection(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle(
                                AppLocalizations.of(context)!.orderSummary,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey[300],
                                    ),
                                    child: state.productImage.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: Image.asset(
                                              state.productImage,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return const Center(
                                                      child: Icon(
                                                        Icons
                                                            .image_not_supported,
                                                        color: Colors.grey,
                                                        size: 40,
                                                      ),
                                                    );
                                                  },
                                            ),
                                          )
                                        : const Center(
                                            child: Icon(
                                              Icons.shopping_bag_outlined,
                                              color: Colors.grey,
                                              size: 40,
                                            ),
                                          ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.productName.isNotEmpty
                                              ? state.productName
                                              : AppLocalizations.of(
                                                  context,
                                                )!.product,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        if (state.selectedColor.isNotEmpty ||
                                            state.selectedSize.isNotEmpty)
                                          Row(
                                            children: [
                                              if (state
                                                  .selectedColor
                                                  .isNotEmpty) ...[
                                                Container(
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color:
                                                        state.selectedColorHex !=
                                                            null
                                                        ? Color(
                                                            int.parse(
                                                              state
                                                                  .selectedColorHex!
                                                                  .replaceFirst(
                                                                    '#',
                                                                    '0xFF',
                                                                  ),
                                                            ),
                                                          )
                                                        : AppColors.main500,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  state.selectedColor,
                                                  style: AppTextStyles.body1
                                                      .copyWith(
                                                        fontSize: 12,
                                                        color: AppColors
                                                            .textPrimary,
                                                        height: 1.4,
                                                      ),
                                                ),
                                              ],
                                              if (state
                                                  .selectedSize
                                                  .isNotEmpty) ...[
                                                const SizedBox(width: 16),
                                                Text(
                                                  '${AppLocalizations.of(context)!.size}: ${state.selectedSize}',
                                                  style: AppTextStyles.body1
                                                      .copyWith(
                                                        fontSize: 12,
                                                        color: AppColors
                                                            .textPrimary,
                                                        height: 1.4,
                                                      ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        const SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${AppLocalizations.of(context)!.qty}: ${state.quantity}',
                                              style: AppTextStyles.body1
                                                  .copyWith(
                                                    fontSize: 12,
                                                    color:
                                                        AppColors.textPrimary,
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
                              const Divider(
                                color: Color(0xFFD0C0E0),
                                height: 1,
                              ),
                              const SizedBox(height: 12),
                              BlocBuilder<OrderBloc, OrderState>(
                                builder: (context, state) {
                                  final subtotal = state is OrderInitial
                                      ? state.subtotal
                                      : 22.40;
                                  final deliveryFee = state is OrderInitial
                                      ? state.deliveryFee
                                      : 5.00;
                                  final total = state is OrderInitial
                                      ? state.total
                                      : 27.40;

                                  return Column(
                                    children: [
                                      _buildPriceRow(
                                        AppLocalizations.of(context)!.subtotal,
                                        "${subtotal.toStringAsFixed(0)}DA",
                                      ),
                                      const SizedBox(height: 8),
                                      _buildPriceRow(
                                        AppLocalizations.of(
                                          context,
                                        )!.deliveryFee,
                                        '${deliveryFee.toStringAsFixed(0)}DA',
                                      ),
                                      const SizedBox(height: 12),
                                      const Divider(
                                        color: Color(0xFFD0C0E0),
                                        height: 1,
                                      ),
                                      const SizedBox(height: 12),
                                      _buildPriceRow(
                                        AppLocalizations.of(context)!.total,
                                        '${total.toStringAsFixed(0)}DA',
                                        isBold: true,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
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
                    BlocBuilder<OrderBloc, OrderState>(
                      builder: (context, state) {
                        final selectedPaymentMethod = state is OrderInitial
                            ? state.paymentMethod
                            : 'cash';

                        return PaymentMethodSection(
                          selectedPaymentMethod: selectedPaymentMethod,
                          onPaymentMethodChanged: (method) {
                            context.read<OrderBloc>().add(
                              SelectPaymentMethod(method),
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // Place Order Button
                    BlocConsumer<OrderBloc, OrderState>(
                      listener: (context, state) {
                        if (state is OrderPlaced) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(
                                  context,
                                )!.orderPlacedSuccessfully(state.orderId),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context);
                        } else if (state is OrderError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (state is OrderFormInvalid) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.errorMessage),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        final isPlacing = state is OrderPlacing;

                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isPlacing
                                ? null
                                : () {
                                    context.read<OrderBloc>().add(
                                      const PlaceOrder(),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.main500,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: isPlacing
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    AppLocalizations.of(context)!.placeOrder,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Lato',
                                    ),
                                  ),
                          ),
                        );
                      },
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
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          style: const TextStyle(
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
                          AppLocalizations.of(context)!.yourInformationIsSecure,
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
