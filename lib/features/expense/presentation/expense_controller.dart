import 'package:flutter/material.dart';

import '../../category/domain/domain.dart';
import '../../debt/debit.dart';
import '../domain/domain.dart';
import 'expense_state.dart';

class ExpenseController {
  final CreateExpenseUseCase _createExpenseUseCase;
  final DeleteExpenseUseCase _deleteExpenseUseCase;
  final GetSumCategoryUseCase _getSumCategoryUseCase;
  final GetExpensesByCreatedUseCase _getExpensesByCreatedUseCase;
  final GetDebtsUseCase _getDebtsUseCase;
  final AddDebtValueUseCase _addDebtValueUseCase;

  ValueNotifier<ExpenseState> state = ValueNotifier<ExpenseState>(
    ExpenseState(status: ExpenseStatus.initial),
  );

  ExpenseController({
    required CreateExpenseUseCase createExpenseUseCase,
    required DeleteExpenseUseCase deleteExpenseUseCase,
    required GetSumCategoryUseCase getSumCategoryUseCase,
    required GetExpensesByCreatedUseCase getExpensesByCreatedUseCase,
    required GetDebtsUseCase getDebtsUseCase,
    required AddDebtValueUseCase addDebtValueUseCase,
  })  : _createExpenseUseCase = createExpenseUseCase,
        _deleteExpenseUseCase = deleteExpenseUseCase,
        _getSumCategoryUseCase = getSumCategoryUseCase,
        _getExpensesByCreatedUseCase = getExpensesByCreatedUseCase,
        _getDebtsUseCase = getDebtsUseCase,
        _addDebtValueUseCase = addDebtValueUseCase;

  Stream<List<ExpenseEntity>> expensesStream(String categoryId) {
    state.value = state.value.copyWith(status: ExpenseStatus.success);
    try {
      return _getExpensesByCreatedUseCase(categoryId: categoryId);
    } catch (e) {
      state.value = state.value.copyWith(
        status: ExpenseStatus.error,
        errorMessage: 'Erro ao obter despesas',
      );
    }
    return Stream.value([]);
  }

  void createExpense(ExpenseEntity expense) {
    state.value = state.value.copyWith(status: ExpenseStatus.loading);
    try {
      _createExpenseUseCase(expense);
      state.value = state.value.copyWith(status: ExpenseStatus.success);
    } catch (e) {
      state.value = state.value.copyWith(
        status: ExpenseStatus.error,
        errorMessage: 'Erro ao criar despesa',
      );
    }
  }

  void deleteExpense({required ExpenseEntity expense, required String debtId}) {
    state.value = state.value.copyWith(status: ExpenseStatus.loading);
    try {
      _deleteExpenseUseCase(expense);

      _addDebtValueUseCase(debtId, -expense.value);
      state.value = state.value.copyWith(status: ExpenseStatus.success);
    } catch (e) {
      state.value = state.value.copyWith(
        status: ExpenseStatus.error,
        errorMessage: 'Erro ao deletar despesa',
      );
    }
  }

  Stream<CategorySumEntity> getSumByCategory({
    required String categoryId,
    required double categoryLimit,
  }) =>
      _getSumCategoryUseCase(
        categoryId: categoryId,
        limit: categoryLimit,
      );

  Future<List<DebtEntity>> getDebts() => _getDebtsUseCase().first;

  Future<void> addDebtValue(String debtId, double debtValue) =>
      _addDebtValueUseCase(debtId, debtValue);
}
