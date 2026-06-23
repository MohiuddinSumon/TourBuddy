# Flutter inside Claude Code on the web

Claude Code web sessions run in an ephemeral Linux container. This repo ships a
**SessionStart hook** that installs Flutter automatically each time a session
boots, so `flutter analyze` and `flutter test` "just work" without manual setup.

## What's wired up

- [x] `.claude/hooks/session-start.sh` — clones Flutter stable into `~/flutter`, runs `flutter precache --universal`, and runs `flutter pub get`
- [x] `.claude/settings.json` — registers the hook on the `SessionStart` event
- [x] PATH is persisted via `$CLAUDE_ENV_FILE` so `flutter` is available in every subsequent shell

## What works inside the container

- [x] `flutter --version`
- [x] `flutter analyze`
- [x] `flutter test` (and `flutter test --plain-name "<test name>"` for a single test)
- [x] `flutter pub get` / `flutter pub upgrade`
- [x] `dart format .`

## What does NOT work inside the container

- [ ] **iOS builds** — require macOS + Xcode. No workaround.
- [ ] **Android APK builds** — would need the Android SDK (~1 GB), JDK 17, and accepted licenses. Possible but heavy; the hook intentionally skips it. Build APKs locally per `docs/build-android.md`.
- [ ] **`flutter run` on a device** — no USB / no simulator in the container.

## Customising

- [ ] To pin a specific Flutter version, change the `git clone -b stable` line in `.claude/hooks/session-start.sh` to a tag, e.g. `-b 3.24.0`.
- [ ] To run the hook in the background (faster session start, but tests may race), change the script to emit `{"async": true, "asyncTimeout": 300000}` on its first line of stdout. See [hook docs](https://docs.claude.com/en/docs/claude-code/hooks).
- [ ] To install the Android SDK as well, extend the hook with a `cmdline-tools` install and `sdkmanager --licenses` — expect the first cold session to take several minutes.

## Verifying after editing the hook

```bash
CLAUDE_CODE_REMOTE=true \
CLAUDE_PROJECT_DIR="$(pwd)" \
CLAUDE_ENV_FILE=/tmp/claude-env-test.sh \
bash .claude/hooks/session-start.sh
```

The script is idempotent — re-running it on a warm container is fast (skips the clone).
