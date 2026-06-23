@echo off
REM One-click Android release APK build (Windows).
REM Prereqs: see docs\build-android.md.

setlocal enabledelayedexpansion
cd /d "%~dp0\.."

where flutter >nul 2>&1
if errorlevel 1 (
  echo [build-apk] ERROR: flutter not found on PATH. See docs\build-android.md.
  exit /b 1
)

echo [build-apk] flutter pub get
call flutter pub get || exit /b 1

echo [build-apk] flutter analyze
call flutter analyze || exit /b 1

echo [build-apk] flutter test
call flutter test || exit /b 1

echo [build-apk] flutter build apk --release
call flutter build apk --release || exit /b 1

set OUT=build\app\outputs\flutter-apk\app-release.apk
if exist "%OUT%" (
  echo.
  echo [build-apk] SUCCESS: %CD%\%OUT%
) else (
  echo [build-apk] ERROR: expected output not found at %OUT%
  exit /b 1
)

endlocal
