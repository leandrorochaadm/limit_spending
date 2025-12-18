import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../debit.dart';

enum DebtStatus { initial, loading, loadingMore, success, error, information }

class DebtState extends Equatable {
  final DebtStatus status;
  final String? messageToUser;
  final List<DebtEntity> debts;
  final String debtsSum;
  final bool hasMore;
  final DocumentSnapshot? lastDocument;
  final bool isLoadingMore;

  const DebtState({
    this.status = DebtStatus.initial,
    this.messageToUser,
    this.debts = const [],
    this.debtsSum = 'R\$ 0,00',
    this.hasMore = true,
    this.lastDocument,
    this.isLoadingMore = false,
  });

  DebtState copyWith({
    DebtStatus? status,
    String? messageToUser,
    List<DebtEntity>? debts,
    String? debtsSum,
    bool? hasMore,
    DocumentSnapshot? lastDocument,
    bool? isLoadingMore,
    bool clearLastDocument = false,
  }) {
    return DebtState(
      status: status ?? this.status,
      messageToUser: messageToUser ?? this.messageToUser,
      debts: debts ?? this.debts,
      debtsSum: debtsSum ?? this.debtsSum,
      hasMore: hasMore ?? this.hasMore,
      lastDocument:
          clearLastDocument ? null : (lastDocument ?? this.lastDocument),
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  bool get canLoadMore =>
      hasMore && !isLoadingMore && status != DebtStatus.loading;

  @override
  List<Object?> get props => [
        status,
        messageToUser,
        debts,
        debtsSum,
        hasMore,
        lastDocument,
        isLoadingMore,
      ];
}
