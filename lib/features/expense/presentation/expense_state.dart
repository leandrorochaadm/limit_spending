import 'package:equatable/equatable.dart';

import '../expense.dart';

enum ExpenseStatus {
  initial,
  loading,
  success,
  error,
}

class ExpenseState extends Equatable {
  final ExpenseStatus status;
  final String? errorMessage;
  final String consumedSum;
  final String limitCategory;
  final String balance;
  final List<ExpenseEntity> expenses;

  const ExpenseState({
    required this.status,
    this.errorMessage,
    this.consumedSum = '0.00',
    this.limitCategory = '0.00',
    this.balance = '0.00',
    this.expenses = const [],
  });

  ExpenseState copyWith({
    ExpenseStatus? status,
    String? errorMessage,
    String? consumedSum,
    String? limitCategory,
    String? balance,
    List<ExpenseEntity>? expenses,
  }) {
    return ExpenseState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      consumedSum: consumedSum ?? this.consumedSum,
      limitCategory: limitCategory ?? this.limitCategory,
      balance: balance ?? this.balance,
      expenses: expenses ?? this.expenses,
    );
  }

  @override
  List<Object?> get props =>
      [status, errorMessage, consumedSum, limitCategory, balance, expenses];
}
