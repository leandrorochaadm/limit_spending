---
paths:
  - "test/**"
---

# Testing Rules

## Framework & Tools
- Flutter test + Riverpod + Mocktail
- Clean Architecture test structure mirrors `lib/` structure

## Test Structure
```
test/features/{feature}/
  ├── data/
  │   ├── datasources/{feature}_remote_data_source_test.dart
  │   ├── models/{feature}_model_test.dart
  │   └── repositories/{feature}_repository_impl_test.dart
  ├── domain/
  │   └── usecases/{action}_use_case_test.dart
  └── presentation/
      └── providers/{feature}_provider_test.dart
```

## Naming Conventions
- File: `{original_name}_test.dart`
- Group: `describe('{ClassName}', ...)`
- Test: descriptive `'should return X when Y'`

## Mocking
- Use `mocktail` (NOT mockito)
- Mock classes: `class MockMyRepo extends Mock implements MyRepository {}`
- Register fallback values for custom types in `setUpAll`

## Test Patterns by Layer

### DataSource Tests
- Mock `ApiClient`
- Verify correct endpoint called
- Verify Model parsed from JSON
- Test exception handling (rethrow)

### Repository Tests
- Mock DataSource
- Verify `Either<Failure, Entity>` returned
- Verify Model -> Entity conversion via `toEntity()`
- Verify exception -> Failure mapping via `handleException`

### UseCase Tests
- Mock Repository
- Verify `call()` delegates to repository
- Test with correct Params

### Provider Tests
- Mock UseCases
- Verify state transitions: Initial -> Loading -> Loaded/Error
- Verify `_mapFailure()` converte Failure → mensagem correta no estado de erro
- Use `ProviderContainer` for testing

## Skills
- For detailed templates, use `/create_tests` skill
