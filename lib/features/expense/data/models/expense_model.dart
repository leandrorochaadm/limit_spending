import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/expense_entity.dart';

class ExpenseModel extends ExpenseEntity with EquatableMixin {
  ExpenseModel({
    required super.id,
    required super.value,
    required super.created,
    required super.categoryId,
    required super.description,
    required super.paymentMethodId,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      value: double.parse(json['value'].toString()),
      created: (json['created'] as Timestamp).toDate(),
      categoryId: json['categoryId'] as String,
      description: json['description'] as String,
      paymentMethodId: (json['paymentMethodId'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'created': Timestamp.fromDate(created),
      'categoryId': categoryId,
      'description': description,
      'debtId': paymentMethodId,
    };
  }

  ExpenseEntity toEntity() {
    return ExpenseEntity(
      id: id,
      value: value,
      created: created,
      categoryId: categoryId,
      description: description,
      paymentMethodId: paymentMethodId,
    );
  }
}
