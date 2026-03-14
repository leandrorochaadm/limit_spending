---
name: create_tests
description: Create and run Flutter/Dart unit tests with Riverpod, Mocktail and Clean Architecture. Use when writing tests, debugging test failures, or improving test coverage.
argument-hint: [filepath]
allowed-tools: Read, Grep, Bash(flutter test:*), Bash(dart test:*), Bash(dart run build_runner build:*)
---

# Skill: Testes Unitarios Flutter/Dart

Especialista em testes unitarios Flutter/Dart com Riverpod, Mocktail e Clean Architecture.

## REGRA CRITICA

**NUNCA altere codigo na pasta `/lib`**. Esta skill e EXCLUSIVA para criar e modificar testes na pasta `/test`.

## Principios Fundamentais

### KISS (Keep It Simple, Stupid)
- Testes simples e diretos
- Evite logica complexa nos testes
- Um teste = uma responsabilidade
- Nomes descritivos que explicam o comportamento

### DRY (Don't Repeat Yourself)
- **Reuso global**: Use helpers de `@test/core/helpers/`
- **Reuso local**: Crie helpers locais para codigo repetido 2+ vezes
- **Fixtures centralizadas**: Uma fonte de verdade para dados de teste

### Single Assertion Principle
Um teste deve verificar um unico comportamento.

---

## Packages de Teste - USO OBRIGATORIO

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_test/riverpod_test.dart';
import 'package:dartz/dartz.dart';

// PROIBIDO: import 'package:mockito/mockito.dart';
```

---

## Estrutura de Organizacao

**Espelhe EXATAMENTE a estrutura de `/lib` em `/test`:**

```
lib/features/auth/domain/entities/user_entity.dart

test/features/auth/domain/entities/
├── user_entity_test.dart      # Testes
├── user_entity_fixture.dart   # Fixtures
└── user_entity_mock.dart      # Mocks (se necessario)
```

---

## Regras Criticas

1. **reset() no tearDown**, NAO no setUp
2. **NUNCA crie dados hardcoded** - use fixtures
3. **Titulos de testes em INGLES**
4. **Use getters static** para entities/models em fixtures (nao funcoes)
5. **Derive variacoes** de constantes base (DRY)
6. **Verifique parametros especificos** ao inves de `any()` no verify
7. **container.dispose() no tearDown** - OBRIGATORIO para ProviderContainer

---

## Mapeamento Exception -> Failure

| Exception | Failure | HTTP |
|-----------|---------|------|
| `NetworkException` | `NetworkFailure` | - |
| `ServerException` | `ServerFailure` | 500+ |
| `BadRequestException` | `ValidationFailure` | 400 |
| `UnauthorizedException` | `UnauthorizedFailure` | 401 |
| `ForbiddenException` | `ForbiddenFailure` | 403 |
| `NotFoundException` | `NotFoundFailure` | 404 |
| `TimeoutException` | `TimeoutFailure` | timeout |
| `CacheException` | `CacheFailure` | cache |

---

## Nomenclatura de Fixtures JSON

| Operacao | Padrao | Exemplo |
|----------|--------|---------|
| GET single | `get_[entity]_response.json` | `get_user_response.json` |
| GET list | `get_[entities]_response.json` | `get_patients_response.json` |
| POST | `create_[entity]_response.json` | `create_consultation_response.json` |
| PUT/PATCH | `update_[entity]_response.json` | `update_profile_response.json` |
| Error | `[op]_error_response.json` | `login_error_response.json` |

---

## Hierarquia de Reuso

```
1. @test/core/helpers/           <- Reuso GLOBAL
2. @test/features/[feature]/     <- Reuso por FEATURE
3. Dentro do arquivo _test.dart  <- Reuso LOCAL
```

---

## Cenarios de Teste Obrigatorios

- **Success case**: comportamento padrao
- **Error case**: ServerFailure
- **Network case**: NetworkFailure
- **Timeout case**: TimeoutFailure
- **Unauthorized case**: UnauthorizedFailure
- **Empty data case**: resposta vazia
- **Edge cases**: limites, nulls, listas vazias

---

## Nomenclatura

| Tipo | Sufixo Arquivo | Sufixo Classe |
|------|----------------|---------------|
| Mock | `_mock.dart` | `Mock` |
| Fixture | `_fixture.dart` | `Fixture` |
| Fake | - | `Fake` |
| Test | `_test.dart` | - |

---

## Helpers Globais Disponiveis

Use `@test/core/helpers/`:
- `HelpersTestUtils.testEquality()` - testes de igualdade
- `FixtureReader.fixture()` - ler fixture JSON
- `FixtureReader.fixtureMap()` - ler fixture como Map
- `setupDefaults()` - configuracao padrao de mocks

---

## Checklist

- [ ] **NAO alterou codigo em `/lib`**
- [ ] Imports corretos (mocktail, flutter_test, riverpod_test)
- [ ] `setUpAll()` com `registerFallbackValue()` para tipos complexos
- [ ] `setUp()` para inicializacao
- [ ] `tearDown()` com `reset()` e `container.dispose()`
- [ ] Fixtures com constantes base (DRY)
- [ ] Getters static para entities (nao funcoes)
- [ ] Padrao AAA (Arrange, Act, Assert)
- [ ] Titulos em ingles descrevendo comportamento
- [ ] `verify()` com parametros especificos
- [ ] **Cobertura >= 80%** nos arquivos de `/lib` testados

---

## Validacao de Cobertura - OBRIGATORIA

Apos todos os testes passarem, verificar cobertura **apenas dos arquivos de `/lib`** que foram alvo dos testes criados nesta sessao.

### Passo a passo

1. Executar os testes com cobertura:
```bash
flutter test --coverage test/path/to/test_file.dart
```

2. Verificar porcentagem de cada arquivo de `/lib` testado:
```bash
lcov --list coverage/lcov.info | grep "arquivo_testado"
```

3. Exibir resumo simples por arquivo:
```
user_entity.dart: 92% ✅
auth_repository_impl.dart: 74% ❌
```

4. **Se algum arquivo estiver abaixo de 80%**: criar testes extras automaticamente ate atingir >= 80%, sem perguntar.

5. Repetir ate que TODOS os arquivos de `/lib` testados tenham **>= 80%** de cobertura.

**IMPORTANTE**: A tarefa so esta concluida quando todos os arquivos de `/lib` testados atingirem >= 80%.

---

## Templates Disponiveis

Use `Read` para carregar o template necessario:

| Template | Arquivo | Quando Usar |
|----------|---------|-------------|
| UseCase | `@.claude/skills/testing/templates/usecase_test.md` | Testar UseCases |
| Repository | `@.claude/skills/testing/templates/repository_test.md` | Testar Repositories (Either) |
| DataSource | `@.claude/skills/testing/templates/datasource_test.md` | Testar DataSources (API) |
| Provider | `@.claude/skills/testing/templates/provider_test.md` | Testar StateNotifiers |
| Widget | `@.claude/skills/testing/templates/widget_test.md` | Testar Widgets |
| Fixture | `@.claude/skills/testing/templates/fixture.md` | Criar Fixtures + FixtureReader |
| Mock | `@.claude/skills/testing/templates/mock.md` | Criar Mocks com setupDefaults() |
| Best Practices | `@.claude/skills/testing/templates/best_practices.md` | Matchers, Parametrized, Tags |

**Instrucao**: Ao criar um teste, leia o template correspondente para obter a estrutura completa.
