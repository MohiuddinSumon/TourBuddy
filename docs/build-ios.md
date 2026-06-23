# Build the iOS app (macOS)

Target machine: MacBook Air (Apple Silicon or Intel). iOS builds **require macOS** — they cannot be produced on Windows or Linux.

## 1. Install prerequisites

- [ ] Install **Xcode** from the Mac App Store (latest stable)
  - [ ] Launch Xcode once, accept the license, let it finish "installing additional components"
  - [ ] `sudo xcode-select --install` — install Command Line Tools
  - [ ] `sudo xcodebuild -license accept`
- [ ] Install **CocoaPods**: `sudo gem install cocoapods` (or `brew install cocoapods`)
- [ ] Install **Homebrew** if you don't have it — https://brew.sh
- [ ] Install **Flutter SDK** (stable channel)
  - [ ] `brew install --cask flutter` **or** download from https://docs.flutter.dev/get-started/install/macos
  - [ ] If downloaded manually, add `flutter/bin` to PATH in `~/.zshrc`:
    ```bash
    export PATH="$PATH:$HOME/development/flutter/bin"
    ```
  - [ ] Reload shell: `source ~/.zshrc`
  - [ ] Verify: `flutter --version`
- [ ] (Optional, for simulator only) install an iOS Simulator runtime: Xcode → Settings → Platforms → iOS

## 2. Verify the toolchain

- [ ] `flutter doctor` — every line under **Xcode** and **CocoaPods** should be a green check
  - The **Android toolchain** line can be ignored for an iOS-only build

## 3. Get the code

- [ ] `git clone https://github.com/MohiuddinSumon/TourBuddy.git`
- [ ] `cd TourBuddy`
- [ ] `flutter pub get`
- [ ] `cd ios && pod install && cd ..`  *(only needed the first time, or after dependency changes)*

## 4. Sanity-check before building

- [ ] `flutter analyze` — should report no issues
- [ ] `flutter test` — all widget tests should pass

## 5. Run in the iOS Simulator (no Apple Developer account needed)

- [ ] Open Simulator: `open -a Simulator`
- [ ] `flutter devices` — the booted simulator should appear
- [ ] `flutter run` — launches a debug build on the simulator

## 6. Run on a real iPhone

A free Apple ID is enough for personal sideloading; a paid **Apple Developer Program** account ($99/yr) is only required for App Store distribution.

- [ ] Plug iPhone in via USB, unlock it, tap **Trust** on the device
- [ ] In Xcode, open `ios/Runner.xcworkspace` (the `.xcworkspace`, not `.xcodeproj`)
- [ ] Select the **Runner** target → **Signing & Capabilities**
  - [ ] Tick **Automatically manage signing**
  - [ ] Choose your Apple ID under **Team** (add via Xcode → Settings → Accounts if missing)
  - [ ] Change the **Bundle Identifier** to something unique (Apple rejects duplicates), e.g. `com.<yourname>.tourbuddy`
- [ ] On the iPhone: Settings → General → VPN & Device Management → trust your developer cert
- [ ] Back in terminal: `flutter run --release`

Personal-team sideloaded apps expire after **7 days** and must be redeployed.

## 7. Build a release `.ipa` (Apple Developer Program required)

- [ ] `flutter build ipa --release`
- [ ] Output: `build/ios/ipa/tourbuddy.ipa`
- [ ] Upload to App Store Connect with Xcode's **Organizer** (Window → Organizer → Archives → Distribute App) or with `xcrun altool`

## 8. Set the display name (one-time, optional)

The launcher label comes from `CFBundleDisplayName` in `ios/Runner/Info.plist`:

```xml
<key>CFBundleDisplayName</key>
<string>TourBuddy</string>
```

## Troubleshooting

- [ ] `pod install` fails with repo errors → `pod repo update` then retry
- [ ] CocoaPods on Apple Silicon issues → `sudo arch -x86_64 gem install ffi` then retry `pod install`
- [ ] "No signing certificate" → check Xcode → Settings → Accounts has your Apple ID and a team is selected on the Runner target
- [ ] "Module ... not found" after a Flutter upgrade → `cd ios && pod deintegrate && pod install`
- [ ] Simulator stuck on "Booting" → `xcrun simctl shutdown all && xcrun simctl erase all`
