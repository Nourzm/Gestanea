import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:gestanea/l10n/app_localizations.dart';

class LocationSelector extends StatelessWidget {
  final String selectedLocation;
  final VoidCallback onTap;

  const LocationSelector({
    Key? key,
    required this.selectedLocation,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.bg_1,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: AppColors.white, width: 0.5),
            boxShadow: [
              const BoxShadow(
                color: AppColors.white,
                offset: Offset(-2.5, -2.5),
                blurRadius: 5,
                spreadRadius: -5,
                inset: true,
              ),
              BoxShadow(
                color: const Color(0xFF000000).withOpacity(0.25),
                offset: const Offset(2.5, 2.5),
                blurRadius: 5,
                inset: true,
              ),
            ],
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Icon(
                  Icons.location_on,
                  color: AppColors.main500,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  selectedLocation == l10n.useCurrentLocation
                      ? l10n.useCurrentLocation
                      : selectedLocation,
                  style: const TextStyle(
                    color: AppColors.main500,
                    fontSize: 16,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.main500,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
