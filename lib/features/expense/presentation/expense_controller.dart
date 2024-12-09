import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../category/domain/domain.dart';
import '../domain/domain.dart';
import 'expense_state.dart';

class ExpenseController {
  final CreateTransactionUseCase createTransactionUseCase;
  final DeleteTransactionUseCase deleteTransactionUseCase;
  final GetExpensesByDateCreatedUseCase getExpensesByCreatedUseCase;
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
    required this.createTransactionUseCase,
    required this.deleteTransactionUseCase,
    required this.getExpensesByCreatedUseCase,
    required this.category,
    required this.paymentMethodId,
  }) {
    load();
  }

  void Function(String message, bool isError)? onShowMessage;

  Future<void> load() async {
    state.value = state.value.copyWith(status: ExpenseStatus.loading);
    try {
      final (failure, expenses) = await getExpensesByCreatedUseCase(
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
      onShowMessage?.call('Erro ao obter despesas', true);
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

    final failure = await createTransactionUseCase(expense);
    if (failure != null) {
      onShowMessage?.call(failure.message, true);
    }

    onShowMessage?.call(
      'Despesa criada com sucesso: ${descriptionEC.text}',
      false,
    );
    await load();
  }

  Future<void> deleteExpense(ExpenseEntity expense) async {
    state.value = state.value.copyWith(status: ExpenseStatus.loading);

    final failure = await deleteTransactionUseCase(expense);
    if (failure != null) {
      onShowMessage?.call(failure.message, true);
    }

    await load();
    onShowMessage?.call(
      'Despesa excluida com sucesso: ${expense.description}',
      false,
    );
  }
}
