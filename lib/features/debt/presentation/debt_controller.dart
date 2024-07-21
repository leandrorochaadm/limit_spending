import '../debit.dart';

class DebtController {
  final AddDebtValueUseCase addDebtValueUseCase;
  final GetSumDebtsUseCase getSumDebtsUseCase;
  final GetDebtsUseCase getDebtsUseCase;
  final CreateDebtUseCase createDebtUseCase;
  final DeleteDebtUseCase deleteDebtUseCase;
  final UpdateDebitUseCase updateDebitUseCase;
  DebtController({
    required this.addDebtValueUseCase,
    required this.getSumDebtsUseCase,
    required this.getDebtsUseCase,
    required this.createDebtUseCase,
    required this.deleteDebtUseCase,
    required this.updateDebitUseCase,
  });

  Stream<double> getSumDebts() => getSumDebtsUseCase();
  Stream<List<DebtEntity>> getDebts() => getDebtsUseCase();
  Future<void> addDebtValue(String debtId, double debtValue) =>
      addDebtValueUseCase(debtId, debtValue);
  Future<void> createDebt(DebtEntity debt) => createDebtUseCase(debt);
  Future<void> deleteDebt(String debtId) => deleteDebtUseCase(debtId);
  Future<void> updateDebt(DebtEntity debt) => updateDebitUseCase(debt);
}
