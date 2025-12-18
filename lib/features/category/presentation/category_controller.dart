import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../category.dart';
import 'category_state.dart';

class CategoryController {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetCategoriesPaginatedUseCase getCategoriesPaginatedUseCase;
  final CreateCategoryUseCase createCategoryUseCase;
  final UpdateCategoryUseCase updateCategoryUseCase;

  static const int _pageSize = 10;

  final ValueNotifier<CategoryState> state =
      ValueNotifier(const CategoryState());
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
    required this.getCategoriesPaginatedUseCase,
    required this.createCategoryUseCase,
    required this.updateCategoryUseCase,
  }) {
    load();
  }

  void Function(String message, bool isError)? onMessage;

  Future<void> load() async {
    state.value = state.value.copyWith(
      status: CategoryStatus.loading,
      clearLastDocument: true,
    );

    // Load first page
    final (errorMessage, result) = await getCategoriesPaginatedUseCase(
      paginationParams: PaginationParams.firstPage(pageSize: _pageSize),
    );

    if (errorMessage != null) {
      state.value = state.value.copyWith(
        status: CategoryStatus.error,
        messageToUser: errorMessage.message,
      );
      onMessage?.call(errorMessage.message, true);
      return;
    }

    if (result.items.isEmpty) {
      state.value = const CategoryState(
        status: CategoryStatus.information,
        messageToUser: 'Nenhuma categoria cadastrada',
      );
      return;
    }

    // Calculate sums using non-paginated query
    final (_, allCategories) = await getCategoriesUseCase();

    final limitSum = allCategories.fold<double>(
      0,
      (previousValue, category) => previousValue + category.limitMonthly,
    );

    final consumedSum = allCategories.fold<double>(
      0,
      (previousValue, category) => previousValue + category.consumed,
    );

    final balanceSum = allCategories.fold<double>(
      0,
      (previousValue, category) => previousValue + category.balance,
    );

    clearForm();

    state.value = CategoryState(
      status: CategoryStatus.success,
      categories: result.items,
      consumedSum: consumedSum.toCurrency(),
      limitSum: limitSum.toCurrency(),
      balanceSum: balanceSum.toCurrency(),
      hasMore: result.hasMore,
      lastDocument: result.lastDocument,
      isLoadingMore: false,
    );
  }

  Future<void> loadMore() async {
    if (!state.value.canLoadMore) return;
    if (state.value.lastDocument == null) return;

    state.value = state.value.copyWith(
      isLoadingMore: true,
      status: CategoryStatus.loadingMore,
    );

    final (errorMessage, result) = await getCategoriesPaginatedUseCase(
      paginationParams: PaginationParams.nextPage(
        lastDocument: state.value.lastDocument!,
        pageSize: _pageSize,
      ),
    );

    if (errorMessage != null) {
      state.value = state.value.copyWith(
        status: CategoryStatus.success,
        isLoadingMore: false,
      );
      onMessage?.call(errorMessage.message, true);
      return;
    }

    final allCategories = [...state.value.categories, ...result.items];

    state.value = state.value.copyWith(
      status: CategoryStatus.success,
      categories: allCategories,
      hasMore: result.hasMore,
      lastDocument: result.lastDocument,
      isLoadingMore: false,
    );
  }

  void clearForm() {
    nameEC.clear();
    limitEC.clear();
  }

  void createCategory(CategoryEntity category) async {
    state.value = state.value.copyWith(status: CategoryStatus.loading);

    final failure = await createCategoryUseCase(category);
    if (failure != null) {
      onMessage?.call(failure.message, true);
      return;
    }
    await load();
  }

  void updateCategory(CategoryEntity category) async {
    state.value = state.value.copyWith(status: CategoryStatus.loading);
    final failure = await updateCategoryUseCase(category);
    if (failure != null) {
      onMessage?.call(failure.message, true);
      return;
    }
    await load();
  }

  void submit() {
    final bool isModeEdition = _categorySelected.name.isNotEmpty;
    if (isModeEdition) {
      CategoryEntity category = _categorySelected.toModel().copyWith(
            name: nameEC.text,
            limitMonthly: limitEC.text.isEmpty
                ? 0
                : double.parse(limitEC.text.toPointFormat()),
          );
      updateCategory(category);
    } else {
      final category = CategoryEntity(
        name: nameEC.text,
        created: DateTime.now(),
        limitMonthly: limitEC.text.isEmpty ? 0 : double.parse(limitEC.text),
        consumed: 0,
      );
      createCategory(category);
    }
  }
}
