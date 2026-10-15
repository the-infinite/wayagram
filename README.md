# WayaGram
The Flutter Mobile Application for the Android and iOS platforms. 

[![tests](https://github.com/WAYA-MULTI-LINK/WAYA-PAY-CHAT-2.0-WAYAGRAM-FLUTTER-APP/actions/workflows/tests.yaml/badge.svg)](https://github.com/WAYA-MULTI-LINK/WAYA-PAY-CHAT-2.0-WAYAGRAM-FLUTTER-APP/actions/workflows/tests.yaml)

## Helpful scripts
There are a few utilities added to the repository to make working somewhat easier and a little 
bit more self-explanatory. You would find these utilities in the helpers folder. 

### `build.bat` or `build.sh`
This helps you quickly run the Flutter CodeGen utility. This should be run every time you add a new
asset or anything else of a similar sort. Recommended to be run each time before you build the app or
run it in debug mode.

## End-to-end setup

### Prerequisites

- Git
- For Android: Android Studio (with Android SDK, platform tools, and a configured emulator or physical device) + Java 17 (required for release builds, see `.github/workflows/release.yaml`)
- For iOS: Xcode (on macOS) + CocoaPods (`sudo gem install cocoapods`)
- A Dart/Flutter-independent install of [FVM](https://fvm.app/). Do **not** install Flutter directly — this repo pins its Flutter SDK through FVM.

### 1. Clone the repo

```bash
git clone <this-repo-url>
cd wayagram
```

### 2. Install FVM and use the repo-pinned Flutter version

This repo pins **Flutter 3.27.2 (stable, bundled Dart 3.6.1)** in:

- `.fvm/fvm_config.json` (`"flutterSdkVersion": "3.27.2"`)
- `.fvm/version` / `.fvm/release`

The same version is used in CI (`.github/workflows/tests.yaml`, `.github/workflows/release.yaml`), so use it locally too.

```bash
# Install FVM (pick one):
dart pub global activate fvm
# or: brew install fvm
# or: choco install fvm   (Windows)

# Install and select the pinned SDK (run from the repo root):
fvm install
fvm use 3.27.2

# Verify — must report Flutter 3.27.2 / Dart 3.6.1:
fvm flutter --version
```

> Always run Flutter/Dart through FVM in this repo: `fvm flutter ...` and `fvm dart ...`, not bare `flutter` / `dart`. `fvm use` wires `.fvm/flutter_sdk` to the correct SDK.

### 3. Install dependencies

```bash
fvm flutter pub get
```

For iOS (macOS only), also install pods on first checkout:

```bash
cd ios && pod install && cd ..
```

### 4. Build the generated outputs (required before first run)

Codegen is driven by `build_runner` (`json_serializable`, `riverpod_generator`, `flutter_gen_runner`, etc.). It generates `*.g.dart` files and `lib/assetsgen/` (`WayaAssets`).

Run the repo helper, or the equivalent manual command:

```bash
# macOS / Linux:
chmod +x helpers/build.sh helpers/run_dev.sh helpers/run_prod.sh
./helpers/build.sh

# Windows:
.\helpers\build.bat

# Manual equivalent (any OS):
fvm dart run build_runner build --delete-conflicting-outputs
```

Re-run this every time you:

- add/edit `*.dart` files using `@JsonSerializable()` / `@riverpod`,
- add/remove assets under `assets/` (regenerates `lib/assetsgen/`),
- pull changes that touch generated files.

Optional watch mode during development:

```bash
fvm dart run build_runner watch --delete-conflicting-outputs
```

### 5. Run the app

The app has dev/prod entry behavior controlled by `--dart-define` flags in `helpers/run_dev.sh` and `helpers/run_prod.sh` (both target `lib/main.dart`):

```bash
# Development (APP_NAME="Wayagram Dev", BUNDLE_ID=ng.wayagram.dev):
./helpers/run_dev.sh

# Production (APP_NAME="Wayagram", BUNDLE_ID=ng.wayagram):
./helpers/run_prod.sh
```

Manual equivalents (use when you need to pick a device with `-d`):

```bash
# List devices:
fvm flutter devices

# Dev:
fvm flutter run -d <device-id> \
  --dart-define=ENVIRONMENT=development \
  --dart-define=API_BASE_URL=https://services.wayagram.ng/ \
  --dart-define=APP_NAME="Wayagram Dev" \
  --dart-define=BUNDLE_ID=ng.wayagram.dev \
  --dart-define=APP_WEB_URL=https://wayagram.ng/ \
  --dart-define=FIREBASE_ANDROID_APP_ID=1:276195200870:android:86d92470ee9355f58b42a7 \
  --dart-define=FIREBASE_IOS_APP_ID=1:276195200870:ios:9618ca822e5d47d48b42a7

# Prod: same, but with ENVIRONMENT=production, APP_NAME="Wayagram",
# BUNDLE_ID=ng.wayagram and the prod Firebase app IDs from helpers/run_prod.sh
```

### 6. Build for release

Make sure step 4 (codegen) is done first, then:

```bash
# Android App Bundle (as in release.yaml):
fvm flutter build appbundle --release

# Android APK (for sideloading/testing):
fvm flutter build apk --release

# iOS (macOS only, as in release.yaml):
fvm flutter build ios --release
# or, for distribution:
fvm flutter build ipa --release
```

Outputs: `build/app/outputs/bundle/release/app-release.aab` (Android), `build/ios/` (iOS).

### 7. Verify your setup

CI runs these on every PR to `production` / `pre-prod` / `restructed_wayagram` / `collab`:

```bash
fvm dart analyze --no-fatal-warnings .
fvm flutter test
```

### Troubleshooting

- **Wrong Flutter version:** re-run `fvm use 3.27.2` from the repo root and use `fvm flutter` / `fvm dart` everywhere.
- **Stale/conflicting `*.g.dart`:** re-run with `--delete-conflicting-outputs` (the helper scripts already do this).
- **`flutter_native_splash` / launcher icons out of date:** regenerate only when `flutter_native_splash.yaml` or `flutter_launcher_icons` in `pubspec.yaml` changes.
- **iOS build fails on pods:** `cd ios && pod repo update && pod install && cd ..`.
- **Android build fails on Java:** ensure Java 17 is active (`java -version`).
