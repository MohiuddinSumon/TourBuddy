# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

TourBuddy is a Flutter Android app (Dart SDK `>=3.2.0 <4.0.0`, Material 3). User enters a destination, the app returns a structured travel guide with five fixed sections: Things to Do, Scams to Avoid, Local Tips, Food to Try, Getting Around.

The MVP ships with **mock data only** — no API key, login, network, maps, or backend. The codebase is deliberately shaped so an OpenAI integration can be dropped in later by replacing the body of `GuideService.generateGuide` without changing anything else.

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

- **`models/travel_guide.dart`** — `TravelGuide` is an immutable value type with five `List<String>` sections plus `destination`. `toShareText()` produces the plaintext used by the "Copy Guide" button on the result screen; its header format (`"TourBuddy — <dest> Travel Guide"`) is asserted-on by the brand and should stay in sync with the app name.
- **`services/guide_service.dart`** — `GuideService.generateGuide(destination)` returns `Future<TravelGuide>` with a simulated ~900 ms delay so the loading spinner is visible. Lookup is case-insensitive against a static `_mockGuides` map (`bali`, `dubai`, `paris`); anything else falls back to `_genericGuide`, a templated guide that interpolates the title-cased destination. **This is the single seam for swapping in a real OpenAI call** — keep the `Future<TravelGuide>` signature stable so screens don't change.
- **`screens/`** — `HomeScreen` (input + example chips + Generate button) navigates to `ResultScreen` (five `_SectionCard`s rendered from the guide). `HomeScreen._generateGuide` captures `Navigator.of(context)` **before** the `await` and rechecks `mounted` after — preserve this pattern when editing async UI code, the analyzer enforces it.

`main.dart` is a thin `MaterialApp` shell (M3, white scaffold, seed color `#2563EB`) that mounts `HomeScreen`.

## Tests

`test/widget_test.dart` drives the real app via `TourBuddyApp` (not mocked widgets). The "Valid destination" and "all five sections" tests use `pumpAndSettle()`, which waits out `GuideService`'s 900 ms delay — if you change that delay or make the service genuinely async over the network, those tests need rework.

## Branding invariants

The product name `TourBuddy` and tagline `Explore smarter. Avoid tourist traps.` appear in `main.dart` (title), `home_screen.dart` (heading + tagline), `travel_guide.dart` (share-text header), and `widget_test.dart` (assertions). Renaming requires updating all four. See `RENAME_REPORT.md` for the audit trail of the previous `TripWise AI → TourBuddy` rename.

## Android launcher label

`flutter create` sets the launcher label to the lowercase project name. To show "TourBuddy" under the icon, set `android:label="TourBuddy"` on `<application>` in `android/app/src/main/AndroidManifest.xml`.
