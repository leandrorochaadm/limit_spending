import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/core.dart';
import '../category.dart';
import 'category_state.dart';

class CategoryPage extends StatelessWidget {
  static const String routeName = '/category';
  CategoryPage({
    super.key,
    required this.categoryController,
    this.paymentMethodId,
    this.isMoney,
  });

  final String? paymentMethodId;
  final bool? isMoney;

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
            padding: const EdgeInsets.only(left: 32, top: 110),
            child: FloatingActionButton(
              onPressed: () {
                categoryController.clearForm();
                modalCreateCategory(context);
              },
              child: const Icon(Icons.add),
            ),
          ),
          bottomSheet: Padding(
            padding: const EdgeInsets.only(bottom: 36.0, top: 24, left: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Limite: ${state.limitSum}\n'
                      'Disponível: ${state.balanceSum}\n'
                      'Consumido nos $daysFilter dias: ${state.consumedSum}',
                  textAlign: TextAlign.left,
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
      padding: const EdgeInsets.only(bottom: 100.0, left: 24, right: 24),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
            categoryController.loadMore();
          }
          return false;
        },
        child: ListView.builder(
          itemCount: categories.length + (state.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            // Show loading indicator at the end
            if (index == categories.length) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: state.isLoadingMore ? const CircularProgressIndicator() : const SizedBox.shrink(),
                ),
              );
            }

            final category = categories[index];
            return Dismissible(
              key: Key(category.id),
              direction: DismissDirection.horizontal,
              onUpdate: (details) {
                if (!actionExecuted && details.direction == DismissDirection.startToEnd && details.progress > 0.5) {
                  actionExecuted = true;
                  categoryController.categorySelected = category;
                  modalCreateCategory(context);
                }
              },
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  return await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          'Deseja realmente excluir esta categoria?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Text(
                          '${category.name}\n\n'
                          'Todas as despesas desta categoria também serão excluídas.',
                          textAlign: TextAlign.justify,
                          style: const TextStyle(fontSize: 16),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Não'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Sim'),
                          ),
                        ],
                      );
                    },
                  );
                }
                return false;
              },
              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart) {
                  categoryController.deleteCategory(category.id);
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
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              child: Card(
                child: ListTile(
                  title: Text(category.name),
                  subtitle: Text(
                    'Disponível: ${category.balance.toCurrency()} \nConsumido nos $daysFilter dias: ${category.consumed.toCurrency()} \nLimite mensal: ${category.limitMonthly.toCurrency()}',
                  ),
                  trailing: paymentMethodId != null ? const Icon(Icons.arrow_forward_ios) : null,
                  onTap: paymentMethodId != null && isMoney != null
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return makeExpensePage(
                                  category: category,
                                  paymentMethodId: paymentMethodId!,
                                  isMoney: isMoney!,
                                  onGoBack: categoryController.load,
                                );
                              },
                            ),
                          );
                        }
                      : null,
                ),
              ),
            );
          },
        ),
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
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
