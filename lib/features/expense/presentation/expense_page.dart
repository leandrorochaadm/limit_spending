import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../text_field_custom_widget.dart';
import '../domain/domain.dart';
import 'expense_controller.dart';
import 'expense_state.dart';

class ExpensePage extends StatelessWidget {
  static const String routeName = '/expense';
  final ExpenseController expenseController;
  const ExpensePage({super.key, required this.expenseController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Despesas'), elevation: 7),
      body: Stack(
        children: [
          StreamBuilder<List<ExpenseEntity>>(
            stream: expenseController.expensesStream,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Nenhuma despesa encontrada'));
              }

              final expenses = snapshot.data!;

              return ListView.separated(
                itemCount: expenses.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final expense = expenses[index];
                  return ListTile(
                    title: Text(
                      '${expense.description} (${DateFormat('dd/MM HH:mm').format(expense.created)})',
                    ),
                    subtitle: Text(
                      'Valor: ${(expense.value).toStringAsFixed(2)}',
                    ),
                    trailing: const Icon(Icons.edit),
                    onTap: () => modalCreateExpense(context, expense: expense),
                  );
                },
              );
            },
          ),
          ValueListenableBuilder<ExpenseState>(
            valueListenable: expenseController.state,
            builder: (context, state, __) {
              if (state.status == ExpenseStatus.error) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      content: Text(state.errorMessage ?? 'Erro desconhecido'),
                    ),
                  );
                });
              }
              if (state.status == ExpenseStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => modalCreateExpense(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<dynamic> modalCreateExpense(
    BuildContext context, {
    ExpenseEntity? expense,
  }) {
    final bool isEdit = expense != null;
    final TextEditingController descriptionEC =
        TextEditingController(text: expense?.description);
    final FocusNode descriptionFN = FocusNode();

    final TextEditingController valueEC =
        TextEditingController(text: expense?.value.toStringAsFixed(2));
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
                controller: descriptionEC,
                focusNode: descriptionFN,
                hintText: 'Descrição da despesa',
              ),
              const SizedBox(height: 24),
              TextFieldCustomWidget(
                controller: valueEC,
                focusNode: valueFN,
                hintText: 'Valor da despesa',
                keyboardType: TextInputType.number,
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
                onPressed: () {
                  if (isEdit) {
                    ExpenseEntity expenseUpdate = expense.copyWith(
                      description: descriptionEC.text,
                      value:
                          valueEC.text.isEmpty ? 0 : double.parse(valueEC.text),
                    );
                    expenseController.updateExpense(expenseUpdate);
                  } else {
                    expenseController.createExpense(
                      ExpenseEntity(
                        description: descriptionEC.text,
                        created: DateTime.now(),
                        value: valueEC.text.isEmpty
                            ? 0
                            : double.parse(valueEC.text),
                        categoryId: '',
                      ),
                    );
                  }
                  Navigator.of(contextModal).pop();
                },
                child: isEdit
                    ? const Text('Editar despesa')
                    : const Text('Criar despesa'),
              ),
            ],
          ),
        );
      },
    );
  }
}
