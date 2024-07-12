import '../domain/entities/entities.dart';

enum CategoryStatus {
  initial,
  loading,
  success,
  error,
}

class CategoryState {
  final CategoryStatus status;
  final List<CategoryEntity> categories;
  final String? errorMessage;

  CategoryState({
    required this.status,
    this.categories = const [],
    this.errorMessage,
  });

  CategoryState copyWith({
    CategoryStatus? status,
    List<CategoryEntity>? categories,
    String? errorMessage,
  }) {
    return CategoryState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
