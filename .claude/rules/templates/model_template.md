---
paths:
  - "lib/features/*/data/models/**"
---

# Model Template

Models são classes **SEPARADAS** da Entity — NUNCA herdam de Entity.

```dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/{feature}_entity.dart';

part '{feature}_model.g.dart';

@JsonSerializable(includeIfNull: false)
class {Feature}Model {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const {Feature}Model({
    required this.id,
    required this.name,
    this.description,
    this.createdAt,
  });

  factory {Feature}Model.fromJson(Map<String, dynamic> json) =>
      _${Feature}ModelFromJson(json);

  Map<String, dynamic> toJson() => _${Feature}ModelToJson(this);

  /// Converte Model → Entity (ponte entre camadas)
  {Feature}Entity toEntity() {
    return {Feature}Entity(
      id: id,
      name: name,
      description: description,
      createdAt: createdAt,
    );
  }

  /// Converte Entity → Model (quando necessário para salvar/enviar)
  factory {Feature}Model.fromEntity({Feature}Entity entity) {
    return {Feature}Model(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      createdAt: entity.createdAt,
    );
  }
}
```

After creating: `dart run build_runner build --build-filter="lib/features/**/data/models/**" --delete-conflicting-outputs`

## Rules
- NEVER extends Entity — classe completamente separada
- MUST have `toEntity()` method
- MUST have `fromEntity()` factory (quando precisar salvar/enviar dados)
- NO `copyWith()` methods
- Use `@JsonSerializable()` + generated `fromJson`/`toJson`
- Use `@JsonKey(name: '...')` para mapear nomes da API
