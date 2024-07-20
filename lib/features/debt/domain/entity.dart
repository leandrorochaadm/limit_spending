import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../data/debts_model.dart';

class DebtEntity implements Equatable {
  final String id;
  final String name;
  final double value;
  final bool isPayment;
  final int dayClose;

  DebtEntity({
    String? id,
    required this.name,
    required this.value,
    required this.dayClose,
    this.isPayment = false,
  }) : id = id ?? const Uuid().v4();

  DebtModel toModel() {
    return DebtModel(
      id: id,
      name: name,
      value: value,
      isPayment: isPayment,
      dayClose: dayClose,
    );
  }

  @override
  List<Object?> get props => [id, name, value, isPayment, dayClose];

  @override
  bool? get stringify => true;

  @override
  String toString() {
    return 'DebtEntity{id: $id, name: $name, value: $value, isPayment: $isPayment, dayClose: $dayClose}\n';
  }
}
