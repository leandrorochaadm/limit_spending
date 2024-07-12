import 'package:flutter/foundation.dart';

import '../category.dart';

class CategoryController {
  final GetCategoriesUseCase getCategoriesUseCase;
  final CreateCategoryUseCase createCategoryUseCase;
  final UpdateCategoryUseCase updateCategoryUseCase;
  final GetSumCategoriesUseCase getSumCategoriesUseCase;
  final GetSumCategoryUseCase getSumCategoryUseCase;
  ValueNotifier<CategoryState> state = ValueNotifier<CategoryState>(
    CategoryState(status: CategoryStatus.initial),
  );

  CategoryController({
    required this.getCategoriesUseCase,
    required this.createCategoryUseCase,
    required this.updateCategoryUseCase,
    required this.getSumCategoriesUseCase,
    required this.getSumCategoryUseCase,
  });

  Stream<List<CategoryEntity>> get categoriesStream {
    state.value = state.value.copyWith(status: CategoryStatus.success);
    try {
      return getCategoriesUseCase();
    } catch (e) {
      state.value = state.value.copyWith(
        status: CategoryStatus.error,
        errorMessage: 'Erro ao obter categorias',
      );
    }
    return Stream.value([]);
  }

  void createCategory(CategoryEntity category) async {
    state.value = state.value.copyWith(status: CategoryStatus.loading);

    try {
      await createCategoryUseCase(category);
      state.value = state.value.copyWith(status: CategoryStatus.success);
    } catch (e) {
      state.value = state.value.copyWith(
        status: CategoryStatus.error,
        errorMessage: 'Erro ao criar categoria',
      );
    }
  }

  void updateCategory(CategoryEntity category) async {
    state.value = state.value.copyWith(status: CategoryStatus.loading);
    try {
      await updateCategoryUseCase(category);
      state.value = state.value.copyWith(status: CategoryStatus.success);
    } catch (e) {
      state.value = state.value.copyWith(
        status: CategoryStatus.error,
        errorMessage: 'Erro ao atualizar categoria',
      );
    }
  }

  Stream<CategorySumEntity> get sumCategories => getSumCategoriesUseCase();

  Stream<CategorySumEntity> getSumByCategory({
    required String categoryId,
    required double categoryLimit,
  }) =>
      getSumCategoryUseCase(
        categoryId: categoryId,
        limit: categoryLimit,
      );
}
