import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../data/debts_model.dart';

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

  @override
  List<Object?> get props => [id, name, value];

  @override
  bool? get stringify => true;
}
