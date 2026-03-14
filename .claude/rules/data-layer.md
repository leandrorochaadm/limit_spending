---
paths:
  - "lib/features/*/data/**"
---

# Data Layer Rules

## DataSources

- Classe abstrata + implementação (`[Feature]RemoteDataSource` / `Impl`)
- **MUST** return Models (strongly typed), NEVER `Map<String, dynamic>`
- **MUST** wrap API calls in try-catch blocks and rethrow
- `ApiClient` already converts `DioException` to custom exceptions
- Verificar rede com `AppUtils.hasNetworkConnection()`
- Lançar exceptions de `@lib/core/error/exceptions.dart`

## Models

- **MUST NOT** extend Entity — são classes **separadas** (nunca herda Entity)
- Use **`@JsonSerializable(includeIfNull: false)`** — SEMPRE com `includeIfNull: false` para não serializar campos nulos
- **MUST** have `toEntity()` method for conversion to Entity
- **MUST** have `fromEntity()` factory for conversion from Entity (quando necessário para salvar)
- **MUST NOT** have `copyWith()` methods

### Nullability dos campos — verificar SEMPRE no backend antes de decidir
**Antes de declarar um campo como `String?` no model, verificar no backend:**
1. O schema do banco (migration): campo é `nullable: true` ou `isNullable: false`?
2. O controller/service: retorna `value || ''` ou `value ?? ''`? (significa que nunca vem null na resposta)
3. O `.proto` (protobuf3): campos sem `optional` têm valor padrão (`""` para string), nunca null

**Só usar `String?` se o backend puder retornar `null` de verdade** — caso contrário, `String` com possível valor vazio.

### Dart 3.11 — `@JsonSerializable(includeIfNull: false)` funciona normalmente
O projeto usa **Dart 3.11**. Os avisos do build_runner sobre versão de SDK podem ser ignorados — são falsos positivos da constraint do `json_annotation`.
Campos `String?` com `includeIfNull: false` geram código válido sem workarounds.
- Após adicionar: `dart run build_runner build --build-filter="lib/features/**/data/models/**" --delete-conflicting-outputs`

```dart
@JsonSerializable(includeIfNull: false)
class BiddingModel {
  @JsonKey(name: 'nr_edital')
  final String number;

  BiddingModel({required this.number});

  factory BiddingModel.fromJson(Map<String, dynamic> json) =>
      _$BiddingModelFromJson(json);

  Map<String, dynamic> toJson() => _$BiddingModelToJson(this);

  // Ponte entre camadas — conversão
  BiddingEntity toEntity() => BiddingEntity(number: number);

  factory BiddingModel.fromEntity(BiddingEntity entity) =>
      BiddingModel(number: entity.number);
}
```

### Build Runner (com filtro para performance)

```bash
# Gera só os models
dart run build_runner build --build-filter="lib/features/**/data/models/**" --delete-conflicting-outputs

# Watch mode
dart run build_runner watch --build-filter="lib/features/**/data/models/**" --delete-conflicting-outputs
```

O `build.yaml` na raiz do projeto já restringe o `json_serializable` para gerar código **apenas** em `lib/features/**/data/models/`, evitando geração acidental em outras pastas.

## Repositories

- **MUST** apply mixins: `with LoggerMixin, ExceptionHandlerMixin implements MyRepository`
  - `LoggerMixin` FIRST, `ExceptionHandlerMixin` SECOND (depends on LoggerMixin via `on`)
- Return `Either<Failure, T>` (dartz)
- **MUST** return Entity (never Model) — conversion via `model.toEntity()`
- Use `handleException(e, stackTrace)` from `ExceptionHandlerMixin` (no manual catch per exception type)
- Definir Provider no final do arquivo

### Return Types Permitidos
- `Either<Failure, Entity>` / `Either<Failure, List<Entity>>`
- `Either<Failure, void>` / `Either<Failure, bool>` / `Either<Failure, String>` / `Either<Failure, int>`
- **NEVER** `Either<Failure, Model>` / `Either<Failure, Map<String, dynamic>>`

## Exception -> Failure Mapping (via ExceptionHandlerMixin)
- `NetworkException` -> `NetworkFailure`
- `TimeoutException` -> `TimeoutFailure`
- `ServerException` -> `ServerFailure`
- `BadRequestException` -> `InputFailure`
- `UnauthorizedException` -> `UnauthorizedFailure`
- `ForbiddenException` -> `ForbiddenFailure`
- `NotFoundException` -> `NotFoundFailure`
- `RequestCancelledException` -> `RequestCancelledFailure`
- `CacheException` -> `CacheFailure`
- `AuthenticationException` -> `AuthFailure`
- Any other -> `ServerFailure` (fallback)

## API Endpoints

- **MUST** be defined as constants in `AppConstants` (`@lib/core/constants/app_constants.dart`)
- Naming: `{featureName}{ActionOrType}Endpoint` (e.g. `consultationsImmediateEndpoint`)
- **NEVER** hardcode endpoints in datasource methods

## Templates
- DataSource: see `@.claude/rules/templates/datasource_template.md`
- Model: see `@.claude/rules/templates/model_template.md`
- Repository: see `@.claude/rules/templates/repository_template.md`
