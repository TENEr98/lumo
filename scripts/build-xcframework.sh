#!/usr/bin/env bash
# Собирает Rust-ядро в apple/Frameworks/LumoCoreFFI.xcframework и генерирует Swift-привязки.
# Порядок — скилл uniffi-bridge. Требует Xcode (xcodebuild -create-xcframework).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CORE="$ROOT/core"
TARGET_DIR="$CORE/target"
GEN="$CORE/generated"
OUT="$ROOT/apple/Frameworks/LumoCoreFFI.xcframework"
SWIFT_DEST="$ROOT/apple/Packages/LumoKit/Sources/LumoCore"
LIB=liblumo_ffi.a
MODULE=lumo_core

TARGETS=(aarch64-apple-darwin x86_64-apple-darwin aarch64-apple-ios aarch64-apple-ios-sim)

cd "$CORE"

# 1. Ядро под четыре цели.
for t in "${TARGETS[@]}"; do
    echo "==> cargo build $t"
    cargo build --release -p lumo-ffi --target "$t"
done

# 2. Универсальная библиотека macOS (NFR-13).
MAC_DIR="$TARGET_DIR/universal-macos/release"
mkdir -p "$MAC_DIR"
lipo -create \
    "$TARGET_DIR/aarch64-apple-darwin/release/$LIB" \
    "$TARGET_DIR/x86_64-apple-darwin/release/$LIB" \
    -output "$MAC_DIR/$LIB"

# 3. Swift-привязки из метаданных собранной библиотеки.
echo "==> uniffi-bindgen"
rm -rf "$GEN"
cargo run --release -p uniffi-bindgen -- generate \
    --library "$TARGET_DIR/aarch64-apple-darwin/release/$LIB" \
    --language swift --out-dir "$GEN"

# 4. Заголовок и module.modulemap для каждой библиотеки XCFramework.
HEADERS="$GEN/Headers"
mkdir -p "$HEADERS"
cp "$GEN/${MODULE}FFI.h" "$HEADERS/"
cp "$GEN/${MODULE}FFI.modulemap" "$HEADERS/module.modulemap"

# 5. XCFramework.
echo "==> xcodebuild -create-xcframework"
rm -rf "$OUT"
mkdir -p "$(dirname "$OUT")"
xcodebuild -create-xcframework \
    -library "$MAC_DIR/$LIB" -headers "$HEADERS" \
    -library "$TARGET_DIR/aarch64-apple-ios/release/$LIB" -headers "$HEADERS" \
    -library "$TARGET_DIR/aarch64-apple-ios-sim/release/$LIB" -headers "$HEADERS" \
    -output "$OUT"

# 6. Сгенерированный Swift-файл — в LumoKit.
mkdir -p "$SWIFT_DEST"
cp "$GEN/$MODULE.swift" "$SWIFT_DEST/"

echo "==> готово: $OUT"
