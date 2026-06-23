#!/bin/bash
# SessionStart hook: installs Flutter (stable) so `flutter analyze` and
# `flutter test` work in Claude Code on the web sessions.
#
# Idempotent: safe to run multiple times. On warm container starts the
# Flutter clone and pub cache are already populated, so this finishes quickly.

set -euo pipefail

# Only run in the remote (web) environment — local users have their own Flutter.
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

FLUTTER_DIR="${HOME}/flutter"
FLUTTER_BIN="${FLUTTER_DIR}/bin"

if [ ! -x "${FLUTTER_BIN}/flutter" ]; then
  echo "[session-start] Cloning Flutter stable into ${FLUTTER_DIR}..."
  git clone --depth 1 -b stable https://github.com/flutter/flutter.git "${FLUTTER_DIR}"
else
  echo "[session-start] Flutter already present at ${FLUTTER_DIR}"
fi

export PATH="${FLUTTER_BIN}:${PATH}"

# Disable analytics + first-run prompts so the CLI is non-interactive.
flutter --disable-analytics >/dev/null 2>&1 || true
flutter config --no-analytics >/dev/null 2>&1 || true

# Warm up the Dart SDK + core artifacts. Skip mobile artifacts — we only need
# analyze/test, which run on the host (Linux) Dart VM.
echo "[session-start] Pre-caching Flutter artifacts (universal only)..."
flutter precache --universal --no-android --no-ios --no-linux --no-windows --no-macos --no-web >/dev/null

# Fetch project dependencies.
if [ -f "${CLAUDE_PROJECT_DIR}/pubspec.yaml" ]; then
  echo "[session-start] Running flutter pub get..."
  (cd "${CLAUDE_PROJECT_DIR}" && flutter pub get)
fi

# Persist PATH for the session.
echo "export PATH=\"${FLUTTER_BIN}:\$PATH\"" >> "${CLAUDE_ENV_FILE}"

echo "[session-start] Flutter ready: $(flutter --version | head -1)"
