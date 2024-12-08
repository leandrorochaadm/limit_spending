import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../category/domain/domain.dart';
import '../../debt/debit.dart';
import '../domain/domain.dart';
import 'expense_state.dart';

class ExpenseController {
  final CreateExpenseUseCase createExpenseUseCase;
  final DeleteExpenseUseCase deleteExpenseUseCase;
  final GetSumCategoryUseCase getSumCategoryUseCase;
  final GetExpensesByDateCreatedUseCase getExpensesByCreatedUseCase;
  final GetDebtsUseCase getDebtsUseCase;
  final AddDebtValueUseCase addDebtValueUseCase;
  final CategoryEntity category;
  final String paymentMethodId;
  ValueNotifier<ExpenseState> state = ValueNotifier<ExpenseState>(
    const ExpenseState(status: ExpenseStatus.initial),
  );

  final TextEditingController descriptionEC = TextEditingController();
  final FocusNode descriptionFN = FocusNode();

  final TextEditingController valueEC = TextEditingController();
  final FocusNode valueFN = FocusNode();

  bool isValid() => descriptionEC.text.isNotEmpty && valueEC.text.isNotEmpty;

  ExpenseController({
    required this.createExpenseUseCase,
    required this.deleteExpenseUseCase,
    required this.getSumCategoryUseCase,
    required this.getExpensesByCreatedUseCase,
    required this.getDebtsUseCase,
    required this.addDebtValueUseCase,
    required this.category,
    required this.paymentMethodId,
  }) {
    load();
  }

  Future<void> load() async {
    state.value = state.value.copyWith(status: ExpenseStatus.loading);
    try {
      final expenses = await getExpensesByCreatedUseCase(
        categoryId: category.id,
        days: daysFilter,
      );

      final expensesSum = expenses.fold<double>(
        0,
        (previousValue, expense) => previousValue + expense.value,
      );
      final balance = category.limitMonthly - expensesSum;

      state.value = ExpenseState(
        status: ExpenseStatus.success,
        expenses: expenses,
        consumedSum: expensesSum.toCurrency(),
        limitCategory: category.limitMonthly.toCurrency(),
        balance: balance.toCurrency(),
      );

      clearForm();
    } catch (e) {
      state.value = const ExpenseState(
        status: ExpenseStatus.error,
        errorMessage: 'Erro ao obter despesas',
      );
    }
  }

  void clearForm() {
    descriptionEC.clear();
    valueEC.clear();
  }

  Future<void> createExpense() async {
    state.value = state.value.copyWith(status: ExpenseStatus.loading);

    final valueDouble = double.parse(valueEC.text.toPointFormat());
    var expense = ExpenseEntity(
      description: descriptionEC.text,
      created: DateTime.now(),
      value: valueEC.text.isEmpty ? 0 : valueDouble,
      categoryId: category.id,
      paymentMethodId: paymentMethodId,
    );

    try {
      await createExpenseUseCase(expense);
      await load();
    } catch (e) {
      state.value = state.value.copyWith(
        status: ExpenseStatus.error,
        errorMessage: 'Erro ao criar despesa',
      );
    }
  }

  Future<void> deleteExpense(ExpenseEntity expense) async {
    state.value = state.value.copyWith(status: ExpenseStatus.loading);
    try {
      await deleteExpenseUseCase(expense);

      await load();
    } catch (e) {
      state.value = state.value.copyWith(
        status: ExpenseStatus.error,
        errorMessage: 'Erro ao deletar despesa',
      );
    }
  }
}
