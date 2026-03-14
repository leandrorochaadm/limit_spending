# Template: Documentação de Entity

## Classe — Domínio e invariantes

```dart
/// Representa um saque no domínio da aplicação.
///
/// Esta entidade encapsula os dados essenciais de um saque,
/// independente da fonte de dados (API, banco local, etc).
///
/// Invariantes:
/// * [amount] deve ser sempre positivo
/// * [id] é único e imutável
/// * [status] define o ciclo de vida do saque
class WithdrawEntity extends Equatable {
```

## Construtor — Assertions e validações

```dart
  /// Cria uma instância de [WithdrawEntity].
  ///
  /// Lança [AssertionError] se [amount] for negativo ou zero.
  const WithdrawEntity({
    required this.id,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.processedAt,
  }) : assert(amount > 0, 'Amount must be positive');
```

## Propriedades — Frases nominais

```dart
  /// Identificador único do saque.
  final String id;

  /// Valor solicitado em reais.
  ///
  /// Sempre positivo, validado no construtor.
  final double amount;

  /// Status atual do saque.
  ///
  /// Veja [WithdrawStatus] para possíveis valores.
  final WithdrawStatus status;

  /// Data e hora de criação da solicitação.
  final DateTime createdAt;

  /// Data e hora de processamento.
  ///
  /// Null se o saque ainda está pendente.
  final DateTime? processedAt;
```

## Getters computados — "Whether" para booleanos

```dart
  /// Whether o saque foi processado.
  ///
  /// Retorna `true` se [processedAt] não é null.
  bool get isProcessed => processedAt != null;
```

## Factory empty()

```dart
  /// Cria uma instância vazia de [WithdrawEntity].
  ///
  /// Usada como valor padrão ou placeholder.
  factory WithdrawEntity.empty() => const WithdrawEntity(
    id: '',
    amount: 0,
    status: WithdrawStatus.pending,
    createdAt: DateTime(0),
  );
```

## Checklist

- [ ] Classe documenta propósito e invariantes
- [ ] Construtor documenta assertions/validações
- [ ] Propriedades obrigatórias com frases nominais
- [ ] Propriedades nullable documentam quando são null
- [ ] Booleanos computados usam "Whether"
- [ ] Referencia enums e tipos relacionados com `[]`
