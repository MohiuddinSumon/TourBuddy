import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tourbuddy/main.dart';

void main() {
  testWidgets('App loads with name, tagline, and button', (tester) async {
    await tester.pumpWidget(const TourBuddyApp());

    expect(find.text('TourBuddy'), findsOneWidget);
    expect(find.text('Explore smarter. Avoid tourist traps.'), findsOneWidget);
    expect(find.text('Generate Guide'), findsOneWidget);
  });

  testWidgets('Empty destination shows a validation message', (tester) async {
    await tester.pumpWidget(const TourBuddyApp());

    await tester.tap(find.text('Generate Guide'));
    await tester.pump();

    expect(find.text('Please enter a destination'), findsOneWidget);
  });

  testWidgets('Valid destination generates a guide', (tester) async {
    await tester.pumpWidget(const TourBuddyApp());

    await tester.enterText(find.byType(TextField), 'Paris');
    await tester.tap(find.text('Generate Guide'));
    await tester.pumpAndSettle();

    expect(find.text('Things to Do'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('Result screen shows all five sections', (tester) async {
    await tester.pumpWidget(const TourBuddyApp());

    await tester.enterText(find.byType(TextField), 'Dubai');
    await tester.tap(find.text('Generate Guide'));
    await tester.pumpAndSettle();

    expect(find.text('Things to Do'), findsOneWidget);
    expect(find.text('Scams to Avoid'), findsOneWidget);
    expect(find.text('Local Tips'), findsOneWidget);
    expect(find.text('Food to Try'), findsOneWidget);
    expect(find.text('Getting Around'), findsOneWidget);
  });
}
