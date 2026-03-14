---
paths:
  - "lib/features/*/domain/entities/**"
---

# Entity Template

```dart
import 'package:equatable/equatable.dart';

class {Feature}Entity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final DateTime? createdAt;

  {Feature}Entity({
    required this.id,
    required this.name,
    this.description,
    this.createdAt,
  });

  // Regras intrínsecas ao objeto (opcional — adicionar se necessário)
  bool get isValid => id.isNotEmpty && name.isNotEmpty;

  @override
  List<Object?> get props => [id, name, description, createdAt];
}
```

## Com coleções (usar unmodifiable)

```dart
class {Feature}Entity extends Equatable {
  final String id;
  final List<{Item}Entity> items;
  final Map<String, String> metadata;

  {Feature}Entity({
    required this.id,
    required List<{Item}Entity> items,
    required Map<String, String> metadata,
  })  : items = List.unmodifiable(items),
        metadata = Map.unmodifiable(metadata);

  @override
  List<Object?> get props => [id, items, metadata];
}
```

## Rules
- MUST extend `Equatable`
- MUST implement `props`
- NO `copyWith()` methods
- NO `fromJson`/`toJson`/`@JsonSerializable`
- NO `Map<String, dynamic>` properties
- Coleções DEVEM usar `List.unmodifiable` / `Map.unmodifiable` / `Set.unmodifiable`
- Factory `empty()` é **opcional** — adicionar apenas se necessário
- Contém regras de negócio intrínsecas ao objeto (getters booleanos, cálculos)
