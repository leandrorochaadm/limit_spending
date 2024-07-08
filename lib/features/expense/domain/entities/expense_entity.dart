import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/expense_model.dart';

class ExpenseEntity extends Equatable {
  final String id;
  final String description;
  final DateTime created;
  final double value;
  final String categoryId;

  ExpenseEntity({
    String? id,
    required this.description,
    required this.created,
    required this.value,
    required this.categoryId,
  }) : id = id ?? const Uuid().v4();

  ExpenseModel toModel() {
    return ExpenseModel(
      id: id,
      description: description,
      created: created,
      value: value,
      categoryId: categoryId,
    );
  }

  ExpenseEntity copyWith({
    String? id,
    String? description,
    DateTime? created,
    double? value,
    String? categoryId,
  }) {
    return ExpenseEntity(
      id: id ?? this.id,
      description: description ?? this.description,
      created: created ?? this.created,
      value: value ?? this.value,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  List<Object?> get props => [id, description, created, value, categoryId];
}