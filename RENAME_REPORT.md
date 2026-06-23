# TourBuddy — Project Rename Report

**Rename:** `TripWise AI` → `TourBuddy`
**Final product name:** TourBuddy
**Tagline:** "Explore smarter. Avoid tourist traps."

---

## 1. Files updated

| File | Change |
|------|--------|
| `pubspec.yaml` | Package description rebranded to TourBuddy |
| `lib/main.dart` | Class `TripWiseApp` → `TourBuddyApp`; `MaterialApp` title → `TourBuddy` |
| `lib/models/travel_guide.dart` | Copy-Guide share header → `TourBuddy — <dest> Travel Guide` |
| `lib/screens/home_screen.dart` | Home-screen brand heading → `TourBuddy` |
| `test/widget_test.dart` | All `TripWiseApp` refs → `TourBuddyApp`; brand assertion → `TourBuddy` |
| `README.md` | Created fresh, fully TourBuddy-branded |

Files with **no** old references (left unchanged): `lib/services/guide_service.dart`,
`lib/screens/result_screen.dart`.

The Dart **package name** was already `tourbuddy`, so application identifiers
(`com.example.tourbuddy`), import paths, and build config needed no change.

## 2. References changed

| # | Location | Before | After |
|---|----------|--------|-------|
| 1 | pubspec description | `"TripWise AI - generate..."` | `"TourBuddy - generate..."` |
| 2 | main.dart entry | `runApp(const TripWiseApp())` | `runApp(const TourBuddyApp())` |
| 3 | main.dart class def | `class TripWiseApp` | `class TourBuddyApp` |
| 4 | main.dart constructor | `const TripWiseApp({...})` | `const TourBuddyApp({...})` |
| 5 | main.dart title | `title: 'TripWise AI'` | `title: 'TourBuddy'` |
| 6 | travel_guide.dart share text | `'TripWise AI — ...'` | `'TourBuddy — ...'` |
| 7 | home_screen.dart heading | `Text('TripWise AI')` | `Text('TourBuddy')` |
| 8 | widget_test.dart (×4) | `const TripWiseApp()` | `const TourBuddyApp()` |
| 9 | widget_test.dart assert | `find.text('TripWise AI')` | `find.text('TourBuddy')` |

## 3. Validation result

| Check | Method | Result |
|-------|--------|--------|
| No leftover "TripWise" anywhere | `grep -rin "tripwise" .` | **PASS — 0 matches** |
| Old class id removed | `grep -rn "TripWiseApp"` | **PASS — 0 matches** |
| New class id consistent (def + 5 call sites) | `grep -rn "TourBuddyApp"` | **PASS** |
| Package import matches pubspec name | string compare | **PASS** (`package:tourbuddy/main.dart`) |
| All relative imports resolve to real files | path existence check | **PASS — 0 missing** |

**Build/run validation — must be run on your machine.** A full `flutter build`
could **not** be executed in this sandbox: the Flutter and Android SDKs (and
Google's Maven repos) aren't installed or reachable here. The rename only touched
string literals and one class identifier (renamed consistently across all call
sites), and no imports or dependencies changed, so the build is expected to
succeed. Confirm with:

```bash
flutter pub get
flutter analyze      # expect: no issues found
flutter test         # expect: all 4 tests pass
flutter run          # launches on device/emulator
```

## 4. Confirmation

> **No "TripWise AI" references remain in the project.**
> Verified by a project-wide, case-insensitive search returning **0 occurrences**.
