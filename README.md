# TourBuddy

**Explore smarter. Avoid tourist traps.**

TourBuddy is a simple Flutter Android app. You enter a destination and it
generates a structured AI travel guide covering Things to Do, Scams to Avoid,
Local Tips, Food to Try, and Getting Around.

The MVP runs entirely on mock data — no API key, login, payments, maps, or
backend required. OpenAI integration is an optional later step.

## File structure

```
tourbuddy/
├── lib/
│   ├── main.dart                 # App entry point (TourBuddyApp)
│   ├── models/
│   │   └── travel_guide.dart     # TravelGuide data model
│   ├── services/
│   │   └── guide_service.dart    # Mock guide generator (swap for OpenAI later)
│   └── screens/
│       ├── home_screen.dart      # Destination input + example chips
│       └── result_screen.dart    # Five structured guide cards
├── test/
│   └── widget_test.dart          # Widget tests
└── pubspec.yaml
```

## Run

```bash
flutter pub get
flutter run
```

## Test

```bash
flutter test
```

## Build APK

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

## App name on device (Android)

`flutter create` sets the launcher label to the lowercase project name. To show
"TourBuddy" under the icon, set the label in
`android/app/src/main/AndroidManifest.xml`:

```xml
<application
    android:label="TourBuddy"
    ...>
```
