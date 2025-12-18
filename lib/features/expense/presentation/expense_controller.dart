import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../category/domain/domain.dart';
import '../domain/domain.dart';
import 'expense_state.dart';

class ExpenseController {
  final CreateTransactionUseCase createTransactionUseCase;
  final DeleteTransactionUseCase deleteTransactionUseCase;
  final GetExpensesByDateCreatedUseCase getExpensesByCreatedUseCase;
  final GetExpensesPaginatedUseCase getExpensesPaginatedUseCase;
  final CategoryEntity category;
  final String paymentMethodId;
  final bool isMoney;
  final Function? onGoBack;

  static const int _pageSize = 10;

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
    required this.getExpensesPaginatedUseCase,
    required this.category,
    required this.paymentMethodId,
    required this.isMoney,
    required this.onGoBack,
  }) {
    load();
  }

  void Function(String message, bool isError)? onShowMessage;
  void Function(Function? onGoBack)? onGoBackFunction;

  Future<void> load() async {
    state.value = state.value.copyWith(
      status: ExpenseStatus.loading,
      clearLastDocument: true,
    );

    try {
      // Load first page
      final (failure, result) = await getExpensesPaginatedUseCase(
        categoryId: category.id,
        days: daysFilter,
        paginationParams: PaginationParams.firstPage(pageSize: _pageSize),
      );

      if (failure != null) {
        state.value = state.value.copyWith(
          status: ExpenseStatus.error,
          errorMessage: failure.message,
        );
        onShowMessage?.call(failure.message, true);
        return;
      }

      // Calculate sum using non-paginated query to get accurate total
      final (_, allExpenses) = await getExpensesByCreatedUseCase(
        categoryId: category.id,
        days: daysFilter,
      );

      final expensesSum = allExpenses.fold<double>(
        0,
        (previousValue, expense) => previousValue + expense.value,
      );

      final balance = category.limitMonthly - expensesSum;

      state.value = ExpenseState(
        status: ExpenseStatus.success,
        expenses: result.items,
        consumedSum: expensesSum.toCurrency(),
        limitCategory: category.limitMonthly.toCurrency(),
        balance: balance.toCurrency(),
        hasMore: result.hasMore,
        lastDocument: result.lastDocument,
        isLoadingMore: false,
      );

      clearForm();
    } catch (e) {
      state.value = state.value.copyWith(
        status: ExpenseStatus.error,
        errorMessage: 'Erro ao obter despesas',
      );
      onShowMessage?.call('Erro ao obter despesas', true);
    }
  }

  Future<void> loadMore() async {
    if (!state.value.canLoadMore) return;
    if (state.value.lastDocument == null) return;

    state.value = state.value.copyWith(
      isLoadingMore: true,
      status: ExpenseStatus.loadingMore,
    );

    try {
      final (failure, result) = await getExpensesPaginatedUseCase(
        categoryId: category.id,
        days: daysFilter,
        paginationParams: PaginationParams.nextPage(
          lastDocument: state.value.lastDocument!,
          pageSize: _pageSize,
        ),
      );

      if (failure != null) {
        state.value = state.value.copyWith(
          status: ExpenseStatus.success,
          isLoadingMore: false,
        );
        onShowMessage?.call(failure.message, true);
        return;
      }

      final allExpenses = [...state.value.expenses, ...result.items];

      state.value = state.value.copyWith(
        status: ExpenseStatus.success,
        expenses: allExpenses,
        hasMore: result.hasMore,
        lastDocument: result.lastDocument,
        isLoadingMore: false,
      );
    } catch (e) {
      state.value = state.value.copyWith(
        status: ExpenseStatus.success,
        isLoadingMore: false,
      );
      onShowMessage?.call('Erro ao carregar mais despesas', true);
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
      isMoney: isMoney,
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

  void clickGoBack() {
    onGoBackFunction?.call(onGoBack);
  }
}
