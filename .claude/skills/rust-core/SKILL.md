---
name: rust-core
description: Соглашения по коду Rust-ядра Lumo — структура воркспейса, ошибки, тесты, производительность, зависимости. Использовать при любой работе в core/.
---

# Соглашения Rust-ядра

## Воркспейс

```
core/
  Cargo.toml            # [workspace], общие версии в [workspace.dependencies]
  crates/
    storage/  archive/  imaging/  clipboard/  sync-model/  ffi/
  testdata/             # генерируется скриптами, см. README внутри
```

Редакция Rust 2021, `rust-toolchain.toml` фиксирует стабильную версию. Целевые платформы: `aarch64-apple-darwin`, `x86_64-apple-darwin`, `aarch64-apple-ios`, `aarch64-apple-ios-sim`.

## Ошибки

- Каждый крейт — свой `enum Error` на `thiserror`; в `ffi` — общий `LumoError`, отображаемый в Swift.
- Сообщения ошибок — для разработчика; текст для пользователя формирует Swift по коду ошибки.
- Никаких паник на пути вызова из Swift. `unwrap`/`expect` допустимы только в тестах.

## Тесты

- Модульные тесты рядом с кодом, интеграционные — в `crates/<крейт>/tests/`.
- Для архивов и изображений — эталонные файлы в `testdata/`, генерируемые скриптом.
- Для поиска — тест производительности на 50 000 элементов (NFR-08) с `#[ignore]`, запускается вручную и в CI по ночам.

## Производительность

- SQLite: режим WAL, подготовленные выражения, транзакция на пакет вставок.
- Изображения: работа с буферами без лишних копий; уменьшение для миниатюр — `fast_image_resize` или `image` с фильтром Lanczos3.
- Долгие операции принимают `ProgressReporter` и `CancellationToken` (свои типы, экспортируемые через UniFFI как callback-интерфейс).

## Зависимости (стартовый набор, лицензии проверены по crates.io перед добавлением)

| Назначение | Крейт |
| --- | --- |
| SQLite + FTS5 | `rusqlite` с функцией `bundled` (проверить, что FTS5 включён в сборке) |
| Ошибки | `thiserror` |
| Сериализация | `serde`, `serde_json` |
| Изображения | `image`, `imageproc` или `fast_image_resize` |
| GIF | `gif` + `color_quant` |
| Архивы | см. скилл `archive-engine` |
| Кодировки имён | `encoding_rs` |
| Идентификаторы и время | `uuid`, `time` |

Каждую новую зависимость записывай в `docs/kb/10-dependencies.md`: крейт, версия, лицензия, зачем.

## Перед сдачей

`cargo fmt --all && cargo clippy --workspace -- -D warnings && cargo test --workspace`
