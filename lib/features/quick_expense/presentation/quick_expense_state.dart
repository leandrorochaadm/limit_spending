import 'package:equatable/equatable.dart';
import '../../account/domain/entities/account_entity.dart';
import '../../category/domain/entities/category_entity.dart';

enum QuickExpenseStatus { initial, loading, success, error, saved }

class QuickExpenseState extends Equatable {
  final QuickExpenseStatus status;
  final List<CategoryEntity> categories;
  final List<AccountEntity> accounts;
  final CategoryEntity? selectedCategory;
  final AccountEntity? selectedAccount;
  final String? errorMessage;

  const QuickExpenseState({
    required this.status,
    this.categories = const [],
    this.accounts = const [],
    this.selectedCategory,
    this.selectedAccount,
    this.errorMessage,
  });

  QuickExpenseState copyWith({
    QuickExpenseStatus? status,
    List<CategoryEntity>? categories,
    List<AccountEntity>? accounts,
    CategoryEntity? selectedCategory,
    AccountEntity? selectedAccount,
    String? errorMessage,
  }) {
    return QuickExpenseState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      accounts: accounts ?? this.accounts,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedAccount: selectedAccount ?? this.selectedAccount,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        categories,
        accounts,
        selectedCategory,
        selectedAccount,
        errorMessage,
      ];
}
