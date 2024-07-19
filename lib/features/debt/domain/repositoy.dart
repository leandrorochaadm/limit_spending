import 'entity.dart';

abstract class DebtRepository {
  Stream<List<DebtEntity>> getDebts();
  Future<void> createDebt(DebtEntity debt);
  Future<void> addDebtValue(String debtId, double debtValue);
  Stream<double> getSumDebts();
}
