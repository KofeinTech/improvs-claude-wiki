# Flutter / Dart Coding Standards

Conventions for all Flutter projects at Improvs.

## Stack

- **Flutter** via FVM (version per project)
- **Riverpod** for all state management (never `setState` in feature code)
- **GoRouter** for navigation
- **Freezed** for all data models
- **Dio** for HTTP requests

## Project structure

```
lib/
  main.dart
  app.dart                    # App widget, GoRouter setup
  core/
    theme/                    # Colors, typography, design tokens
    router/                   # GoRouter configuration
    constants/                # App-wide constants
    utils/                    # Shared utilities
  data/
    models/                   # Freezed data models
    repositories/             # Repository pattern
    sources/                  # API clients, local storage
  features/
    auth/
      providers/              # Riverpod providers
      screens/                # Full screens (pages)
      widgets/                # Feature-specific widgets
    profile/
      ...
```

Every feature gets its own directory under `lib/features/`. No feature should depend directly on another feature's internal code.

## State management

Use Riverpod with `@riverpod` code generation:

```dart
@riverpod
class UserList extends _$UserList {
  @override
  Future<List<User>> build() async {
    return ref.read(userRepositoryProvider).getAll();
  }
}
```

- One provider per concern
- Use `AsyncNotifier` for async state
- Invalidate providers to refresh data -- don't manually fetch

## Data models

All data models use Freezed:

```dart
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    String? email,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

## Naming

- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables/functions: `camelCase`
- Constants: `camelCase` (Dart convention, not SCREAMING_SNAKE)
- Private members: `_prefixed`

## Quality gates

Every commit must pass:
- `flutter analyze` -- zero warnings
- `flutter test` -- all tests pass
- `dart format` -- auto-applied on every file edit

## Don't

- Don't use `setState` outside of `StatefulWidget` local UI state
- Don't put business logic in widgets -- use providers
- Don't hardcode strings -- use constants or localization
- Don't import from another feature's internal files
- Don't skip code generation: run `dart run build_runner build` after changing Freezed/Riverpod models
