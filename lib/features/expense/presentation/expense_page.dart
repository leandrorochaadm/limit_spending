import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/core.dart';
import '../../category/domain/entities/entities.dart';
import '../domain/domain.dart';
import 'expense_controller.dart';
import 'expense_state.dart';

class ExpensePage extends StatelessWidget {
  static const String routeName = '/expense';
  final ExpenseController expenseController;
  const ExpensePage({
    super.key,
    required this.expenseController,
  });

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final categoryId = args['categoryId'] as String;
    final categoryName = args['categoryName'] as String;
    final categoryLimit = args['categoryLimit'] as double;

    return Scaffold(
      appBar: AppBar(title: Text('Despesas: $categoryName'), elevation: 7),
      floatingActionButton: FloatingActionButton(
        onPressed: () => modalCreateExpense(context, categoryId: categoryId),
        child: const Icon(Icons.add),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(bottom: 36.0, top: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<CategorySumEntity>(
              stream: expenseController.getSumByCategory(
                categoryId: categoryId,
                categoryLimit: categoryLimit,
              ),
              builder: (context, categorySum) {
                if (categorySum.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (categorySum.hasError) {
                  debugPrint(categorySum.error.toString());
                  return Text('Error: ${categorySum.error}');
                }
                if (categorySum.hasData) {
                  final sumEntity = categorySum.data!;

                  return Text(
                    'Limite mensal: R\$ ${sumEntity.limit.toStringAsFixed(2)}\nConsumido nos ultimos 30 dias: R\$ ${sumEntity.consumed.toStringAsFixed(2)}\nDisponível: R\$ ${sumEntity.balance.toStringAsFixed(2)}',
                    textAlign: TextAlign.center,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          StreamBuilder<List<ExpenseEntity>>(
            stream: expenseController.expensesStream(categoryId),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Nenhuma despesa encontrada'));
              }

              final expenses = snapshot.data!;

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
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '${expense.description} ${expense.value.toStringAsFixed(2)} foi removido'),
                            ),
                          );
                        }
                      },
                      background: Container(
                        color: Theme.of(context).colorScheme.error,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: ListTile(
                        title: Text(
                          '${expense.description} (${DateFormat('dd/MM HH:mm').format(expense.created)})',
                        ),
                        subtitle: Text(
                          'Valor: ${(expense.value).toStringAsFixed(2)}',
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          ValueListenableBuilder<ExpenseState>(
            valueListenable: expenseController.state,
            builder: (context, state, __) {
              if (state.status == ExpenseStatus.error) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        content:
                            Text(state.errorMessage ?? 'Erro desconhecido'),
                      ),
                    );
                  }
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
    );
  }

  Future<dynamic> modalCreateExpense(
    BuildContext context, {
    ExpenseEntity? expense,
    String categoryId = '',
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
                      categoryId: categoryId,
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
                        categoryId: categoryId,
                      ),
                    );
                  }
                  Navigator.of(contextModal).pop();
                },
                child: const Text('Salvar despesa'),
              ),
            ],
          ),
        );
      },
    );
  }
}
