import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../domain/entities/entities.dart';
import 'presentation.dart';

class SupermarketPage extends StatelessWidget {
  final SupermarketController supermarketController;

  const SupermarketPage(this.supermarketController, {super.key});

  @override
  Widget build(BuildContext context) {
    supermarketController.onMessage = (String message, bool isError) {
      SnackBarCustom(
        context: context,
        message: message,
        isError: isError,
        duration: const Duration(seconds: 1),
      );
    };

    return ValueListenableBuilder(
      valueListenable: supermarketController,
      builder: (context, state, __) {
        return Scaffold(
          appBar: AppBar(title: const Text('Produtos do mercado'), elevation: 7),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              modalCreateSupermarket(context);
            },
            child: const Icon(Icons.add),
          ),
          body: buildBodyWidget(state),
        );
      },
    );
  }

  Widget buildBodyWidget(SupermarketState state) {
    if (state.status == SupermarketStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state.status == SupermarketStatus.error) {
      return Center(child: Text('${state.messageToUser}'));
    } else if (state.status == SupermarketStatus.information) {
      return Center(child: Text('${state.messageToUser}'));
    }

    final products = state.products;
    return Padding(
      padding: const EdgeInsets.only(bottom: 120.0),
      child: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return Dismissible(
            key: Key(product.id),
            direction: product.needToBuy ? DismissDirection.none : DismissDirection.horizontal,
            confirmDismiss: (direction) async {
              Future<bool?>? resultDismiss;
              if (direction == DismissDirection.endToStart) {
                if (product.needToBuy) {
                  resultDismiss = showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Aviso'),
                        content: const Text(
                          'Cartão de crédito não pode ser excluido, pague a divida do cartão que ela será excluida automaticamente',
                          textAlign: TextAlign.justify,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('Ok'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  resultDismiss = showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Excluir divida'),
                        content: const Text('Deseja realmente excluir esta divida?'),
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
                }
              }

              if (direction == DismissDirection.startToEnd) {
                resultDismiss = modalCreateSupermarket(context, product: product);
              }
              return resultDismiss;
            },
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                supermarketController.deleteProduct(product.id);
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
                title: Text('${product.name} ${product.measure.toStringAsFixed(0)}${product.unitOfMeasure.symbol}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('preco: ${product.price.toCurrency()} | ${product.pricePerUnit.toStringAsFixed(5)}'),
                    Text('quantidade comprada: ${product.quantity.toStringAsFixed(0)}'),
                  ],
                ),
                leading: Icon(
                  product.needToBuy ? Icons.shopping_cart_outlined : Icons.shopping_cart_rounded,
                  size: 32,
                ),
                onTap: () {
                  /*   showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Deseja pagar pagar divida?'),
                        content: const Text(
                          'Escolha a forma de pagamento',
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Não'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Sim'),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentMethodPage(
                                    paymentMethodNotifierFactory(product.id),
                                    onGoBack: supermarketController.load,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );*/
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<bool?> modalCreateSupermarket(BuildContext context, {ProductEntity? product}) {
    final bool isEdit = product != null;
    final TextEditingController nameEC = TextEditingController(text: product?.name);
    final FocusNode nameFN = FocusNode();

    final TextEditingController valueEC = TextEditingController(text: product?.price.toStringAsFixed(2));
    final FocusNode valueFN = FocusNode();

    return showModalBottomSheet<bool>(
      context: context,
      useSafeArea: true,
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true,
      // Permite o ajuste com o teclado
      isDismissible: false,
      builder: (BuildContext contextModal) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(contextModal).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFieldCustomWidget(
                  controller: nameEC,
                  focusNode: nameFN,
                  hintText: 'Nome da produto',
                ),
                const SizedBox(height: 24),
                TextFieldCustomWidget(
                  controller: valueEC,
                  focusNode: valueFN,
                  hintText: 'Valor da produto',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(contextModal).pop(false);
                        },
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final valueDouble = double.parse(valueEC.text.toPointFormat());
                          if (isEdit) {
                            await supermarketController.updateProduct(
                              product.copyWith(
                                name: nameEC.text,
                                measure: valueDouble,
                              ),
                            );
                          } else {
                            await supermarketController.createProduct(
                              ProductEntity(
                                name: nameEC.text,
                                measure: valueDouble,
                                unitOfMeasure: UnitOfMeasure.grams,
                              ),
                            );
                          }
                          Navigator.of(contextModal).pop(false);
                        },
                        child: const Text('Salvar produto'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
