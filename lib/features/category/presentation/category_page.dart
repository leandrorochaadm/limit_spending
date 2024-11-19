import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../category.dart';

class CategoryPage extends StatelessWidget {
  static const String routeName = '/category';

  CategoryPage({
    super.key,
    required this.categoryController,
    required this.debtId,
  });

  final String debtId;
  final CategoryController categoryController;
  bool actionExecuted = false; // Flag para controlar a execução

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CategoriesEntity>(
      stream: categoryController.categoriesStream,
      builder: (_, snapshot) {
        final data = snapshot.data!;

        return Scaffold(
          appBar: AppBar(title: const Text('Categorias'), elevation: 7),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(left: 32),
            child: FloatingActionButton(
              onPressed: () => modalCreateCategory(context),
              child: const Icon(Icons.add),
            ),
          ),
          bottomSheet: Padding(
            padding: const EdgeInsets.only(bottom: 36.0, top: 24),
            child: Text(
              'Limite mensal: R\$ ${data.sumLimit.toCurrency()}\nDisponível: R\$ ${data.sumBalance.toCurrency()}',
              textAlign: TextAlign.center,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(bottom: 72.0),
            child: snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : snapshot.hasError
                    ? Center(child: Text('Error: ${snapshot.error}'))
                    : !snapshot.hasData || snapshot.data!.categories.isEmpty
                        ? const Center(
                            child: Text('Nenhuma categoria encontrada'),
                          )
                        : buildCategoriesWidget(data),
          ),
        );
      },
    );
  }

  ListView buildCategoriesWidget(CategoriesEntity data) {
    return ListView.separated(
      itemCount: data.categories.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final category = data.categories[index];
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
            title: Text(category.name),
            subtitle: Text(
              'Disponível: ${category.balance.toCurrency()} \nConsumo:${category.consumed.toCurrency()} \nlimite mensal: ${category.limitMonthly.toCurrency()}',
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return makeExpensePage(
                      category: category,
                      debtId: debtId,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
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
                              : double.parse(limitEC.text.toPointFormat()),
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
