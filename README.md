# FieldSnap

FieldSnap is a Flutter app for capturing photos and auto-filling location
details (province, regency, district, village, postal) using device GPS and
reverse geocoding. It also includes a simple users list demo.

## Features

- Location auto-fill with hierarchical region selection
- Camera capture flow with retake/delete
- Users list with pagination
- Custom theming and UI components

## Requirements

- Flutter SDK 3.9+
- Android Studio / Xcode (for platform builds)

## Setup

1) Install dependencies:

```bash
flutter pub get
```

2) Create `.env` (if needed by APIs):

```bash
API_KEY=your_key_here
```

3) Run the app:

```bash
flutter run
```

## Icons and Splash

- App icon source: `assets/logo.png`
- Splash source: `assets/logo-with-text.png`

Regenerate assets:

```bash
flutter pub run flutter_launcher_icons
flutter pub run flutter_native_splash
```

## Tests and Coverage

```bash
flutter test --coverage
```

Generate HTML report (Windows):

```powershell
& "C:\ProgramData\chocolatey\lib\lcov\tools\bin\genhtml" coverage/lcov.info -o coverage/html
```

Open the report:

```powershell
& "$env:ProgramFiles(x86)\Microsoft\Edge\Application\msedge.exe" "coverage/html/index.html"
```
