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
  CategoryEntity _categorySelected = CategoryEntity.empty();

  set categorySelected(CategoryEntity category) {
    _categorySelected = category;
    nameEC.text = category.name;
    limitEC.text = category.limitMonthly.toStringAsFixed(2);
  }

  TextEditingController nameEC = TextEditingController();
  final FocusNode nameFN = FocusNode();
  TextEditingController limitEC = TextEditingController();
  final FocusNode limitFN = FocusNode();

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

    clearForm();

    state.value = CategoryState(
      status: CategoryStatus.success,
      categories: categories,
      consumedSum: consumedSum.toCurrency(),
      limitSum: limitSum.toCurrency(),
      balanceSum: balanceSum.toCurrency(),
    );
  }

  void clearForm() {
    nameEC.clear();
    limitEC.clear();
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

  void submit() {
    final bool isModeEdition = _categorySelected.name.isNotEmpty;
    print('isModeEdition: $isModeEdition');
    if (isModeEdition) {
      CategoryEntity category = _categorySelected.toModel().copyWith(
            name: nameEC.text,
            limitMonthly: limitEC.text.isEmpty
                ? 0
                : double.parse(limitEC.text.toPointFormat()),
          );
      print(category);
      updateCategory(category);
    } else {
      final category = CategoryEntity(
        name: nameEC.text,
        created: DateTime.now(),
        limitMonthly: limitEC.text.isEmpty ? 0 : double.parse(limitEC.text),
        consumed: 0,
      );
      print(category);
      createCategory(category);
    }
  }
}
