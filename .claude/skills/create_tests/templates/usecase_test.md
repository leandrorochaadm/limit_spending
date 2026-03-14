# Template: UseCase Test

## Estrutura Completa

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

// Mocks
class UserRepositoryMock extends Mock implements UserRepository {}

void main() {
  late UserRepositoryMock repositoryMock;
  late GetUserUseCase useCase;

  setUpAll(() {
    // OBRIGATORIO: Registrar tipos complexos para any()
    registerFallbackValue(const GetUserParams(id: ''));
  });

  setUp(() {
    repositoryMock = UserRepositoryMock();
    useCase = GetUserUseCase(repository: repositoryMock);
  });

  tearDown(() {
    reset(repositoryMock); // Reset no tearDown, NAO no setUp
  });

  group('GetUserUseCase', () {
    group('Success cases', () {
      test('should return user when repository call succeeds', () async {
        // Arrange
        when(() => repositoryMock.getUserById(any()))
            .thenAnswer((_) async => Right(UserEntityFixture.valid));

        // Act
        final result = await useCase(const GetUserParams(id: '123'));

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected Right'),
          (user) => expect(user.id, '123'),
        );
      });

      test('should call repository with correct parameters', () async {
        // Arrange
        when(() => repositoryMock.getUserById(any()))
            .thenAnswer((_) async => Right(UserEntityFixture.valid));

        // Act
        await useCase(const GetUserParams(id: '123'));

        // Assert - verificar parametros especificos
        verify(() => repositoryMock.getUserById('123')).called(1);
      });
    });

    group('Error cases', () {
      test('should return ServerFailure when repository throws', () async {
        // Arrange
        when(() => repositoryMock.getUserById(any()))
            .thenAnswer((_) async => Left(ServerFailure()));

        // Act
        final result = await useCase(const GetUserParams(id: '123'));

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (_) => fail('Expected Left'),
        );
      });

      test('should return NetworkFailure when no connection', () async {
        // Arrange
        when(() => repositoryMock.getUserById(any()))
            .thenAnswer((_) async => Left(NetworkFailure()));

        // Act
        final result = await useCase(const GetUserParams(id: '123'));

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, isA<NetworkFailure>()),
          (_) => fail('Expected Left'),
        );
      });
    });
  });
}
```

## UseCase sem Parametros (NoParams)

```dart
import 'package:clyvo_mobile/core/usecases/usecase.dart';

void main() {
  late UserRepositoryMock repositoryMock;
  late GetAllUsersUseCase useCase;

  setUp(() {
    repositoryMock = UserRepositoryMock();
    useCase = GetAllUsersUseCase(repository: repositoryMock);
  });

  tearDown(() => reset(repositoryMock));

  group('GetAllUsersUseCase', () {
    test('should return list of users', () async {
      // Arrange
      when(() => repositoryMock.getUsers())
          .thenAnswer((_) async => Right([UserEntityFixture.valid]));

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (users) => expect(users, hasLength(1)),
      );
    });

    test('should return empty list when no users', () async {
      // Arrange
      when(() => repositoryMock.getUsers())
          .thenAnswer((_) async => const Right([]));

      // Act
      final result = await useCase(NoParams());

      // Assert
      result.fold(
        (_) => fail('Expected Right'),
        (users) => expect(users, isEmpty),
      );
    });
  });
}
```

## Cenarios Obrigatorios para UseCase

1. **Success case**: retorno esperado
2. **Error case**: ServerFailure
3. **Network case**: NetworkFailure
4. **Timeout case**: TimeoutFailure
5. **Verify call**: parametros corretos
6. **Empty result**: lista vazia (se aplicavel)
