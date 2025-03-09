import '../../../../core/enums/enums.dart';
import 'historic_price_entity.dart';

class ProductEntity {
  final String id;
  final String name;
  final double measure;
  final UnitOfMeasure unitOfMeasure;
  final List<HistoricPurchase> historicPurchase;
  final bool needToBuy;

  ProductEntity({
    String? id,
    required this.name,
    required this.measure,
    required this.unitOfMeasure,
    this.historicPurchase = const [],
    this.needToBuy = false,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  /// Retorna o `HistoricPrice` com o menor preço
  HistoricPurchase get bestHistoricPrice {
    if (historicPurchase.isEmpty) {
      return HistoricPurchase.empty();
    }
    return historicPurchase.reduce((a, b) => a.price < b.price ? a : b);
  }

  double get pricePerUnit => measure != 0 ? bestHistoricPrice.price / measure : 0.0;

  double get price => measure != 0 ? bestHistoricPrice.price : 0.0;

  double get quantity {
    if (historicPurchase.isEmpty) {
      return 0;
    }
    return historicPurchase.map((e) => e.quantity).reduce((a, b) => a + b);
  }

  ProductEntity copyWith({
    String? id,
    String? name,
    double? measure,
    UnitOfMeasure? unitOfMeasure,
    List<HistoricPurchase>? historicPurchase,
    bool? needToBuy,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      measure: measure ?? this.measure,
      unitOfMeasure: unitOfMeasure ?? this.unitOfMeasure,
      historicPurchase: historicPurchase ?? this.historicPurchase,
      needToBuy: needToBuy ?? this.needToBuy,
    );
  }
}
