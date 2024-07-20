import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../debit.dart';

class DebtPage extends StatelessWidget {
  final DebtController debtController;
  const DebtPage(this.debtController, {super.key});

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
            StreamBuilder<double>(
              stream: debtController.getSumDebtsUseCase(),
              builder: (context, debtsSum) {
                if (debtsSum.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (debtsSum.hasError) {
                  return Text('Error: ${debtsSum.error}');
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
      body: StreamBuilder<List<DebtEntity>>(
        stream: debtController.getDebts(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
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

                return ListTile(
                  title: Text('${debt.name}\n${debt.value.toCurrency()}'),
                  subtitle: debt.isCardCredit
                      ? Text(
                          'Dia de fechamento: ${debt.dayClose}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      : null,
                  leading: Icon(
                    Icons.circle,
                    color: debt.isAllowsToBuy() ? Colors.green : Colors.red,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return makeCategoryPage(debt.id);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> modalCreateDebt(BuildContext context) {
    final TextEditingController nameEC = TextEditingController();
    final FocusNode nameFN = FocusNode();

    final TextEditingController valueEC = TextEditingController();
    final FocusNode valueFN = FocusNode();

    final TextEditingController dayCloseEC = TextEditingController();
    final FocusNode dayCloseFN = FocusNode();

    bool isPayment = false;
    bool isCardCredit = false;

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
                      var valueStr = valueEC.text.toPointFormat();
                      await debtController.createDebt(
                        DebtEntity(
                          name: nameEC.text,
                          value: double.parse(valueStr),
                          isPayment: isPayment,
                          dayClose: int.tryParse(dayCloseEC.text) ?? 0,
                          isCardCredit: isCardCredit,
                        ),
                      );
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
