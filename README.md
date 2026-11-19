# Island Lab

A small, fully editable native iPhone app for experimenting with Live Activities
and Dynamic Island. Built for iOS 17 or later, including iPhone 15 Pro Max.

Choose text, a symbol, a color, and progress. Tap **Start Live Activity**, leave
the app, and touch and hold the Dynamic Island. Lock your phone to see the card.
Change the controls and tap **Update Live Activity** to apply changes.
The preview updates immediately; the actual activity updates when you tap Update.

## Build from Windows without a paid Apple membership

This repository's GitHub Actions workflow builds an **unsigned physical-device**
IPA on a standard macOS runner. No Apple account, certificates, or secrets are
needed in GitHub. Standard hosted Actions runners are free for public repositories:
https://docs.github.com/en/actions/concepts/billing-and-usage

1. Open this repository's **Actions** tab and select **Build iPhone app**.
2. Open the latest successful run (or choose **Run workflow** to build again).
3. Under **Artifacts**, download **IslandLab-unsigned** and extract the ZIP.
4. Use the contained **IslandLab-unsigned.ipa** with Sideloadly on Windows.

The IPA cannot be installed directly: Sideloadly signs it using your free Apple
Account. Actual Live Activity extension signing and display must be tested on
your iPhone; a successful cloud build does not prove that device installation works.

## Install on your iPhone

1. Install Sideloadly from https://sideloadly.io/ and follow its Windows prerequisites
   for Apple's iTunes/iCloud components. Keep Apple credentials out of this repo
   and enter them only in the signing tool's own interface.
2. Connect your unlocked iPhone by USB. Accept **Trust This Computer** if prompted.
3. Select your iPhone and the IPA in Sideloadly. Sign in with your free Apple Account
   and start the installation. Preserve the bundled widget/Live Activity extension;
   do not choose an option that removes app extensions or PlugIns.
4. Follow any iPhone trust prompt under **Settings > General > VPN & Device Management**.
5. Enable **Settings > Privacy & Security > Developer Mode** if requested, restart,
   and confirm. This setting may appear only after the first installation attempt.
6. Open **Island Lab**, allow Live Activities if asked, then tap Start.

Free signing lasts seven days and permits at most three installed development
apps. The app and extension also use App IDs from the free account's weekly limit.
Use the same Apple Account and bundle identifiers for subsequent installs.
Sideloadly can refresh signing over USB or properly configured Wi-Fi when the PC
and phone can connect. See https://sideloadly.io/faq.html for current instructions.

## Scope and limits

- This test starts and updates from the foreground app. It does not use APNs,
  a server, App Groups, or background polling.
- Ordinary third-party Live Activities run for up to eight hours; their Lock Screen
  card may remain for up to four more hours. They are not permanent widgets.
- iOS chooses placement, size, and which activity is visible. Music, navigation,
  or another activity may share or take priority in the Island.
- The first build has no custom home-screen icon. This is a functional experiment.
- No jailbreak, TestFlight, or paid Apple Developer membership is used in this workflow.

## Customize the code

- `App/ContentView.swift`: editor and in-app preview.
- `App/ActivityController.swift`: start, update, stop, and error reporting.
- `Shared/IslandAttributes.swift`: shared data, color/icon choices, Lock Screen card.
- `LiveActivity/IslandLabActivity.swift`: compact, minimal, and expanded Island views.
- `project.yml`: app and widget extension configuration (generated with XcodeGen).

Commit and push changes to main to get a new IPA from Actions. Sideload the new
IPA with the same account to update the installed app.

On a Mac, install XcodeGen and run `bash scripts/build-ipa.sh`. The script compiles
both targets, checks arm64 binaries and extension metadata, and packages the IPA.

Apple reference: https://developer.apple.com/documentation/activitykit/displaying-live-data-with-live-activities
