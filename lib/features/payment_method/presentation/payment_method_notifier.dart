import 'package:flutter/cupertino.dart';

import '../../../core/core.dart';
import '../domain/entities/payment_method_entity.dart';
import '../domain/user_cases/use_cases.dart';
import 'payment_method_state.dart';

class PaymentMethodNotifier extends ValueNotifier<PaymentMethodState> {
  final GetAllPaymentMethodsUseCase getPaymentMethodsUseCase;
  final GetMoneyPaymentMethodsUseCase getMoneyPaymentMethodsUseCase;
  final CreatePaymentMethodUseCase createPaymentMethodUseCase;
  final UpdatePaymentMethodUseCase updatePaymentMethodUseCase;
  final DeletePaymentMethodUseCase deletePaymentMethodUseCase;
  PaymentMethodEntity? _paymentMethodSelected;
  set paymentMethodSelected(PaymentMethodEntity? paymentMethod) {
    _paymentMethodSelected = paymentMethod;
    nameEC.text = paymentMethod?.name ?? '';
    limitEC.text = paymentMethod?.limit.toStringAsFixed(2) ?? '';
    valueEC.text = paymentMethod?.value.toStringAsFixed(2) ?? '';
    isMoneySelected = paymentMethod?.isMoney ?? true;
    dayCloseEC.text = paymentMethod?.dayClose.toString() ?? '';
  }

  TextEditingController nameEC = TextEditingController();
  final FocusNode nameFN = FocusNode();
  TextEditingController limitEC = TextEditingController();
  final FocusNode limitFN = FocusNode();
  TextEditingController valueEC = TextEditingController();
  final FocusNode valueFN = FocusNode();
  TextEditingController dayCloseEC = TextEditingController();
  final FocusNode dayCloseFN = FocusNode();
  bool isMoneySelected = true;
  bool isMoneyFilter;
  PaymentMethodNotifier({
    required this.getPaymentMethodsUseCase,
    required this.createPaymentMethodUseCase,
    required this.updatePaymentMethodUseCase,
    required this.deletePaymentMethodUseCase,
    required this.getMoneyPaymentMethodsUseCase,
    bool? isMoneyFilter,
  })  : isMoneyFilter = isMoneyFilter ?? false,
        super(PaymentMethodState()) {
    load();
  }

  Future<void> load() async {
    value = PaymentMethodState(status: PaymentMethodStatus.loading);
    clearForm();

    (String?, List<PaymentMethodEntity>) data = (null, <PaymentMethodEntity>[]);

    if (isMoneyFilter) {
      data = await getMoneyPaymentMethodsUseCase();
    } else {
      data = await getPaymentMethodsUseCase();
    }

    final paymentMethods = data.$2;
    final errorMessage = data.$1;

    if (errorMessage != null) {
      value = PaymentMethodState(
        status: PaymentMethodStatus.error,
        messageToUser: errorMessage,
      );
      return;
    }

    if (paymentMethods.isEmpty) {
      value = PaymentMethodState(
        status: PaymentMethodStatus.information,
        messageToUser: 'Nenhum meio de pagamento encontrado',
      );
      return;
    }

    double moneySum = 0;
    double cardSum = 0;

    for (final paymentMethod in paymentMethods) {
      if (paymentMethod.isCard) {
        cardSum += paymentMethod.balance;
      }
      if (paymentMethod.isMoney) {
        moneySum += paymentMethod.balance;
      }
    }

    value = PaymentMethodState(
      status: PaymentMethodStatus.success,
      paymentMethods: paymentMethods,
      cardSum: cardSum.toCurrency(),
      moneySum: moneySum.toCurrency(),
    );
  }

  void submit() {
    value = PaymentMethodState(status: PaymentMethodStatus.loading);
    if (_paymentMethodSelected != null) {
      final paymentMethod = _paymentMethodSelected!.copyWith(
        name: nameEC.text,
        limit: limitEC.text.isEmpty ? 0 : double.parse(limitEC.text),
        isMoney: isMoneySelected,
        isCard: !isMoneySelected,
        dayClose: int.tryParse(dayCloseEC.text) ?? 0,
        value: valueEC.text.isEmpty ? 0 : double.parse(valueEC.text),
      );
      updatePaymentMethodUseCase(paymentMethod);
    } else {
      final paymentMethod = PaymentMethodEntity(
        name: nameEC.text,
        limit: limitEC.text.isEmpty ? 0 : double.parse(limitEC.text),
        isMoney: isMoneySelected,
        isCard: !isMoneySelected,
        dayClose: int.tryParse(dayCloseEC.text) ?? 0,
        value: valueEC.text.isEmpty ? 0 : double.parse(valueEC.text),
      );
      createPaymentMethodUseCase(paymentMethod);
    }
    load();
  }

  void clearForm() {
    _paymentMethodSelected = null;
    nameEC.clear();
    limitEC.clear();
    valueEC.clear();
    dayCloseEC.clear();
  }
}
