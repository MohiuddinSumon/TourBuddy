# Build the Android APK (Windows)

Target machine: Windows 10/11 PC. Produces `app-release.apk` you can sideload onto any Android device.

## 1. Install prerequisites

- [ ] Install **Git for Windows** — https://git-scm.com/download/win
- [ ] Install **Flutter SDK** (stable channel) — https://docs.flutter.dev/get-started/install/windows
  - [ ] Unzip to a path with **no spaces**, e.g. `C:\src\flutter`
  - [ ] Add `C:\src\flutter\bin` to the **User PATH** (System Properties → Environment Variables)
  - [ ] Open a **new** PowerShell window and verify: `flutter --version`
- [ ] Install **Android Studio** — https://developer.android.com/studio
  - [ ] During first launch, let it install: Android SDK, Android SDK Platform-Tools, Android SDK Build-Tools
  - [ ] Install **Android SDK Command-line Tools** (Settings → SDK Manager → SDK Tools tab → check "Android SDK Command-line Tools (latest)")
- [ ] Install a **JDK 17** if Android Studio didn't bundle one — https://adoptium.net/temurin/releases/
  - [ ] Set `JAVA_HOME` to the JDK install dir
  - [ ] Add `%JAVA_HOME%\bin` to PATH

## 2. Accept licenses and verify the toolchain

- [ ] `flutter doctor --android-licenses` — accept all (press `y` repeatedly)
- [ ] `flutter doctor` — every line under **Android toolchain** should be a green check
  - Ignore the Chrome / VS Code / Xcode lines — not needed for an APK build

## 3. Get the code

- [ ] `git clone https://github.com/MohiuddinSumon/TourBuddy.git`
- [ ] `cd TourBuddy`
- [ ] `flutter pub get`

## 4. Sanity-check before building

- [ ] `flutter analyze` — should report no issues
- [ ] `flutter test` — all widget tests should pass

## Build folders
- flutter create --platforms=android,ios --org com.rocketlab --project-name tourbuddy .

## 5. Build the release APK

- [ ] `flutter build apk --release`
- [ ] Output file: `build\app\outputs\flutter-apk\app-release.apk`

The unsigned release APK above is signed with Flutter's debug key, which is fine
for sideloading to your own device but **not** for Play Store upload.

### Optional: split per ABI (smaller APKs)

- [ ] `flutter build apk --release --split-per-abi`
- [ ] Outputs: `app-armeabi-v7a-release.apk`, `app-arm64-v8a-release.apk`, `app-x86_64-release.apk`

## 6. Install on a device

- [ ] Enable **Developer options** → **USB debugging** on the phone
- [ ] Plug in via USB, accept the RSA prompt
- [ ] `flutter devices` — your phone should show up
- [ ] `flutter install` — pushes the most recent release build

Or copy the `.apk` file to the phone and tap it in a file manager (you may need
to allow "Install unknown apps" for that file manager).

## 7. Set the launcher label (one-time, optional)

`flutter create` uses the lowercase package name (`tourbuddy`) as the app label.
To show **TourBuddy** under the launcher icon, edit
`android\app\src\main\AndroidManifest.xml` and set:

```xml
<application
    android:label="TourBuddy"
    ...>
```

Then rebuild.

## Troubleshooting

- [ ] `flutter doctor` complains about `cmdline-tools` → install **Android SDK Command-line Tools (latest)** via SDK Manager
- [ ] Gradle download hangs behind a corporate proxy → set `HTTP_PROXY` / `HTTPS_PROXY` env vars before running `flutter build`
- [ ] "SDK location not found" → set `ANDROID_HOME` to `%LOCALAPPDATA%\Android\Sdk`
- [ ] First build is slow (5–15 min) — Gradle is downloading dependencies. Subsequent builds are fast.
