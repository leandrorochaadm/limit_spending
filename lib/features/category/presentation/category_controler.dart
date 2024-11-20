import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../category.dart';
import 'category_state.dart';

class CategoryController {
  final GetCategoriesUseCase getCategoriesUseCase;
  final CreateCategoryUseCase createCategoryUseCase;
  final UpdateCategoryUseCase updateCategoryUseCase;
  final GetSumCategoriesUseCase getSumCategoriesUseCase;
  final ValueNotifier<CategoryState> state = ValueNotifier(CategoryState());
  final int daysFilter = 30;

  CategoryController({
    required this.getCategoriesUseCase,
    required this.createCategoryUseCase,
    required this.updateCategoryUseCase,
    required this.getSumCategoriesUseCase,
  }) {
    load();
  }

  Future<void> load() async {
    state.value = CategoryState(status: CategoryStatus.loading);
    final (errorMessage, categories) = await getCategoriesUseCase();

    if (errorMessage != null) {
      state.value = CategoryState(
        status: CategoryStatus.error,
        messageToUser: errorMessage,
      );
      return;
    }

    if (categories.isEmpty) {
      state.value = CategoryState(
        status: CategoryStatus.information,
        categories: categories,
        messageToUser: 'Nenhuma categoria cadastrada',
      );
      return;
    }

    final limitSum = categories.fold<double>(
      0,
      (previousValue, category) => previousValue + category.limitMonthly,
    );

    final consumedSum = categories.fold<double>(
      0,
      (previousValue, category) => previousValue + category.consumed,
    );

    final balanceSum = categories.fold<double>(
      0,
      (previousValue, category) => previousValue + category.balance,
    );

    state.value = CategoryState(
      status: CategoryStatus.success,
      categories: categories,
      consumedSum: consumedSum.toCurrency(),
      limitSum: limitSum.toCurrency(),
      balanceSum: balanceSum.toCurrency(),
    );
  }

  void createCategory(CategoryEntity category) async {
    state.value = CategoryState(status: CategoryStatus.loading);
    await createCategoryUseCase(category);
    await load();
  }

  void updateCategory(CategoryEntity category) async {
    state.value = CategoryState(status: CategoryStatus.loading);
    await updateCategoryUseCase(category);
    await load();
  }
}
