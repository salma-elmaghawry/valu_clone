# Sprint 1 Report — No Wait

Sprint 1 (Jira epic **KAN-1**) covered the app rebrand plus the full auth flow: project setup, Splash, Intro, Login, and Register — extended with Forgot Password and session persistence. All tasks (KAN-6 → KAN-10) are implemented and moved to **In Review** on the board.

---

## 1. Rebrand: valU clone → No Wait

### Package & identifiers

| Platform | Change |
|---|---|
| Dart | pubspec `name: valu_clone` → `no_wait`, all imports updated |
| Android | namespace + applicationId `com.example.no_wait`, `android:label="No Wait"`, `MainActivity.kt` moved to the new package path |
| iOS | `CFBundleDisplayName` = "No Wait", bundle id `com.example.noWait` |
| macOS | `PRODUCT_NAME = no_wait`, bundle id `com.example.noWait` |
| Web | manifest name/short_name + `<title>` = "No Wait" |
| Windows / Linux | binary name, window title, resource strings |

The app widget class was renamed `ValuApp` → `NoWaitApp`.

### Logo & launcher icons

Brand assets live in `assets/images/logo/`:

| Asset | Purpose |
|---|---|
| `logo-compact.png` | Colored "no wait" wordmark — app header, splash, intro, auth screens (`AppAssets.logo`) |
| `nw_mark.png` | White "nw" arrow mark, trimmed of padding — BNPL card, promo banner, bottom nav (`AppAssets.logoMark`) |
| `app_icon.png` | 1024×1024 white mark on brand orange `#FF5100` — iOS/legacy Android/web icon |
| `app_icon_foreground.png` | Transparent foreground for Android adaptive icons |

Launcher icons for Android (adaptive), iOS, and web are generated with `flutter_launcher_icons` (config in `pubspec.yaml`). Regenerate after any logo change:

```bash
dart run flutter_launcher_icons
```

All old valU logo references in the home screen widgets were replaced with the new assets. Theme colors already matched the No Wait palette (primary orange `#FF5100`, teal `#00C4B3`, near-black `#1D1F1F`) so `AppColors` needed no changes. Translations now use "No Wait" / "نو وايت".

---

## 2. Auth feature

### Flow

```
Splash ──(2.4s)──► logged in? ──yes──► Home
                        │no
                        ▼
                      Intro ──► Login ◄──► Register
                                  │
                                  ▼
                          Forgot Password
```

- **Splash** — animated wordmark + tagline; routes to Home if a session is cached, otherwise Intro.
- **Intro** — dark hero panel with the wordmark (scale-in entrance, then looping pulse + shimmer), Log in / Create account buttons.
- **Login** — email + password with validation, loading button, error snackbars, "Forgot password?" link, demo-account hint card, link to Register.
- **Register** — name, email, password, confirm password; auto-logs-in on success.
- **Forgot Password** — email input; verifies the account exists and confirms with a success snackbar.

### Demo account

The backend is not integrated yet, so auth runs against an in-memory demo backend:

> **Email:** `demo@nowait.com` — **Password:** `123456`

Wrong credentials return the localized "invalid credentials" error. Registered accounts persist for the app session; the logged-in user persists across restarts (SharedPreferences).

### Architecture (API-ready)

```
features/auth/
├── data/
│   ├── datasource/
│   │   ├── auth_remote_datasource.dart        # contract: login / register / forgotPassword
│   │   ├── auth_remote_datasource_impl.dart   # in-memory demo backend (replace with real API)
│   │   └── auth_local_datasource.dart         # session cache (SharedPreferences)
│   └── models/user_model.dart                 # fromJson / toJson / toEntity
├── domain/entities/app_user.dart
├── repository/
│   ├── auth_repository.dart                   # Either<Failure, T> + isLoggedIn / currentUser / logout
│   └── auth_repository_impl.dart              # try/catch → ErrorMapper, caches session
└── presentation/
    ├── cubit/  auth_cubit.dart, auth_state.dart   # AuthAction { login, register, forgotPassword }
    ├── screens/  splash, intro, login, register, forgot_password
    └── widgets/  auth_header.dart
```

Supporting pieces:

- `core/error_handling/app_exceptions.dart` — `InvalidCredentialsException`, `EmailAlreadyInUseException`, `UserNotFoundException`, mapped to localized `Failure`s in `ErrorMapper` (`UserNotFoundFailure` added).
- `core/widgets/app_text_field.dart` — shared labeled text field with password visibility toggle, theme-aware in light/dark, RTL-safe.
- DI registrations in `injection_container.dart`; routes `/splash`, `/intro`, `/login`, `/sign-up`, `/forgot-password` in `Routes` + `AppRouter` (each auth screen gets its own `AuthCubit` via `BlocProvider`).
- All new strings added to both `en.json` and `ar.json`.

### Integrating the real API later

1. Implement `AuthRemoteDataSource` with the real client (Dio/Supabase/etc.) — **only `auth_remote_datasource_impl.dart` changes**.
2. Map API error codes to the exceptions in `app_exceptions.dart`.
3. Extend `UserModel.fromJson` if the API returns more fields.

Repository, cubit, screens, routing, and error handling all stay as-is.

---

## 3. Verification

- `flutter analyze` — no issues.
- `flutter build apk --debug` — builds successfully.
- Manual flow: splash → intro → login with demo account → home; wrong password shows localized error; register → home; forgot password with demo email → success snackbar; session persists across restart.

## 4. Board status

| Issue | Summary | Status |
|---|---|---|
| KAN-1 | Sprint 1 epic — Auth flow | In Progress |
| KAN-6 | Project setup | In Review |
| KAN-7 | Splash screen | In Review |
| KAN-8 | Intro screen | In Review |
| KAN-9 | Login screen | In Review |
| KAN-10 | Register screen | In Review |

Next up (Sprint 2, KAN-2): Stores, Shop'IT, Products, and Product details screens — the Home screen UI already exists.
