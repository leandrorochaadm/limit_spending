# Template: DataSource Test

## Estrutura Completa

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class ApiClientMock extends Mock implements ApiClient {}

void main() {
  late ApiClientMock apiClientMock;
  late UserRemoteDataSource dataSource;

  setUp(() {
    apiClientMock = ApiClientMock();
    dataSource = UserRemoteDataSourceImpl(apiClient: apiClientMock);
  });

  tearDown(() => reset(apiClientMock));

  group('UserRemoteDataSource', () {
    group('getUserById', () {
      test('should call GET with correct endpoint', () async {
        // Arrange
        when(() => apiClientMock.get(any()))
            .thenAnswer((_) async => UserModelFixture.validJson);

        // Act
        await dataSource.getUserById('123');

        // Assert
        verify(() => apiClientMock.get('/users/123')).called(1);
      });

      test('should return UserModel when API succeeds', () async {
        // Arrange
        when(() => apiClientMock.get(any()))
            .thenAnswer((_) async => UserModelFixture.validJson);

        // Act
        final result = await dataSource.getUserById('123');

        // Assert
        expect(result, isA<UserModel>());
        expect(result.id, '123');
      });

      test('should throw ServerException when API returns 500', () async {
        // Arrange
        when(() => apiClientMock.get(any()))
            .thenThrow(ServerException());

        // Assert
        expect(
          () async => await dataSource.getUserById('123'),
          throwsA(isA<ServerException>()),
        );
      });
    });

    group('createUser', () {
      test('should call POST with correct endpoint and body', () async {
        // Arrange
        when(() => apiClientMock.post(any(), data: any(named: 'data')))
            .thenAnswer((_) async => UserModelFixture.createResponseJson);

        // Act
        await dataSource.createUser(
          fullName: 'John Doe',
          email: 'john@example.com',
        );

        // Assert
        verify(() => apiClientMock.post(
          '/users',
          data: {
            'fullName': 'John Doe',
            'email': 'john@example.com',
          },
        )).called(1);
      });

      test('should return created UserModel', () async {
        // Arrange
        when(() => apiClientMock.post(any(), data: any(named: 'data')))
            .thenAnswer((_) async => UserModelFixture.createResponseJson);

        // Act
        final result = await dataSource.createUser(
          fullName: 'John Doe',
          email: 'john@example.com',
        );

        // Assert
        expect(result, isA<UserModel>());
      });
    });

    group('updateUser', () {
      test('should call PUT with correct endpoint and body', () async {
        // Arrange
        when(() => apiClientMock.put(any(), data: any(named: 'data')))
            .thenAnswer((_) async => UserModelFixture.validJson);

        // Act
        await dataSource.updateUser(
          id: '123',
          fullName: 'Updated Name',
        );

        // Assert
        verify(() => apiClientMock.put(
          '/users/123',
          data: {'fullName': 'Updated Name'},
        )).called(1);
      });
    });

    group('deleteUser', () {
      test('should call DELETE with correct endpoint', () async {
        // Arrange
        when(() => apiClientMock.delete(any()))
            .thenAnswer((_) async => {});

        // Act
        await dataSource.deleteUser('123');

        // Assert
        verify(() => apiClientMock.delete('/users/123')).called(1);
      });
    });
  });
}
```

## Testando Query Parameters

```dart
test('should call GET with query parameters', () async {
  // Arrange
  when(() => apiClientMock.get(any(), queryParameters: any(named: 'queryParameters')))
      .thenAnswer((_) async => []);

  // Act
  await dataSource.searchUsers(query: 'john', page: 1, limit: 10);

  // Assert
  verify(() => apiClientMock.get(
    '/users/search',
    queryParameters: {
      'query': 'john',
      'page': 1,
      'limit': 10,
    },
  )).called(1);
});
```

## Testando Headers Customizados

```dart
test('should call API with custom headers', () async {
  // Arrange
  when(() => apiClientMock.get(any(), headers: any(named: 'headers')))
      .thenAnswer((_) async => UserModelFixture.validJson);

  // Act
  await dataSource.getUserWithAuth('123', token: 'bearer-token');

  // Assert
  verify(() => apiClientMock.get(
    '/users/123',
    headers: {'Authorization': 'Bearer bearer-token'},
  )).called(1);
});
```

## Cenarios Obrigatorios para DataSource

1. **Endpoint correto**: verify com path exato
2. **Body correto**: verify com dados exatos
3. **Retorno correto**: Model parseado
4. **Exceptions**: ServerException, NetworkException
5. **Query params**: se aplicavel
