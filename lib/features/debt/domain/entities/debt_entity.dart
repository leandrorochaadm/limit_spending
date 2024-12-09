import 'package:equatable/equatable.dart';

import '../../data/debts_model.dart';

class DebtEntity implements Equatable {
  final String id;
  final String name;
  final double value;
  final bool isCardCredit;

  DebtEntity({
    String? id,
    required this.name,
    required this.value,
    this.isCardCredit = false,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  DebtModel toModel() {
    return DebtModel(
      id: id,
      name: name,
      value: value,
      isCardCredit: isCardCredit,
    );
  }

  DebtEntity copyWith({
    String? id,
    String? name,
    double? value,
    bool? isCardCredit,
  }) {
    return DebtEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
      isCardCredit: isCardCredit ?? this.isCardCredit,
    );
  }

  @override
  List<Object?> get props => [id, name, value, isCardCredit];

  @override
  bool? get stringify => true;

  @override
  String toString() {
    return 'DebtEntity{id: $id, name: $name, value: $value, isCardCredit: $isCardCredit}\n';
  }
}
