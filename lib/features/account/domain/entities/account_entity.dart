import 'package:equatable/equatable.dart';

import '../../data/models/account_model.dart';
import 'account_type.dart';

class AccountEntity extends Equatable {
  final String id;
  final String name;
  final AccountType type;
  final double value;  // Saldo (money) ou Valor devido (loan/card)
  final double limit;  // Limite (card) - 0 para outros
  final int dayClose;  // Dia fechamento (card) - 0 para outros

  // Computed properties
  double get balance => switch (type) {
        AccountType.money => value,
        AccountType.card => limit - value,
        AccountType.loan => -value, // Negativo pois é dívida
      };

  bool get isMoney => type == AccountType.money;
  bool get isCard => type == AccountType.card;
  bool get isLoan => type == AccountType.loan;

  AccountEntity({
    String? id,
    required this.name,
    required this.type,
    required this.value,
    this.limit = 0,
    this.dayClose = 0,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        value,
        limit,
        dayClose,
      ];

  AccountEntity copyWith({
    String? id,
    String? name,
    AccountType? type,
    double? value,
    double? limit,
    int? dayClose,
  }) {
    return AccountEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      value: value ?? this.value,
      limit: limit ?? this.limit,
      dayClose: dayClose ?? this.dayClose,
    );
  }

  AccountModel toModel() {
    return AccountModel(
      id: id,
      name: name,
      type: type,
      value: value,
      limit: limit,
      dayClose: dayClose,
    );
  }

  @override
  String toString() {
    return 'AccountEntity{id: $id, name: $name, type: $type, value: $value, limit: $limit, dayClose: $dayClose}';
  }
}
