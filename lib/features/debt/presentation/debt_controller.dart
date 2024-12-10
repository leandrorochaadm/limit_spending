import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../payment_method/domain/use_cases/get_card_payment_methods.dart';
import '../debit.dart';
import 'debt_state.dart';

class DebtController {
  final AddDebtValueUseCase addDebtValueUseCase;
  final GetDebtsUseCase getDebtsUseCase;
  final CreateDebtUseCase createDebtUseCase;
  final DeleteDebtUseCase deleteDebtUseCase;
  final UpdateDebitUseCase updateDebitUseCase;
  final GetCardPaymentMethodsUseCase getCardPaymentMethodsUseCase;

  final ValueNotifier<DebtState> state = ValueNotifier(DebtState());

  void Function(String message, bool isError)? onMessage;

  DebtController({
    required this.addDebtValueUseCase,
    required this.getDebtsUseCase,
    required this.createDebtUseCase,
    required this.deleteDebtUseCase,
    required this.updateDebitUseCase,
    required this.getCardPaymentMethodsUseCase,
  }) {
    load();
  }

  void load() async {
    state.value = DebtState(status: DebtStatus.loading);
    final debts = await getDebtsUseCase();
    final (failureCard, cards) = await getCardPaymentMethodsUseCase();
    if (failureCard != null) {
      onMessage?.call(failureCard.message, true);
    }

    final debtsCards = cards.map((element) => element.toDebt());

    final listDebts = <DebtEntity>[...debtsCards, ...debts];

    if (listDebts.isEmpty) {
      state.value = DebtState(
        status: DebtStatus.information,
        messageToUser: 'Parabens! Nenhuma dívida encontrada',
      );
    }

    final debtsSum = listDebts.fold<double>(
      0,
      (previousValue, debt) => previousValue + debt.value,
    );
    final debtsSumFormatted = debtsSum.toCurrency();

    state.value = DebtState(
      status: DebtStatus.success,
      debtsSum: debtsSumFormatted,
      debts: listDebts,
    );
  }

  Future<void> addDebtValue(String debtId, double debtValue) =>
      addDebtValueUseCase(debtId: debtId, debtValue: debtValue);
  Future<void> createDebt(DebtEntity debt) async {
    state.value = DebtState(status: DebtStatus.loading);
    await createDebtUseCase(debt);
    load();
  }

  Future<void> deleteDebt(String debtId) async {
    state.value = DebtState(status: DebtStatus.loading);
    final failure = await deleteDebtUseCase(debtId);
    if (failure != null) {
      onMessage?.call(failure.message, false);
      return;
    }
    onMessage?.call('Dívida excluida com sucesso', false);
    load();
  }

  Future<void> updateDebt(DebtEntity debt) async {
    state.value = DebtState(status: DebtStatus.loading);
    await updateDebitUseCase(debt);
    load();
  }
}
