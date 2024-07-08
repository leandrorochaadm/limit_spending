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

  Stream<List<CategoryEntity>> get categoriesStream => getCategoriesUseCase();

  void createCategory(CategoryEntity category) async {
    state.value = state.value.copyWith(status: CategoryStatus.loading);

    await createCategoryUseCase(category);

    state.value = state.value.copyWith(status: CategoryStatus.success);
  }
}
