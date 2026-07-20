import 'package:flutter/material.dart';
import 'package:gestanea/features/dashboard/presentation/pages/tip_details.dart';
import 'package:gestanea/features/dashboard/presentation/widgets/expanded_tips_card.dart';
import 'package:gestanea/features/dashboard/presentation/widgets/tips_card.dart';

class ProductCardToggle extends StatefulWidget {
  final bool initialExpanded;

  final String title;
  final String description;
  final String readTime;
  final String? imagePath;
  final VoidCallback? onDetailsTap;

  const ProductCardToggle({
    super.key,
    this.initialExpanded = false,
    required this.title,
    required this.description,
    required this.readTime,
    this.imagePath,
    this.onDetailsTap,
  });

  @override
  State<ProductCardToggle> createState() => _ProductCardToggleState();
}

class _ProductCardToggleState extends State<ProductCardToggle> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initialExpanded;
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _goToDetailsPage() {
    if (widget.onDetailsTap != null) {
      widget.onDetailsTap!();
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CustomCurvedPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState:
          _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,

      firstChild: CompactCard(
        onTap: _toggleExpanded,
        title: widget.title,
        description: widget.description,
        readTime: widget.readTime,
        imagePath: widget.imagePath,
      ),

      secondChild: ExpandedCard(
        onCollapse: _toggleExpanded,
        onDetailsTap: _goToDetailsPage,
        title: widget.title,
        description: widget.description,
        readTime: widget.readTime,
        imagePath: widget.imagePath,
      ),

      duration: const Duration(milliseconds: 400),
      alignment: Alignment.topCenter,
    );
  }
}
