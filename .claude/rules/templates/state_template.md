---
paths:
  - "lib/features/*/presentation/providers/**"
---

# State Template (Sealed Classes)

File: `{feature}_state.dart` (SEPARATE from provider)

```dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/{feature}_entity.dart';

/// Sealed base class (classe selada que força tratamento exaustivo de todos os estados)
sealed class {Feature}State extends Equatable {
  @override
  List<Object?> get props => [hashCode];
}

/// Estado inicial — sem campos, herda props da base
class {Feature}Initial extends {Feature}State {}

/// Carregando — sem campos, herda props da base
class {Feature}Loading extends {Feature}State {}

/// Lista carregada — com campos, sobrescreve props
class {Feature}sLoaded extends {Feature}State {
  final List<{Feature}Entity> items;

  {Feature}sLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

/// Item único carregado — com campos, sobrescreve props
class {Feature}Loaded extends {Feature}State {
  final {Feature}Entity item;

  {Feature}Loaded(this.item);

  @override
  List<Object?> get props => [item];
}

/// Erro — com campos, sobrescreve props
class {Feature}Error extends {Feature}State {
  final String message;

  {Feature}Error(this.message);

  @override
  List<Object?> get props => [message];
}
```

## Estados opcionais (adicionar quando necessário)

```dart
// Lista vazia
class {Feature}Empty extends {Feature}State {}

// Recarregando (mantém dados visíveis)
class {Feature}Refreshing extends {Feature}State {
  final List<{Feature}Entity> items;
  {Feature}Refreshing(this.items);

  @override
  List<Object?> get props => [items];
}

// Submetendo formulário
class {Feature}Submitting extends {Feature}State {}

// Erro com possibilidade de retry
class {Feature}ErrorRetryable extends {Feature}State {
  final String message;
  final bool canRetry;
  {Feature}ErrorRetryable(this.message, {this.canRetry = false});

  @override
  List<Object?> get props => [message, canRetry];
}
```

## Uso na UI (switch exaustivo)

```dart
return switch (state) {
  {Feature}Initial()              => const SizedBox.shrink(),
  {Feature}Loading()              => const ClyvoLoadingIndicator(),
  {Feature}sLoaded(:final items)  => {Feature}ListView(items: items),
  {Feature}Loaded(:final item)    => {Feature}DetailWidget(item: item),
  {Feature}Empty()                => const EmptyStateWidget(),
  {Feature}Error(:final message)  => ClyvoErrorWidget(message: message),
};
```

## Rules
- Base sealed com `props => [hashCode]`
- Subclasses **sem campos**: não sobrescrevem `props` (herdam da base)
- Subclasses **com campos**: sobrescrevem `props` com seus campos
- NUNCA contém `Either` — o Either morre no Notifier
- NUNCA usar `const` em subclasses sem `const` constructor definido na base
