import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/core.dart';
import '../debit.dart';

class DebtPage extends StatelessWidget {
  final DebtController debtController;
  DebtPage(this.debtController, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dividas'), elevation: 7),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          modalCreateDebt(context);
        },
        child: const Icon(Icons.add),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(bottom: 36.0, top: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<double>(
              future: debtController.getSumDebtsUseCase(),
              builder: (context, debtsSum) {
                if (debtsSum.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (debtsSum.hasError) {
                  return Text('Erro: ${debtsSum.error}');
                }
                if (debtsSum.hasData) {
                  final sumEntity = debtsSum.data!;

                  return Text(
                    'Total: ${sumEntity.toCurrency()}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<DebtEntity>>(
        future: debtController.getDebts(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Parabens! Nenhuma divida encontrada'),
            );
          }

          final debtData = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.only(bottom: 72.0),
            child: ListView.separated(
              itemCount: debtData.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final debt = debtData[index];

                return Dismissible(
                  key: Key(debt.id),
                  direction: DismissDirection.horizontal,
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      final bool? result = await showModalBottomSheet<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Excluir divida'),
                            content: const Text(
                              'Deseja realmente excluir esta divida?',
                            ),
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
                      return result ?? false;
                    } else if (direction == DismissDirection.startToEnd) {
                      modalCreateDebt(context, debt: debt);
                      return false;
                    }
                    return false;
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
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  child: ListTile(
                    title: Text('${debt.name}\n${debt.value.toCurrency()}'),
                    subtitle: debt.isCardCredit
                        ? Text(
                            'Vence em: ${DateFormat('dd/MM').format(debt.getDueDate())}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          )
                        : null,
                    leading: Icon(
                      Icons.circle,
                      color: debt.isPayment
                          ? (debt.isAllowsToBuy() ? Colors.green : Colors.red)
                          : Colors.transparent,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      if (!debt.isPayment) {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(debt.name),
                              content: const Text(
                                'Não pode ser usada como uma forma de pagamento',
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('Fechar'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return makeCategoryPage(debt.id);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> modalCreateDebt(BuildContext context, {DebtEntity? debt}) {
    final bool isEdit = debt != null;
    final TextEditingController nameEC =
        TextEditingController(text: debt?.name);
    final FocusNode nameFN = FocusNode();

    final TextEditingController valueEC =
        TextEditingController(text: debt?.value.toStringAsFixed(2));
    final FocusNode valueFN = FocusNode();

    final TextEditingController dayCloseEC =
        TextEditingController(text: debt?.dayClose.toString());
    final FocusNode dayCloseFN = FocusNode();

    bool isPayment = debt?.isPayment ?? false;
    bool isCardCredit = debt?.isCardCredit ?? false;

    return showModalBottomSheet(
      context: context,
      useSafeArea: true,
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext contextModal) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: StatefulBuilder(
            builder: (context, setState) {
              void onChangedPayment(bool? newValue) {
                setState(() {
                  isPayment = newValue ?? false;

                  if (!isPayment) {
                    isCardCredit = false;
                  }
                });
              }

              void onChangedCardCredit(bool? newValue) {
                if (!isPayment) return;
                setState(() {
                  isCardCredit = newValue ?? false;
                });
              }

              return Column(
                children: <Widget>[
                  TextFieldCustomWidget(
                    controller: nameEC,
                    focusNode: nameFN,
                    hintText: 'Nome da divida',
                  ),
                  const SizedBox(height: 24),
                  TextFieldCustomWidget(
                    controller: valueEC,
                    focusNode: valueFN,
                    hintText: 'Valor da divida',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 24),
                  TextFieldCustomWidget(
                    controller: dayCloseEC,
                    focusNode: dayCloseFN,
                    hintText: 'Dia fechamento da fatura',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                      onChangedPayment(!isPayment);
                    },
                    child: Row(
                      children: [
                        const Text('É forma de pagamento?'),
                        Checkbox(
                          value: isPayment,
                          onChanged: onChangedPayment,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      onChangedCardCredit(!isCardCredit);
                    },
                    child: Row(
                      children: [
                        const Text('É cartão de crédito?'),
                        Checkbox(
                          value: isCardCredit,
                          onChanged: isPayment ? onChangedCardCredit : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                      shape: const StadiumBorder(),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onPressed: () async {
                      final valueDouble =
                          double.parse(valueEC.text.toPointFormat());
                      if (isEdit) {
                        await debtController.updateDebt(
                          debt.copyWith(
                            name: nameEC.text,
                            value: valueDouble,
                            isPayment: isPayment,
                            dayClose: int.tryParse(dayCloseEC.text) ?? 0,
                            isCardCredit: isCardCredit,
                          ),
                        );
                      } else {
                        await debtController.createDebt(
                          DebtEntity(
                            name: nameEC.text,
                            value: valueDouble,
                            isPayment: isPayment,
                            dayClose: int.tryParse(dayCloseEC.text) ?? 0,
                            isCardCredit: isCardCredit,
                          ),
                        );
                      }
                      Navigator.of(contextModal).pop();
                    },
                    child: const Text('Salvar divida'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
