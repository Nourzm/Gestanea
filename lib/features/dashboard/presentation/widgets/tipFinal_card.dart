import 'package:flutter/material.dart';
import 'package:gestanea/features/dashboard/presentation/pages/tip_details.dart';
import 'package:gestanea/features/dashboard/presentation/widgets/expanded_tips_card.dart';
import 'package:gestanea/features/dashboard/presentation/widgets/tips_card.dart';

class ProductCardToggle extends StatefulWidget {
  // 1. Define the optional property in the widget
  final bool initialExpanded;

  // Set the default value to false (compact)
  const ProductCardToggle({super.key, this.initialExpanded = false});

  @override
  State<ProductCardToggle> createState() => _ProductCardToggleState();
}

class _ProductCardToggleState extends State<ProductCardToggle> {
  // State variable to track the card's current appearance
  // Use 'late' because we will initialize it in initState
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    // 2. Initialize the state using the property passed in the constructor
    _isExpanded = widget.initialExpanded;
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  // Navigation function for the Arrow Button
  void _goToDetailsPage() {
    // Implement your navigation here
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const CustomCurvedPage()));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState: _isExpanded
          ? CrossFadeState
                .showSecond // Show the expanded card
          : CrossFadeState.showFirst, // Show the compact card
      // Compact Card (First Child)
      firstChild: CompactCard(onTap: _toggleExpanded),

      // Expanded Card (Second Child)
      secondChild: ExpandedCard(
        onCollapse: _toggleExpanded,
        onDetailsTap: _goToDetailsPage,
      ),

      duration: const Duration(milliseconds: 400),
      alignment: Alignment.topCenter,
    );
  }
}

// Dummy page for navigation
class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: const Center(child: Text('This is the details page!')),
    );
  }
}
