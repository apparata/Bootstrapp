#!/usr/bin/env bash
set -euo pipefail

# ── Constants ────────────────────────────────────────────────────────────────
SCHEME="Bootstrapp"
APP_NAME="Bootstrapp"
KEYCHAIN_PROFILE="notary"
SPARKLE_VERSION="2.9.0"
GITHUB_REPO="apparata/Bootstrapp"

# ── Paths ────────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$PROJECT_DIR/build"
SPARKLE_TOOLS_DIR="$BUILD_DIR/Sparkle-tools"
ARCHIVE_PATH="$BUILD_DIR/$APP_NAME.xcarchive"
EXPORT_DIR="$BUILD_DIR/export"
EXPORT_OPTIONS="$SCRIPT_DIR/ExportOptions.plist"

# ── Clean build directory ────────────────────────────────────────────────────
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# ── Download Sparkle tools if needed ─────────────────────────────────────────
if [ ! -x "$SPARKLE_TOOLS_DIR/bin/sign_update" ]; then
    echo "▸ Downloading Sparkle tools ${SPARKLE_VERSION}..."
    curl -sL "https://github.com/sparkle-project/Sparkle/releases/download/$SPARKLE_VERSION/Sparkle-$SPARKLE_VERSION.tar.xz" \
        -o "$BUILD_DIR/Sparkle.tar.xz"
    mkdir -p "$SPARKLE_TOOLS_DIR"
    tar -xf "$BUILD_DIR/Sparkle.tar.xz" -C "$SPARKLE_TOOLS_DIR"
    rm "$BUILD_DIR/Sparkle.tar.xz"
    echo "  ✓ Sparkle tools ready"
fi

# ── Version check against latest GitHub release ─────────────────────────────
CURRENT_VERSION=$(xcodebuild -project "$PROJECT_DIR/Bootstrapp.xcodeproj" \
    -scheme "$SCHEME" -showBuildSettings 2>/dev/null \
    | grep 'MARKETING_VERSION' | head -1 | awk '{print $NF}')

echo "▸ Current project version: $CURRENT_VERSION"

LATEST_TAG=$(gh release view --repo "$GITHUB_REPO" --json tagName -q '.tagName' 2>/dev/null || echo "")

if [ -n "$LATEST_TAG" ]; then
    echo "  Latest GitHub release: $LATEST_TAG"
fi

version_gt() {
    [ "$(printf '%s\n' "$1" "$2" | sort -V | tail -1)" = "$1" ] && [ "$1" != "$2" ]
}

if [ -z "$LATEST_TAG" ] || version_gt "$CURRENT_VERSION" "$LATEST_TAG"; then
    echo "  Version $CURRENT_VERSION is newer than latest release."
    read -rp "  Use version $CURRENT_VERSION? [Y/n] " USE_CURRENT
    if [[ "${USE_CURRENT:-Y}" =~ ^[Nn] ]]; then
        read -rp "  Enter new version: " NEW_VERSION
    else
        NEW_VERSION="$CURRENT_VERSION"
    fi
else
    echo "  ⚠ Version $CURRENT_VERSION is not newer than $LATEST_TAG"
    read -rp "  Enter new version: " NEW_VERSION
fi

if [ "$NEW_VERSION" != "$CURRENT_VERSION" ]; then
    if ! version_gt "$NEW_VERSION" "${LATEST_TAG:-0.0.0}"; then
        echo "  ✗ Version $NEW_VERSION is not newer than $LATEST_TAG"
        exit 1
    fi
    echo "  Updating version to $NEW_VERSION..."
    PBXPROJ="$PROJECT_DIR/Bootstrapp.xcodeproj/project.pbxproj"
    sed -i '' "s/MARKETING_VERSION = $CURRENT_VERSION;/MARKETING_VERSION = $NEW_VERSION;/g" "$PBXPROJ"
    sed -i '' "s/CURRENT_PROJECT_VERSION = [0-9]*;/CURRENT_PROJECT_VERSION = $NEW_VERSION;/g" "$PBXPROJ"
    cd "$PROJECT_DIR"
    git add "$PBXPROJ"
    git commit -m "Bump version to $NEW_VERSION"
    git push origin HEAD
    cd "$SCRIPT_DIR"
    VERSION="$NEW_VERSION"
else
    VERSION="$CURRENT_VERSION"
fi

echo "▸ Building version $VERSION"

# ── Archive ──────────────────────────────────────────────────────────────────
echo "▸ Archiving..."
xcodebuild archive \
    -project "$PROJECT_DIR/Bootstrapp.xcodeproj" \
    -scheme "$SCHEME" \
    -archivePath "$ARCHIVE_PATH" \
    -configuration Release \
    -arch arm64 \
    ENABLE_HARDENED_RUNTIME=YES \
    | tail -1

echo "  ✓ Archive complete"

# ── Export ───────────────────────────────────────────────────────────────────
echo "▸ Exporting..."
xcodebuild -exportArchive \
    -archivePath "$ARCHIVE_PATH" \
    -exportPath "$EXPORT_DIR" \
    -exportOptionsPlist "$EXPORT_OPTIONS" \
    | tail -1

APP_PATH="$EXPORT_DIR/$APP_NAME.app"
EXPORTED_VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$APP_PATH/Contents/Info.plist")
echo "  ✓ Exported $APP_NAME.app ($EXPORTED_VERSION)"

# ── Create DMG ───────────────────────────────────────────────────────────────
DMG_NAME="${APP_NAME}-${VERSION}.dmg"
DMG_PATH="$BUILD_DIR/$DMG_NAME"
DMG_STAGING="$BUILD_DIR/dmg-staging"

echo "▸ Creating DMG..."
mkdir -p "$DMG_STAGING"
cp -a "$APP_PATH" "$DMG_STAGING/"
ln -s /Applications "$DMG_STAGING/Applications"
hdiutil create -volname "$APP_NAME" -srcfolder "$DMG_STAGING" -ov -format UDZO "$DMG_PATH" > /dev/null
rm -rf "$DMG_STAGING"
echo "  ✓ $DMG_NAME"

# ── Verify codesign ─────────────────────────────────────────────────────────
echo "▸ Verifying codesign..."
codesign --verify --deep --strict "$APP_PATH"
echo "  ✓ Codesign valid"

# ── Notarize ─────────────────────────────────────────────────────────────────
echo "▸ Submitting for notarization..."
xcrun notarytool submit "$DMG_PATH" \
    --keychain-profile "$KEYCHAIN_PROFILE" \
    --wait

echo "▸ Stapling..."
xcrun stapler staple "$DMG_PATH"
echo "  ✓ Notarized and stapled"

# ── Sign for Sparkle ─────────────────────────────────────────────────────────
echo "▸ Signing for Sparkle..."
SPARKLE_SIG=$("$SPARKLE_TOOLS_DIR/bin/sign_update" "$DMG_PATH")
echo "  Sparkle signature: $SPARKLE_SIG"

# ── Create GitHub release ────────────────────────────────────────────────────
TAG="$VERSION"

read -rp "▸ Release title (default: $APP_NAME $VERSION): " RELEASE_TITLE
RELEASE_TITLE="${RELEASE_TITLE:-$APP_NAME $VERSION}"

read -rp "  Release subtitle (optional): " RELEASE_SUBTITLE
if [ -n "$RELEASE_SUBTITLE" ]; then
    RELEASE_TITLE="$RELEASE_TITLE — $RELEASE_SUBTITLE"
fi

echo "▸ Creating GitHub release $TAG..."
cd "$PROJECT_DIR"
git tag "$TAG"
git push origin "$TAG"

gh release create "$TAG" "$DMG_PATH" \
    --repo "$GITHUB_REPO" \
    --title "$RELEASE_TITLE" \
    --generate-notes

echo "  ✓ Release created"

# ── Generate appcast ─────────────────────────────────────────────────────────
echo "▸ Generating appcast..."
APPCAST_DIR="$BUILD_DIR/appcast-assets"
mkdir -p "$APPCAST_DIR"

# Copy existing appcast so generate_appcast can append to it
if [ -f "$PROJECT_DIR/appcast.xml" ]; then
    cp "$PROJECT_DIR/appcast.xml" "$APPCAST_DIR/"
fi

# Only include the new DMG
cp "$DMG_PATH" "$APPCAST_DIR/"

"$SPARKLE_TOOLS_DIR/bin/generate_appcast" \
    --download-url-prefix "https://github.com/$GITHUB_REPO/releases/download/$TAG/" \
    -o "$APPCAST_DIR/appcast.xml" \
    "$APPCAST_DIR"

cp "$APPCAST_DIR/appcast.xml" "$PROJECT_DIR/appcast.xml"
git add appcast.xml
git commit -m "Update appcast for $VERSION"
git push origin HEAD

echo "  ✓ Appcast updated"

# ── Done ─────────────────────────────────────────────────────────────────────
echo ""
echo "═══════════════════════════════════════════════════"
echo "  ✓ $APP_NAME $VERSION released successfully!"
echo "═══════════════════════════════════════════════════"
