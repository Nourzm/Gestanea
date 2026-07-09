import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestanea/core/widgets/gradient_pill_button.dart';

Widget _wrap(Widget child) => MaterialApp(
  home: Scaffold(body: Center(child: child)),
);

void main() {
  group('GradientPillButton', () {
    testWidgets('renders the label and fires onPressed', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _wrap(GradientPillButton(label: 'Continue', onPressed: () => taps++)),
      );

      expect(find.text('Continue'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('hides label and shows a spinner while isLoading', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          GradientPillButton(label: 'Save', isLoading: true, onPressed: () {}),
        ),
      );

      expect(find.text('Save'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('does not fire onPressed when isLoading', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _wrap(
          GradientPillButton(
            label: 'Send',
            isLoading: true,
            onPressed: () => taps++,
          ),
        ),
      );

      // Tap at the centre of the pill — the InkWell should be disabled.
      await tester.tap(find.byType(GradientPillButton));
      await tester.pump();
      expect(taps, 0);
    });

    testWidgets('disables tap when onPressed is null', (tester) async {
      await tester.pumpWidget(
        _wrap(const GradientPillButton(label: 'Disabled', onPressed: null)),
      );

      // Should still render the label, just inert.
      expect(find.text('Disabled'), findsOneWidget);
      await tester.tap(find.byType(GradientPillButton));
      await tester.pump();
      // Nothing to assert beyond "did not crash" — onPressed is null.
    });

    testWidgets('renders trailing icon when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(
          GradientPillButton(
            label: 'Next',
            icon: Icons.arrow_forward,
            onPressed: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });
  });
}
