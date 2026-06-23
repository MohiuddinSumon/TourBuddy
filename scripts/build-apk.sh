#!/bin/bash
# One-click Android release APK build (macOS/Linux).
# Prereqs: see docs/build-android.md.

set -euo pipefail

cd "$(dirname "$0")/.."

if ! command -v flutter >/dev/null 2>&1; then
  echo "[build-apk] ERROR: flutter not found on PATH. See docs/build-android.md."
  exit 1
fi

echo "[build-apk] flutter pub get"
flutter pub get

echo "[build-apk] flutter analyze"
flutter analyze

echo "[build-apk] flutter test"
flutter test

echo "[build-apk] flutter build apk --release"
flutter build apk --release

OUT="build/app/outputs/flutter-apk/app-release.apk"
if [ -f "$OUT" ]; then
  echo ""
  echo "[build-apk] SUCCESS: $(pwd)/$OUT"
else
  echo "[build-apk] ERROR: expected output not found at $OUT"
  exit 1
fi
