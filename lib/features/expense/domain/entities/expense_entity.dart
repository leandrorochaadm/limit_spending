import 'package:equatable/equatable.dart';

import '../../data/models/expense_model.dart';

class ExpenseEntity extends Equatable {
  final String id;
  final String description;
  final DateTime created;
  final double value;
  final String categoryId;
  final String paymentMethodId;
  final bool isMoney;
  final String? accountId;

  ExpenseEntity({
    String? id,
    required this.description,
    required this.created,
    required this.value,
    required this.categoryId,
    required this.paymentMethodId,
    required this.isMoney,
    this.accountId,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  ExpenseModel toModel() {
    return ExpenseModel(
      id: id,
      description: description,
      created: created,
      value: value,
      categoryId: categoryId,
      paymentMethodId: paymentMethodId,
      isMoney: isMoney,
      accountId: accountId,
    );
  }

  ExpenseEntity copyWith({
    String? id,
    String? description,
    DateTime? created,
    double? value,
    String? categoryId,
    String? paymentMethodId,
    bool? isMoney,
    String? accountId,
  }) {
    return ExpenseEntity(
      id: id ?? this.id,
      description: description ?? this.description,
      created: created ?? this.created,
      value: value ?? this.value,
      categoryId: categoryId ?? this.categoryId,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      isMoney: isMoney ?? this.isMoney,
      accountId: accountId ?? this.accountId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        description,
        created,
        value,
        categoryId,
        paymentMethodId,
        isMoney,
        accountId,
      ];
}
