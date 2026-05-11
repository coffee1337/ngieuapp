# NGIEU App — Claude Project Memory

## Project

This repository is a Flutter/Dart application for NGIEU university workflows.

The app includes:
- university news;
- schedule features;
- profile screen;
- settings screen;
- learning section through WebView;
- local storage and cache infrastructure;
- light and dark themes;
- notifications;
- offline-related UI.

Treat this as a real Flutter application, not as a throwaway demo.

## User preference

The user is Russian-speaking.

Use Russian for:
- explanations;
- plans;
- summaries;
- reviews;
- risk notes.

Use English for:
- code identifiers;
- class names;
- file names;
- commit messages unless the user asks for Russian.

## Tech stack

Use the existing stack unless explicitly asked otherwise:

- Flutter
- Dart
- Riverpod
- GoRouter
- Dio
- Drift / SQLite
- Hive
- Flutter secure storage
- Freezed / json_serializable
- local notifications
- WebView
- very_good_analysis

Do not add new dependencies without explaining:
1. why the dependency is needed;
2. what problem it solves;
3. why the existing stack is not enough.

## Architecture

Prefer feature-first architecture:

```text
lib/app/features/<feature>/
  data/
  domain/
  presentation/
```

Use these responsibilities:

- `presentation`: screens, widgets, UI state, Riverpod UI controllers/providers.
- `domain`: entities, repository contracts, use cases if needed, business rules.
- `data`: DTOs, API datasources, DB datasources, mappers, repository implementations.
- `core`: shared infrastructure such as networking, storage, routing, theme, errors, utilities.
- `shared/widgets`: reusable UI widgets.

Do not put networking, HTML parsing, database access, or business logic directly inside widgets.

## Coding rules

Prefer:
- small focused widgets;
- explicit names;
- immutable models;
- clear state handling;
- `AsyncValue` for async Riverpod state;
- safe parsing;
- graceful error handling;
- repository boundaries for data access;
- mapper functions between API/DB/domain models.

Avoid:
- huge screens;
- business logic in `build`;
- silent `catch` blocks;
- unsafe `int.parse` on route params;
- force unwraps without a clear reason;
- global mutable state;
- unrelated large refactors;
- raw Dio errors leaking into UI.

## Routing rules

When working with GoRouter:
- avoid unsafe route parsing;
- use `int.tryParse` or equivalent safe parsing;
- provide fallback behavior for invalid params;
- keep route paths and route names consistent;
- do not put business logic inside route builders.

## Networking rules

When working with Dio:
- keep base URLs in configuration/environment layer;
- convert Dio exceptions into app-level failures;
- avoid exposing raw network errors to users;
- retry only safe/idempotent requests;
- log details only in debug mode.

## News rules

News parsing depends on external HTML and is fragile.

When editing news code:
- keep parser logic outside widgets;
- handle missing title/date/image/description gracefully;
- add parser tests when possible;
- use local HTML fixtures or inline sample HTML in tests;
- do not make real network calls in tests.

## Schedule rules

When editing schedule code:
- keep API parsing tolerant of response shape changes;
- use mappers between raw API data and domain models;
- preserve cache/offline behavior if present;
- do not break actor search flows;
- add mapper tests when possible.

## UI rules

Prefer:
- Material 3 style;
- theme-aware colors;
- responsive layouts;
- loading, error, empty, and success states for async screens;
- Russian user-facing text;
- accessibility-friendly text scaling.

Avoid:
- hardcoded colors when theme tokens exist;
- text overflow issues;
- magic spacing everywhere;
- screens with too many responsibilities.

## Work process

For complex tasks:

1. Inspect relevant files.
2. Summarize current implementation.
3. Propose a small safe plan.
4. Implement only the requested scope.
5. Run checks if possible.
6. Summarize changes, risks, and next steps.

For simple tasks:

1. Inspect.
2. Patch.
3. Format/check if possible.
4. Summarize.

## Checks

Run these when possible:

```bash
flutter pub get
dart format .
flutter analyze
flutter test
```

If Flutter or platform tooling is unavailable, say so clearly and still perform static reasoning.

## Git rules

Do not commit automatically unless explicitly asked.

When asked to prepare a commit, provide:
- short summary;
- changed files;
- risks;
- suggested commit message.

## Response format for implementation tasks

Use this format:

```md
## Что сделано

...

## Изменённые файлы

...

## Проверки

...

## Риски

...

## Что дальше

...
```

## Response format for planning tasks

Use this format:

```md
## Что я увидел в коде

...

## План

...

## Риски

...

## Первый безопасный шаг

...
```
