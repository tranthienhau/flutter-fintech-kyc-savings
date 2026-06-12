# Screenshot capture flow

Real captures from the iOS Simulator via an integration-test driver (no mockups).

## Steps

1. Boot the simulator:
   ```bash
   xcrun simctl boot "iPhone 17 Pro"
   open -a Simulator
   ```
2. Scaffold the iOS platform folder (lib-only project) and get dependencies:
   ```bash
   flutter create . --platforms=ios --project-name flutter_fintech_kyc_savings
   flutter pub get
   ```
3. Drive the screenshot test:
   ```bash
   flutter drive \
     --driver test_driver/integration_test.dart \
     --target integration_test/screenshot_test.dart \
     -d "iPhone 17 Pro"
   ```
4. Build the demo GIF from the PNGs:
   ```bash
   cd screenshots
   ffmpeg -y -framerate 1 -pattern_type glob -i '*.png' \
     -vf "scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
     -loop 0 demo.gif
   ```

PNGs + `demo.gif` are written to `screenshots/` and embedded in `README.md`.

## How it works

- `test_driver/integration_test.dart` - `integrationDriver(onScreenshot:)` writes each PNG to `screenshots/<name>.png`.
- `integration_test/screenshot_test.dart` - pumps the full `SavingsApp` (`MaterialApp.router` with Riverpod, no Firebase/network init). All providers seed real data by default (balance, points, badges, rules), so screens render populated content. The test:
  1. captures `01-dashboard` (balance card, points/streak/level stats, smart-savings nav tiles),
  2. taps the "Badges and streaks" tile and captures `02-badges` (badge grid + summary),
  3. goes back, taps "Smart rules" and captures `03-rules` (round-ups, payday %, activity, baby savings toggles),
  4. goes back, taps "Identity verification" and captures `04-kyc` (Onfido-style KYC flow).
- Navigation uses go_router `context.push` triggered by tapping the dashboard tiles, with `tester.pageBack()` to return between captures.
