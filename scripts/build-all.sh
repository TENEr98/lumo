#!/usr/bin/env bash
# Одна команда: тесты ядра → XCFramework → проект Xcode → тесты LumoKit → сборка Mac и iOS (критерий задачи 0.2).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "==> Ядро: fmt, clippy, тесты"
(cd "$ROOT/core" && cargo fmt --all --check && cargo clippy --workspace --all-targets -- -D warnings && cargo test --workspace)

"$ROOT/scripts/build-xcframework.sh"

echo "==> Проект Xcode из apple/project.yml"
(cd "$ROOT/apple" && xcodegen --quiet)

echo "==> Тесты LumoKit (macOS)"
(cd "$ROOT/apple/Packages/LumoKit" && swift test)

cd "$ROOT/apple"
echo "==> Сборка Lumo-macOS"
xcodebuild -project Lumo.xcodeproj -scheme Lumo-macOS -destination 'generic/platform=macOS' \
    CODE_SIGNING_ALLOWED=NO -quiet build

echo "==> Сборка Lumo-iOS (симулятор)"
xcodebuild -project Lumo.xcodeproj -scheme Lumo-iOS -destination 'generic/platform=iOS Simulator' \
    CODE_SIGNING_ALLOWED=NO -quiet build

echo "==> Всё собрано"
