import 'entity.dart';

abstract class DebtRepository {
  Future<List<DebtEntity>> getDebts();
  Future<void> createDebt(DebtEntity debt);
  Future<void> addDebtValue(String debtId, double debtValue);
  Future<double> getSumDebts();
  Future<void> deleteDebt(String debtId);
  Future<void> updateDebt(DebtEntity debt);
}
