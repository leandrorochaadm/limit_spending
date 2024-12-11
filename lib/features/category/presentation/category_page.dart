import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../../core/widgets/snack_bar_custom.dart';
import '../category.dart';
import 'category_state.dart';

class CategoryPage extends StatelessWidget {
  static const String routeName = '/category';
  CategoryPage({
    super.key,
    required this.categoryController,
    required this.paymentMethodId,
    required this.isMoney,
  });

  final String paymentMethodId;
  final bool isMoney;

  final CategoryController categoryController;
  bool actionExecuted = false; // Flag para controlar a execução

  @override
  Widget build(BuildContext context) {
    categoryController.onMessage = (message, isError) {
      SnackBarCustom(message: message, isError: isError, context: context);
    };

    return ValueListenableBuilder(
      valueListenable: categoryController.state,
      builder: (context, state, __) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Categorias', textAlign: TextAlign.center),
            elevation: 7,
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(left: 32),
            child: FloatingActionButton(
              onPressed: () {
                categoryController.clearForm();
                modalCreateCategory(context);
              },
              child: const Icon(Icons.add),
            ),
          ),
          bottomSheet: Padding(
            padding: const EdgeInsets.only(bottom: 36.0, top: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Limite: ${state.limitSum}\nDisponível: ${state.balanceSum}\nConsumido nos $daysFilter dias: ${state.consumedSum}',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          body: buildBodyWidget(state),
        );
      },
    );
  }

  Widget buildBodyWidget(CategoryState state) {
    if (state.status == CategoryStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state.status == CategoryStatus.error) {
      return Center(child: Text('Erro: ${state.messageToUser}'));
    } else if (state.status == CategoryStatus.information) {
      return Center(child: Text('${state.messageToUser}'));
    }

    final categories = state.categories;

    return Padding(
      padding: const EdgeInsets.only(bottom: 100.0),
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Dismissible(
            key: Key(category.id),
            direction: DismissDirection.startToEnd,
            onUpdate: (details) {
              if (!actionExecuted && details.progress > 0.5) {
                actionExecuted = true; // Marca a ação como executada
                categoryController.categorySelected = category;
                modalCreateCategory(context);
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
            secondaryBackground: Container(
              color: Theme.of(context).colorScheme.error,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            child: Card(
              child: ListTile(
                title: Text(category.name),
                subtitle: Text(
                  'Disponível: ${category.balance.toCurrency()} \nConsumido nos $daysFilter dias: ${category.consumed.toCurrency()} \nLimite mensal: ${category.limitMonthly.toCurrency()}',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return makeExpensePage(
                          category: category,
                          paymentMethodId: paymentMethodId,
                          isMoney: isMoney,
                          onGoBack: categoryController.load,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> modalCreateCategory(BuildContext context) {
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
                    controller: categoryController.nameEC,
                    focusNode: categoryController.nameFN,
                    hintText: 'Nome da categoria',
                  ),
                  const SizedBox(height: 24),
                  TextFieldCustomWidget(
                    controller: categoryController.limitEC,
                    focusNode: categoryController.limitFN,
                    hintText: 'Limite mensal',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      categoryController.submit();
                      Navigator.of(contextModal).pop();
                    },
                    child: const Text('Salvar categoria'),
                  ),
                ],
              );
            },
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
