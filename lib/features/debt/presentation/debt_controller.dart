import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../debit.dart';
import 'debt_state.dart';

class DebtController {
  final AddDebtValueUseCase addDebtValueUseCase;
  final GetDebtsUseCase getDebtsUseCase;
  final CreateDebtUseCase createDebtUseCase;
  final DeleteDebtUseCase deleteDebtUseCase;
  final UpdateDebitUseCase updateDebitUseCase;

  final ValueNotifier<DebtState> state = ValueNotifier(DebtState());
  DebtController({
    required this.addDebtValueUseCase,
    required this.getDebtsUseCase,
    required this.createDebtUseCase,
    required this.deleteDebtUseCase,
    required this.updateDebitUseCase,
  }) {
    load();
  }

  void load() async {
    state.value = DebtState(status: DebtStatus.loading);
    final debts = await getDebtsUseCase();

    if (debts.isEmpty) {
      state.value = DebtState(
        status: DebtStatus.information,
        messageToUser: 'Parabens! Nenhuma dívida encontrada',
      );
    }

    final debtsSum = debts.fold<double>(
      0,
      (previousValue, debt) => previousValue + debt.value,
    );
    final debtsSumFormatted = debtsSum.toCurrency();

    state.value = DebtState(
      status: DebtStatus.success,
      debtsSum: debtsSumFormatted,
      debts: debts,
    );
  }

  Future<void> addDebtValue(String debtId, double debtValue) =>
      addDebtValueUseCase(debtId, debtValue);
  Future<void> createDebt(DebtEntity debt) async {
    state.value = DebtState(status: DebtStatus.loading);
    await createDebtUseCase(debt);
    load();
  }

  Future<void> deleteDebt(String debtId) async {
    state.value = DebtState(status: DebtStatus.loading);
    await deleteDebtUseCase(debtId);
    load();
  }

  Future<void> updateDebt(DebtEntity debt) async {
    state.value = DebtState(status: DebtStatus.loading);
    await updateDebitUseCase(debt);
    load();
  }
}
