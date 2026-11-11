# Репозиторий и сборка

Структура создаётся в задаче 0.2 этапа 0.

```
lumo/
  CLAUDE.md
  README.md
  .claude/
    agents/          # агенты проекта
    skills/          # скиллы проекта
  core/              # Rust-воркспейс
    Cargo.toml
    rust-toolchain.toml
    crates/{storage,archive,imaging,clipboard,sync-model,ffi}   # пакеты lumo-*
    tools/uniffi-bindgen    # генератор привязок той же версии, что uniffi
  apple/
    project.yml      # описание проекта для XcodeGen
    Lumo.xcodeproj   # генерируется `xcodegen`, не в git
    Config/          # Base.xcconfig; Local.xcconfig с DEVELOPMENT_TEAM — не в git
    Lumo-macOS/
    Lumo-iOS/
    Extensions/{ShareExtension,BroadcastUpload,Keyboard}
    Packages/LumoKit/
    Frameworks/LumoCoreFFI.xcframework   # артефакт сборки, не в git
  scripts/
    build-all.sh           # одна команда: ядро + оболочки + тесты
    build-xcframework.sh
    gen-testdata.sh
  testdata/          # генерируется, не в git (кроме README и генераторов)
  docs/
    bft.md  plan.md  decisions.md  progress.md
    kb/  test-scripts/
  release/<версия>/  # тексты App Store
```

## Ветки и коммиты

- `main` — всегда собирается. Работа — в ветке спринта `sprint/NN`, слияние после ревью.
- Сообщение коммита начинается с кода требования: `SCR-01: рамка выделения области с лупой`.
- Служебные: `chore:`, `docs:`, `build:`.

## CI (GitHub Actions, macOS-раннер)

1. `cargo fmt --check`, `cargo clippy -- -D warnings`, `cargo test --workspace`.
2. Сборка XCFramework.
3. `xcodebuild build` для Mac и симулятора iOS, `xcodebuild test` для LumoKit.

Тесты, требующие сети, iCloud или разрешений ОС, в CI не запускаются.

## Подпись

До оплаты членства — автоматическая подпись с бесплатной учётной записью (сборки на iPhone нужно переустанавливать примерно раз в неделю — проверить фактический срок). После — команда разработчика и профили для App Store.
