import 'dart:core';

import 'category_entity.dart';

class CategoriesEntity {
  final List<CategoryEntity> categories;

  CategoriesEntity({required this.categories});

  double get sumConsumed =>
      categories.fold<double>(0.0, (sum, category) => sum + category.consumed);

  double get sumBalance =>
      categories.fold<double>(0.0, (sum, category) => sum + category.balance);

  double get sumLimit => categories.fold<double>(
        0.0,
        (sum, category) => sum + category.limitMonthly,
      );
}
