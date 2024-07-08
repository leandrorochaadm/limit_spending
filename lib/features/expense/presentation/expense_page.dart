import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../text_field_custom_widget.dart';
import '../../category/category.dart';
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
      appBar: AppBar(
        title: const Text('Despesas'),
        elevation: 7,
        actions: [
          IconButton.outlined(
            onPressed: () =>
                Navigator.pushNamed(context, CategoryPage.routeName),
            icon: const Icon(Icons.category),
          ),
        ],
      ),
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
                  return Dismissible(
                    key: Key(expense.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      expenseController.deleteExpense(expense);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${expense.description} foi removido'),
                        ),
                      );
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
                      // trailing: const Icon(Icons.edit),
                      // onTap: () =>
                      //     modalCreateExpense(context, expense: expense),
                    ),
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
    List<CategoryEntity>? categories,
  }) {
    final bool isEdit = expense != null;
    final TextEditingController descriptionEC =
        TextEditingController(text: expense?.description);
    final FocusNode descriptionFN = FocusNode();

    final TextEditingController valueEC =
        TextEditingController(text: expense?.value.toStringAsFixed(2));
    final FocusNode valueFN = FocusNode();

    CategoryEntity? selectedCategory;

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
              StreamBuilder<List<CategoryEntity>>(
                stream: expenseController.categoriesStream(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('Nenhuma categoria encontrada'));
                  }

                  final categories = snapshot.data!;
                  return Autocomplete<CategoryEntity>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<CategoryEntity>.empty();
                      }
                      return categories.where((CategoryEntity category) {
                        return category.name
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    displayStringForOption: (CategoryEntity option) =>
                        option.name,
                    onSelected: (CategoryEntity selection) {
                      selectedCategory = selection;
                      print('Selected: ${selection.name}');
                    },
                    fieldViewBuilder: (
                      BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted,
                    ) {
                      return TextFieldCustomWidget(
                        focusNode: focusNode,
                        controller: textEditingController,
                        hintText: 'Digite para buscar categorias',
                      );
                    },
                    optionsViewBuilder: (
                      BuildContext context,
                      AutocompleteOnSelected<CategoryEntity> onSelected,
                      Iterable<CategoryEntity> options,
                    ) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(8.0),
                              itemCount: options.length,
                              itemBuilder: (BuildContext context, int index) {
                                final CategoryEntity option =
                                    options.elementAt(index);
                                return GestureDetector(
                                  onTap: () {
                                    onSelected(option);
                                  },
                                  child: ListTile(
                                    title: Text(option.name),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
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
                      categoryId: selectedCategory?.id ?? expense.categoryId,
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
                        categoryId: selectedCategory?.id ?? '',
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
