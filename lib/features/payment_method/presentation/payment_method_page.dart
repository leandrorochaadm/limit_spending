import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../payment_method.dart';

class PaymentMethodPage extends StatelessWidget {
  static const String routeName = '/paymentMethod';

  final VoidCallback? onGoBack;
  PaymentMethodPage(this.paymentMethodNotifier, {super.key, this.onGoBack});

  final PaymentMethodNotifier paymentMethodNotifier;
  bool actionExecuted = false; // Flag para controlar a execução

  @override
  Widget build(BuildContext context) {
    paymentMethodNotifier.onNextCategoryPage = (String paymentMethodId) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return makeCategoryPage(paymentMethodId);
          },
        ),
      ).then((_) => paymentMethodNotifier.load());
    };

    paymentMethodNotifier.onOpenModalPaymentDebt =
        (PaymentMethodEntity paymentMethod) async {
      final double value = await modalPaymentDebt(context);

      return value;
    };

    paymentMethodNotifier.onShowMessage = (String message, bool isError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: isError ? Colors.red : Colors.green,
        ),
      );
    };

    return PopScope(
      canPop: onGoBack == null,
      onPopInvokedWithResult: (bool didPop, _) {
        if (didPop) return;
        onGoBack?.call();
        Navigator.of(context).pop();
      },
      child: ValueListenableBuilder(
        valueListenable: paymentMethodNotifier,
        builder: (context, state, __) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Formas de pagamento',
                textAlign: TextAlign.center,
              ),
              elevation: 7,
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(left: 32),
              child: FloatingActionButton(
                onPressed: () {
                  paymentMethodNotifier.clearForm();
                  modalCreatePaymentMethod(context);
                },
                child: const Icon(Icons.add),
              ),
            ),
            bottomSheet: Padding(
              padding: const EdgeInsets.only(bottom: 36.0, top: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total dinheiro: ${state.moneySum}',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            body: buildBodyWidget(state),
          );
        },
      ),
    );
  }

  Widget buildBodyWidget(PaymentMethodState state) {
    if (state.status == PaymentMethodStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state.status == PaymentMethodStatus.error) {
      return Center(child: Text('Erro: ${state.messageToUser}'));
    } else if (state.status == PaymentMethodStatus.information) {
      return Center(child: Text('${state.messageToUser}'));
    }

    final paymentMethods = state.paymentMethods;

    return Padding(
      padding: const EdgeInsets.only(bottom: 90.0),
      child: ListView.separated(
        itemCount: paymentMethods.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final paymentMethod = paymentMethods[index];
          return Dismissible(
            key: Key(paymentMethod.id),
            direction: DismissDirection.startToEnd,
            onUpdate: (details) {
              if (!actionExecuted && details.progress > 0.5) {
                actionExecuted = true; // Marca a ação como executada
                paymentMethodNotifier.paymentMethodSelected = paymentMethod;
                modalCreatePaymentMethod(context);
              }
            },
            confirmDismiss: (direction) async {
              return false; // Retorne false para não descartar o item
            },
            background: Container(
              color: Theme.of(context).colorScheme.inversePrimary,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            child: ListTile(
              title: Text(
                '${paymentMethod.isMoney ? 'Dinheiro' : 'Cartão'}: ${paymentMethod.name}',
              ),
              subtitle:
                  Text('Disponível ${paymentMethod.balance.toCurrency()}'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                paymentMethodNotifier.selectPaymentMethod(paymentMethod);
              },
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> modalCreatePaymentMethod(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return showModalBottomSheet(
      context: context,
      useSafeArea: true,
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext contextModal) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Form(
                key: formKey,
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  children: <Widget>[
                    RadioListTile<bool>(
                      value: true,
                      groupValue: paymentMethodNotifier.isMoneySelected,
                      onChanged: (value) {
                        setState(() {
                          paymentMethodNotifier.isMoneySelected =
                              value ?? false;
                        });
                      },
                      title: const Text('Dinheiro'),
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 24),
                    RadioListTile<bool>(
                      value: false,
                      groupValue: paymentMethodNotifier.isMoneySelected,
                      onChanged: (value) {
                        setState(() {
                          paymentMethodNotifier.isMoneySelected =
                              value ?? false;
                        });
                      },
                      title: const Text('Cartão'),
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 24),
                    TextFieldCustomWidget(
                      controller: paymentMethodNotifier.nameEC,
                      focusNode: paymentMethodNotifier.nameFN,
                      hintText: 'Nome da forma de pagamento',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nome inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    TextFieldCustomWidget(
                      controller: paymentMethodNotifier.valueEC,
                      focusNode: paymentMethodNotifier.valueFN,
                      hintText: 'Valor',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        final day = double.tryParse(value!) ?? 0;
                        if (day <= 0) {
                          return 'Valor inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    if (!paymentMethodNotifier.isMoneySelected)
                      Column(
                        children: [
                          TextFieldCustomWidget(
                            controller: paymentMethodNotifier.limitEC,
                            focusNode: paymentMethodNotifier.limitFN,
                            hintText: 'Limite do cartão',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              final day = double.tryParse(value!) ?? 0;
                              if (day <= 0) {
                                return 'Limite inválido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          TextFieldCustomWidget(
                            controller: paymentMethodNotifier.dayCloseEC,
                            focusNode: paymentMethodNotifier.dayCloseFN,
                            hintText: 'Dia do fechamento',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              final day = int.tryParse(value!) ?? 0;
                              if (day <= 0 || day > 31) {
                                return 'Dia inválido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                        shape: const StadiumBorder(),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                      ),
                      onPressed: () {
                        final bool val = formKey.currentState!.validate();
                        if (!val) return;

                        paymentMethodNotifier.submit();
                        Navigator.of(contextModal).pop();
                      },
                      child: const Text('Salvar categoria'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    ).whenComplete(
      () {
        actionExecuted = false;
      },
    );
  }

  Future<double> modalPaymentDebt(BuildContext context) {
    final TextEditingController valueEC = TextEditingController();
    final FocusNode valueFN = FocusNode();
    bool isPopping = false;

    return showModalBottomSheet<double>(
      context: context,
      useSafeArea: true,
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true,
      isDismissible: false,
      builder: (BuildContext contextModal) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(contextModal).viewInsets.bottom + 16,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFieldCustomWidget(
                  controller: valueEC,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  hintText: 'Valor a Pagar',
                  focusNode: valueFN,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 24,
                          ),
                          shape: const StadiumBorder(),
                          backgroundColor: Theme.of(context).colorScheme.error,
                          foregroundColor:
                              Theme.of(context).colorScheme.onError,
                          textStyle: Theme.of(context).textTheme.bodyMedium,
                        ),
                        onPressed: () {
                          if (!isPopping) {
                            isPopping = true;
                            Navigator.of(contextModal).pop(0.0);
                          }
                        },
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 24,
                          ),
                          shape: const StadiumBorder(),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          textStyle: Theme.of(context).textTheme.bodyMedium,
                        ),
                        onPressed: () {
                          if (!isPopping) {
                            isPopping = true;
                            final double valuePaymentDebt = valueEC.text.isEmpty
                                ? 0.0
                                : double.parse(valueEC.text.toPointFormat());
                            Navigator.of(contextModal).pop(valuePaymentDebt);
                          }
                        },
                        child: const Text('Pagar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) => value ?? 0.0);
  }
}
