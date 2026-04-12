# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Analyze/lint
flutter analyze

# Run tests
flutter test

# Run a single test file
flutter test test/path/to/test_file.dart

# Clean build
flutter clean && flutter pub get

# iOS pod setup (after flutter pub get)
cd ios && pod install
```

## Architecture

This is a Flutter salon/stylist business management app using **GetX** for state management, routing, and dependency injection.

### Patterns

**State Management (GetX MVC)**
- Controllers extend `GetxController` with reactive `.obs` variables
- Controllers are registered globally in `main.dart` via `Get.put()`
- Three primary controllers: `AuthController`, `HomeController`, `StylistController`
- Use `Obx()` widgets for reactive UI rebuilds

**API Layer (`lib/api/`)**
- `DioClient` is a singleton HTTP client with a base URL from `APIConstants`
- `DioInterceptors` handles auth token injection, 401/403 refresh-token flow with retry, and connectivity-based retries
- Separate API classes per domain: `AuthAPI`, `HomeAPI`, `StylistHomeAPI`, `MasterAPI`
- Response success is checked via `DioResponseExtension.isSuccess` (extension in `lib/util/extensions.dart`)

**Models (`lib/model/`)**
- Manual JSON serialization: `fromJson()` / `toJson()` / `copyWith()` — no code generation
- Organized in domain subdirectories (auth, service, stylist, etc.)

**Navigation**
- Named GetX routes; initial route `"/"` → `SplashPage`
- Two distinct bottom-bar flows: one for Salon owners, one for Stylists/Artists
- Role determined post-login from `AuthController`

**Storage**
- `SharedPrefs` utility wraps GetStorage (persistent) and SharedPreferences
- Keys defined in `PrefConstants` (auth token, FCM token, device ID, etc.)

**Notifications**
- Firebase Messaging (FCM) for push notifications
- `flutter_local_notifications` for foreground/local display
- Two notification channels: `booking` (with sound) and `general` (silent)
- `NotificationUtils` delegates all message routing logic

### Key Files

| File | Purpose |
|------|---------|
| `lib/main.dart` | App init: Firebase, controllers, FCM, permissions, orientation |
| `lib/api/dio_interceptors.dart` | Token refresh and retry logic |
| `lib/constant/api_constant.dart` | Base URL and endpoint constants |
| `lib/constant/pref_constant.dart` | Storage key constants |
| `lib/util/shared_prefs.dart` | Typed storage wrapper |
| `lib/util/extensions.dart` | `DioResponseExtension` for response validation |
| `lib/util/notification_utils.dart` | FCM message handling and routing |
| `lib/project_specific/` | Shared custom widgets (AppBar, TextField, Button, etc.) |

### Firebase

- Staging project ID: `scuts-3ede2`
- Android credentials hardcoded in `main.dart` (lines 70–73)
- iOS credentials come from `ios/GoogleService-Info.plist`
