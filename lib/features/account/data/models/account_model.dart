import '../../domain/entities/account_entity.dart';
import '../../domain/entities/account_type.dart';

class AccountModel extends AccountEntity {
  AccountModel({
    required super.id,
    required super.name,
    required super.type,
    required super.value,
    super.limit,
    super.dayClose,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: AccountType.values.byName(json['type'] as String),
      value: (json['value'] as num).toDouble(),
      limit: (json['limit'] as num?)?.toDouble() ?? 0,
      dayClose: json['dayClose'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'value': value,
      'limit': limit,
      'dayClose': dayClose,
    };
  }

  AccountEntity toEntity() {
    return AccountEntity(
      id: id,
      name: name,
      type: type,
      value: value,
      limit: limit,
      dayClose: dayClose,
    );
  }

  factory AccountModel.fromEntity(AccountEntity entity) {
    return AccountModel(
      id: entity.id,
      name: entity.name,
      type: entity.type,
      value: entity.value,
      limit: entity.limit,
      dayClose: entity.dayClose,
    );
  }
}
