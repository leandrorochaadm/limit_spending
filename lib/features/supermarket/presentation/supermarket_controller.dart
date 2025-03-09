import 'package:flutter/cupertino.dart';

import '../../../core/enums/enums.dart';
import '../domain/entities/entities.dart';
import 'presentation.dart';

class SupermarketController extends ValueNotifier<SupermarketState> {
  SupermarketController() : super(SupermarketState.initial()) {
    load();
  }

  void Function(String message, bool isError)? onMessage;

  void load() {
    value = SupermarketState(status: SupermarketStatus.loading);

    final products = [
      ProductEntity(name: 'Banana', measure: 2, unitOfMeasure: UnitOfMeasure.grams),
      ProductEntity(name: 'Laranja', measure: 2.5, unitOfMeasure: UnitOfMeasure.grams),
      ProductEntity(name: 'Macarrao', measure: 4, unitOfMeasure: UnitOfMeasure.grams),
      ProductEntity(name: 'Refigerante', measure: 10, unitOfMeasure: UnitOfMeasure.milliliters),
    ];

    value = SupermarketState(status: SupermarketStatus.success, products: products);
  }

  void deleteProduct(String productId) {
    value = SupermarketState(status: SupermarketStatus.loading);
  }

  Future<void> createProduct(ProductEntity product) async {
    value = SupermarketState(status: SupermarketStatus.loading);
  }

  Future<void> updateProduct(ProductEntity product) async {
    value = SupermarketState(status: SupermarketStatus.loading);
  }
}
