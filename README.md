# Lumo — стартовый комплект для Claude Code

Это заготовка репозитория: правила проекта, 9 агентов, 16 скиллов и база знаний. Кода ещё нет — его создаёт Claude Code начиная с задачи 0.2.

## Как начать

1. Распакуйте папку туда, где будет жить проект, например `~/Projects/lumo`.
2. Выполните `git init` и первый коммит — так у Claude Code будет точка отсчёта.
3. Откройте папку в Claude Code (`cd ~/Projects/lumo && claude`). Он сам прочитает `CLAUDE.md`, а агенты и скиллы из `.claude/` подхватятся автоматически.
4. Проверьте командой `/agents`, что видны 9 агентов.
5. Первая задача:

> Выполни задачу 0.2 этапа 0 из docs/plan.md: создай структуру репозитория по docs/kb/06-repository.md, Rust-воркспейс с пустыми крейтами, мост UniFFI с одной тестовой функцией, скрипт scripts/build-xcframework.sh и пустые приложения для macOS и iOS, которые вызывают эту функцию. Начни с агента architect, в конце — reviewer. Обнови docs/progress.md.

## Что где

| Путь | Что |
| --- | --- |
| `CLAUDE.md` | Правила проекта: порядок работы, агенты, запреты |
| `.claude/agents/` | architect, rust-core-engineer, apple-platform-engineer, media-engineer, swiftui-engineer, test-engineer, reviewer, release-manager, docs-keeper |
| `.claude/skills/` | Знания по технологиям и процессам, подключены к агентам через поле `skills` |
| `docs/bft.md` | Требования с кодами |
| `docs/plan.md` | Этапы, спринты, контрольные точки |
| `docs/decisions.md` | Принятые архитектурные решения |
| `docs/progress.md` | Состояние работ |
| `docs/kb/` | База знаний |

## Агенты и их скиллы

| Агент | Модель | Скиллы |
| --- | --- | --- |
| architect | opus | lumo-architecture, uniffi-bridge, cloudkit-sync, kb-upkeep |
| rust-core-engineer | sonnet | lumo-architecture, rust-core, uniffi-bridge, archive-engine |
| apple-platform-engineer | opus | lumo-architecture, screencapturekit, replaykit-broadcast, cloudkit-sync, clipboard-history |
| media-engineer | opus | avfoundation-media, screencapturekit, replaykit-broadcast, annotation-editor |
| swiftui-engineer | sonnet | lumo-architecture, swiftui-conventions, annotation-editor, localization |
| test-engineer | sonnet | acceptance-testing, rust-core, swiftui-conventions |
| reviewer | sonnet | code-review-lumo, lumo-architecture, acceptance-testing |
| release-manager | sonnet | app-store-release, localization |
| docs-keeper | haiku | kb-upkeep |

Модель любого агента можно поменять в его файле (поле `model`), например на `inherit`, чтобы он работал на модели текущей сессии.
