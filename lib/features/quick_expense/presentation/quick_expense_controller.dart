import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../account/domain/entities/account_entity.dart';
import '../../account/domain/usecases/get_accounts_usecase.dart';
import '../../category/domain/entities/category_entity.dart';
import '../../category/domain/usecases/usecases.dart';
import '../../expense/domain/entities/expense_entity.dart';
import 'quick_expense_state.dart';

class QuickExpenseController {
  // Dependencies
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetAccountsUseCase getAccountsUseCase;
  final CreateTransactionUseCase createTransactionUseCase;
  Function? onShowMessage;
  Function? onGoBack;

  // Form controllers
  final descriptionEC = TextEditingController();
  final valueEC = TextEditingController();

  // State
  final ValueNotifier<QuickExpenseState> state = ValueNotifier<QuickExpenseState>(
    const QuickExpenseState(status: QuickExpenseStatus.initial),
  );

  QuickExpenseController({
    required this.getCategoriesUseCase,
    required this.getAccountsUseCase,
    required this.createTransactionUseCase,
    this.onShowMessage,
    this.onGoBack,
  });

  Future<void> load() async {
    state.value = state.value.copyWith(status: QuickExpenseStatus.loading);

    // Buscar categorias
    final (categoryFailure, categories) = await getCategoriesUseCase();

    if (categoryFailure != null) {
      state.value = state.value.copyWith(
        status: QuickExpenseStatus.error,
        errorMessage: categoryFailure.message,
      );
      return;
    }

    // Buscar accounts
    final (accountFailure, accounts) = await getAccountsUseCase(false);

    if (accountFailure != null) {
      state.value = state.value.copyWith(
        status: QuickExpenseStatus.error,
        errorMessage: accountFailure.message,
      );
      return;
    }

    // Filtrar apenas contas que não são do tipo loan
    final availableAccounts = accounts?.where((account) => !account.isLoan).toList() ?? [];

    state.value = QuickExpenseState(
      status: QuickExpenseStatus.success,
      categories: categories,
      accounts: availableAccounts,
      selectedCategory: null,
      selectedAccount: null,
    );
  }

  void selectCategory(CategoryEntity category) {
    state.value = state.value.copyWith(selectedCategory: category);
  }

  void selectAccount(AccountEntity account) {
    state.value = state.value.copyWith(selectedAccount: account);
  }

  bool isValid() {
    return descriptionEC.text.isNotEmpty &&
        valueEC.text.isNotEmpty &&
        state.value.selectedCategory != null &&
        state.value.selectedAccount != null;
  }

  Future<void> createExpense() async {
    if (!isValid()) {
      onShowMessage?.call('Preencha todos os campos', true);
      return;
    }

    state.value = state.value.copyWith(status: QuickExpenseStatus.loading);

    final valueDouble = double.parse(valueEC.text.toPointFormat());
    final expense = ExpenseEntity(
      description: descriptionEC.text,
      created: DateTime.now(),
      value: valueDouble,
      categoryId: state.value.selectedCategory!.id,
      paymentMethodId: '', // Não usado mais
      isMoney: state.value.selectedAccount!.isMoney,
      accountId: state.value.selectedAccount!.id,
    );

    final failure = await createTransactionUseCase(expense);

    if (failure != null) {
      state.value = state.value.copyWith(
        status: QuickExpenseStatus.error,
        errorMessage: failure.message,
      );
      onShowMessage?.call(failure.message, true);
      return;
    }

    state.value = state.value.copyWith(status: QuickExpenseStatus.saved);
    onShowMessage?.call('Despesa criada com sucesso: ${descriptionEC.text}', false);

    // Limpar campos
    descriptionEC.clear();
    valueEC.clear();

    // Voltar ou recarregar
    onGoBack?.call();
  }

  void dispose() {
    descriptionEC.dispose();
    valueEC.dispose();
    state.dispose();
  }
}
