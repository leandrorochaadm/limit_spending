import '../debit.dart';

class DebtModel {
  final String id;
  final String name;
  final double value;
  final bool isCardCredit;

  DebtModel({
    required this.id,
    required this.name,
    required this.value,
    required this.isCardCredit,
  });

  DebtEntity toEntity() {
    return DebtEntity(
      id: id,
      name: name,
      value: value,
      isCardCredit: isCardCredit,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'isCardCredit': isCardCredit,
    };
  }

  factory DebtModel.fromJson(Map<String, dynamic> map) {
    return DebtModel(
      id: map['id'] as String,
      name: map['name'] as String,
      value: double.tryParse('${map['value'] ?? '0.0'}') ?? 0.0,
      isCardCredit: bool.tryParse('${map['isCardCredit'] ?? 'false'}') ?? false,
    );
  }
}
