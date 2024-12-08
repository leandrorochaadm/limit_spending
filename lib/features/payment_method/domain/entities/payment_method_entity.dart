import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../../debt/debit.dart';
import '../../data/data.dart';

class PaymentMethodEntity extends Equatable {
  final String id;
  final String name;
  final bool isMoney;
  final bool isCard;
  final int dayClose;
  final double value;
  final double limit;

  double get balance => isMoney ? value : (limit - value);

  PaymentMethodEntity({
    String? id,
    required this.name,
    required this.isMoney,
    required this.isCard,
    this.dayClose = 0,
    required this.value,
    required this.limit,
  }) : id = id ?? const Uuid().v4();

  @override
  List<Object?> get props => [
        id,
        name,
        isMoney,
        isCard,
        dayClose,
        value,
        limit,
      ];

  PaymentMethodEntity copyWith({
    String? id,
    String? name,
    bool? isMoney,
    bool? isCard,
    int? dayClose,
    double? value,
    double? limit,
  }) {
    return PaymentMethodEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      isMoney: isMoney ?? this.isMoney,
      isCard: isCard ?? this.isCard,
      dayClose: dayClose ?? this.dayClose,
      value: value ?? this.value,
      limit: limit ?? this.limit,
    );
  }

  PaymentMethodModel toModel() {
    return PaymentMethodModel(
      id: id,
      name: name,
      isCard: isCard,
      isMoney: isMoney,
      dayClose: dayClose,
      value: value,
      limit: limit,
    );
  }

  DebtEntity toDebt() {
    return DebtEntity(
      id: id,
      name: '${isMoney ? 'Dinheiro: ' : 'Cartão: '} $name',
      value: value,
    );
  }

  @override
  String toString() {
    return 'PaymentMethodEntity{name: $name, isMoney: $isMoney, value: $value}\n';
  }
}
