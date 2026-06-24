import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tourbuddy/main.dart';
import 'package:tourbuddy/services/guide_service.dart';

void main() {
  // Warm the bundle cache once before any widget test runs. The static cache
  // in GuideService keeps it loaded for the rest of the suite, so subsequent
  // taps resolve synchronously and pumpAndSettle reliably terminates.
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await GuideService().generateGuide('Paris');
  });

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
    // Tall viewport so all five lazy-built section cards are realised in the
    // widget tree without scrolling.
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

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
