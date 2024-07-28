import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Calculator/main.dart'; // Replace with your actual import path

void main() {
  testWidgets('Calculator app test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app starts with an empty display.
    expect(find.text(''), findsOneWidget);
    //expect(find.text('1'), findsNothing);

    // Tap the '1' button and verify that the displayedText is updated.
    await tester.tap(find.text('1'));
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
    expect(find.text('0'), findsNothing);

    // Tap the '0' button and verify that the displayedText is updated.
    await tester.tap(find.text('0'));
    await tester.pump();

    expect(find.text('10'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' button and verify that the displayedText is updated.
    await tester.tap(find.text('+'));
    await tester.pump();

    expect(find.text('10+'), findsOneWidget);

    // Tap the '2' button and verify that the displayedText is updated.
    await tester.tap(find.text('2'));
    await tester.pump();

    expect(find.text('10+2'), findsOneWidget);

    // Tap the '=' button and verify that the displayedText is updated with the result.
    await tester.tap(find.text('='));
    await tester.pump();

    expect(find.text('12'), findsOneWidget);

    // Tap the 'x' icon to clear the display
    await tester.tap(find.byIcon(Icons.cancel));
    await tester.pump();

    expect(find.text(''), findsOneWidget);
  });
}
