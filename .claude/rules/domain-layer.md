---
paths:
  - "lib/features/*/domain/**"
---

# Domain Layer Rules

## Entities

- **MUST** extend `Equatable`
- **MUST NOT** have `copyWith()` methods — imutabilidade garantida pela estrutura
- **MUST NOT** use `Map<String, dynamic>` as properties
- **MUST** implement `props` para Equatable
- **MUST** usar `List.unmodifiable`, `Map.unmodifiable`, `Set.unmodifiable` em coleções para garantir imutabilidade real
- Factory `empty()` é **opcional** — adicionar apenas quando o código precisar de valor padrão
- NUNCA contém `fromJson`, `toJson`, `@JsonSerializable` ou qualquer anotação de serialização
- Contém regras de negócio **intrínsecas ao objeto** (validações, cálculos, estados derivados)

Pergunta-chave: _"O objeto SABE isso sobre si mesmo, sem depender de nada externo?"_ → Se sim, vai na Entity.

```dart
class BiddingEntity extends Equatable {
  final String number;
  final List<BiddingItemEntity> items;

  BiddingEntity({
    required this.number,
    required List<BiddingItemEntity> items,
  }) : items = List.unmodifiable(items); // garante imutabilidade real

  // Regras intrínsecas ao objeto
  bool get isValid => number.isNotEmpty && items.isNotEmpty;
  double get totalValue => items.fold(0, (sum, i) => sum + i.value);

  @override
  List<Object?> get props => [number, items];
}
```

## UseCases

- **MUST** extend `UseCase<T, Params>` de `@lib/core/usecases/usecase.dart`
- **MUST** implement `call(Params params)` (NOT `execute()`)
- Use `NoParams` when no parameters needed
- Return `Either<Failure, T>`
- Params class **MUST** extend `Equatable`
- Nome é um **verbo** que descreve a ação + sufixo obrigatório `UseCase` (ex: `GetPatientByIdUseCase`, `AnalyzeBiddingUseCase`)

Pergunta-chave: _"Precisa de algo FORA do objeto para executar essa regra?"_ → Se sim, vai no UseCase.

## Repository Interfaces

- **MUST** use Entity types only (never Model, never Map)
- Return `Either<Failure, T>` where T is Entity, List<Entity>, void, bool, String, or int
- Pure business contracts — no data implementation details

## Failures

- Carregam **dados**, NUNCA mensagens de texto — mensagens são responsabilidade da Presentation (`_mapFailure` no Notifier)
- `Failure` é `abstract class` em `lib/core/error/failures.dart`
- Failures de infra (rede, servidor, etc.) ficam em `lib/core/error/failures.dart`
- Failures específicas de feature ficam em `features/{feature}/domain/failures/{feature}_failures.dart`

### Localização

```
lib/core/error/failures.dart          → NetworkFailure, ServerFailure, etc. (infra)
features/auth/domain/failures/        → MissingCredentialsFailure
features/consultation/domain/failures/ → InvalidPatientIdFailure
features/{feature}/domain/failures/   → {Feature}Failures específicas
```

### Adicionar nova failure de feature

Criar `lib/features/{feature}/domain/failures/{feature}_failures.dart`:

```dart
import '../../../../core/error/failures.dart';

class InvalidBiddingFailure extends Failure {
  const InvalidBiddingFailure();
}

// Com campos específicos — sobrescrevem props
class ValueAboveCeilingFailure extends Failure {
  final double ceiling;
  final double proposed;

  const ValueAboveCeilingFailure({
    required this.ceiling,
    required this.proposed,
  });

  @override
  List<Object?> get props => [ceiling, proposed];
}
```

### No `_mapFailure` do Notifier — usar `FailureMapperMixin` (DRY)

Notifiers usam `with FailureMapperMixin` (`lib/core/error/failure_mapper_mixin.dart`) para não repetir as failures de infra em todo notifier.

```dart
// Sem feature-specific failures:
String _mapFailure(Failure failure) => mapInfraFailure(failure);

// Com feature-specific failures:
String _mapFailure(Failure failure) => switch (failure) {
  ValueAboveCeilingFailure() =>
    'Valor de R\$ ${failure.proposed} excede o teto de R\$ ${failure.ceiling}.',
  InvalidBiddingFailure() => 'Edital com dados inválidos.',
  _ => mapInfraFailure(failure),
};
```

**Imports necessários no Notifier:**
```dart
import '../../../../core/error/failure_mapper_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../domain/failures/{feature}_failures.dart'; // se houver feature-specific
```

## Imutabilidade — Por Que Importa

### Riverpod não detecta mudança sem objeto novo

```dart
// ❌ ANTI-PATTERN — UI não atualiza (bug silencioso)
//    items é List.unmodifiable, mas se fosse mutável:
entity.items.add(newItem);          // mutou o mesmo objeto
state = FeatureLoaded(entity);      // Riverpod: "mesmo objeto, não notifica"

// ❌ ANTI-PATTERN — mutando lista mutável internamente
final mutableEntity = SomeEntity(items: []);
mutableEntity.items.add(newItem);   // possível se items não for unmodifiable
state = FeatureLoaded(mutableEntity); // Riverpod não sabe que mudou

// ✅ CORRETO — sempre criar objeto novo
state = FeatureLoaded(
  FeatureEntity(
    id: entity.id,
    name: entity.name,
    items: [...entity.items, newItem], // novo List → novo objeto → Riverpod notifica
  ),
);
```

### Efeito colateral à distância

```dart
// ❌ ANTI-PATTERN — lista mutável vaza para fora da Entity
class PatientEntity extends Equatable {
  final List<ConsultationEntity> consultations; // ⚠ final protege referência, não conteúdo!

  PatientEntity({required this.consultations}); // qualquer um pode fazer consultations.add(...)
}

// Em algum lugar do código...
final patient = ref.read(patientProvider).patient;
patient.consultations.add(fakeConsultation); // muta sem ninguém saber — bug silencioso

// ✅ CORRETO — List.unmodifiable lança erro em runtime se tentar mutar
class PatientEntity extends Equatable {
  final List<ConsultationEntity> consultations;

  PatientEntity({required List<ConsultationEntity> consultations})
      : consultations = List.unmodifiable(consultations);
}

// Agora isso lança UnsupportedError em runtime:
patient.consultations.add(fakeConsultation); // ✋ erro imediato, fácil de debugar
```

### Receita para imutabilidade sem Freezed

```
1. final em todos os campos
2. List.unmodifiable / Map.unmodifiable / Set.unmodifiable em coleções
3. Equatable para comparação por valor (não por referência)
4. Para "copiar com modificação": construir novo objeto explicitamente no UseCase ou Notifier
```

## EquatableConfig.stringify

Configurar globalmente no `main.dart` para facilitar debug (toString mostra os campos):

```dart
void main() {
  EquatableConfig.stringify = true;
  runApp(const MyApp());
}
```

Com isso, `print(entity)` mostra `BiddingEntity(number: 001, ...)` em vez de `Instance of BiddingEntity`.

## Type Rules
- **ONLY** Entity types allowed in domain layer
- **NEVER** Model types (data layer only)
- **NEVER** `Map<String, dynamic>` in parameters or return types

## Templates
- Entity: see `@.claude/rules/templates/entity_template.md`
- UseCase: see `@.claude/rules/templates/usecase_template.md`
