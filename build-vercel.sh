#!/usr/bin/env bash
# Vercel build script for the admin web portal.
#
# Vercel's build boxes do NOT ship with Flutter, so we download the Flutter SDK
# matching the project's SDK constraint, add it to PATH, then build the web app
# for the admin target.
#
# Usage in vercel.json -> "buildCommand": "bash build-vercel.sh"
set -euo pipefail

# Pin a Flutter release channel/version for reproducible Vercel builds.
# 3.35.x satisfies the project's `sdk: ^3.11.5` constraint (Dart bundled).
FLUTTER_VERSION="${FLUTTER_VERSION:-3.35.5}"
FLUTTER_DIR="${HOME}/.flutter-sdk"

echo "▶ Installing Flutter ${FLUTTER_VERSION} (cached at ${FLUTTER_DIR})..."
if [ ! -d "${FLUTTER_DIR}/bin" ]; then
  git clone --depth 1 --branch "${FLUTTER_VERSION}" https://github.com/flutter/flutter.git "${FLUTTER_DIR}" 2>&1 | tail -5
fi

export PATH="${FLUTTER_DIR}/bin:${PATH}"

echo "▶ Flutter doctor:"
flutter --version

echo "▶ Resolving dependencies..."
flutter pub get

echo "▶ Building admin web app..."
# Web-only target; APP_VARIANT=admin activates the portal's admin branch.
flutter build web --release \
  --target lib/admin/admin_main.dart \
  --dart-define=APP_VARIANT=admin \
  --base-href=/

echo "✓ Web build complete -> build/web"
