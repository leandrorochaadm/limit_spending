import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../data/debts_model.dart';

class DebtEntity implements Equatable {
  final String id;
  final String name;
  final double value;

  DebtEntity({
    String? id,
    required this.name,
    required this.value,
  }) : id = id ?? const Uuid().v4();

  DebtModel toModel() {
    return DebtModel(
      id: id,
      name: name,
      value: value,
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
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        value,
      ];

  @override
  bool? get stringify => true;

  @override
  String toString() {
    return 'DebtEntity{id: $id, name: $name, value: $value}\n';
  }
}
