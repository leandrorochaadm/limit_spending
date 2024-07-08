import 'package:flutter/foundation.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/usecases/usecases.dart';
import 'category_state.dart';

class CategoryController {
  final GetCategoriesUseCase getCategoriesUseCase;
  final CreateCategoryUseCase createCategoryUseCase;
  final UpdateCategoryUseCase updateCategoryUseCase;
  ValueNotifier<CategoryState> state = ValueNotifier<CategoryState>(
    CategoryState(status: CategoryStatus.initial),
  );

  CategoryController({
    required this.getCategoriesUseCase,
    required this.createCategoryUseCase,
    required this.updateCategoryUseCase,
  });

  Stream<List<CategoryEntity>> get categoriesStream => getCategoriesUseCase();

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
}
