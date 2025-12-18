import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../domain/entities/entities.dart';

enum CategoryStatus {
  initial,
  loading,
  loadingMore,
  success,
  error,
  information,
}

class CategoryState extends Equatable {
  final List<CategoryEntity> categories;
  final CategoryStatus status;
  final String? messageToUser;
  final String consumedSum;
  final String limitSum;
  final String balanceSum;
  final bool hasMore;
  final DocumentSnapshot? lastDocument;
  final bool isLoadingMore;

  const CategoryState({
    this.categories = const [],
    this.status = CategoryStatus.initial,
    this.messageToUser,
    this.consumedSum = '0.00',
    this.limitSum = '0.00',
    this.balanceSum = '0.00',
    this.hasMore = true,
    this.lastDocument,
    this.isLoadingMore = false,
  });

  CategoryState copyWith({
    List<CategoryEntity>? categories,
    CategoryStatus? status,
    String? messageToUser,
    String? consumedSum,
    String? limitSum,
    String? balanceSum,
    bool? hasMore,
    DocumentSnapshot? lastDocument,
    bool? isLoadingMore,
    bool clearLastDocument = false,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      status: status ?? this.status,
      messageToUser: messageToUser ?? this.messageToUser,
      consumedSum: consumedSum ?? this.consumedSum,
      limitSum: limitSum ?? this.limitSum,
      balanceSum: balanceSum ?? this.balanceSum,
      hasMore: hasMore ?? this.hasMore,
      lastDocument:
          clearLastDocument ? null : (lastDocument ?? this.lastDocument),
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  bool get canLoadMore =>
      hasMore && !isLoadingMore && status != CategoryStatus.loading;

  @override
  List<Object?> get props => [
        categories,
        status,
        messageToUser,
        consumedSum,
        limitSum,
        balanceSum,
        hasMore,
        lastDocument,
        isLoadingMore,
      ];
}
