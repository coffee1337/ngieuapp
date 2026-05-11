---
name: ngieu-flutter
description: Work on the NGIEU Flutter app. Use for architecture review, feature implementation, bug fixing, testing, refactoring, README updates, release preparation, Riverpod state management, GoRouter routing, Dio networking, Drift/Hive storage, WebView, local notifications, and feature-first Flutter architecture.
---

# NGIEU Flutter Skill

Use this skill when working on the NGIEU Flutter app.

## Main rule

First understand the existing implementation, then change it.

Do not make broad refactors unless the user explicitly asks for a refactor.

## Default workflow

For every non-trivial task:

1. Inspect relevant files.
2. Identify the affected feature or layer.
3. Summarize current behavior.
4. Propose the smallest safe change.
5. Make focused edits.
6. Run available checks.
7. Summarize results in Russian.

## Feature areas

Use these areas when navigating the project:

```text
lib/app/core
lib/app/shared
lib/app/features/news
lib/app/features/schedule
lib/app/features/profile
lib/app/features/settings
lib/app/features/learning
lib/app/features/notifications
```

## Architecture rules

Use feature-first structure:

```text
lib/app/features/<feature>/
  data/
  domain/
  presentation/
```

Responsibilities:

- `data`: API clients, datasources, DB datasources, DTOs, mappers, repository implementations.
- `domain`: entities, repository contracts, business logic.
- `presentation`: screens, widgets, Riverpod providers/controllers.
- `core`: shared infrastructure.
- `shared`: reusable UI components.

Do not move code across layers without a reason.

Do not put API calls, database calls, or HTML parsing inside widgets.

## Riverpod rules

Prefer:
- `AsyncValue` for async state;
- focused providers;
- repository providers for data access;
- `ref.watch` for reactive UI reads;
- `ref.read` for actions;
- explicit provider names.

Avoid:
- side effects in widget `build`;
- large providers that mix unrelated concerns;
- manually duplicated loading/error/data state when `AsyncValue` is enough.

## GoRouter rules

When editing routing:
- avoid unsafe `int.parse`;
- use `int.tryParse`;
- provide fallback behavior for invalid route params;
- keep route names and paths stable;
- avoid business logic in route builders.

## Dio/network rules

When editing network code:
- keep URLs in configuration/environment layer;
- keep Dio setup centralized;
- convert Dio exceptions to app-level errors/failures;
- do not leak raw Dio exceptions to UI;
- retry only safe requests;
- avoid changing timeout/retry behavior without explaining impact.

## News rules

News parsing is fragile because it depends on external HTML.

When editing news:
- keep parser code separate from UI;
- handle missing fields safely;
- add parser tests when possible;
- avoid real network calls in tests;
- use fixtures or inline HTML samples.

## Schedule rules

When editing schedule:
- preserve API compatibility;
- keep mapping logic separate from UI;
- handle empty/missing fields safely;
- preserve local cache/offline behavior if present;
- add mapper tests when possible.

## UI rules

Prefer:
- theme-aware colors;
- Material 3 components;
- responsive layouts;
- loading/error/empty/success states;
- Russian copy for user-facing text.

Avoid:
- hardcoded colors;
- layout overflow;
- huge widgets;
- duplicated UI logic.

## Testing rules

Add or update tests when touching:
- parsers;
- mappers;
- repositories;
- provider logic;
- error handling;
- route parsing.

Prefer small deterministic tests.

Do not call real APIs in tests.

## Check commands

Run when possible:

```bash
dart format .
flutter analyze
flutter test
```

If a check cannot run, explain why.

## Final response format

For implementation:

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

For analysis/planning:

```md
## Что я увидел

...

## Проблемы

...

## План

...

## Первый безопасный шаг

...
```
