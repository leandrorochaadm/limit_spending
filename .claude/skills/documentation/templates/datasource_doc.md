# Template: Documentação de DataSource

## Classe — Descreva responsabilidades

```dart
/// Um datasource para gerenciar operações de saque via API.
///
/// Esta classe é responsável por:
/// * Fazer chamadas à API de saques
/// * Converter respostas JSON em [WithdrawModel]
/// * Tratar erros e registrá-los no Firebase Crashlytics
/// * Mapear erros de API para [Failure] objects
///
/// Implementa [WithdrawRepository] seguindo Clean Architecture.
class WithdrawDataSource implements WithdrawRepository {
```

## Construtor — Liste dependências

```dart
  /// Cria uma instância do [WithdrawDataSource].
  ///
  /// [apiService] é usado para fazer requisições HTTP.
  /// [firebaseCrashlytics] é usado para logging de erros.
  WithdrawDataSource({
    required this.apiService,
    required this.firebaseCrashlytics,
  });
```

## Métodos — Documente erros e tratamento

```dart
  @override
  Future<Either<Failure?, WithdrawEntity>> requestWithdraw({
    required double amount,
  }) async {
    try {
      // Validação prévia do valor mínimo
      if (amount < 50.0) {
        return const Left(InvalidAmountFailure());
      }

      final response = await apiService.post(
        endpoint: '/withdraw/request',
        body: {'amount': amount},
      );

      if (response.success) {
        final model = WithdrawModel.fromApi(map: response.data);
        return Right(model);
      }

      return const Left(null);
    } on TimeoutException {
      return const Left(TimeoutFailure());
    } catch (error, stackTrace) {
      // Registra erro no Crashlytics para análise
      await firebaseCrashlytics.recordError(
        error,
        stackTrace,
        reason: 'Erro ao solicitar saque de R\$ $amount',
      );

      log('Erro ao solicitar saque: $error', name: 'WithdrawDataSource');
      return const Left(null);
    }
  }
```

## Padrão de Logging

```dart
final _logger = ConsoleLogger(tag: 'WITHDRAW_DATA_SOURCE');

// Em caso de erro
_logger.e('Erro ao solicitar saque', error: error, stackTrace: stackTrace);

// Debug/info
_logger.d('Requisição de saque: amount=$amount');
```

## Checklist

- [ ] Classe tem doc comment com lista de responsabilidades
- [ ] Construtor documenta cada dependência
- [ ] Métodos `@override` listam Failures possíveis
- [ ] Blocos catch têm comentário inline explicando o tratamento
- [ ] Usa `ConsoleLogger` ao invés de `print()` ou `log()`
