# Template: Mock

## Estrutura Padrao com setupDefaults()

```dart
import 'package:mocktail/mocktail.dart';

class UserRepositoryMock extends Mock implements UserRepository {
  /// Configura comportamentos padrao do mock
  static void setupDefaults(UserRepositoryMock mock, {UserEntity? user}) {
    when(() => mock.getUserById(any()))
        .thenAnswer((_) async => Right(user ?? UserEntityFixture.valid));

    when(() => mock.getUsers())
        .thenAnswer((_) async => Right([UserEntityFixture.valid]));

    when(() => mock.createUser(any()))
        .thenAnswer((_) async => Right(UserEntityFixture.valid));

    when(() => mock.updateUser(any()))
        .thenAnswer((_) async => Right(UserEntityFixture.valid));

    when(() => mock.deleteUser(any()))
        .thenAnswer((_) async => const Right(unit));
  }

  /// Configura comportamentos de erro
  static void setupErrors(UserRepositoryMock mock, {Failure? failure}) {
    final errorFailure = failure ?? ServerFailure();

    when(() => mock.getUserById(any()))
        .thenAnswer((_) async => Left(errorFailure));

    when(() => mock.getUsers())
        .thenAnswer((_) async => Left(errorFailure));

    when(() => mock.createUser(any()))
        .thenAnswer((_) async => Left(errorFailure));
  }

  /// Configura erro de rede
  static void setupNetworkError(UserRepositoryMock mock) {
    when(() => mock.getUserById(any()))
        .thenAnswer((_) async => Left(NetworkFailure()));

    when(() => mock.getUsers())
        .thenAnswer((_) async => Left(NetworkFailure()));
  }
}
```

## Uso nos Testes

```dart
late UserRepositoryMock repositoryMock;

setUp(() {
  repositoryMock = UserRepositoryMock();
  UserRepositoryMock.setupDefaults(repositoryMock);
});

tearDown(() => reset(repositoryMock));

test('should return user', () async {
  // setupDefaults ja configurou o comportamento padrao
  final result = await repository.getUserById('123');
  expect(result.isRight(), isTrue);
});

test('should handle error', () async {
  // Sobrescreve com erro
  UserRepositoryMock.setupErrors(repositoryMock);

  final result = await repository.getUserById('123');
  expect(result.isLeft(), isTrue);
});
```

---

## registerFallbackValue() - Quando e Como Usar

**OBRIGATORIO para tipos complexos em mocktail.** Deve ser registrado em `setUpAll()`:

```dart
void main() {
  // OBRIGATORIO: Registrar ANTES dos testes
  setUpAll(() {
    // Para Params de UseCases
    registerFallbackValue(const GetUsersParams());
    registerFallbackValue(const LoginParams(email: '', password: ''));

    // Para Enums
    registerFallbackValue(DocumentType.rg);
    registerFallbackValue(UserStatus.active);

    // Para Entities/Models
    registerFallbackValue(UserEntityFixture.valid);
    registerFallbackValue(ConsultationModelFixture.valid);
  });

  // ... resto dos testes
}
```

**Quando registrar:**
- Qualquer classe customizada usada com `any()`
- Enums usados com `any()`
- Entities/Models passados como parametros em mocks

---

## Mock de DataSource

```dart
class UserRemoteDataSourceMock extends Mock implements UserRemoteDataSource {
  static void setupDefaults(UserRemoteDataSourceMock mock) {
    when(() => mock.getUserById(any()))
        .thenAnswer((_) async => UserModelFixture.valid);

    when(() => mock.getUsers())
        .thenAnswer((_) async => [UserModelFixture.valid]);

    when(() => mock.createUser(
      fullName: any(named: 'fullName'),
      email: any(named: 'email'),
    )).thenAnswer((_) async => UserModelFixture.valid);
  }

  static void setupThrows(UserRemoteDataSourceMock mock, Exception exception) {
    when(() => mock.getUserById(any())).thenThrow(exception);
    when(() => mock.getUsers()).thenThrow(exception);
  }
}
```

---

## Mock de UseCase

```dart
class GetUserUseCaseMock extends Mock implements GetUserUseCase {
  static void setupDefaults(GetUserUseCaseMock mock) {
    when(() => mock(any()))
        .thenAnswer((_) async => Right(UserEntityFixture.valid));
  }

  static void setupError(GetUserUseCaseMock mock, Failure failure) {
    when(() => mock(any()))
        .thenAnswer((_) async => Left(failure));
  }
}
```

---

## Mock de ApiClient

```dart
class ApiClientMock extends Mock implements ApiClient {
  static void setupDefaults(ApiClientMock mock) {
    when(() => mock.get(any(), queryParameters: any(named: 'queryParameters')))
        .thenAnswer((_) async => {});

    when(() => mock.post(any(), data: any(named: 'data')))
        .thenAnswer((_) async => {});

    when(() => mock.put(any(), data: any(named: 'data')))
        .thenAnswer((_) async => {});

    when(() => mock.delete(any()))
        .thenAnswer((_) async => {});
  }

  static Response<T> createSuccessResponse<T>(T data) {
    return Response(
      requestOptions: RequestOptions(path: ''),
      data: data,
      statusCode: 200,
    );
  }

  static Response createErrorResponse(int statusCode, String message) {
    return Response(
      requestOptions: RequestOptions(path: ''),
      data: {'message': message},
      statusCode: statusCode,
    );
  }
}
```

---

## Mock de StateNotifier (para Widget Tests)

```dart
class AuthNotifierMock extends Mock implements AuthNotifier {
  // Mock precisa retornar state
  @override
  AuthState get state => _state;

  AuthState _state = const AuthInitial();

  void setState(AuthState state) {
    _state = state;
  }
}

// Uso
setUp(() {
  authNotifierMock = AuthNotifierMock();
});

test('should show error', () {
  authNotifierMock.setState(const AuthError('Error'));
  // ou
  when(() => authNotifierMock.state).thenReturn(const AuthError('Error'));
});
```

---

## Regras Criticas

1. **setupDefaults()**: Metodo estatico de configuracao
2. **reset() no tearDown**: NAO no setUp
3. **registerFallbackValue**: Para tipos complexos com any()
4. **setUpAll**: Registrar fallbacks antes dos testes
5. **Nomenclatura**: ClasseMock (sufixo Mock)
