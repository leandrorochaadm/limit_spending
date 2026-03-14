---
paths:
  - "lib/features/*/presentation/providers/**"
---

# Provider Template (StateNotifier)

File: `{feature}_provider.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/logging/logger_provider.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_all_{feature}s_use_case.dart';
import '../../domain/usecases/get_{feature}_by_id_use_case.dart';
import '{feature}_state.dart';

class {Feature}Notifier extends StateNotifier<{Feature}State> with LoggerMixin {
  final Ref _ref;

  {Feature}Notifier(this._ref) : super({Feature}Initial());

  /// Buscar lista
  Future<void> fetchAll() async {
    state = {Feature}Loading();

    final usecase = _ref.read(getAll{Feature}sUseCaseProvider);
    final result = await usecase(const NoParams());

    result.fold(
      (failure) {
        logWarning('Failed to fetch {feature}s',
            data: {'failure': failure.runtimeType.toString()});
        state = {Feature}Error(_mapFailure(failure));
      },
      (items) => state = {Feature}sLoaded(items),
    );
  }

  /// Buscar item por ID
  Future<void> fetchById(String id) async {
    state = {Feature}Loading();

    final usecase = _ref.read(get{Feature}ByIdUseCaseProvider);
    final result = await usecase(Get{Feature}ByIdParams(id: id));

    result.fold(
      (failure) {
        logWarning('Failed to fetch {feature}',
            data: {'id': id, 'failure': failure.runtimeType.toString()});
        state = {Feature}Error(_mapFailure(failure));
      },
      (item) => state = {Feature}Loaded(item),
    );
  }

  void reset() => state = {Feature}Initial();

  /// Mapear Failure → mensagem é responsabilidade da Presentation
  String _mapFailure(Failure failure) {
    return switch (failure) {
      NoConnectionFailure()     => 'Sem conexão com a internet.',
      TimeoutFailure()          => 'Tempo de resposta esgotado.',
      ServerFailure()           => 'Erro no servidor. Tente novamente.',
      UnauthorizedFailure()     => 'Sessão expirada. Faça login novamente.',
      NotFoundFailure()         => 'Não encontrado.',
      _                         => 'Erro inesperado.',
    };
  }
}

/// Provider global
final {feature}Provider =
    StateNotifierProvider<{Feature}Notifier, {Feature}State>((ref) {
  return {Feature}Notifier(ref);
});
```

## Rules
- Use UseCases only (NEVER repositories or datasources directly)
- `_mapFailure(Failure)` com switch exaustivo para mensagens ao usuário
- Logs usam `failure.runtimeType.toString()` (nunca `failure.message` — Failures não têm `.message`)
- Use `LoggerMixin` for logging
- Define StateNotifierProvider at the end of file
- Failures com campos específicos (ex: `ValueAboveCeilingFailure`) devem ser tratados no switch com seus dados
