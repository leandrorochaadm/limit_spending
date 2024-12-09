import 'package:flutter/cupertino.dart';

import '../../../core/core.dart';
import '../../debt/debit.dart';
import '../domain/entities/payment_method_entity.dart';
import '../domain/use_cases/use_cases.dart';
import 'payment_method_state.dart';

class PaymentMethodNotifier extends ValueNotifier<PaymentMethodState> {
  final GetAllPaymentMethodsUseCase getPaymentMethodsUseCase;
  final GetMoneyPaymentMethodsUseCase getMoneyPaymentMethodsUseCase;
  final CreatePaymentMethodUseCase createPaymentMethodUseCase;
  final UpdatePaymentMethodUseCase updatePaymentMethodUseCase;
  final DeletePaymentMethodUseCase deletePaymentMethodUseCase;
  final PaymentDebitUseCase paymentDebitUseCase;
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
  String? debtId;

  @override
  void dispose() {
    nameEC.dispose();
    limitEC.dispose();
    valueEC.dispose();
    dayCloseEC.dispose();
    super.dispose();
  }

  void Function(String paymentMethodId)? onNextCategoryPage;
  Future<double> Function(PaymentMethodEntity paymentMethod)?
      onOpenModalPaymentDebt;

  void Function(String message, bool isError)? onShowMessage;

  PaymentMethodNotifier({
    required this.getPaymentMethodsUseCase,
    required this.createPaymentMethodUseCase,
    required this.updatePaymentMethodUseCase,
    required this.deletePaymentMethodUseCase,
    required this.getMoneyPaymentMethodsUseCase,
    required this.paymentDebitUseCase,
    this.debtId,
  }) : super(PaymentMethodState()) {
    load();
  }

  Future<void> load() async {
    value = PaymentMethodState(status: PaymentMethodStatus.loading);

    // Limpa o formulário para evitar dados residuais
    clearForm();

    // Obtém os meios de pagamento, dependendo da presença de debtId
    final (failure, paymentMethods) = debtId?.isNotEmpty ?? false
        ? await getMoneyPaymentMethodsUseCase()
        : await getPaymentMethodsUseCase();

    // Trata erros
    if (failure != null) {
      value = PaymentMethodState(
        status: PaymentMethodStatus.error,
        messageToUser: failure.message,
      );
      return;
    }

    // Nenhum meio de pagamento encontrado
    if (paymentMethods.isEmpty) {
      value = PaymentMethodState(
        status: PaymentMethodStatus.information,
        messageToUser: 'Nenhum meio de pagamento encontrado',
      );
      return;
    }

    // Calcula somatórios para cartões e dinheiro
    final (moneySum, cardSum) = _calculateSums(paymentMethods);

    // Atualiza o estado com sucesso
    value = PaymentMethodState(
      status: PaymentMethodStatus.success,
      paymentMethods: paymentMethods,
      cardSum: cardSum.toCurrency(),
      moneySum: moneySum.toCurrency(),
    );
  }

  /// Função auxiliar para calcular somatórios de valores de meios de pagamento
  (double, double) _calculateSums(List<PaymentMethodEntity> paymentMethods) {
    double moneySum = 0;
    double cardSum = 0;

    for (final paymentMethod in paymentMethods) {
      if (paymentMethod.isCard) {
        cardSum += paymentMethod.balance;
      } else if (paymentMethod.isMoney) {
        moneySum += paymentMethod.balance;
      }
    }

    return (moneySum, cardSum);
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

  Future<void> paymentDebt(
    String paymentMethodId,
    String debtId,
    double valuePayment,
  ) async {
    final failure =
        await paymentDebitUseCase(paymentMethodId, debtId, valuePayment);
    if (failure != null) {
      value = PaymentMethodState(
        status: PaymentMethodStatus.error,
        messageToUser: failure.message,
      );
    }
  }

  Future<void> selectPaymentMethod(PaymentMethodEntity paymentMethod) async {
    if (paymentMethod.value <= 0) {
      onShowMessage?.call('Nenhum saldo disponível', true);
      return;
    }

    _paymentMethodSelected = paymentMethod;
    if (debtId?.isNotEmpty ?? false) {
      final value = await onOpenModalPaymentDebt?.call(paymentMethod);
      if (value != null && value > 0) {
        await paymentDebt(paymentMethod.id, debtId!, value);
        load();
      }
    } else {
      onNextCategoryPage?.call(paymentMethod.id);
    }
  }
}
