import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../../core/widgets/snack_bar_custom.dart';
import '../../payment_method/presentation/payment_method_page.dart';
import '../debit.dart';
import 'debt_state.dart';

class DebtPage extends StatelessWidget {
  final DebtController debtController;
  const DebtPage(this.debtController, {super.key});

  @override
  Widget build(BuildContext context) {
    debtController.onMessage = (String message, bool isError) {
      SnackBarCustom(
        context: context,
        message: message,
        isError: isError,
        duration: const Duration(seconds: 1),
      );
    };

    return ValueListenableBuilder(
      valueListenable: debtController.state,
      builder: (context, state, __) {
        return Scaffold(
          appBar: AppBar(title: const Text('Dividas'), elevation: 7),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              modalCreateDebt(context);
            },
            child: const Icon(Icons.add),
          ),
          bottomSheet: Padding(
            padding: const EdgeInsets.only(bottom: 36.0, top: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentMethodPage(
                          paymentMethodNotifierFactory(),
                          onGoBack: debtController.load,
                        ),
                      ),
                    );
                  },
                  child: const Text('Quero gastar'),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      child: Text(
                        'Total: ${state.debtsSum}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: buildBodyWidget(state),
        );
      },
    );
  }

  Widget buildBodyWidget(DebtState state) {
    if (state.status == DebtStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state.status == DebtStatus.error) {
      return Center(child: Text('${state.messageToUser}'));
    } else if (state.status == DebtStatus.information) {
      return Center(child: Text('${state.messageToUser}'));
    }

    final debts = state.debts;
    return Padding(
      padding: const EdgeInsets.only(bottom: 120.0),
      child: ListView.builder(
        itemCount: debts.length,
        itemBuilder: (context, index) {
          final debt = debts[index];

          return Dismissible(
            key: Key(debt.id),
            direction: debt.isCardCredit
                ? DismissDirection.none
                : DismissDirection.horizontal,
            confirmDismiss: (direction) async {
              Future<bool?>? resultDismiss;
              if (direction == DismissDirection.endToStart) {
                if (debt.isCardCredit) {
                  resultDismiss = showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Aviso'),
                        content: const Text(
                          'Cartão de crédito não pode ser excluido, pague a divida do cartão que ela será excluida automaticamente',
                          textAlign: TextAlign.justify,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('Ok'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  resultDismiss = showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Excluir divida'),
                        content:
                            const Text('Deseja realmente excluir esta divida?'),
                        actions: [
                          TextButton(
                            child: const Text('Cancelar'),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: const Text('Excluir'),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              }

              if (direction == DismissDirection.startToEnd) {
                resultDismiss = modalCreateDebt(context, debt: debt);
              }
              return resultDismiss;
            },
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                debtController.deleteDebt(debt.id);
              }
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
            secondaryBackground: Container(
              color: Theme.of(context).colorScheme.error,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            child: Card(
              child: ListTile(
                title: Text(debt.name),
                subtitle: Text(debt.value.toCurrency()),
                leading: Icon(
                  debt.isCardCredit
                      ? Icons.credit_card
                      : Icons.monetization_on_rounded,
                  size: 32,
                ),
                onTap: () {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Deseja pagar pagar divida?'),
                        content: const Text(
                          'Escolha a forma de pagamento',
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Não'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Sim'),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentMethodPage(
                                    paymentMethodNotifierFactory(debt.id),
                                    onGoBack: debtController.load,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<bool?> modalCreateDebt(BuildContext context, {DebtEntity? debt}) {
    final bool isEdit = debt != null;
    final TextEditingController nameEC =
        TextEditingController(text: debt?.name);
    final FocusNode nameFN = FocusNode();

    final TextEditingController valueEC =
        TextEditingController(text: debt?.value.toStringAsFixed(2));
    final FocusNode valueFN = FocusNode();

    return showModalBottomSheet<bool>(
      context: context,
      useSafeArea: true,
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true, // Permite o ajuste com o teclado
      isDismissible: false,
      builder: (BuildContext contextModal) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(contextModal).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFieldCustomWidget(
                  controller: nameEC,
                  focusNode: nameFN,
                  hintText: 'Nome da dívida',
                ),
                const SizedBox(height: 24),
                TextFieldCustomWidget(
                  controller: valueEC,
                  focusNode: valueFN,
                  hintText: 'Valor da dívida',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(contextModal).pop(false);
                        },
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final valueDouble =
                              double.parse(valueEC.text.toPointFormat());
                          if (isEdit) {
                            await debtController.updateDebt(
                              debt.copyWith(
                                name: nameEC.text,
                                value: valueDouble,
                              ),
                            );
                          } else {
                            await debtController.createDebt(
                              DebtEntity(
                                name: nameEC.text,
                                value: valueDouble,
                              ),
                            );
                          }
                          Navigator.of(contextModal).pop(false);
                        },
                        child: const Text('Salvar dívida'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
