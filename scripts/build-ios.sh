#!/bin/bash
# One-click iOS build (macOS only). Defaults to a debug build for the simulator.
# Pass --release to build a signed .ipa (requires Apple Developer team in Xcode).
#
# Prereqs: see docs/build-ios.md.

set -euo pipefail

cd "$(dirname "$0")/.."

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "[build-ios] ERROR: iOS builds require macOS."
  exit 1
fi

if ! command -v flutter >/dev/null 2>&1; then
  echo "[build-ios] ERROR: flutter not found on PATH. See docs/build-ios.md."
  exit 1
fi

MODE="debug"
if [[ "${1:-}" == "--release" ]]; then
  MODE="release"
fi

echo "[build-ios] flutter pub get"
flutter pub get

echo "[build-ios] pod install (ios/)"
( cd ios && pod install )

echo "[build-ios] flutter analyze"
flutter analyze

echo "[build-ios] flutter test"
flutter test

if [[ "$MODE" == "release" ]]; then
  echo "[build-ios] flutter build ipa --release"
  flutter build ipa --release
  OUT="build/ios/ipa"
  echo ""
  echo "[build-ios] SUCCESS: $(pwd)/$OUT/*.ipa"
  ls -1 "$OUT"
else
  echo "[build-ios] flutter build ios --debug --simulator"
  flutter build ios --debug --simulator
  echo ""
  echo "[build-ios] SUCCESS: simulator build at build/ios/iphonesimulator/Runner.app"
  echo "[build-ios] Run on simulator with:  flutter run"
fi
