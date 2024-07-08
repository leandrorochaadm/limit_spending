import '../../domain/entities/entities.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({
    super.id,
    required super.name,
    required super.created,
    required super.limitMonthly,
    required super.consumed,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      created: DateTime.parse(json['created'] as String),
      limitMonthly: (json['limit_monthly'] as num).toDouble(),
      consumed: (json['consumed'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'created': created?.toIso8601String(),
        'limit_monthly': limitMonthly,
        'consumed': consumed,
      };

  CategoryModel copyWith({
    String? id,
    String? name,
    DateTime? created,
    double? limitMonthly,
    double? consumed,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      created: created ?? this.created,
      limitMonthly: limitMonthly ?? this.limitMonthly,
      consumed: consumed ?? this.consumed,
    );
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      created: created,
      limitMonthly: limitMonthly,
      consumed: consumed,
    );
  }
}
