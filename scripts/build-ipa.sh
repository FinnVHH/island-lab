#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."

xcodegen generate
xcodebuild \
  -project IslandLab.xcodeproj \
  -scheme IslandLab \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -derivedDataPath build/DerivedData \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY='' \
  build

APP='build/DerivedData/Build/Products/Release-iphoneos/IslandLab.app'
EXTENSION="$APP/PlugIns/IslandLabActivity.appex"
test -f "$APP/IslandLab"
test -f "$EXTENSION/IslandLabActivity"
xcrun lipo -verify_arch arm64 "$APP/IslandLab"
xcrun lipo -verify_arch arm64 "$EXTENSION/IslandLabActivity"
/usr/libexec/PlistBuddy -c 'Print :NSSupportsLiveActivities' "$APP/Info.plist" | /usr/bin/grep -qx true
/usr/libexec/PlistBuddy -c 'Print :NSExtension:NSExtensionPointIdentifier' "$EXTENSION/Info.plist" | /usr/bin/grep -qx com.apple.widgetkit-extension

mkdir -p build/package/Payload
ditto "$APP" build/package/Payload/IslandLab.app
(cd build/package && ditto -c -k --keepParent Payload ../IslandLab-unsigned.ipa)
unzip -t build/IslandLab-unsigned.ipa
echo 'Ready: build/IslandLab-unsigned.ipa (sign with Sideloadly before installing)'
