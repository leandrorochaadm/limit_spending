# Template: Provider Test

## REGRA CRITICA: Testar TODOS os Estados

**OBRIGATORIO testar TODOS os estados do sealed class sem excecao:**

| Estado | Descricao | Obrigatorio |
|--------|-----------|-------------|
| `Initial` | Estado inicial antes de qualquer acao | SIM |
| `Loading` | Durante operacao async | SIM |
| `Loaded` | Sucesso com dados | SIM |
| `Empty` | Sucesso sem dados (lista vazia) | SIM |
| `Error` | Falha com mensagem | SIM |

---

## Opcao 1: riverpod_test (Recomendado)

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_test/riverpod_test.dart';
import 'package:dartz/dartz.dart';

// Mocks
class GetUsersMock extends Mock implements GetUsersUseCase {}

void main() {
  late GetUsersMock getUsersMock;

  setUpAll(() {
    registerFallbackValue(const GetUsersParams());
  });

  setUp(() {
    getUsersMock = GetUsersMock();
  });

  tearDown(() {
    reset(getUsersMock);
  });

  group('UsersProvider', () {
    // ============================================
    // ESTADO 1: Initial (OBRIGATORIO)
    // ============================================
    group('Initial state', () {
      test('should have UsersInitial as initial state', () {
        testProvider<UsersState>(
          usersProvider,
          overrides: [
            getUsersUseCaseProvider.overrideWithValue(getUsersMock),
          ],
          expect: () => [const UsersInitial()],
        );
      });
    });

    // ============================================
    // ESTADO 2: Loading (OBRIGATORIO)
    // ============================================
    group('Loading state', () {
      test('should emit UsersLoading when loadUsers is called', () {
        when(() => getUsersMock(any()))
            .thenAnswer((_) async => Right([UserEntityFixture.valid]));

        testProvider<UsersState>(
          usersProvider,
          overrides: [
            getUsersUseCaseProvider.overrideWithValue(getUsersMock),
          ],
          act: (notifier) async {
            await notifier.loadUsers();
          },
          expect: () => [
            const UsersInitial(),
            const UsersLoading(), // Verifica que Loading foi emitido
            isA<UsersLoaded>(),
          ],
        );
      });
    });

    // ============================================
    // ESTADO 3: Loaded (OBRIGATORIO)
    // ============================================
    group('Loaded state', () {
      test('should emit UsersLoaded with users when loadUsers succeeds', () {
        when(() => getUsersMock(any()))
            .thenAnswer((_) async => Right([UserEntityFixture.valid]));

        testProvider<UsersState>(
          usersProvider,
          overrides: [
            getUsersUseCaseProvider.overrideWithValue(getUsersMock),
          ],
          act: (notifier) async {
            await notifier.loadUsers();
          },
          expect: () => [
            const UsersInitial(),
            const UsersLoading(),
            UsersLoaded(users: [UserEntityFixture.valid]),
          ],
          verify: (notifier) {
            verify(() => getUsersMock(any())).called(1);
          },
        );
      });

      test('should emit UsersLoaded with correct user data', () {
        final expectedUsers = [
          UserEntityFixture.valid,
          UserEntityFixture.alternative,
        ];
        when(() => getUsersMock(any()))
            .thenAnswer((_) async => Right(expectedUsers));

        testProvider<UsersState>(
          usersProvider,
          overrides: [
            getUsersUseCaseProvider.overrideWithValue(getUsersMock),
          ],
          act: (notifier) async {
            await notifier.loadUsers();
          },
          expect: () => [
            const UsersInitial(),
            const UsersLoading(),
            UsersLoaded(users: expectedUsers),
          ],
        );
      });
    });

    // ============================================
    // ESTADO 4: Empty (OBRIGATORIO)
    // ============================================
    group('Empty state', () {
      test('should emit UsersEmpty when loadUsers returns empty list', () {
        when(() => getUsersMock(any()))
            .thenAnswer((_) async => const Right([]));

        testProvider<UsersState>(
          usersProvider,
          overrides: [
            getUsersUseCaseProvider.overrideWithValue(getUsersMock),
          ],
          act: (notifier) async {
            await notifier.loadUsers();
          },
          expect: () => [
            const UsersInitial(),
            const UsersLoading(),
            const UsersEmpty(), // ou UsersLoaded(users: []) dependendo da implementacao
          ],
        );
      });
    });

    // ============================================
    // ESTADO 5: Error (OBRIGATORIO)
    // ============================================
    group('Error state', () {
      test('should emit UsersError with message when ServerFailure', () {
        when(() => getUsersMock(any()))
            .thenAnswer((_) async => Left(ServerFailure()));

        testProvider<UsersState>(
          usersProvider,
          overrides: [
            getUsersUseCaseProvider.overrideWithValue(getUsersMock),
          ],
          act: (notifier) async {
            await notifier.loadUsers();
          },
          expect: () => [
            const UsersInitial(),
            const UsersLoading(),
            isA<UsersError>(),
          ],
        );
      });

      test('should emit UsersError with correct message when NetworkFailure', () {
        when(() => getUsersMock(any()))
            .thenAnswer((_) async => Left(NetworkFailure()));

        testProvider<UsersState>(
          usersProvider,
          overrides: [
            getUsersUseCaseProvider.overrideWithValue(getUsersMock),
          ],
          act: (notifier) async {
            await notifier.loadUsers();
          },
          expect: () => [
            const UsersInitial(),
            const UsersLoading(),
            predicate<UsersState>((state) =>
                state is UsersError &&
                state.message.contains('network') || state.message.contains('conexao')),
          ],
        );
      });

      test('should emit UsersError when UnauthorizedFailure', () {
        when(() => getUsersMock(any()))
            .thenAnswer((_) async => Left(UnauthorizedFailure()));

        testProvider<UsersState>(
          usersProvider,
          overrides: [
            getUsersUseCaseProvider.overrideWithValue(getUsersMock),
          ],
          act: (notifier) async {
            await notifier.loadUsers();
          },
          expect: () => [
            const UsersInitial(),
            const UsersLoading(),
            isA<UsersError>(),
          ],
        );
      });

      test('should emit UsersError when TimeoutFailure', () {
        when(() => getUsersMock(any()))
            .thenAnswer((_) async => Left(TimeoutFailure()));

        testProvider<UsersState>(
          usersProvider,
          overrides: [
            getUsersUseCaseProvider.overrideWithValue(getUsersMock),
          ],
          act: (notifier) async {
            await notifier.loadUsers();
          },
          expect: () => [
            const UsersInitial(),
            const UsersLoading(),
            isA<UsersError>(),
          ],
        );
      });
    });
  });
}
```

---

## Opcao 2: ProviderContainer (Alternativa)

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';

void main() {
  late ProviderContainer container;
  late GetUsersMock getUsersMock;

  setUpAll(() {
    registerFallbackValue(const GetUsersParams());
  });

  setUp(() {
    getUsersMock = GetUsersMock();
    container = ProviderContainer(
      overrides: [
        getUsersUseCaseProvider.overrideWithValue(getUsersMock),
      ],
    );
  });

  tearDown(() {
    reset(getUsersMock);
    container.dispose(); // CRITICO! Evita memory leaks
  });

  group('UsersProvider', () {
    // ============================================
    // ESTADO 1: Initial (OBRIGATORIO)
    // ============================================
    group('Initial state', () {
      test('should have UsersInitial as initial state', () {
        // Assert - sem chamar nenhuma acao
        final state = container.read(usersProvider);
        expect(state, isA<UsersInitial>());
        expect(state, const UsersInitial());
      });
    });

    // ============================================
    // ESTADO 2: Loading (OBRIGATORIO)
    // ============================================
    group('Loading state', () {
      test('should emit UsersLoading during async operation', () async {
        // Arrange - delay para capturar estado loading
        when(() => getUsersMock(any())).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return Right([UserEntityFixture.valid]);
        });

        // Act
        final notifier = container.read(usersProvider.notifier);
        final future = notifier.loadUsers();

        // Assert - estado intermediario
        expect(container.read(usersProvider), isA<UsersLoading>());

        await future;
        expect(container.read(usersProvider), isA<UsersLoaded>());
      });
    });

    // ============================================
    // ESTADO 3: Loaded (OBRIGATORIO)
    // ============================================
    group('Loaded state', () {
      test('should emit UsersLoaded when getUsers succeeds', () async {
        // Arrange
        when(() => getUsersMock(any()))
            .thenAnswer((_) async => Right([UserEntityFixture.valid]));

        // Act
        final notifier = container.read(usersProvider.notifier);
        await notifier.loadUsers();

        // Assert
        final state = container.read(usersProvider);
        expect(state, isA<UsersLoaded>());
        expect((state as UsersLoaded).users, hasLength(1));
        expect(state.users.first.id, UserEntityFixture.valid.id);
      });

      test('should emit UsersLoaded with multiple users', () async {
        // Arrange
        final expectedUsers = [
          UserEntityFixture.valid,
          UserEntityFixture.alternative,
        ];
        when(() => getUsersMock(any()))
            .thenAnswer((_) async => Right(expectedUsers));

        // Act
        final notifier = container.read(usersProvider.notifier);
        await notifier.loadUsers();

        // Assert
        final state = container.read(usersProvider) as UsersLoaded;
        expect(state.users, hasLength(2));
        expect(state.users, equals(expectedUsers));
      });
    });

    // ============================================
    // ESTADO 4: Empty (OBRIGATORIO)
    // ============================================
    group('Empty state', () {
      test('should emit UsersEmpty when getUsers returns empty list', () async {
        // Arrange
        when(() => getUsersMock(any()))
            .thenAnswer((_) async => const Right([]));

        // Act
        final notifier = container.read(usersProvider.notifier);
        await notifier.loadUsers();

        // Assert
        final state = container.read(usersProvider);
        // Dependendo da implementacao: UsersEmpty ou UsersLoaded com lista vazia
        expect(
          state,
          anyOf(
            isA<UsersEmpty>(),
            predicate<UsersState>((s) => s is UsersLoaded && s.users.isEmpty),
          ),
        );
      });
    });

    // ============================================
    // ESTADO 5: Error (OBRIGATORIO)
    // ============================================
    group('Error state', () {
      test('should emit UsersError when ServerFailure', () async {
        // Arrange
        when(() => getUsersMock(any()))
            .thenAnswer((_) async => Left(ServerFailure()));

        // Act
        final notifier = container.read(usersProvider.notifier);
        await notifier.loadUsers();

        // Assert
        final state = container.read(usersProvider);
        expect(state, isA<UsersError>());
      });

      test('should emit UsersError with message when NetworkFailure', () async {
        // Arrange
        when(() => getUsersMock(any()))
            .thenAnswer((_) async => Left(NetworkFailure()));

        // Act
        final notifier = container.read(usersProvider.notifier);
        await notifier.loadUsers();

        // Assert
        final state = container.read(usersProvider);
        expect(state, isA<UsersError>());
        expect((state as UsersError).message, isNotEmpty);
      });

      test('should emit UsersError when UnauthorizedFailure', () async {
        // Arrange
        when(() => getUsersMock(any()))
            .thenAnswer((_) async => Left(UnauthorizedFailure()));

        // Act
        final notifier = container.read(usersProvider.notifier);
        await notifier.loadUsers();

        // Assert
        final state = container.read(usersProvider);
        expect(state, isA<UsersError>());
      });

      test('should emit UsersError when TimeoutFailure', () async {
        // Arrange
        when(() => getUsersMock(any()))
            .thenAnswer((_) async => Left(TimeoutFailure()));

        // Act
        final notifier = container.read(usersProvider.notifier);
        await notifier.loadUsers();

        // Assert
        final state = container.read(usersProvider);
        expect(state, isA<UsersError>());
      });
    });
  });
}
```

---

## Testando Transicoes de Estado

```dart
group('State transitions', () {
  test('should transition Initial -> Loading -> Loaded', () async {
    final states = <UsersState>[];

    when(() => getUsersMock(any())).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 50));
      return Right([UserEntityFixture.valid]);
    });

    // Capturar transicoes
    container.listen(usersProvider, (_, state) => states.add(state));

    // Act
    await container.read(usersProvider.notifier).loadUsers();

    // Assert - ordem das transicoes
    expect(states, [
      isA<UsersLoading>(),
      isA<UsersLoaded>(),
    ]);
  });

  test('should transition Initial -> Loading -> Error', () async {
    final states = <UsersState>[];

    when(() => getUsersMock(any())).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 50));
      return Left(ServerFailure());
    });

    container.listen(usersProvider, (_, state) => states.add(state));

    await container.read(usersProvider.notifier).loadUsers();

    expect(states, [
      isA<UsersLoading>(),
      isA<UsersError>(),
    ]);
  });
});
```

---

## Testando Multiplas Acoes

```dart
group('Multiple actions', () {
  test('should handle refresh correctly', () async {
    // Arrange - primeira carga
    when(() => getUsersMock(any()))
        .thenAnswer((_) async => Right([UserEntityFixture.valid]));

    final notifier = container.read(usersProvider.notifier);
    await notifier.loadUsers();
    expect(container.read(usersProvider), isA<UsersLoaded>());

    // Act - refresh com novos dados
    when(() => getUsersMock(any()))
        .thenAnswer((_) async => Right([
          UserEntityFixture.valid,
          UserEntityFixture.alternative,
        ]));
    await notifier.refresh();

    // Assert
    final state = container.read(usersProvider) as UsersLoaded;
    expect(state.users, hasLength(2));
  });

  test('should handle retry after error', () async {
    // Arrange - primeira tentativa falha
    when(() => getUsersMock(any()))
        .thenAnswer((_) async => Left(NetworkFailure()));

    final notifier = container.read(usersProvider.notifier);
    await notifier.loadUsers();
    expect(container.read(usersProvider), isA<UsersError>());

    // Act - retry com sucesso
    when(() => getUsersMock(any()))
        .thenAnswer((_) async => Right([UserEntityFixture.valid]));
    await notifier.loadUsers();

    // Assert
    expect(container.read(usersProvider), isA<UsersLoaded>());
  });
});
```

---

## Testes Parametrizados para Erros

```dart
group('Error mapping', () {
  final errorCases = [
    (ServerFailure(), 'ServerFailure'),
    (NetworkFailure(), 'NetworkFailure'),
    (TimeoutFailure(), 'TimeoutFailure'),
    (UnauthorizedFailure(), 'UnauthorizedFailure'),
    (NotFoundFailure(), 'NotFoundFailure'),
  ];

  for (final (failure, name) in errorCases) {
    test('should emit UsersError when $name occurs', () async {
      // Arrange
      when(() => getUsersMock(any()))
          .thenAnswer((_) async => Left(failure));

      // Act
      await container.read(usersProvider.notifier).loadUsers();

      // Assert
      expect(container.read(usersProvider), isA<UsersError>());
    });
  }
});
```

---

## Regras Criticas

1. **container.dispose() no tearDown** - OBRIGATORIO
2. **reset() mocks no tearDown** - NAO no setUp
3. **registerFallbackValue no setUpAll** - para tipos complexos
4. **Novo container por teste** - isolamento total
5. **Testar TODOS os estados** - sem excecao

---

## Checklist de Estados (OBRIGATORIO)

- [ ] **Initial**: Estado antes de qualquer acao
- [ ] **Loading**: Durante operacao async
- [ ] **Loaded**: Sucesso com dados
- [ ] **Empty**: Sucesso sem dados (lista vazia)
- [ ] **Error (Server)**: ServerFailure
- [ ] **Error (Network)**: NetworkFailure
- [ ] **Error (Timeout)**: TimeoutFailure
- [ ] **Error (Unauthorized)**: UnauthorizedFailure
- [ ] **Transicoes**: Ordem correta dos estados
- [ ] **Retry**: Recuperacao apos erro
