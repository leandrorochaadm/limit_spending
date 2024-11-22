import 'package:equatable/equatable.dart';

import '../../domain/domain.dart';

class PaymentMethodModel extends PaymentMethodEntity with EquatableMixin {
  PaymentMethodModel({
    required super.id,
    required super.name,
    required super.isCard,
    required super.isMoney,
    required super.dayClose,
    required super.value,
    required super.limit,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'] as String,
      name: json['name'] as String,
      isCard: json['isCard'] as bool,
      isMoney: json['isMoney'] as bool,
      dayClose: json['dayClose'] as int,
      value: json['value'] as double,
      limit: json['limit'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isCard': isCard,
      'isMoney': isMoney,
      'dayClose': dayClose,
      'value': value,
      'limit': limit,
    };
  }

  PaymentMethodEntity toEntity() => PaymentMethodEntity(
        id: id,
        name: name,
        isCard: isCard,
        isMoney: isMoney,
        dayClose: dayClose,
        value: value,
        limit: limit,
      );
}
