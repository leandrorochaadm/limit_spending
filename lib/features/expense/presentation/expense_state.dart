import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../expense.dart';

enum ExpenseStatus {
  initial,
  loading,
  loadingMore,
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
  final bool hasMore;
  final DocumentSnapshot? lastDocument;
  final bool isLoadingMore;

  const ExpenseState({
    required this.status,
    this.errorMessage,
    this.consumedSum = '0.00',
    this.limitCategory = '0.00',
    this.balance = '0.00',
    this.expenses = const [],
    this.hasMore = true,
    this.lastDocument,
    this.isLoadingMore = false,
  });

  ExpenseState copyWith({
    ExpenseStatus? status,
    String? errorMessage,
    String? consumedSum,
    String? limitCategory,
    String? balance,
    List<ExpenseEntity>? expenses,
    bool? hasMore,
    DocumentSnapshot? lastDocument,
    bool? isLoadingMore,
    bool clearLastDocument = false,
  }) {
    return ExpenseState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      consumedSum: consumedSum ?? this.consumedSum,
      limitCategory: limitCategory ?? this.limitCategory,
      balance: balance ?? this.balance,
      expenses: expenses ?? this.expenses,
      hasMore: hasMore ?? this.hasMore,
      lastDocument:
          clearLastDocument ? null : (lastDocument ?? this.lastDocument),
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  /// Helper to check if can load more
  bool get canLoadMore =>
      hasMore && !isLoadingMore && status != ExpenseStatus.loading;

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        consumedSum,
        limitCategory,
        balance,
        expenses,
        hasMore,
        lastDocument,
        isLoadingMore,
      ];
}
