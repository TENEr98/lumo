# Модель данных

Черновик для спринта 1. Окончательную схему утверждает `architect`; изменения — через миграции и запись в ADR, если меняется смысл.

## SQLite (`library.sqlite`, режим WAL)

```sql
CREATE TABLE items (
  id            TEXT PRIMARY KEY,          -- UUID
  kind          TEXT NOT NULL,             -- screenshot | recording | video_project | image | file
  title         TEXT,
  created_at    INTEGER NOT NULL,          -- unix ms
  modified_at   INTEGER NOT NULL,
  source_app    TEXT,                      -- bundle id приложения-источника
  device        TEXT,                      -- имя устройства-создателя
  media_path    TEXT,                      -- относительный путь в контейнере
  thumb_path    TEXT,
  width         INTEGER, height INTEGER, duration_ms INTEGER, size_bytes INTEGER,
  favorite      INTEGER NOT NULL DEFAULT 0,
  deleted_at    INTEGER,                   -- мягкое удаление (LIB-04)
  version       INTEGER NOT NULL DEFAULT 1,
  sync_state    TEXT NOT NULL DEFAULT 'pending' -- pending | synced | conflict
);

CREATE TABLE tags (id TEXT PRIMARY KEY, name TEXT NOT NULL UNIQUE);
CREATE TABLE item_tags (item_id TEXT REFERENCES items(id) ON DELETE CASCADE,
                        tag_id  TEXT REFERENCES tags(id)  ON DELETE CASCADE,
                        PRIMARY KEY (item_id, tag_id));
CREATE TABLE collections (id TEXT PRIMARY KEY, name TEXT NOT NULL, created_at INTEGER NOT NULL);
CREATE TABLE collection_items (collection_id TEXT REFERENCES collections(id) ON DELETE CASCADE,
                               item_id TEXT REFERENCES items(id) ON DELETE CASCADE,
                               PRIMARY KEY (collection_id, item_id));

CREATE TABLE clips (
  id           TEXT PRIMARY KEY,
  kind         TEXT NOT NULL,              -- text | rich_text | url | image | file | color
  text         TEXT,                       -- текстовое представление для поиска и вставки
  payload_path TEXT,                       -- для изображений и файлов
  content_hash TEXT NOT NULL,              -- дедупликация (CLP-06)
  source_app   TEXT,
  created_at   INTEGER NOT NULL,
  last_used_at INTEGER NOT NULL,
  pinned       INTEGER NOT NULL DEFAULT 0,
  pinboard_id  TEXT,                       -- подборки (CLP-10, v1)
  version      INTEGER NOT NULL DEFAULT 1,
  sync_state   TEXT NOT NULL DEFAULT 'pending'
);
CREATE UNIQUE INDEX clips_hash ON clips(content_hash);

-- Полнотекстовый поиск (LIB-02, CLP-03): заголовки, теги, OCR, текст буфера
CREATE VIRTUAL TABLE search USING fts5(
  ref_id UNINDEXED, ref_kind UNINDEXED, title, body,
  tokenize = 'unicode61 remove_diacritics 2'
);
```

`unicode61` корректно работает с кириллицей и узбекской латиницей (включая апостроф в oʻ/gʻ — проверить на тестовом наборе).

## Записи CloudKit

Типы `LibraryItem`, `EditorProject`, `ClipItem`, `Settings` в зоне `LumoZone` частной базы. Поля и шифрование — скилл `cloudkit-sync`. Идентификатор записи = `id` из SQLite.

## Форматы JSON

- Проект редактора изображений — `projects/<id>.json`, схема в скилле `annotation-editor`.
- Проект видеомонтажа — `projects/<id>.json`, схема в скилле `avfoundation-media`.
- Входящие от расширений — `inbox/<uuid>.json`: `{ "kind", "file", "createdAt", "sourceApp" }`.

У каждого формата поле `version`; чтение старых версий поддерживается, запись — только текущей.
