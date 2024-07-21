import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../data/debts_model.dart';

class DebtEntity implements Equatable {
  final String id;
  final String name;
  final double value;
  final bool isPayment;
  final int dayClose;
  final bool isCardCredit;

  DebtEntity({
    String? id,
    required this.name,
    required this.value,
    required this.dayClose,
    this.isPayment = false,
    this.isCardCredit = false,
  }) : id = id ?? const Uuid().v4();

  bool isAllowsToBuy() {
    if (isCardCredit) {
      return dayClose < DateTime.now().day;
    }
    if (isPayment) {
      return value > 0;
    }
    return false;
  }

  DebtModel toModel() {
    return DebtModel(
      id: id,
      name: name,
      value: value,
      isPayment: isPayment,
      dayClose: dayClose,
      isCardCredit: isCardCredit,
    );
  }

  DebtEntity copyWith({
    String? id,
    String? name,
    double? value,
    bool? isPayment,
    int? dayClose,
    bool? isCardCredit,
  }) {
    return DebtEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
      isPayment: isPayment ?? this.isPayment,
      dayClose: dayClose ?? this.dayClose,
      isCardCredit: isCardCredit ?? this.isCardCredit,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        value,
        isPayment,
        dayClose,
        isCardCredit,
      ];

  @override
  bool? get stringify => true;

  @override
  String toString() {
    return 'DebtEntity{id: $id, name: $name, value: $value, isPayment: $isPayment, dayClose: $dayClose, isCardCredit: $isCardCredit}\n';
  }
}
