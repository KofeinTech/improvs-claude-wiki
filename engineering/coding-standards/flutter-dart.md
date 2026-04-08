# Flutter / Dart Coding Standards

Conventions for all Flutter projects at Improvs.

## Stack

- **Flutter** via FVM (version per project)
- **Riverpod** for all state management (never `setState` in feature code)
- **GoRouter** for navigation
- **Freezed** for all data models
- **Dio** + **Retrofit** for HTTP requests
- **flutter_gen** for generated asset paths (images, SVGs, fonts)
- **flutter_svg** for SVG rendering, integrated with flutter_gen

## Project structure

```
assets/
  icons/
    auth/
    profile/
    ...
  images/
    auth/
    profile/
    ...
integration_test/           # external boundary tests, run against staging
lib/
  main.dart
  app.dart                    # App widget, GoRouter setup
  core/
    theme/                    # Colors, typography, design tokens
    router/                   # GoRouter configuration
    constants/                # App-wide constants
    utils/                    # Shared utilities
    l10n/                     # Localisation — Flutter l10n generated code
  features/
    auth/
      presentation/
        providers/            # Riverpod providers
        screens/              # Full screens (pages)
        widgets/              # Feature-specific widgets
      domain/
        entities/             # Freezed domain models
        repositories/         # Abstract repository interfaces
        use_cases/            # Business logic
      data/
        repositories/         # Concrete repository implementations
        models/               # API/local data models
        sources/              # API clients, local storage
    profile/
      ...
test/                       # mirrors lib/ structure
  features/
    auth/
      ...
.env                        # environment variables — never commit
build.yaml                  # build_runner codegen configuration
CLAUDE.md                   # Claude project config
pubspec.yaml                # dependencies, app version
```

### Layer responsibilities

**`presentation/`** — UI and state. Flutter-dependent, no business logic.

- `providers/` — Manage feature state. Call use cases, expose results to screens and widgets. No data processing logic here.
- `screens/` — Full-page widgets, feature-specific. Compose widgets and react to provider state.
- `widgets/` — Smaller UI components scoped to the feature. Reusable within the feature but not shared globally.

**`domain/`** — Pure Dart. No Flutter, no external dependencies. The core of the feature.

- `entities/` — Plain Dart classes (Freezed). The canonical data shape used across all layers. May contain additional getters or methods to derive or format data for UI consumption.
- `repositories/` — Abstract contracts (interfaces) that define what data operations the feature needs. No implementation here.
- `use_cases/` — Encapsulate business logic. Called by providers, they coordinate one or more repositories to produce a result. Each use case file also contains its params class.

**`data/`** — Data sourcing. Implements the contracts defined in `domain/`.

- `repositories/` — Concrete implementations of domain repository interfaces. Fetch from sources and convert models to entities.
- `models/` — Data containers for API JSON or local DB (DAO). Contain a `toEntity()` method; conversion happens at the repository level, never above.
- `sources/` — Raw data access: Dio API clients, SharedPreferences, local DB, etc. No business logic.

**`core/l10n/`** — Localisation. Uses Flutter's built-in l10n generation (`flutter gen-l10n`). `.arb` files are the source of truth; generated Dart code is consumed across the app.

Every feature gets its own directory under `lib/features/`. No feature should depend directly on another feature's internal code.

## Assets

- Assets live in the top-level `assets/` folder, next to `lib/`
- Separated by kind (`icons/`, `images/`, etc.), then by feature inside each kind
- All asset paths are generated via **flutter_gen** — never hardcode asset path strings
- SVG files are rendered with **flutter_svg**, which integrates with flutter_gen to provide typed `SvgGenImage` accessors

## State management

Use Riverpod with `@riverpod` code generation. Providers call use cases — never repositories directly:

```dart
@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {}

  Future<void> signIn(SignInParams params) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(signInUseCaseProvider).call(params),
    );
  }
}
```

- One provider per concern
- Use `AsyncNotifier` for async state
- Invalidate providers to refresh data -- don't manually fetch
- The only acceptable in-widget state is things like animations that are intrinsic to the widget itself and must stay encapsulated inside it — everything else goes in a provider

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

## Theme

- Use `TextTheme` as the base for all text styles — never hardcode `TextStyle` values directly in widgets
- Use `ColorScheme` as the base for all colors — never hardcode color values directly in widgets
- Both are defined in `core/theme/` and accessed via `Theme.of(context)`
- Use `ColorScheme` extensions only when all semantically appropriate fields are exhausted

`TextTheme` size reference:

```
Display (45-57px)  → Hero/marketing content
├── Headline (24-32px) → Content structure
├── Title (14-22px)    → UI component labels
├── Body (12-16px)     → Readable content
└── Label (11-14px)    → Interactive elements
```

## Naming

- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables/functions: `camelCase`
- Constants: `camelCase` (Dart convention, not SCREAMING_SNAKE)
- Private members: `_prefixed`

## Testing

See [Flutter Testing Guidelines](flutter-testing.md) for the full testing guidelines, examples, and patterns.

## Quality gates

Every commit must pass:
- `flutter analyze` -- zero warnings
- `flutter test` -- all tests pass
- `dart format` -- auto-applied on every file edit

## Don't

- Don't put business logic in widgets -- use providers + use cases
- Don't hardcode strings -- use constants or localization
- Don't hardcode asset paths -- use flutter_gen generated accessors
- Don't import from another feature's internal files
- Don't skip code generation: run `dart run build_runner build` after changing Freezed/Riverpod/Retrofit/Mockito models
