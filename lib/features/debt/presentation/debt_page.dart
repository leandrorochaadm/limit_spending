import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/widgets.dart';
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
                final valueFormat = NumberFormat.simpleCurrency(
                  decimalDigits: 2,
                  locale: 'pt_BR',
                ).format(debt.value);
                return Visibility(
                  visible: debt.value >= 0.0,
                  child: ListTile(
                    title: Text(debt.name),
                    subtitle: Text(
                      valueFormat,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
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

    return showModalBottomSheet(
      context: context,
      useSafeArea: true,
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext contextModal) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
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
                  var valueStr = valueEC.text.trim().replaceAll(',', '.');
                  await debtController.createDebt(
                    DebtEntity(
                      name: nameEC.text,
                      value: double.parse(
                        valueStr,
                      ),
                    ),
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Salvar divida'),
              ),
            ],
          ),
        );
      },
    );
  }
}
