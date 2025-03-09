import '../../../../core/enums/enums.dart';
import 'historic_price_entity.dart';
import 'supermarket_entity.dart';

class ProductEntity {
  final String id;
  final String name;
  final double measure;
  final UnitOfMeasure unitOfMeasure;
  final List<HistoricPrice> historicPrices;

  ProductEntity({
    required this.id,
    required this.name,
    required this.measure,
    required this.unitOfMeasure,
    required this.historicPrices,
  });

  /// Retorna o `HistoricPrice` com o menor preço
  HistoricPrice get bestHistoricPrice {
    if (historicPrices.isEmpty)
      return HistoricPrice(supermarket: SupermarketEntity(name: ''), price: 0, date: DateTime.now());
    return historicPrices.reduce((a, b) => a.price < b.price ? a : b);
  }

  double get pricePerUnit => measure != 0 ? bestHistoricPrice.price / measure : 0.0;
}
