import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gestanea/core/constants/app_colors.dart';

/// Legacy name preserved for backward compatibility — under the hood this now
/// renders the flat purple-gradient pill from the Gestanéa design system, so
/// every screen that referenced `NeumorphicButton` automatically picks up the
/// new style without rewriting callsites.
class NeumorphicButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final dynamic prefixIcon; // IconData or SVG asset path
  final dynamic suffixIcon; // IconData or SVG asset path
  final Color? color;
  final double? minHeight;
  final double? maxWidth;

  const NeumorphicButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.prefixIcon,
    this.suffixIcon,
    this.color,
    this.minHeight,
    this.maxWidth,
  });

  Widget? _renderIcon(dynamic icon) {
    if (icon == null) return null;
    if (icon is IconData) {
      return Icon(icon, color: Colors.white, size: 20);
    }
    if (icon is String) {
      return SvgPicture.asset(
        icon,
        width: 18,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = minHeight ?? 56.0;
    final prefix = _renderIcon(prefixIcon);
    final suffix = _renderIcon(suffixIcon);

    final gradient = color == null
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.main500, AppColors.main600],
          )
        : LinearGradient(colors: [color!, color!]);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? size.width,
        minHeight: height,
      ),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height / 2),
          gradient: gradient,
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(height / 2),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (prefix != null) ...[prefix, const SizedBox(width: 10)],
                  Flexible(
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (suffix != null) ...[const SizedBox(width: 10), suffix],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
