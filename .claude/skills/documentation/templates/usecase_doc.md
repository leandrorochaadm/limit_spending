# Template: Documentação de UseCase

## Classe — Propósito e regras de negócio

```dart
/// Caso de uso para solicitar um novo saque.
///
/// Encapsula a lógica de negócio para validar e processar
/// solicitações de saque, incluindo verificações de saldo
/// e limites diários.
///
/// Exemplo de uso:
/// ```dart
/// final useCase = RequestWithdrawUseCase(repository: repository);
/// final result = await useCase(const NoParams());
///
/// result.fold(
///   (failure) => print('Erro: $failure'),
///   (withdraw) => print('Saque solicitado: ${withdraw.id}'),
/// );
/// ```
class RequestWithdrawUseCase extends UseCase<WithdrawEntity, WithdrawParams> {
```

## Construtor — Dependências

```dart
  /// Cria uma instância do [RequestWithdrawUseCase].
  RequestWithdrawUseCase({required this.repository});

  final WithdrawRepository repository;
```

## Método call() — Regras de negócio

```dart
  /// Executa o caso de uso.
  ///
  /// Valida o [params] e delega a solicitação para o [repository].
  ///
  /// Regras de negócio aplicadas:
  /// * Valor mínimo: R$ 50,00
  /// * Valor máximo: R$ 50.000,00
  /// * Limite diário: 3 saques
  @override
  Future<Either<Failure, WithdrawEntity>> call(WithdrawParams params) async {
    // Valida valor máximo (regra de negócio)
    if (params.amount > 50000.0) {
      return const Left(MaxAmountExceededFailure());
    }

    return repository.requestWithdraw(amount: params.amount);
  }
```

## Padrões Importantes

### UseCase com NoParams

```dart
/// Busca a lista de pacientes do médico logado.
///
/// Não requer parâmetros. O médico é identificado pelo token.
class GetPatientsUseCase extends UseCase<List<PatientEntity>, NoParams> {
```

### UseCase com Params customizado

```dart
/// Parâmetros para solicitação de saque.
class WithdrawParams extends Equatable {
  /// O valor do saque em reais.
  final double amount;

  const WithdrawParams({required this.amount});

  @override
  List<Object?> get props => [amount];
}
```

## Checklist

- [ ] Classe documenta propósito e regras de negócio
- [ ] Exemplo de uso com `call()` incluído
- [ ] Método `call()` lista regras aplicadas
- [ ] Params customizado documenta cada campo
- [ ] Referencia o repository com `[]`
