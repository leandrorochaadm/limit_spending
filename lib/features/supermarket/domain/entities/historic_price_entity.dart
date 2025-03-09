import '../../supermarket.dart';

class HistoricPurchase {
  final SupermarketEntity supermarket;
  final double price;
  final DateTime date;
  final double quantity;

  HistoricPurchase({required this.supermarket, required this.price, required this.date, required this.quantity});

  factory HistoricPurchase.empty() =>
      HistoricPurchase(supermarket: SupermarketEntity(name: ''), price: 0, date: DateTime.now(), quantity: 0);
}
