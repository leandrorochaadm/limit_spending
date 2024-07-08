import '../domain/domain.dart';

enum ExpenseStatus {
  initial,
  loading,
  success,
  error,
}

class ExpenseState {
  final ExpenseStatus status;
  final List<ExpenseEntity> categories;
  final String? errorMessage;

  ExpenseState({
    required this.status,
    this.categories = const [],
    this.errorMessage,
  });

  ExpenseState copyWith({
    ExpenseStatus? status,
    List<ExpenseEntity>? categories,
    String? errorMessage,
  }) {
    return ExpenseState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
