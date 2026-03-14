# Template: Best Practices

## Matchers Especificos (flutter_test)

```dart
// Matchers para Either (dartz)
expect(result.isRight(), isTrue);
expect(result.isLeft(), isTrue);

// Matchers para colecoes
expect(list, isEmpty);
expect(list, isNotEmpty);
expect(list, hasLength(3));
expect(list, contains(item));
expect(list, containsAll([item1, item2]));

// Matchers para valores
expect(value, isNull);
expect(value, isNotNull);
expect(value, isZero);
expect(value, isPositive);
expect(value, isNegative);

// Matchers para tipos
expect(object, isA<UserEntity>());
expect(failure, isA<ServerFailure>());

// Matchers para Futures
expect(future, completes);
expect(future, throwsA(isA<ServerException>()));
expect(() async => await fn(), throwsA(isA<Exception>()));

// Matchers para Streams
expect(stream, emits(expectedValue));
expect(stream, emitsInOrder([value1, value2]));
expect(stream, neverEmits(badValue));
expect(stream, emitsError(isA<Exception>()));
```

---

## Testes Parametrizados (DRY)

```dart
// Testar multiplos inputs
group('Email validation', () {
  final testCases = [
    ('valid@email.com', true),
    ('invalid.email', false),
    ('@missing.local', false),
    ('missing@domain', false),
    ('', false),
  ];

  for (final (email, expected) in testCases) {
    test('should return $expected for "$email"', () {
      expect(EmailValidator.isValid(email), expected);
    });
  }
});

// Testar mapeamento de exceptions
group('Exception to Failure mapping', () {
  final errorCases = [
    (ServerException(), ServerFailure),
    (NetworkException(), NetworkFailure),
    (TimeoutException(), TimeoutFailure),
    (NotFoundException(), NotFoundFailure),
  ];

  for (final (exception, failureType) in errorCases) {
    test('should return $failureType when ${exception.runtimeType} is thrown', () async {
      // Arrange
      when(() => dataSource.fetch()).thenThrow(exception);

      // Act
      final result = await repository.fetch();

      // Assert
      expect(result.fold((f) => f.runtimeType, (_) => null), failureType);
    });
  }
});
```

---

## Async Best Practices

```dart
// Sempre usar async/await em testes assincronos
test('should fetch user', () async {
  when(() => repo.getUser()).thenAnswer((_) async => user);

  final result = await usecase();

  expect(result, isA<Right<Failure, User>>());
});

// Para Futures que devem falhar
test('should throw on error', () async {
  when(() => repo.getUser()).thenThrow(Exception());

  expect(
    () async => await dataSource.getUser(),
    throwsA(isA<Exception>()),
  );
});

// Para timeouts (casos especiais)
test('should complete within timeout', () async {
  final result = await usecase().timeout(const Duration(seconds: 5));
  expect(result, isNotNull);
});

// Usar addTearDown para cleanup garantido
test('stream cleanup', () async {
  final subscription = stream.listen((_) {});
  addTearDown(subscription.cancel); // Executado mesmo se teste falhar

  // ... asserts
});
```

---

## Test Tags (Categorizacao)

```dart
@Tags(['unit', 'fast'])
void main() {
  // Testes unitarios rapidos
}

@Tags(['integration', 'slow'])
void main() {
  // Testes de integracao lentos
}

// Executar apenas testes rapidos:
// flutter test --tags fast

// Excluir testes lentos:
// flutter test --exclude-tags slow

// Multiplas tags:
// flutter test --tags "unit,fast"
```

---

## Custom Matchers

Crie matchers customizados em `@test/core/helpers/custom_matchers.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

/// Matcher para Either que contem valor esperado no Right
Matcher isRightWith<T>(T expected) => _IsRightWith<T>(expected);

class _IsRightWith<T> extends Matcher {
  final T expected;
  _IsRightWith(this.expected);

  @override
  bool matches(item, Map matchState) {
    if (item is Either) {
      return item.fold((_) => false, (r) => r == expected);
    }
    return false;
  }

  @override
  Description describe(Description description) =>
      description.add('Right containing $expected');
}

/// Matcher para Either que contem Failure especifico no Left
Matcher isLeftWith<F>() => _IsLeftWith<F>();

class _IsLeftWith<F> extends Matcher {
  @override
  bool matches(item, Map matchState) {
    if (item is Either) {
      return item.fold((l) => l is F, (_) => false);
    }
    return false;
  }

  @override
  Description describe(Description description) =>
      description.add('Left containing $F');
}

// Uso:
expect(result, isRightWith(expectedUser));
expect(result, isLeftWith<ServerFailure>());
```

---

## Test Isolation (Riverpod)

```dart
// Criar novo container para cada teste
setUp(() {
  container = ProviderContainer(overrides: [...]);
});

// OBRIGATORIO: dispose no tearDown
tearDown(() {
  container.dispose(); // Evita memory leaks e estado compartilhado
});

// reset() para mocks no tearDown, NAO no setUp
tearDown(() {
  reset(mockA);
  reset(mockB);
  container.dispose();
});
```

---

## Hierarquia de Grupos

```dart
void main() {
  group('ClassName', () {
    // setUp/tearDown compartilhado

    group('methodName', () {
      group('Success cases', () {
        test('should return X when Y', () {});
      });

      group('Error cases', () {
        test('should throw when Z', () {});
      });

      group('Edge cases', () {
        test('should handle empty list', () {});
      });
    });
  });
}
```

---

## Nomenclatura de Testes (Effective Dart)

```dart
// Bom - descreve comportamento esperado
test('should return user when repository call succeeds', () {});
test('should throw ServerFailure when API returns 500', () {});
test('should emit loading then loaded states in order', () {});

// Ruim - muito vago
test('test user', () {});
test('success case', () {});
test('works', () {});
```

---

## Single Assertion Principle

```dart
// Bom - um comportamento por teste
test('should return user with correct id', () async {
  final result = await usecase(params);
  result.fold((_) => fail('Expected Right'), (user) {
    expect(user.id, '123');
  });
});

test('should call repository exactly once', () async {
  await usecase(params);
  verify(() => repository.getUser(any())).called(1);
});

// Evitar - multiplos comportamentos
test('should work correctly', () async {
  final result = await usecase(params);
  expect(result.isRight(), isTrue);
  expect(result.getOrElse(() => null)?.id, '123');
  expect(result.getOrElse(() => null)?.name, 'John');
  verify(() => repository.getUser(any())).called(1);
  verifyNoMoreInteractions(repository);
});
```

---

## Testes de Igualdade (Equatable)

```dart
import 'package:clyvo_mobile/test/core/helpers/helpers_test_utils.dart';

test('UserEntity equality', () {
  HelpersTestUtils.testEquality<UserEntity>(
    baseInstance: UserEntityFixture.valid,
    instanceWithSameProps: UserEntityFixture.valid,
    instanceWithDifferentProps: UserEntityFixture.alternative,
    objectName: 'UserEntity',
  );
});
```
