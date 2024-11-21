import 'package:equatable/equatable.dart';

import '../domain/entity.dart';

class DebtModel extends DebtEntity with EquatableMixin {
  DebtModel({
    required super.id,
    required super.name,
    required super.value,
  });

  factory DebtModel.fromJson(Map<String, dynamic> json) {
    return DebtModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      value: (json['value'] as num).toDouble(),
    );
  }

  factory DebtModel.fromEntity(DebtEntity entity) {
    return DebtModel(
      id: entity.id,
      name: entity.name,
      value: entity.value,
    );
  }

  DebtEntity toEntity() {
    return DebtEntity(
      id: id,
      name: name,
      value: value,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'value': value,
    };
  }
}
