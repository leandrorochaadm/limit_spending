import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/core.dart';
import 'expense_controller.dart';
import 'expense_state.dart';

class ExpensePage extends StatelessWidget {
  static const String routeName = '/expense';

  final ExpenseController expenseController;

  const ExpensePage(this.expenseController, {super.key});

  @override
  Widget build(BuildContext context) {
    expenseController.onShowMessage = (String message, bool isError) {
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

    return ValueListenableBuilder(
      valueListenable: expenseController.state,
      builder: (context, state, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Despesas: ${expenseController.category.name}'),
            elevation: 7,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              expenseController.clearForm();
              modalCreateExpense(context);
            },
            child: const Icon(Icons.add),
          ),
          body: buildBody(state),
          bottomSheet: Padding(
            padding: const EdgeInsets.only(bottom: 36.0, top: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Limite mensal: ${state.limitCategory}\nConsumido nos ultimos $daysFilter dias: ${state.consumedSum}\nDisponível: ${state.balance}',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildBody(ExpenseState state) {
    if (state.status == ExpenseStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state.status == ExpenseStatus.error) {
      return Center(child: Text('${state.errorMessage}'));
    } else if (state.expenses.isEmpty) {
      return const Center(child: Text('Nenhuma despesa encontrada'));
    }

    if (state.status == ExpenseStatus.success) {
      final expenses = state.expenses;
      return Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
        child: ListView.separated(
          itemCount: expenses.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final expense = expenses[index];
            return Dismissible(
              key: Key(expense.id),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                expenseController.deleteExpense(expense);
                if (context.mounted) {}
              },
              background: Container(
                color: Theme.of(context).colorScheme.error,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: ListTile(
                title: Text(
                  '${expense.description} | ${(expense.value).toCurrency()}',
                ),
                subtitle: Text(
                  DateFormat('dd/MM HH:mm').format(expense.created),
                ),
              ),
            );
          },
        ),
      );
    }

    return Center(
      child: Column(
        children: [
          const Text('Erro ao carregar despesas'),
          const SizedBox.square(dimension: 24),
          FilledButton(
            onPressed: expenseController.load,
            child: const Text('Tente novamente'),
          ),
        ],
      ),
    );
  }

  Future<dynamic> modalCreateExpense(BuildContext context) {
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
            builder: (BuildContext context, StateSetter setState) {
              return ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                children: <Widget>[
                  const SizedBox(height: 24),
                  TextFieldCustomWidget(
                    controller: expenseController.descriptionEC,
                    focusNode: expenseController.descriptionFN,
                    hintText: 'Descrição da despesa',
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 24),
                  TextFieldCustomWidget(
                    controller: expenseController.valueEC,
                    focusNode: expenseController.valueFN,
                    hintText: 'Valor da despesa',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {}),
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
                    onPressed: expenseController.isValid()
                        ? () {
                            expenseController.createExpense();
                            Navigator.pop(context);
                          }
                        : null,
                    child: const Text('Salvar despesa'),
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
