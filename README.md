# hassmic-screen

A screen app for an Amazon Echo Show running [hassmic](https://github.com/Nt-f/echo-dot-assist), in Flutter: what
the Echo Show's screen shows when it is not hassmic's (the clock, a request's words, a ringing alarm stay hassmic's).

This is the template. It does what hassmic's built-in Java kiosk does, so that you can start from something that
works and make it yours:

- the screens Home Assistant's hassmic integration lists (Home Assistant's dashboards, Music Assistant, any page) in
  a WebView, logged into Home Assistant with the Echo's own token (no typing: the integration made a user for it)
- a handle at the top edge: tap it for the screens and a reload
- back to the start screen after the time the integration says, untouched
- an on-screen keyboard (the Echo has no input method): it comes up when a text field in the page has the focus and
  types with real key events (`MainActivity.kt`)

The contract with hassmic (how the app is started, where its config comes from, what it tells hassmic) is in
echo-dot-assist's [docs/screen-apps.md](https://github.com/Nt-f/echo-dot-assist/blob/main/docs/screen-apps.md);
`lib/hassmic.dart` is this app's side of it. The config also carries Home Assistant's address and a token for its
websocket API, for screens drawn in Flutter instead of a WebView.

## Build

Flutter 3.41.2 (the Echo Show 5 is Android 7.1, 32-bit ARM, a Mali-T720 GPU without Vulkan: Flutter draws with Skia on
OpenGL ES there, at 60 fps; keep full-screen live blurs out, they cost half of that).

```sh
flutter build apk --release --target-platform android-arm
```

Release builds are signed with Flutter's debug key unless you set up your own
([Flutter's docs](https://docs.flutter.dev/deployment/android#sign-the-app)); an update must be signed with the same
key as the installed app. CI builds the APK on every push and attaches it to a release for each `v*` tag.

## Install

```sh
adb install build/app/outputs/flutter-apk/app-release.apk
```

Then in Home Assistant: Settings › Devices & services › hassmic › Configure on the Echo Show, "Screen app":
`org.hassmic.screen` (your fork: its `applicationId`). Empty brings hassmic's own kiosk back. hassmic starts the app
by the intent `org.hassmic.action.SCREEN` and hands its config to that app alone.

## Make it yours

Fork it, change `applicationId` in `android/app/build.gradle.kts`, and replace the WebView in `lib/main.dart` with
your own screens. Measured on an Echo Show 5: this app with Home Assistant in its WebView takes 81 MB; the whole
Echo has 1 GB for Android, hassmic and the screen.

MIT licence.
