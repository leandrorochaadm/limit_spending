import '../domain/domain.dart';

enum PaymentMethodStatus { initial, loading, success, error, information }

class PaymentMethodState {
  final PaymentMethodStatus status;
  final List<PaymentMethodEntity> paymentMethods;
  final String? messageToUser;
  final String moneySum;
  final String cardSum;

  PaymentMethodState({
    this.status = PaymentMethodStatus.initial,
    this.paymentMethods = const [],
    this.messageToUser = '',
    this.moneySum = 'R\$ 0,00',
    this.cardSum = 'R\$ 0,00',
  });
}
