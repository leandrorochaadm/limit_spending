import '../../features/supermarket/supermarket.dart';

SupermarketController supermarketControllerFactory() => SupermarketController();
SupermarketPage supermarketPageFactory() => SupermarketPage(supermarketControllerFactory());
