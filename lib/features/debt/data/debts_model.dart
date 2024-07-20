import '../domain/entity.dart';

class DebtModel extends DebtEntity {
  DebtModel({
    required super.id,
    required super.name,
    required super.value,
    required super.isPayment,
    required super.dayClose,
    required super.isCardCredit,
  });

  factory DebtModel.fromJson(Map<String, dynamic> json) {
    return DebtModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      value: (json['value'] as num).toDouble(),
      isPayment: json['isPayment'] as bool,
      isCardCredit: json['isCardCredit'] as bool,
      dayClose: json['dayClosing'] as int,
    );
  }

  factory DebtModel.fromEntity(DebtEntity entity) {
    return DebtModel(
      id: entity.id,
      name: entity.name,
      value: entity.value,
      isPayment: entity.isPayment,
      dayClose: entity.dayClose,
      isCardCredit: entity.isCardCredit,
    );
  }

  DebtEntity toEntity() {
    return DebtEntity(
      id: id,
      name: name,
      value: value,
      isPayment: isPayment,
      dayClose: dayClose,
      isCardCredit: isCardCredit,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'value': value,
      'isPayment': isPayment,
      'dayClosing': dayClose,
      'isCardCredit': isCardCredit,
    };
  }
}
