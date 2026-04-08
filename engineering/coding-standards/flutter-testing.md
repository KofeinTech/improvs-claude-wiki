# Flutter Testing Guidelines

Testing guidelines for all Flutter projects at Improvs.

## Philosophy

Test all business logic. Every use case, repository implementation, and entity method with non-trivial logic should have tests. Auth and the app's core feature are the absolute minimum -- but aim for full coverage of the domain and data layers.

## Test types

- **Unit** — logic you own (use cases, repository implementations, entity methods). Mock everything external. Lives in `test/`.
- **Widget** — required for every new feature. Focus on critical or complex UI behavior: `CustomPainter` rendering, complex animation-driven state, multi-step interaction flows. Lives in `test/`.
- **Integration** — external boundaries (Retrofit sources, local databases). No mocks, real data flows through. Run against a staging server. Lives in `integration_test/`.

## File structure

Mirrors `lib/`. A test for `lib/features/auth/domain/use_cases/sign_in_use_case.dart` lives at `test/features/auth/domain/use_cases/sign_in_use_case_test.dart`.

## Mocks

Use `mockito` for generated mocks. Annotate `main()` with `@GenerateMocks` and run `dart run build_runner build` to generate the `*.mocks.dart` file. Import it in the test file.

- Use `group()` to organize by class or method, `test()` for individual scenarios
- Test names describe the scenario in plain language: `'returns user when credentials are valid'`
- Use `verify()` to assert a method was called, not just that a result was returned

## Unit test example

Verifies business logic in isolation, pure Dart, no Riverpod:

```dart
// test/features/auth/domain/use_cases/sign_in_use_case_test.dart
import 'sign_in_use_case_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late SignInUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignInUseCase(mockRepository);
  });

  const tUser = User(id: '1', name: 'Test User', email: 'a@b.com');
  final tParams = SignInParams(email: 'a@b.com', password: '123');

  group('SignInUseCase', () {
    test('returns user when credentials are valid', () async {
      when(mockRepository.signIn(any())).thenAnswer((_) async => tUser);

      final result = await useCase.call(tParams);

      expect(result, tUser);
      verify(mockRepository.signIn(any())).called(1);
    });

    test('throws AuthException when credentials are invalid', () async {
      when(mockRepository.signIn(any())).thenThrow(AuthException());

      expect(
        () async => await useCase.call(tParams),
        throwsA(isA<AuthException>()),
      );
    });
  });
}
```

## Notifier test example

Verifies state transitions the UI actually sees (`AsyncLoading` -> `AsyncData` / `AsyncError`):

```dart
// test/features/auth/presentation/providers/auth_controller_test.dart
import 'auth_controller_test.mocks.dart';

// generic Listener mock to track provider state changes
class Listener<T> extends Mock {
  void call(T? previous, T next);
}

@GenerateMocks([AuthRepository])
void main() {
  ProviderContainer makeProviderContainer(MockAuthRepository authRepository) {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('AuthController', () {
    test('initial state is AsyncData', () {
      final authRepository = MockAuthRepository();
      final container = makeProviderContainer(authRepository);
      final listener = Listener<AsyncValue<void>>();

      container.listen(authControllerProvider, listener, fireImmediately: true);

      verify(listener(null, const AsyncData<void>(null)));
      verifyNoMoreInteractions(listener);
      verifyNever(authRepository.signInAnonymously());
    });

    test('emits loading then data when sign in succeeds', () async {
      final authRepository = MockAuthRepository();
      when(authRepository.signInAnonymously()).thenAnswer((_) => Future.value());

      final container = makeProviderContainer(authRepository);
      final listener = Listener<AsyncValue<void>>();
      container.listen(authControllerProvider, listener, fireImmediately: true);

      const data = AsyncData<void>(null);
      verify(listener(null, data));

      await container.read(authControllerProvider.notifier).signInAnonymously();

      verifyInOrder([
        listener(data, isA<AsyncLoading<void>>()),
        listener(isA<AsyncLoading<void>>(), data),
      ]);
      verifyNoMoreInteractions(listener);
      verify(authRepository.signInAnonymously()).called(1);
    });

    test('emits loading then error when sign in fails', () async {
      final authRepository = MockAuthRepository();
      when(authRepository.signInAnonymously()).thenThrow(AuthException());

      final container = makeProviderContainer(authRepository);
      final listener = Listener<AsyncValue<void>>();
      container.listen(authControllerProvider, listener, fireImmediately: true);

      const data = AsyncData<void>(null);
      verify(listener(null, data));

      await container.read(authControllerProvider.notifier).signInAnonymously();

      verifyInOrder([
        listener(data, isA<AsyncLoading<void>>()),
        listener(isA<AsyncLoading<void>>(), isA<AsyncError<void>>()),
      ]);
      verifyNoMoreInteractions(listener);
    });
  });
}
```

## Full flow example

Sign in from repository to notifier — each layer tested in isolation:

```dart
// test/features/auth/sign_in_test.dart
import 'sign_in_test.mocks.dart';

class Listener<T> extends Mock { void call(T? previous, T next); }

@GenerateMocks([AuthRemoteSource, AuthRepository, SignInUseCase])
void main() {
  final tParams = SignInParams(email: 'a@b.com', password: '123');
  const tModel = UserModel(id: '1', name: 'Test User', email: 'a@b.com');
  const tUser = User(id: '1', name: 'Test User', email: 'a@b.com');

  // 1. Repository — maps model to entity
  group('AuthRepositoryImpl', () {
    late AuthRepository repository;
    late MockAuthRemoteSource mockSource;

    setUp(() {
      mockSource = MockAuthRemoteSource();
      repository = AuthRepositoryImpl(mockSource);
    });

    test('returns User entity mapped from model', () async {
      when(mockSource.signIn(any())).thenAnswer((_) async => tModel);

      final result = await repository.signIn(tParams);

      expect(result, tUser);
    });

    test('propagates exception from source', () async {
      when(mockSource.signIn(any())).thenThrow(AuthException());

      expect(() async => await repository.signIn(tParams), throwsA(isA<AuthException>()));
    });
  });

  // 2. Use case — orchestrates repository call
  group('SignInUseCase', () {
    late SignInUseCase useCase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = SignInUseCase(mockRepository);
    });

    test('returns user when repository succeeds', () async {
      when(mockRepository.signIn(any())).thenAnswer((_) async => tUser);

      final result = await useCase.call(tParams);

      expect(result, tUser);
      verify(mockRepository.signIn(any())).called(1);
    });
  });

  // 3. Notifier — state transitions the UI sees
  group('AuthController', () {
    ProviderContainer makeContainer(MockSignInUseCase useCase) {
      final container = ProviderContainer(
        overrides: [signInUseCaseProvider.overrideWithValue(useCase)],
      );
      addTearDown(container.dispose);
      return container;
    }

    test('initial state is AsyncData', () {
      final container = makeContainer(MockSignInUseCase());
      final listener = Listener<AsyncValue<void>>();

      container.listen(authControllerProvider, listener, fireImmediately: true);

      verify(listener(null, const AsyncData<void>(null)));
      verifyNoMoreInteractions(listener);
    });

    test('emits loading then data on success', () async {
      final mockUseCase = MockSignInUseCase();
      when(mockUseCase.call(any())).thenAnswer((_) async => tUser);

      final container = makeContainer(mockUseCase);
      final listener = Listener<AsyncValue<void>>();
      container.listen(authControllerProvider, listener, fireImmediately: true);

      const data = AsyncData<void>(null);
      verify(listener(null, data));

      await container.read(authControllerProvider.notifier).signIn(tParams);

      verifyInOrder([
        listener(data, isA<AsyncLoading<void>>()),
        listener(isA<AsyncLoading<void>>(), data),
      ]);
      verifyNoMoreInteractions(listener);
    });

    test('emits loading then error on failure', () async {
      final mockUseCase = MockSignInUseCase();
      when(mockUseCase.call(any())).thenThrow(AuthException());

      final container = makeContainer(mockUseCase);
      final listener = Listener<AsyncValue<void>>();
      container.listen(authControllerProvider, listener, fireImmediately: true);

      const data = AsyncData<void>(null);
      verify(listener(null, data));

      await container.read(authControllerProvider.notifier).signIn(tParams);

      verifyInOrder([
        listener(data, isA<AsyncLoading<void>>()),
        listener(isA<AsyncLoading<void>>(), isA<AsyncError<void>>()),
      ]);
      verifyNoMoreInteractions(listener);
    });
  });
}
```

## Widget test example

Only for critical or complex UI behavior that can't be verified at the unit level:

```dart
// test/features/match/presentation/widgets/match_score_painter_test.dart

void main() {
  group('MatchScoreWidget', () {
    testWidgets('renders painter with correct initial scores', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MatchScoreWidget(homeScore: 2, awayScore: 1),
          ),
        ),
      );

      final customPaint = tester.widget<CustomPaint>(find.byType(CustomPaint));
      final painter = customPaint.painter as MatchScorePainter;
      expect(painter.homeScore, 2);
      expect(painter.awayScore, 1);
    });

    testWidgets('updates painter when scores change', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MatchScoreWidget(homeScore: 0, awayScore: 0),
          ),
        ),
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MatchScoreWidget(homeScore: 3, awayScore: 0),
          ),
        ),
      );
      await tester.pump();

      final customPaint = tester.widget<CustomPaint>(find.byType(CustomPaint));
      final painter = customPaint.painter as MatchScorePainter;
      expect(painter.homeScore, 3);
      expect(painter.awayScore, 0);
    });
  });
}
```

## Integration test example

External boundaries only, no mocks, run against staging:

```dart
// integration_test/auth_integration_test.dart

void main() {
  late Dio dio;
  late AuthRemoteSource source;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://staging.yourapi.com'));
    source = AuthRemoteSourceImpl(dio);
  });

  group('AuthRemoteSource', () {
    test('returns valid UserModel for correct credentials', () async {
      final result = await source.signIn(
        SignInParams(email: 'test@staging.com', password: 'test123'),
      );

      expect(result.id, isNotEmpty);
      expect(result.email, 'test@staging.com');
      expect(result.name, isNotEmpty);
    });

    test('throws DioException on wrong credentials', () async {
      expect(
        () async => await source.signIn(
          SignInParams(email: 'test@staging.com', password: 'wrongpassword'),
        ),
        throwsA(isA<DioException>()),
      );
    });
  });
}
```
