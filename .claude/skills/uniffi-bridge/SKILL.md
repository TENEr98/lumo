---
name: uniffi-bridge
description: Как Rust-ядро Lumo подключается к Swift через UniFFI и XCFramework — правила экспорта, типы, асинхронность, колбэки, сборка под macOS и iOS. Использовать при изменении публичного API ядра и при задаче 0.2 этапа 0.
---

# Мост Rust → Swift (UniFFI)

## Подход

- Экспорт через процедурные макросы UniFFI: `#[uniffi::export]`, `#[derive(uniffi::Record)]`, `#[derive(uniffi::Enum)]`, `#[derive(uniffi::Error)]`, `#[derive(uniffi::Object)]`. Файл `.udl` не используется.
- Весь экспорт — в крейте `ffi`; `crate-type = ["staticlib", "lib"]`.
- Swift-привязки генерируются `uniffi-bindgen` (бинарь внутри воркспейса, версия совпадает с версией `uniffi`).
- Версию `uniffi` фиксируй точно и обновляй отдельной задачей: формат генерации меняется между версиями.

## Правила проектирования API

- Крупные операции, а не болтливые вызовы: «добавить элемент со всеми метаданными», а не десять сеттеров.
- Данные — `Record` (передаются копией), долгоживущие объекты (база, сессия архива) — `Object` (передаются ссылкой, `Arc`).
- Большие бинарные данные не гоняем через FFI: передаём путь к файлу в общем контейнере.
- Прогресс и отмена — callback-интерфейс (`#[uniffi::export(callback_interface)]` или `with_foreign`), реализуемый в Swift.
- Асинхронные функции — `async fn` с `#[uniffi::export(async_runtime = "tokio")]` только там, где действительно нужен ввод-вывод; простые вызовы оставляй синхронными и вызывай из Swift вне главного потока.
- Ошибки — один `LumoError` с вариантами по смыслу (`NotFound`, `Corrupted`, `PermissionDenied`, `Cancelled`, `Io`, `Unsupported`).

## Сборка XCFramework (`scripts/build-xcframework.sh`)

1. `cargo build --release -p lumo-ffi --target` для четырёх целей: `aarch64-apple-darwin`, `x86_64-apple-darwin`, `aarch64-apple-ios`, `aarch64-apple-ios-sim`.
2. `lipo -create` для двух macOS-библиотек в одну универсальную.
3. Генерация Swift-привязок: `uniffi-bindgen generate --library <путь к .a или .dylib> --language swift --out-dir generated/`.
4. Заголовок и `module.modulemap` из `generated/` кладутся в папку `Headers` каждой библиотеки.
5. `xcodebuild -create-xcframework -library <mac.a> -headers <h> -library <ios.a> -headers <h> -library <ios-sim.a> -headers <h> -output LumoCoreFFI.xcframework`.
6. Сгенерированный `.swift`-файл копируется в `apple/Packages/LumoKit/Sources/LumoCore/`.

## Проверка

- Swift-тест в LumoKit вызывает одну функцию ядра и получает ожидаемое значение на macOS и в симуляторе iOS.
- Размер приложения для iOS после подключения ядра — сверить с NFR-02.
