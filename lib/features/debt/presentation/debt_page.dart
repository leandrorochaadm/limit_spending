import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../debit.dart';
import 'debt_state.dart';

class DebtPage extends StatelessWidget {
  final DebtController debtController;
  const DebtPage(this.debtController, {super.key});

  @override
  Widget build(BuildContext context) {
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
                        builder: (context) => makePaymentMethodPage(),
                      ),
                    ).whenComplete(() => debtController.load());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 4,
                    ),
                  ),
                  child: const Text(
                    'Quero gastar',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total: ${state.debtsSum}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
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
      return Center(child: Text('Erro: ${state.messageToUser}'));
    } else if (state.status == DebtStatus.information) {
      return Center(child: Text('Erro: ${state.messageToUser}'));
    }

    final debts = state.debts;
    return Padding(
      padding: const EdgeInsets.only(bottom: 120.0),
      child: ListView.separated(
        itemCount: debts.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final debt = debts[index];

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
              title: Text('${debt.name} | ${debt.value.toCurrency()}'),
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
                          debt.copyWith(name: nameEC.text, value: valueDouble),
                        );
                      } else {
                        await debtController.createDebt(
                          DebtEntity(name: nameEC.text, value: valueDouble),
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
