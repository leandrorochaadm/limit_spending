---
paths:
  - "lib/features/*/presentation/**"
---

# Presentation Layer Rules

## State Management - StateNotifier + Sealed Classes

- **MUST** use StateNotifier with sealed state classes
- State file SEPARADO: `{feature}_state.dart`
- Provider file: `{feature}_provider.dart`

### State Classes (sealed)
- Base: `sealed class {Feature}State extends Equatable` com `props => [hashCode]`
- Initial: `{Feature}Initial`
- Loading: `{Feature}Loading`
- Loaded (list): `{Feature}sLoaded` / Loaded (single): `{Feature}Loaded`
- Error: `{Feature}Error` com `String message`
- Optional: `{Feature}Empty`, `{Feature}Refreshing`, `{Feature}Submitting`
- Subclasses **sem campos** herdam `props` da base (não sobrescrevem)
- Subclasses **com campos** sobrescrevem `props` com seus campos
- **NUNCA** contém `Either` — o Either morre no Notifier

### Exceptions
- **voice_assistant**: uses BLoC (complex state)
- **call**: uses traditional CallState (not sealed)

## Provider Rules

- **MUST** use UseCases (never inject repositories directly)
- **MUST** ter método `_mapFailure(Failure failure)` para converter Failure → mensagem
- `_mapFailure` usa `switch` exaustivo sobre o tipo de Failure
- **NEVER** hardcode error messages fora do `_mapFailure`
- Para regras completas de Riverpod (ref.watch/read, autoDispose, family, disposal): `@.claude/rules/riverpod.md`

```dart
// Padrão obrigatório no Notifier — listar TODOS os tipos de infra explicitamente
String _mapFailure(Failure failure) => switch (failure) {
  // failures de domínio da feature (se houver)
  // MyFeatureFailure() => 'Mensagem específica.',
  // infra — todos explícitos
  NetworkFailure()          => AppConstants.errorNetworkMessage,
  TimeoutFailure()          => AppConstants.errorTimeoutMessage,
  ServerFailure()           => AppConstants.errorServerDefaultMessage,
  UnauthorizedFailure()     => AppConstants.errorUnauthorizedMessage,
  ForbiddenFailure()        => AppConstants.errorUnauthorizedMessage,
  NotFoundFailure()         => AppConstants.errorNotFoundMessage,
  CacheFailure()            => AppConstants.errorCacheMessage,
  RequestCancelledFailure() => AppConstants.errorUnknownMessage,
  BadRequestFailure(:final serverMessage) => serverMessage ?? AppConstants.errorUnknownMessage,
  _                         => AppConstants.errorUnknownMessage,
};
```

## Type Safety

- **ONLY** Entity types (never Model, never `Map<String, dynamic>`)
- Screen/Widget constructors: Entity parameters only
- State class properties: Entity types only

## Styling

- **MUST** use `AppColors` and `AppStyles` exclusively
- **NEVER** hardcode colors (`Color(0xFF...)`, `Colors.blue`)
- **NEVER** inline TextStyle — use `AppStyles.s{size}w{weight}{color}`
- If color/style doesn't exist, add to `AppColors`/`AppStyles` first
- Import: `package:clyvo_mobile/core/theme/app_colors.dart` / `app_styles.dart`

## Formatters

- Formatação de dados (CPF, telefone, moeda, data) é feita **apenas na UI** — nunca na Entity, UseCase ou Notifier
- Formatters reutilizáveis vivem em `lib/core/formatters/` — importar de lá
- Import: `package:clyvo_mobile/core/formatters/formatters_export.dart`

```dart
// CERTO — usar formatters de lib/core/formatters/
Text(CPFFormatter.format(entity.cpf))
Text(PhoneNumberFormatter.format(entity.phone))

// ERRADO — formatter inline no widget
Text(entity.cpf.replaceAll(...)) // NÃO!

// ERRADO — formatação na Entity
class PatientEntity extends Equatable {
  String get formattedCpf => CPFFormatter.format(cpf); // NÃO!
}
```

Novo formatter? Adicionar em `lib/core/formatters/` e exportar em `formatters_export.dart`.

## UI — Pattern matching exaustivo

- Usar `switch` exaustivo do Dart 3 para todos os estados
- NUNCA usar `if (state is ...)` em cadeia — usar `switch`
- Formatação visual (moeda, data, etc.) é feita **apenas na UI** (não no UseCase, nem na Entity)

```dart
return switch (state) {
  FeatureInitial()  => const SizedBox.shrink(),
  FeatureLoading()  => const ClyvoLoadingIndicator(),
  FeatureLoaded()   => FeatureContent(item: state.item),
  FeatureError()    => ClyvoErrorWidget(message: state.message),
};
```

## Templates
- State: see `@.claude/rules/templates/state_template.md`
- Provider: see `@.claude/rules/templates/provider_template.md`
