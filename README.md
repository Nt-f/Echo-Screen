# Echo-Screen

A screen app for an Amazon Echo Show running [hassmic](https://github.com/Nt-f/echo-dot-assist), in Flutter: what
the Echo Show's screen shows: a clock to start on, a request's words, a ringing alarm, and Home Assistant's pages.

This is the template. It does what hassmic's built-in Java kiosk does, so that you can start from something that
works and make it yours:

- the screens Home Assistant's Echo Local integration lists (Home Assistant's dashboards, Music Assistant, any page) in
  a WebView, logged into Home Assistant with the Echo's own token (no typing: the integration made a user for it)
- the screens in hassmic's own bar (pulled down from the top edge over any app, with the apps you installed): it
  starts this app with the screen picked, which the app shows (`MainActivity.kt` `onNewIntent`, the extras `screen` and
  `home`); no bar of the app's own
- back to the start screen after the time the integration says, untouched
- an on-screen keyboard (the Echo has no input method): it comes up when a text field in the page has the focus and
  types with real key events (`MainActivity.kt`); on a device with a keyboard of its own, that one comes instead
- round screens (Echo Spot): the keyboard kept inside the circle
- hassmic's own pictures in the app's look (it polls `/front/draws`, so hassmic leaves the screen to it): the clock as
  a screen ("Clock" in the integration's options), a request's words, an alarm or timer ringing, from hassmic's state
  feed (`/kiosk/state`, a long poll: words appear as hassmic has them); taps on a ring still reach hassmic

The contract with hassmic (how the app is started, where its config comes from, what it tells hassmic) is in
echo-dot-assist's [docs/screen-apps.md](https://github.com/Nt-f/echo-dot-assist/blob/main/docs/screen-apps.md);
`lib/hassmic.dart` is this app's side of it. The config also carries Home Assistant's address and a token for its
websocket API, for screens drawn in Flutter instead of a WebView.

## On other Echo screens

What the template draws itself, at each display Echo's resolution and density in an Android emulator
(`tools/screenshots.py`): the clock (the `hassmic:clock` screen, the one an Echo starts on), a request's words over
it as they come in, an alarm ringing (`/kiosk/state`). Only the Echo Show 5 has run it for real so far; the emulator
shows layout, not speed. On a round screen (Android's `isScreenRound`) everything is kept inside the circle. The Echo
Dots with a clock have LED segments, no screen for this.

| Model | Screen | dpi | Clock | Request | Alarm |
|---|---|---|---|---|---|
| Echo Show 5 (all three) | 960 × 480 | 160 (measured) | <img src="docs/screenshots/show5-clock.png" width="220"> | <img src="docs/screenshots/show5-request.png" width="220"> | <img src="docs/screenshots/show5-alarm.png" width="220"> |
| Echo Show 8 (1st–3rd gen), Show 10, Echo Hub | 1280 × 800 | 213 (measured, 1st gen) | <img src="docs/screenshots/show8-clock.png" width="220"> | <img src="docs/screenshots/show8-request.png" width="220"> | <img src="docs/screenshots/show8-alarm.png" width="220"> |
| Echo Show 8 (2025) | 1340 × 800 | 213 (estimated) | <img src="docs/screenshots/show8-2025-clock.png" width="220"> | <img src="docs/screenshots/show8-2025-request.png" width="220"> | <img src="docs/screenshots/show8-2025-alarm.png" width="220"> |
| Echo Show 11 (2025) | 1920 × 1200 | 240 (estimated) | <img src="docs/screenshots/show11-clock.png" width="220"> | <img src="docs/screenshots/show11-request.png" width="220"> | <img src="docs/screenshots/show11-alarm.png" width="220"> |
| Echo Show 15 / 21 | 1920 × 1080 | 160 (estimated) | <img src="docs/screenshots/show15-clock.png" width="220"> | <img src="docs/screenshots/show15-request.png" width="220"> | <img src="docs/screenshots/show15-alarm.png" width="220"> |
| Echo Show 15, hung upright | 1080 × 1920 | 160 (estimated) | <img src="docs/screenshots/show15-portrait-clock.png" width="220"> | <img src="docs/screenshots/show15-portrait-request.png" width="220"> | <img src="docs/screenshots/show15-portrait-alarm.png" width="220"> |
| Echo Show (1st gen) | 1024 × 600 | 160 (estimated) | <img src="docs/screenshots/show1-clock.png" width="220"> | <img src="docs/screenshots/show1-request.png" width="220"> | <img src="docs/screenshots/show1-alarm.png" width="220"> |
| Echo Spot (1st gen), round | 480 × 480 | 240 (estimated) | <img src="docs/screenshots/spot-clock.png" width="220"> | <img src="docs/screenshots/spot-request.png" width="220"> | <img src="docs/screenshots/spot-alarm.png" width="220"> |
| Echo Spot (2024) | 320 × 240 | 120 (estimated) | <img src="docs/screenshots/spot2024-clock.png" width="220"> | <img src="docs/screenshots/spot2024-request.png" width="220"> | <img src="docs/screenshots/spot2024-alarm.png" width="220"> |

<details><summary>Over Home Assistant's own pages: the switcher and the keyboard</summary>

A tap on the clock fades into the screens the integration lists (the demo integration's made-up home here). The page
itself is Home Assistant's; the template's part is the keyboard on a sign-in page (the screenshots of the switcher
show the template's own bar of before: hassmic's shell has the bar now). On a round screen the keyboard's rows follow
the circle.

| Model | Switcher | Keyboard |
|---|---|---|
| Echo Show 5 (all three) | <img src="docs/screenshots/show5-switcher.png" width="220"> | <img src="docs/screenshots/show5-keyboard.png" width="220"> |
| Echo Show 8 (1st–3rd gen), Show 10, Echo Hub | <img src="docs/screenshots/show8-switcher.png" width="220"> | <img src="docs/screenshots/show8-keyboard.png" width="220"> |
| Echo Show 8 (2025) | <img src="docs/screenshots/show8-2025-switcher.png" width="220"> | <img src="docs/screenshots/show8-2025-keyboard.png" width="220"> |
| Echo Show 11 (2025) | <img src="docs/screenshots/show11-switcher.png" width="220"> | <img src="docs/screenshots/show11-keyboard.png" width="220"> |
| Echo Show 15 / 21 | <img src="docs/screenshots/show15-switcher.png" width="220"> | <img src="docs/screenshots/show15-keyboard.png" width="220"> |
| Echo Show 15, hung upright | <img src="docs/screenshots/show15-portrait-switcher.png" width="220"> | <img src="docs/screenshots/show15-portrait-keyboard.png" width="220"> |
| Echo Show (1st gen) | <img src="docs/screenshots/show1-switcher.png" width="220"> | <img src="docs/screenshots/show1-keyboard.png" width="220"> |
| Echo Spot (1st gen), round | <img src="docs/screenshots/spot-switcher.png" width="220"> | <img src="docs/screenshots/spot-keyboard.png" width="220"> |
| Echo Spot (2024) | <img src="docs/screenshots/spot2024-switcher.png" width="220"> | <img src="docs/screenshots/spot2024-keyboard.png" width="220"> |

</details>

Again: `flutter build apk --release --target-platform android-x64`, start an emulator, then
`python3 tools/screenshots.py --serial emulator-5554` (its header says what it needs).

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

Then in Home Assistant: Settings › Devices & services › Echo Local › Configure on the Echo Show, "Screen app":
`io.github.nt_f.echoscreen` (your fork: its `applicationId`). Empty brings hassmic's own kiosk back. hassmic starts the app
by the intent `io.github.gamer92000.echodotassist.action.SCREEN` and hands its config to that app alone.

## Make it yours

Fork it, change `applicationId` in `android/app/build.gradle.kts`, and replace the WebView in `lib/main.dart` with
your own screens. Measured on an Echo Show 5: this app with Home Assistant in its WebView takes 81 MB; the whole
Echo has 1 GB for Android, hassmic and the screen.

MIT licence.
