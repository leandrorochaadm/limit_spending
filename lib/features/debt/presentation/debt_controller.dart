import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../payment_method/domain/use_cases/get_card_payment_methods.dart';
import '../debit.dart';
import 'debt_state.dart';

class DebtController {
  final AddDebtValueUseCase addDebtValueUseCase;
  final GetDebtsUseCase getDebtsUseCase;
  final GetDebtsPaginatedUseCase getDebtsPaginatedUseCase;
  final CreateDebtUseCase createDebtUseCase;
  final DeleteDebtUseCase deleteDebtUseCase;
  final UpdateDebitUseCase updateDebitUseCase;
  final GetCardPaymentMethodsUseCase getCardPaymentMethodsUseCase;

  static const int _pageSize = 10;

  final ValueNotifier<DebtState> state = ValueNotifier(const DebtState());

  void Function(String message, bool isError)? onMessage;

  DebtController({
    required this.addDebtValueUseCase,
    required this.getDebtsUseCase,
    required this.getDebtsPaginatedUseCase,
    required this.createDebtUseCase,
    required this.deleteDebtUseCase,
    required this.updateDebitUseCase,
    required this.getCardPaymentMethodsUseCase,
  }) {
    load();
  }

  void load() async {
    state.value = state.value.copyWith(
      status: DebtStatus.loading,
      clearLastDocument: true,
    );

    // Load cards (not paginated)
    final (failureCard, cards) = await getCardPaymentMethodsUseCase();
    if (failureCard != null) {
      onMessage?.call(failureCard.message, true);
    }

    // Load first page of debts
    final (failureDebt, result) = await getDebtsPaginatedUseCase(
      paginationParams: PaginationParams.firstPage(pageSize: _pageSize),
    );

    if (failureDebt != null) {
      state.value = state.value.copyWith(
        status: DebtStatus.error,
        messageToUser: failureDebt.message,
      );
      onMessage?.call(failureDebt.message, true);
      return;
    }

    final debtsCards = cards.map((element) => element.toDebt()).toList();
    final listDebts = <DebtEntity>[...debtsCards, ...result.items];
    listDebts.sort((a, b) => b.name.compareTo(a.name));

    if (listDebts.isEmpty) {
      state.value = DebtState(
        status: DebtStatus.information,
        messageToUser: 'Parabens! Nenhuma dívida encontrada',
      );
      return;
    }

    // Calculate sum using non-paginated query
    final (_, allDebts) = await getDebtsUseCase();
    final allListDebts = <DebtEntity>[...debtsCards, ...allDebts];
    final debtsSum = allListDebts.fold<double>(
      0,
      (previousValue, debt) => previousValue + debt.value,
    );
    final debtsSumFormatted = debtsSum.toCurrency();

    state.value = DebtState(
      status: DebtStatus.success,
      debtsSum: debtsSumFormatted,
      debts: listDebts,
      hasMore: result.hasMore,
      lastDocument: result.lastDocument,
      isLoadingMore: false,
    );
  }

  void loadMore() async {
    if (!state.value.canLoadMore) return;
    if (state.value.lastDocument == null) return;

    state.value = state.value.copyWith(
      isLoadingMore: true,
      status: DebtStatus.loadingMore,
    );

    final (failureDebt, result) = await getDebtsPaginatedUseCase(
      paginationParams: PaginationParams.nextPage(
        lastDocument: state.value.lastDocument!,
        pageSize: _pageSize,
      ),
    );

    if (failureDebt != null) {
      state.value = state.value.copyWith(
        status: DebtStatus.success,
        isLoadingMore: false,
      );
      onMessage?.call(failureDebt.message, true);
      return;
    }

    // Get cards from current state
    final currentDebts = state.value.debts;
    final debtsCards = currentDebts.where((d) => d.isCardCredit).toList();
    final currentPureDebts =
        currentDebts.where((d) => !d.isCardCredit).toList();

    // Merge new debts
    final allDebts = <DebtEntity>[
      ...debtsCards,
      ...currentPureDebts,
      ...result.items,
    ];
    allDebts.sort((a, b) => b.name.compareTo(a.name));

    state.value = state.value.copyWith(
      status: DebtStatus.success,
      debts: allDebts,
      hasMore: result.hasMore,
      lastDocument: result.lastDocument,
      isLoadingMore: false,
    );
  }

  Future<void> addDebtValue(String debtId, double debtValue) =>
      addDebtValueUseCase(debtId: debtId, debtValue: debtValue);

  Future<void> createDebt(DebtEntity debt) async {
    state.value = state.value.copyWith(status: DebtStatus.loading);
    final failure = await createDebtUseCase(debt);
    if (failure != null) {
      onMessage?.call(failure.message, false);
      return;
    }

    onMessage?.call('Dívida criada com sucesso', false);
    load();
  }

  Future<void> deleteDebt(String debtId) async {
    state.value = state.value.copyWith(status: DebtStatus.loading);
    final failure = await deleteDebtUseCase(debtId);
    if (failure != null) {
      onMessage?.call(failure.message, false);
      return;
    }
    onMessage?.call('Dívida excluida com sucesso', false);
    load();
  }

  Future<void> updateDebt(DebtEntity debt) async {
    state.value = state.value.copyWith(status: DebtStatus.loading);
    final failure = await updateDebitUseCase(debt);
    if (failure != null) {
      onMessage?.call(failure.message, false);
      return;
    }

    onMessage?.call('Dívida atualizada com sucesso', false);
    load();
  }
}
