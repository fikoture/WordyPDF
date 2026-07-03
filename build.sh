#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_DIR="$ROOT_DIR/Word to PDF.app"

mkdir -p "$APP_DIR/Contents/MacOS" "$APP_DIR/Contents/Resources" "$ROOT_DIR/.build/module-cache"
cp "$ROOT_DIR/Info.plist" "$APP_DIR/Contents/Info.plist"

env CLANG_MODULE_CACHE_PATH="$ROOT_DIR/.build/module-cache" \
	swiftc "$ROOT_DIR/Sources/main.swift" "$ROOT_DIR/Sources/WordToPDF.swift" \
	-framework Cocoa \
	-o "$APP_DIR/Contents/MacOS/Word to PDF"
