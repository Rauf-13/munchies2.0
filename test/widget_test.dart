import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodapp/main.dart';

void main() {
  testWidgets('Home screen renders key content', (WidgetTester tester) async {
    await tester.pumpWidget(const MunchiesApp());

    expect(find.text('Good morning,'), findsOneWidget);
    expect(find.text('Nearby Vendors'), findsOneWidget);
    expect(find.text('Chop Budget Mode'), findsOneWidget);
  });

  testWidgets('Opening a vendor menu works', (WidgetTester tester) async {
    await tester.pumpWidget(const MunchiesApp());

    final vendorCardFinder = find.byKey(const ValueKey('1'));
    await tester.pumpAndSettle();

    // Scroll the main page so the horizontal vendor list comes into view.
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -450),
    );
    await tester.pumpAndSettle();

    // If multiple matches exist, take the first to keep the test robust.
    await tester.tap(vendorCardFinder.at(0));
    await tester.pumpAndSettle();

    expect(find.text('Browse menu'), findsOneWidget);
    expect(find.text('Ask AI to order'), findsOneWidget);
  });
}
