# FieldSnap

FieldSnap is a Flutter app for capturing photos and auto-filling Indonesian
location details (province, regency, district, village, postal) using device
GPS and reverse geocoding. It also includes a users list demo with pagination.

## Features

- Location auto-fill with hierarchical region selection
- Camera capture flow with retake/delete
- Users list with pagination (limit/skip)
- Custom theming and reusable UI components

## Architecture

The project uses a layered structure:

- Presentation: controllers and widgets (GetX)
- Domain: entities and use cases
- Data: repositories and datasources

### Key Modules

- `features/location`: location autocomplete + dropdown selections
- `features/camera`: camera capture flow
- `features/users`: users list + paging
- `features/home`: simple navigation hub

## Project Structure

```
lib/
  core/
    config/        # env access
    enums/         # shared enums
    routes/        # GetX routes
    services/      # API service (Dio)
    theme/         # colors, text styles, theme
    utils/         # helpers, constants
  features/
    camera/
    home/
    location/
    users/
  presentation/
    widgets/       # shared UI widgets
```

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

## App Name

The app name shown on device is "FieldSnap".

- Android: `android/app/src/main/AndroidManifest.xml`
- iOS: `ios/Runner/Info.plist`

## Permissions

The app requests:

- Camera (capture photos)
- Location (auto-fill address)

## Environment Variables

`.env` supports:

- `API_KEY` for the location API (if enabled)

## API Notes

- Users endpoint: `https://dummyapi.io/data/v1/user`
- Location endpoints: `https://use.api.co.id/regional/indonesia/*`
- Postal API: `https://carikodepos.id/api/postal-codes`

## Testing

Run all tests:

```bash
flutter test
```

Run with coverage:

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

Coverage snapshot (from `coverage/html/index.html` on 2026-01-21):

- Lines: 453 / 965 (46.9%)
- Functions: 0 / 0 (n/a)
- Lowest coverage areas: `core/theme`, `presentation/widgets`, and `features/*/presentation/pages`

## Troubleshooting

- If location auto-fill is inaccurate, check GPS accuracy and network.
- If mock location is used on Android, ensure the mock app is selected in
  Developer Options and `AndroidSettings(forceLocationManager: true)` is used.
