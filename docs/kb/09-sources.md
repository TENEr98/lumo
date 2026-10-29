# Источники

Проверенные материалы, на которые опираются решения проекта. При сомнении в поведении API — первичный источник: документация developer.apple.com.

## Захват экрана (macOS)

- ScreenCaptureKit на macOS Sonoma — SCScreenshotManager, устаревание CGWindowListCreateImage, требование разрешения: https://nonstrict.eu/blog/2023/a-look-at-screencapturekit-on-macos-sonoma/
- Rust-обёртка screencapturekit — версии macOS для скриншотов (14+), записи в файл и микрофона (15+): https://docs.rs/screencapturekit
- Приложения на ScreenCaptureKit допускаются в Mac App Store: https://developer.apple.com/forums/thread/728140
- Периодическое подтверждение записи экрана в macOS Sequoia: https://9to5mac.com/2024/08/14/macos-sequoia-screen-recording-prompt-monthly/
- Системные сочетания скриншотов нельзя переопределить: https://github.com/alan13367/opensnapx

## iOS

- Доступ к буферу на iOS, запрос подтверждения с iOS 16: https://mas.owasp.org/MASTG/knowledge/ios/MASVS-PLATFORM/MASTG-KNOW-0083/
- Настройка «Вставка из других приложений»: https://pasteapp.io/help/allow-paste-permissions-in-ios
- Запись экрана через Broadcast Upload Extension, лимит памяти, остановка при блокировке: https://www.tencentcloud.com/ind/document/product/1071/50585
- Лимиты памяти расширений (Share Extension — 120 МБ): https://reactnative.dev/docs/app-extensions

## iCloud

- Rust-обёртка cloudkit — только macOS, мост через Swift: https://docs.rs/crate/cloudkit/0.3.1/source/README.md

## Архивы и лицензии

- Лицензия RAR/UnRAR: https://metadata.ftp-master.debian.org/changelogs/non-free/r/rar/testing_copyright
- Лицензия 7-Zip, ограничение unRAR: https://cobalt.googlesource.com/depot_tools/+/0242eb4266c7688e8e1789cb50c00dae06323007/win_toolchain/7z/LICENSE

## App Store

- Членство Apple Developer, 99 USD/год, что доступно бесплатно: https://developer.apple.com/support/compare-memberships
- App Store Small Business Program, 15%: https://developer.apple.com/app-store/small-business-program/

## Claude Code

- Подагенты и предзагрузка скиллов через поле `skills`: https://code.claude.com/docs/en/sub-agents
