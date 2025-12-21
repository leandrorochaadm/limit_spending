import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../domain/entities/account_entity.dart';

enum AccountStatus {
  initial,
  loading,
  loadingMore,
  success,
  error,
  information,
}

class AccountState extends Equatable {
  final AccountStatus status;
  final List<AccountEntity> accounts;
  final String? messageToUser;
  final String moneySum;
  final String cardSum;
  final String loanSum;
  final String totalSum;
  final bool hasMore;
  final DocumentSnapshot? lastDocument;
  final bool isLoadingMore;

  const AccountState({
    required this.status,
    this.accounts = const [],
    this.messageToUser,
    this.moneySum = 'R\$ 0,00',
    this.cardSum = 'R\$ 0,00',
    this.loanSum = 'R\$ 0,00',
    this.totalSum = 'R\$ 0,00',
    this.hasMore = false,
    this.lastDocument,
    this.isLoadingMore = false,
  });

  bool get canLoadMore => hasMore && !isLoadingMore && status != AccountStatus.loading;

  AccountState copyWith({
    AccountStatus? status,
    List<AccountEntity>? accounts,
    String? messageToUser,
    String? moneySum,
    String? cardSum,
    String? loanSum,
    String? totalSum,
    bool? hasMore,
    DocumentSnapshot? lastDocument,
    bool? isLoadingMore,
    bool clearLastDocument = false,
  }) {
    return AccountState(
      status: status ?? this.status,
      accounts: accounts ?? this.accounts,
      messageToUser: messageToUser,
      moneySum: moneySum ?? this.moneySum,
      cardSum: cardSum ?? this.cardSum,
      loanSum: loanSum ?? this.loanSum,
      totalSum: loanSum ?? this.totalSum,
      hasMore: hasMore ?? this.hasMore,
      lastDocument: clearLastDocument ? null : (lastDocument ?? this.lastDocument),
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
        status,
        accounts,
        messageToUser,
        moneySum,
        cardSum,
        loanSum,
        totalSum,
        hasMore,
        lastDocument,
        isLoadingMore,
      ];
}
