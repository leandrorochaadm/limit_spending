import '../domain/entity.dart';

enum DebtStatus { initial, loading, success, error, information }

class DebtState {
  final DebtStatus status;
  final String? messageToUser;
  final List<DebtEntity> debts;

  final String debtsSum;
  DebtState({
    this.status = DebtStatus.initial,
    this.messageToUser,
    this.debts = const [],
    this.debtsSum = 'R\$ 0,00',
  });
}
