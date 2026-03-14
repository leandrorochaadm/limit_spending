# Template: Repository Test

## Estrutura Completa

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

// Mocks
class UserRemoteDataSourceMock extends Mock implements UserRemoteDataSource {}

void main() {
  late UserRemoteDataSourceMock dataSourceMock;
  late UserRepository repository;

  setUp(() {
    dataSourceMock = UserRemoteDataSourceMock();
    repository = UserRepositoryImpl(dataSource: dataSourceMock);
  });

  tearDown(() => reset(dataSourceMock));

  group('UserRepository', () {
    group('getUserById', () {
      group('Success cases', () {
        test('should return Right(user) when datasource succeeds', () async {
          // Arrange
          when(() => dataSourceMock.getUserById(any()))
              .thenAnswer((_) async => UserModelFixture.valid);

          // Act
          final result = await repository.getUserById('123');

          // Assert
          expect(result.isRight(), isTrue);
          result.fold(
            (failure) => fail('Expected Right'),
            (user) => expect(user.id, '123'),
          );
        });

        test('should return empty list when datasource returns empty', () async {
          // Arrange
          when(() => dataSourceMock.getUsers())
              .thenAnswer((_) async => []);

          // Act
          final result = await repository.getUsers();

          // Assert
          result.fold(
            (_) => fail('Expected Right'),
            (users) => expect(users, isEmpty),
          );
        });
      });

      group('Error cases', () {
        test('should return Left(ServerFailure) when ServerException thrown', () async {
          // Arrange
          when(() => dataSourceMock.getUserById(any()))
              .thenThrow(ServerException());

          // Act
          final result = await repository.getUserById('123');

          // Assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) => expect(failure, isA<ServerFailure>()),
            (_) => fail('Expected Left'),
          );
        });

        test('should return Left(NetworkFailure) when NetworkException thrown', () async {
          // Arrange
          when(() => dataSourceMock.getUserById(any()))
              .thenThrow(NetworkException());

          // Act
          final result = await repository.getUserById('123');

          // Assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) => expect(failure, isA<NetworkFailure>()),
            (_) => fail('Expected Left'),
          );
        });

        test('should return Left(TimeoutFailure) when TimeoutException thrown', () async {
          // Arrange
          when(() => dataSourceMock.getUserById(any()))
              .thenThrow(TimeoutException());

          // Act
          final result = await repository.getUserById('123');

          // Assert
          result.fold(
            (failure) => expect(failure, isA<TimeoutFailure>()),
            (_) => fail('Expected Left'),
          );
        });

        test('should return Left(UnauthorizedFailure) when UnauthorizedException thrown', () async {
          // Arrange
          when(() => dataSourceMock.getUserById(any()))
              .thenThrow(UnauthorizedException());

          // Act
          final result = await repository.getUserById('123');

          // Assert
          result.fold(
            (failure) => expect(failure, isA<UnauthorizedFailure>()),
            (_) => fail('Expected Left'),
          );
        });
      });
    });
  });
}
```

## Mapeamento Exception -> Failure

Use esta tabela para testar conversoes:

| Exception | Failure | HTTP Code |
|-----------|---------|-----------|
| `NetworkException` | `NetworkFailure` | - (sem conexao) |
| `ServerException` | `ServerFailure` | 500+ |
| `BadRequestException` | `ValidationFailure` | 400 |
| `UnauthorizedException` | `UnauthorizedFailure` | 401 |
| `ForbiddenException` | `ForbiddenFailure` | 403 |
| `NotFoundException` | `NotFoundFailure` | 404 |
| `TimeoutException` | `TimeoutFailure` | timeout |
| `CacheException` | `CacheFailure` | cache local |

## Testes Parametrizados (DRY)

```dart
group('Exception to Failure mapping', () {
  final errorCases = [
    (ServerException(), ServerFailure),
    (NetworkException(), NetworkFailure),
    (TimeoutException(), TimeoutFailure),
    (NotFoundException(), NotFoundFailure),
    (UnauthorizedException(), UnauthorizedFailure),
    (ForbiddenException(), ForbiddenFailure),
  ];

  for (final (exception, failureType) in errorCases) {
    test('should return $failureType when ${exception.runtimeType} is thrown', () async {
      // Arrange
      when(() => dataSourceMock.getUserById(any())).thenThrow(exception);

      // Act
      final result = await repository.getUserById('123');

      // Assert
      expect(result.fold((f) => f.runtimeType, (_) => null), failureType);
    });
  }
});
```

## Cenarios Obrigatorios para Repository

1. **Success case**: Right com dados
2. **ServerException**: ServerFailure
3. **NetworkException**: NetworkFailure
4. **TimeoutException**: TimeoutFailure
5. **UnauthorizedException**: UnauthorizedFailure
6. **Empty data**: lista/dados vazios
