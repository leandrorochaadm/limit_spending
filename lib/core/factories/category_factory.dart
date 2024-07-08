import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/category/category.dart';

CategoryController categoryControllerFactory(FirebaseFirestore firestore) {
  final categoryRepository = CategoryFirebaseRepository(firestore);
  final getCategoriesUseCase = GetCategoriesUseCase(categoryRepository);
  final createCategoryUseCase = CreateCategoryUseCase(categoryRepository);
  final updateCategoryUseCase = UpdateCategoryUseCase(categoryRepository);
  final categoryController = CategoryController(
    getCategoriesUseCase: getCategoriesUseCase,
    createCategoryUseCase: createCategoryUseCase,
    updateCategoryUseCase: updateCategoryUseCase,
  );
  return categoryController;
}
