import 'package:flutter/material.dart';

import '../../category/domain/entities/category_entity.dart';
import '../../category/domain/usecases/get_categories_usecase.dart';
import '../domain/domain.dart';
import 'expense_state.dart';

class ExpenseController {
  final GetExpensesUseCase getExpensesUseCase;
  final CreateExpenseUseCase createExpenseUseCase;
  final UpdateExpenseUseCase updateExpenseUseCase;
  final DeleteExpenseUseCase deleteExpenseUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;

  ValueNotifier<ExpenseState> state = ValueNotifier<ExpenseState>(
    ExpenseState(status: ExpenseStatus.initial),
  );

  ExpenseController({
    required this.getExpensesUseCase,
    required this.createExpenseUseCase,
    required this.updateExpenseUseCase,
    required this.deleteExpenseUseCase,
    required this.getCategoriesUseCase,
  });

  Stream<List<ExpenseEntity>> get expensesStream {
    state.value = state.value.copyWith(status: ExpenseStatus.success);
    try {
      return getExpensesUseCase();
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
      createExpenseUseCase(expense);
      state.value = state.value.copyWith(status: ExpenseStatus.success);
    } catch (e) {
      state.value = state.value.copyWith(
        status: ExpenseStatus.error,
        errorMessage: 'Erro ao criar despesa',
      );
    }
  }

  void deleteExpense(ExpenseEntity expense) {
    state.value = state.value.copyWith(status: ExpenseStatus.loading);
    try {
      deleteExpenseUseCase(expense);
      state.value = state.value.copyWith(status: ExpenseStatus.success);
    } catch (e) {
      state.value = state.value.copyWith(
        status: ExpenseStatus.error,
        errorMessage: 'Erro ao deletar despesa',
      );
    }
  }

  void updateExpense(ExpenseEntity expense) {
    state.value = state.value.copyWith(status: ExpenseStatus.loading);
    try {
      updateExpenseUseCase(expense);
      state.value = state.value.copyWith(status: ExpenseStatus.success);
    } catch (e) {
      state.value = state.value.copyWith(
        status: ExpenseStatus.error,
        errorMessage: 'Erro ao atualizar despesa',
      );
    }
  }

  Stream<List<CategoryEntity>> categoriesStream() {
    try {
      return getCategoriesUseCase();
    } catch (e) {
      state.value = state.value.copyWith(
        status: ExpenseStatus.error,
        errorMessage: 'Erro ao obter categorias',
      );
    }
    return Stream.value([]);
  }
}
