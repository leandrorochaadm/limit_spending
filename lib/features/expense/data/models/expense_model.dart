import 'package:equatable/equatable.dart';

import '../../domain/entities/expense_entity.dart';

class ExpenseModel extends ExpenseEntity with EquatableMixin {
  ExpenseModel({
    required super.id,
    required super.value,
    required super.created,
    required super.categoryId,
    required super.description,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      value: double.parse(json['value'].toString()),
      created: DateTime.parse(json['created'].toString()),
      categoryId: json['categoryId'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'created': created.toIso8601String(),
      'categoryId': categoryId,
      'description': description,
    };
  }

  ExpenseEntity toEntity() {
    return ExpenseEntity(
      id: id,
      value: value,
      created: created,
      categoryId: categoryId,
      description: description,
    );
  }
}
