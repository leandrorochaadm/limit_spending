# Template: Fixture

## Estrutura Padrao (DRY)

```dart
/// Fixture para UserEntity - fonte unica de verdade
class UserEntityFixture {
  // === CONSTANTES BASE (fonte unica) ===
  static const _defaultId = '123';
  static const _defaultName = 'John Doe';
  static const _defaultEmail = 'john@example.com';
  static const _defaultPhone = '+5511999999999';
  static final _defaultCreatedAt = DateTime(2024, 1, 1);

  // === JSON DATA (usa constantes base) ===
  static const Map<String, dynamic> validData = {
    'id': _defaultId,
    'name': _defaultName,
    'email': _defaultEmail,
    'phone': _defaultPhone,
    'createdAt': '2024-01-01T00:00:00.000Z',
  };

  // Variacao: apenas sobrescreve o necessario
  static Map<String, dynamic> get expiredData => {
    ...validData,
    'expiresAt': '2020-01-01T00:00:00Z',
  };

  static Map<String, dynamic> get withoutPhoneData => {
    ...validData,
  }..remove('phone');

  // === ENTITIES (getters static, NAO funcoes) ===
  static UserEntity get valid => UserEntity(
    id: _defaultId,
    name: _defaultName,
    email: _defaultEmail,
    phone: _defaultPhone,
    createdAt: _defaultCreatedAt,
  );

  // Variacao com dados diferentes
  static UserEntity get alternative => const UserEntity(
    id: '456',
    name: 'Jane Doe',
    email: 'jane@example.com',
    phone: '+5511888888888',
    createdAt: DateTime(2024, 2, 1),
  );

  // Entity vazia (para comparacoes)
  static UserEntity get empty => UserEntity.empty();

  // === FACTORY (para customizacao) ===
  static UserEntity create({
    String? id,
    String? name,
    String? email,
    String? phone,
    DateTime? createdAt,
  }) => UserEntity(
    id: id ?? _defaultId,
    name: name ?? _defaultName,
    email: email ?? _defaultEmail,
    phone: phone ?? _defaultPhone,
    createdAt: createdAt ?? _defaultCreatedAt,
  );

  // === LISTAS ===
  static List<UserEntity> get validList => [valid, alternative];

  static List<UserEntity> get emptyList => [];
}
```

## Uso nos Testes

```dart
// Getter static (recomendado para casos comuns)
final user = UserEntityFixture.valid;
final altUser = UserEntityFixture.alternative;
final emptyUser = UserEntityFixture.empty;

// Factory method (apenas quando precisa customizar)
final customUser = UserEntityFixture.create(email: 'custom@test.com');

// JSON data (para DataSource tests)
final json = UserEntityFixture.validData;

// Listas
final users = UserEntityFixture.validList;
```

## Fixture para Model (com fromJson)

```dart
class UserModelFixture {
  static const _defaultId = '123';
  static const _defaultName = 'John Doe';
  static const _defaultEmail = 'john@example.com';

  // JSON para testes de parsing
  static const Map<String, dynamic> validJson = {
    'id': _defaultId,
    'name': _defaultName,
    'email': _defaultEmail,
  };

  static Map<String, dynamic> get createResponseJson => {
    ...validJson,
    'createdAt': '2024-01-01T00:00:00.000Z',
  };

  // Model instances
  static UserModel get valid => UserModel.fromJson(validJson);

  static UserModel get alternative => UserModel.fromJson({
    'id': '456',
    'name': 'Jane Doe',
    'email': 'jane@example.com',
  });
}
```

---

## FixtureReader - Ler JSON de Arquivos

Use `@test/core/helpers/fixture_reader.dart`:

```dart
class FixtureReader {
  /// Le arquivo JSON como String
  static String fixture(String feature, String name) {
    final path = 'test/features/$feature/fixtures/$name';
    return File(path).readAsStringSync();
  }

  /// Le arquivo JSON como Map
  static Map<String, dynamic> fixtureMap(String feature, String name) =>
    json.decode(fixture(feature, name)) as Map<String, dynamic>;

  /// Le arquivo JSON como List
  static List<dynamic> fixtureList(String feature, String name) =>
    json.decode(fixture(feature, name)) as List<dynamic>;
}

// Uso:
final json = FixtureReader.fixtureMap('auth', 'login_response.json');
final list = FixtureReader.fixtureList('patients', 'get_patients_response.json');
```

---

## Nomenclatura de Fixtures JSON

| Operacao | Padrao de Nome | Exemplo |
|----------|----------------|---------|
| GET (single) | `get_[entity]_response.json` | `get_user_response.json` |
| GET (list) | `get_[entities]_response.json` | `get_patients_response.json` |
| POST | `create_[entity]_response.json` | `create_consultation_response.json` |
| PUT/PATCH | `update_[entity]_response.json` | `update_profile_response.json` |
| DELETE | `delete_[entity]_response.json` | `delete_document_response.json` |
| Search | `search_[entities]_response.json` | `search_doctors_response.json` |
| Error | `[operation]_error_response.json` | `login_error_response.json` |

---

## Estrutura de Pastas

```
test/features/auth/
├── fixtures/                      # JSON fixtures
│   ├── login_response.json
│   ├── login_error_response.json
│   └── get_user_response.json
├── domain/
│   └── entities/
│       └── user_entity_fixture.dart
└── data/
    └── models/
        └── user_model_fixture.dart
```

---

## Regras Criticas

1. **Constantes base**: Derive tudo de constantes base
2. **Getters static**: NAO use funcoes para entities
3. **validData**: JSON para testes de DataSource
4. **valid getter**: Entity para testes de UseCase/Repository
5. **create factory**: Apenas para customizacao pontual
6. **Nomenclatura JSON**: Siga a tabela acima
