import '../../supermarket.dart';

class HistoricPrice {
  final SupermarketEntity supermarket;
  final double price;
  final DateTime date;

  HistoricPrice({required this.supermarket, required this.price, required this.date});
}
