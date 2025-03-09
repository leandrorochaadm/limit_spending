import '../domain/domain.dart';

enum SupermarketStatus { initial, loading, success, error, information }

class SupermarketState {
  final SupermarketStatus status;
  final String? messageToUser;
  final List<ProductEntity> products;

  SupermarketState({required this.status, this.messageToUser, this.products = const []});

  SupermarketState.initial() : this(status: SupermarketStatus.initial, messageToUser: null, products: []);

  SupermarketState copyWith({
    SupermarketStatus? status,
    String? messageToUser,
    List<ProductEntity>? products,
  }) {
    return SupermarketState(
      status: status ?? this.status,
      messageToUser: messageToUser ?? this.messageToUser,
      products: products ?? this.products,
    );
  }
}
