# Template: Documentação de Repository

## Interface (Domain) — Defina contrato

```dart
/// Interface para operações de saque.
///
/// Define os métodos disponíveis para gerenciar saques,
/// sem expor detalhes de implementação.
///
/// Implementado por [WithdrawDataSource] na camada de data.
abstract class WithdrawRepository {
  /// Solicita um novo saque.
  ///
  /// Retorna [Right] com [WithdrawEntity] em caso de sucesso,
  /// ou [Left] com [Failure] em caso de erro.
  ///
  /// Possíveis falhas:
  /// * [InvalidAmountFailure] - Valor abaixo do mínimo permitido
  /// * [TimeoutFailure] - Timeout na requisição
  /// * [OfflineFailure] - Sem conexão com internet
  /// * `null` - Erro genérico
  Future<Either<Failure?, WithdrawEntity>> requestWithdraw({
    required double amount,
  });

  /// Busca o histórico de saques do usuário.
  ///
  /// Retorna lista vazia se não houver saques registrados.
  Future<Either<Failure?, List<WithdrawEntity>>> getWithdrawHistory();
}
```

## Padrões Importantes

### Retornos Either — Documente ambos os lados

```dart
/// Retorna [Right] com [PatientEntity] em caso de sucesso,
/// ou [Left] com [Failure] em caso de erro.
```

### Liste Failures Possíveis

```dart
/// Possíveis falhas:
/// * [NetworkFailure] - Sem conexão com internet
/// * [ServerFailure] - Erro interno do servidor
/// * [TimeoutFailure] - Timeout na requisição
/// * [UnauthorizedFailure] - Token expirado
/// * [NotFoundFailure] - Recurso não encontrado
```

### Lista Vazia vs Null

```dart
/// Retorna lista vazia se não houver registros.
/// Nunca retorna null — use lista vazia para ausência de dados.
```

## Checklist

- [ ] Interface tem doc comment explicando propósito
- [ ] Referencia a implementação com `[NomeImpl]`
- [ ] Cada método documenta retorno [Right] e [Left]
- [ ] Failures possíveis listadas
- [ ] Casos especiais documentados (lista vazia, null)
