import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/category_model.dart';

class CategoryEntity extends Equatable {
  CategoryEntity({
    String? id,
    required this.name,
    required this.created,
    required this.limitMonthly,
    required this.consumed,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String name;
  final DateTime? created;
  final double limitMonthly;
  final double consumed;

  double get balance {
    final timeMouth = (DateTime.now().difference(created!).inDays / 30) + 1;
    return (timeMouth * limitMonthly) - consumed;
  }

  @override
  String toString() => '$id, $name, $created, $limitMonthly, $consumed, ';

  @override
  List<Object?> get props => <Object?>[
        id,
        name,
        created,
        limitMonthly,
        consumed,
      ];

  CategoryModel toModel() {
    return CategoryModel(
      id: id,
      name: name,
      created: created,
      limitMonthly: limitMonthly,
      consumed: consumed,
    );
  }
}
