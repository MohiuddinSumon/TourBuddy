# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

TourBuddy is a Flutter Android app (Dart SDK `>=3.2.0 <4.0.0`, Material 3). User enters a destination, the app returns a structured travel guide with five fixed sections: Things to Do, Scams to Avoid, Local Tips, Food to Try, Getting Around.

The MVP ships **offline-first** with 105 pre-bundled city guides in `assets/guides-bundle.json` (~480 KB, keyed by lowercase city name). Each guide entry is a `{title, description}` pair, not a flat string — see `GuideItem` in `models/travel_guide.dart`.

Phased roadmap (see `RENAME_REPORT.md` and PR history for source-of-truth):
1. **Foundation (done):** structured `GuideItem` model, 105-guide bundle, generic fallback for unknown destinations.
2. **Multi-provider live AI:** OpenAI / Anthropic / Gemini / xAI direct from device, keys in `flutter_secure_storage`; Settings screen.
3. **Itinerary builder + dark mode + bookmarks.**
4. **World map + Explorer Identity.**
5. **Polish:** hero images, Year in Travel card, pre-departure brief, phrase book.

## Commands

```bash
flutter pub get             # install deps
flutter analyze             # static analysis
flutter test                # run all widget tests
flutter test test/widget_test.dart -p "Valid destination generates a guide"  # single test by name
flutter run                 # run on connected device/emulator
flutter build apk --release # APK at build/app/outputs/flutter-apk/app-release.apk
```

## Architecture

Three-layer split, all under `lib/`:

- **`models/travel_guide.dart`** — `TravelGuide` holds five `List<GuideItem>` sections plus `destination`. `GuideItem` is `{title, description}`. `TravelGuide.fromJson` matches the bundled JSON schema (`topThingsToDo`, `scamsToAvoid`, `localTips`, `foodToTry`, `gettingAround`). `toShareText()` produces the plaintext used by the "Copy Guide" button; its header format (`"TourBuddy — <dest> Travel Guide"`) is asserted-on by the brand and should stay in sync with the app name.
- **`services/guide_service.dart`** — `GuideService.generateGuide(destination)` returns `Future<TravelGuide>`. Resolution order: in-memory cache → bundled `assets/guides-bundle.json` (lazy-loaded once via `rootBundle.loadString`) → `_genericGuide` templated fallback. **The single seam for live AI generation** in Phase 2 — keep the `Future<TravelGuide>` signature stable so screens don't change.
- **`screens/`** — `HomeScreen` (input + example chips + Generate button) navigates to `ResultScreen` (five `_SectionCard`s, each rendering bold title + lighter description per `GuideItem`). `HomeScreen._generateGuide` captures `Navigator.of(context)` **before** the `await` and rechecks `mounted` after — preserve this pattern when editing async UI code, the analyzer enforces it.

`main.dart` is a thin `MaterialApp` shell (M3, white scaffold, seed color `#2563EB`) that mounts `HomeScreen`.

## Tests

`test/widget_test.dart` drives the real app via `TourBuddyApp` (not mocked widgets). Notes:
- `setUpAll` warms the bundle cache once via `GuideService().generateGuide('Paris')` so widget taps resolve synchronously and `pumpAndSettle()` reliably terminates.
- "Result screen shows all five sections" enlarges `tester.view.physicalSize` to 800×3000 so all lazy `ListView` cards are realised without scrolling.
- When you make `GuideService` go genuinely async over the network in Phase 2, mock the AI client in tests — don't add real-clock delays the tests have to wait out.

## Branding invariants

The product name `TourBuddy` and tagline `Explore smarter. Avoid tourist traps.` appear in `main.dart` (title), `home_screen.dart` (heading + tagline), `travel_guide.dart` (share-text header), and `widget_test.dart` (assertions). Renaming requires updating all four. See `RENAME_REPORT.md` for the audit trail of the previous `TripWise AI → TourBuddy` rename.

## Android launcher label

`flutter create` sets the launcher label to the lowercase project name. To show "TourBuddy" under the icon, set `android:label="TourBuddy"` on `<application>` in `android/app/src/main/AndroidManifest.xml`.
