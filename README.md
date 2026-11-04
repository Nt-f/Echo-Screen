# Echo-Screen

**The smallest home app for an Echo Show running [echo-dot-assist](https://github.com/Nt-f/echo-dot-assist): fork it
and make the screen yours.**

A Flutter app that already does everything the Echo asks of a home app, so you can start from something that works:
Home Assistant's pages logged in with no typing, the screen picked in the Echo's drawer, a request's words and a
ringing alarm in your own look. [Echo-Wall](https://github.com/Nt-f/Echo-Wall) grew out of it.

<img src="docs/screenshots/show5-clock.png" width="32%"> <img src="docs/screenshots/show5-request.png" width="32%"> <img src="docs/screenshots/show5-alarm.png" width="32%">

## What it does

|                              |                                                                                  |
|------------------------------|----------------------------------------------------------------------------------|
| **Home Assistant's pages**   | the screens Echo Local lists (dashboards, Music Assistant, any page) in a WebView, logged in with the Echo's own token |
| **The Echo's drawer**        | opens the screen picked there (the SCREEN intent's `screen` and `home` extras: `MainActivity.kt` `onNewIntent`) |
| **Back to the start**        | after the time Echo Local says, untouched                                        |
| **Its own look for the Echo's moments** | the clock as a screen, a request's words as they come, a ringing alarm (tap snoozes, hold stops) |
| **A keyboard**               | for the pages' text fields (the Echo has none): real key events, kept inside the circle on a round screen |

The contract with the Echo (how it starts the app, where the config comes from, what the app claims) is
echo-dot-assist's [docs/screen-apps.md](https://github.com/Nt-f/echo-dot-assist/blob/main/docs/screen-apps.md);
`lib/hassmic.dart` is this app's side of it. The config also carries Home Assistant's address and a token for its
websocket API, for screens drawn in Flutter instead of a WebView.

## Make it yours

Fork it, change `applicationId` in `android/app/build.gradle.kts`, and replace the WebView in `lib/main.dart` with
your own screens. Keep it light: on an Echo Show 5 this app with Home Assistant in its WebView takes 81 MB of the 1 GB
Android, hassmic and the screen share, and its Mali-T720 (no Vulkan) runs Flutter on OpenGL ES at 60 fps until a
full-screen live blur halves that.

## Build and install

```sh
flutter build apk --release --target-platform android-arm     # Flutter 3.41.2
```

Install it from the Echo's settings page (Screen › Add an app) or Echo Local's Apps tab (or `adb install`), then make
it the home app there or in Echo Local › Screen › Home app (`io.github.nt_f.echoscreen`, or your fork's
`applicationId`). Release builds are signed with Flutter's debug key unless you set up your own
([Flutter's docs](https://docs.flutter.dev/deployment/android#sign-the-app)); an update must be signed with the same
key. CI builds the APK on every push and attaches it to a release for each `v*` tag.

<details><summary>On every Echo screen (emulator): the clock, a request, an alarm</summary>

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

</details>

<details><summary>Over Home Assistant's own pages, and the keyboard</summary>

| Model | Home Assistant's pages | Keyboard |
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

MIT licence.
