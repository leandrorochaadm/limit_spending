import 'debt_entity.dart';

class DebtsEntity {
  final List<DebtEntity> debts;

  DebtsEntity(this.debts);

  double get sumDebts => debts.fold<double>(
        0.0,
        (previousValue, element) => previousValue + element.value,
      );
}
