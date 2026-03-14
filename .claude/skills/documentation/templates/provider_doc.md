# Template: Documentação de StateNotifier/Provider

## Classe — Métodos e estados disponíveis

```dart
/// Gerencia o estado da funcionalidade de saques.
///
/// Coordena solicitações de saque, carregamento de histórico
/// e tratamento de erros através de estados.
///
/// Métodos disponíveis:
/// * [requestWithdraw] - Solicita novo saque
/// * [loadHistory] - Carrega histórico
/// * [cancelWithdraw] - Cancela saque pendente
///
/// Veja [WithdrawState] para possíveis estados.
class WithdrawNotifier extends StateNotifier<WithdrawState> {
```

## Construtor — Dependências

```dart
  /// Cria uma instância de [WithdrawNotifier].
  WithdrawNotifier({
    required this.requestWithdrawUseCase,
    required this.getHistoryUseCase,
  }) : super(const WithdrawInitial());
```

## Métodos públicos — Fluxo e estados emitidos

```dart
  /// Solicita um novo saque.
  ///
  /// Verifica conectividade antes de fazer a requisição.
  /// Emite estados apropriados baseado no resultado.
  Future<void> requestWithdraw(double amount) async {
    state = const WithdrawLoading();

    final result = await requestWithdrawUseCase(WithdrawParams(amount: amount));

    state = result.fold(
      (failure) => WithdrawError(ErrorHandler.getMessage(failure)),
      (withdraw) => WithdrawLoaded(withdraw),
    );
  }
```

## Métodos privados — Quando lógica não é óbvia

```dart
  /// Mapeia [Failure] para mensagem de erro usando [ErrorHandler].
  ///
  /// Usa [ErrorHandler.getMessage] para mensagens amigáveis ao usuário.
  String _getErrorMessage(Failure failure) {
    return ErrorHandler.getMessage(failure);
  }
```

## Sealed States — Documente cada estado

```dart
/// Estados da funcionalidade de saques.
sealed class WithdrawState extends Equatable {
  const WithdrawState();
  @override
  List<Object?> get props => [];
}

/// Estado inicial antes de qualquer operação.
class WithdrawInitial extends WithdrawState {
  const WithdrawInitial();
}

/// Operação em andamento.
class WithdrawLoading extends WithdrawState {
  const WithdrawLoading();
}

/// Saque carregado com sucesso.
class WithdrawLoaded extends WithdrawState {
  /// Os dados do saque.
  final WithdrawEntity withdraw;
  const WithdrawLoaded(this.withdraw);
  @override
  List<Object?> get props => [withdraw];
}

/// Erro na operação.
class WithdrawError extends WithdrawState {
  /// Mensagem de erro amigável ao usuário.
  final String message;
  const WithdrawError(this.message);
  @override
  List<Object?> get props => [message];
}
```

## Provider Definition

```dart
/// Provider para gerenciar estado de saques.
///
/// Usa [autoDispose] pois é estado de tela.
final withdrawProvider = StateNotifierProvider.autoDispose<WithdrawNotifier, WithdrawState>((ref) {
  return WithdrawNotifier(
    requestWithdrawUseCase: ref.watch(requestWithdrawUseCaseProvider),
    getHistoryUseCase: ref.watch(getWithdrawHistoryUseCaseProvider),
  );
});
```

## Checklist

- [ ] Classe lista métodos disponíveis
- [ ] Referencia sealed state com `[]`
- [ ] Métodos documentam estados emitidos
- [ ] Usa `ErrorHandler.getMessage()` para erros
- [ ] Sealed states têm doc comment breve
- [ ] Provider definition documenta autoDispose se aplicável
