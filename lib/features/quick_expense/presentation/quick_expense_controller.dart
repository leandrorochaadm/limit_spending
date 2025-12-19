import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../category/domain/entities/category_entity.dart';
import '../../category/domain/usecases/usecases.dart';
import '../../expense/domain/entities/expense_entity.dart';
import '../../payment_method/domain/entities/payment_method_entity.dart';
import '../../payment_method/domain/use_cases/get_all_payment_methods.dart';
import 'quick_expense_state.dart';

class QuickExpenseController {
  // Dependencies
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetAllPaymentMethodsUseCase getPaymentMethodsUseCase;
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
    required this.getPaymentMethodsUseCase,
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

    // Buscar payment methods
    final (paymentFailure, paymentMethods) = await getPaymentMethodsUseCase(false);

    if (paymentFailure != null) {
      state.value = state.value.copyWith(
        status: QuickExpenseStatus.error,
        errorMessage: paymentFailure.message,
      );
      return;
    }

    state.value = QuickExpenseState(
      status: QuickExpenseStatus.success,
      categories: categories,
      paymentMethods: paymentMethods,
      selectedCategory: null,
      selectedPaymentMethod: null,
    );
  }

  void selectCategory(CategoryEntity category) {
    state.value = state.value.copyWith(selectedCategory: category);
  }

  void selectPaymentMethod(PaymentMethodEntity paymentMethod) {
    state.value = state.value.copyWith(selectedPaymentMethod: paymentMethod);
  }

  bool isValid() {
    return descriptionEC.text.isNotEmpty &&
        valueEC.text.isNotEmpty &&
        state.value.selectedCategory != null &&
        state.value.selectedPaymentMethod != null;
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
      paymentMethodId: state.value.selectedPaymentMethod!.id,
      isMoney: state.value.selectedPaymentMethod!.isMoney,
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
