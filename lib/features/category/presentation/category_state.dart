import '../domain/entities/entities.dart';

enum CategoryStatus {
  initial,
  loading,
  success,
  error,
  information,
}

class CategoryState {
  final List<CategoryEntity> categories;
  final CategoryStatus status;
  final String? messageToUser;
  final String consumedSum;
  final String limitSum;
  final String balanceSum;

  CategoryState({
    this.categories = const [],
    this.status = CategoryStatus.initial,
    this.messageToUser,
    this.consumedSum = '0.00',
    this.limitSum = '0.00',
    this.balanceSum = '0.00',
  });

  CategoryState copyWith({
    List<CategoryEntity>? categories,
    CategoryStatus? status,
    String? messageToUser,
    String? consumedSum,
    String? limitSum,
    String? balanceSum,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      status: status ?? this.status,
      messageToUser: messageToUser ?? this.messageToUser,
      consumedSum: consumedSum ?? this.consumedSum,
      limitSum: limitSum ?? this.limitSum,
      balanceSum: balanceSum ?? this.balanceSum,
    );
  }
}
