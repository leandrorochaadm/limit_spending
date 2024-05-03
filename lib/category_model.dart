import 'package:equatable/equatable.dart';

class Category extends Equatable {
  const Category({
    required this.id,
    required this.name,
    required this.created,
    required this.limitMonthly,
    required this.consumed,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      created: DateTime.tryParse(json['created'] as String? ?? ''),
      limitMonthly: (json['limit_monthly'] as num?)?.toDouble() ?? 0.0,
      consumed: (json['consumed'] as num?)?.toDouble() ?? 0.0,
    );
  }

  final String id;
  final String name;
  final DateTime? created;
  final double limitMonthly;
  final double consumed;

  Category copyWith({
    String? id,
    String? name,
    DateTime? created,
    double? limitMonthly,
    double? consumed,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      created: created ?? this.created,
      limitMonthly: limitMonthly ?? this.limitMonthly,
      consumed: consumed ?? this.consumed,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'created':
            "${created?.year.toString().padLeft(4, '0')}-${created?.month.toString().padLeft(2, '0')}-${created?.day.toString().padLeft(2, '0')}",
        'limit_monthly': limitMonthly,
        'consumed': consumed,
      };

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
}
