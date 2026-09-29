# Codex instructions for ngieuapp

Before changing code, read `CLAUDE.md` for the project architecture, stack, conventions, and response language. Treat those project rules as the source of truth.

## Shared project rules

- This is a maintained Flutter/Dart application for NGIEU, not a throwaway demo.
- Keep changes focused and preserve the existing feature-first architecture.
- Use the current stack: Riverpod, GoRouter, Dio, Drift/Hive, and existing Flutter packages.
- Do not add dependencies without explaining why the current stack is insufficient.
- Keep API, database, parsing, and business logic out of widgets.
- Preserve cache/offline behavior in schedule and news features.
- Keep user-facing text in Russian; use English for identifiers.
- Never commit, push, or merge unless the user explicitly asks.

## Delegation

For a non-trivial feature or refactor, use the configured project agents:

1. Ask `flutter-architect` to inspect the affected area and return a short plan, file ownership, contracts, and acceptance criteria. It must not edit files.
2. Have `flutter-implementer` implement only the assigned application files.
3. Have `flutter-test-writer` add or update tests only under `test/`. It may work in parallel with the implementer only after the plan defines the behavior and the file scopes do not overlap.
4. After both finish, ask `flutter-reviewer` to inspect the final diff read-only. Fix any confirmed blocking issues before reporting completion.

Do not delegate trivial one-line changes. Do not ask two agents to edit the same file. Keep each agent's context limited to the relevant feature files and tests.

## Verification

Run focused tests first, then as appropriate:

```sh
dart format .
flutter analyze
flutter test
```

If a check cannot run, state why. Never claim a check passed unless it was run.
