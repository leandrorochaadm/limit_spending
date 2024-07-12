import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../expense/expense.dart';
import '../category.dart';

class CategoryPage extends StatelessWidget {
  static const String routeName = '/category';
  CategoryPage({super.key, required this.categoryController});

  final CategoryController categoryController;
  bool actionExecuted = false; // Flag para controlar a execução

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categorias'), elevation: 7),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 42.0),
        child: FloatingActionButton(
          onPressed: () => modalCreateCategory(context),
          child: const Icon(Icons.add),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(bottom: 36.0, top: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<CategorySumEntity>(
              stream: categoryController.getSumCategoriesUseCase(),
              builder: (context, categorySum) {
                if (categorySum.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (categorySum.hasError) {
                  return Text('Error: ${categorySum.error}');
                }
                if (categorySum.hasData) {
                  final sumEntity = categorySum.data!;

                  return Text(
                    'Limite: R\$ ${sumEntity.limit.toStringAsFixed(2)} | Consumido: R\$ ${sumEntity.consumed.toStringAsFixed(2)}',
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
          StreamBuilder<List<CategoryEntity>>(
            stream: categoryController.categoriesStream,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('Nenhuma categoria encontrada'),
                );
              }

              final categories = snapshot.data!;

              return ListView.separated(
                itemCount: categories.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final category = categories[index];

                  return Dismissible(
                    key: Key(category.id),
                    direction: DismissDirection.startToEnd,
                    onUpdate: (details) {
                      if (!actionExecuted && details.progress > 0.5) {
                        actionExecuted = true; // Marca a ação como executada
                        modalCreateCategory(context, category: category);
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
                        '${category.name} (limite mensal: ${category.limitMonthly.toStringAsFixed(2)})',
                      ),
                      subtitle: Text(
                        'Disponível: ${(category.balance).toStringAsFixed(2)} | Consumido: ${(category.consumed).toStringAsFixed(2)}',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          ExpensePage.routeName,
                          arguments: {
                            'categoryId': category.id,
                            'categoryName': category.name,
                          },
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
          ValueListenableBuilder<CategoryState>(
            valueListenable: categoryController.state,
            builder: (context, state, __) {
              if (state.status == CategoryStatus.error) {
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
              if (state.status == CategoryStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Future<dynamic> modalCreateCategory(
    BuildContext context, {
    CategoryEntity? category,
  }) {
    final bool isEdit = category != null;
    final TextEditingController nameEC =
        TextEditingController(text: category?.name);
    final FocusNode nameFN = FocusNode();

    final TextEditingController limitEC =
        TextEditingController(text: category?.limitMonthly.toStringAsFixed(2));
    final FocusNode limitFN = FocusNode();

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
                hintText: 'Nome da categoria',
              ),
              const SizedBox(height: 24),
              TextFieldCustomWidget(
                controller: limitEC,
                focusNode: limitFN,
                hintText: 'Limite mensal',
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
                    CategoryEntity categoryUpdate = category.toModel().copyWith(
                          name: nameEC.text,
                          limitMonthly: limitEC.text.isEmpty
                              ? 0
                              : double.parse(limitEC.text),
                        );
                    categoryController.updateCategory(categoryUpdate);
                  } else {
                    categoryController.createCategory(
                      CategoryEntity(
                        name: nameEC.text,
                        created: DateTime.now(),
                        limitMonthly: limitEC.text.isEmpty
                            ? 0
                            : double.parse(limitEC.text),
                        consumed: 0,
                      ),
                    );
                  }
                  Navigator.of(contextModal).pop();
                },
                child: const Text('Salvar categoria'),
              ),
            ],
          ),
        );
      },
    ).whenComplete(
      () {
        actionExecuted = false;
      },
    );
  }
}