import 'package:flutter/foundation.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/usecases/category_create_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import 'category_state.dart';

class CategoryController {
  final GetCategoriesUseCase getCategoriesUseCase;
  final CreateCategoryUseCase createCategoryUseCase;
  ValueNotifier<CategoryState> state = ValueNotifier<CategoryState>(
    CategoryState(status: CategoryStatus.initial),
  );

  CategoryController({
    required this.getCategoriesUseCase,
    required this.createCategoryUseCase,
  });

  void fetchCategories() {
    state.value = state.value.copyWith(status: CategoryStatus.loading);
    getCategoriesUseCase().listen(
      (categories) {
        state.value = state.value.copyWith(
          status: CategoryStatus.success,
          categories: categories,
        );
      },
      onError: (error) {
        state.value = state.value.copyWith(
          status: CategoryStatus.error,
          errorMessage: error.toString(),
        );
      },
    );
  }

  void createCategory(CategoryEntity category) async {
    state.value = state.value.copyWith(status: CategoryStatus.loading);

    await createCategoryUseCase(category);

    state.value = state.value.copyWith(status: CategoryStatus.success);
  }
}
