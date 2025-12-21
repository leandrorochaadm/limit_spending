import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../domain/entities/account_entity.dart';
import '../domain/entities/account_type.dart';
import 'account_controller.dart';
import 'account_state.dart';

class AccountPage extends StatelessWidget {
  static const String routeName = '/account';

  AccountPage({
    super.key,
    required this.accountController,
  });

  final AccountController accountController;
  bool actionExecuted = false;

  @override
  Widget build(BuildContext context) {
    accountController.onMessage = (message, isError) {
      SnackBarCustom(message: message, isError: isError, context: context);
    };

    return ValueListenableBuilder(
      valueListenable: accountController.state,
      builder: (context, state, __) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Contas', textAlign: TextAlign.center),
            elevation: 7,
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                tooltip: 'Opções',
                onSelected: (String value) {
                  if (value == 'categories') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => makeCategoryPage(),
                      ),
                    ).then((_) => accountController.load());
                  } else if (value == 'new-account') {
                    accountController.clearForm();
                    modalCreateAccount(context);
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'categories',
                    child: Row(
                      children: [
                        Icon(Icons.category),
                        SizedBox(width: 12),
                        Text('Gerenciar Categorias'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'new-account',
                    child: Row(
                      children: [
                        Icon(Icons.category),
                        SizedBox(width: 12),
                        Text('Nova conta'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(left: 32),
            child: FloatingActionButton(
              heroTag: 'quick_expense',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => makeQuickExpensePage(),
                  ),
                ).then((_) => accountController.load());
              },
              child: const Icon(Icons.add_shopping_cart),
            ),
          ),
          bottomSheet: Padding(
            padding: const EdgeInsets.only(bottom: 36.0, top: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Dinheiro: ${state.moneySum}\nCartão: ${state.cardSum}\nEmpréstimo: ${state.loanSum}'
                  '\nDinheiro-Cartão: ${state.totalSum}',
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

  Widget buildBodyWidget(AccountState state) {
    if (state.status == AccountStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state.status == AccountStatus.error) {
      return Center(child: Text('Erro: ${state.messageToUser}'));
    } else if (state.status == AccountStatus.information) {
      return Center(child: Text('${state.messageToUser}'));
    }

    final accounts = state.accounts;

    return Padding(
      padding: const EdgeInsets.only(bottom: 100.0, left: 24, right: 24, top: 8),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
            accountController.loadMore();
          }
          return false;
        },
        child: ListView.builder(
          itemCount: accounts.length + (state.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == accounts.length) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: state.isLoadingMore ? const CircularProgressIndicator() : const SizedBox.shrink(),
                ),
              );
            }

            final account = accounts[index];
            return Dismissible(
              key: Key(account.id),
              direction: DismissDirection.horizontal,
              onUpdate: (details) {
                if (!actionExecuted && details.direction == DismissDirection.startToEnd && details.progress > 0.5) {
                  actionExecuted = true;
                  accountController.accountSelected = account;
                  modalCreateAccount(context);
                }
              },
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  return await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          'Deseja realmente excluir esta conta?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Text(
                          '${account.name}\n\n'
                          'Todas as despesas desta conta também serão excluídas.',
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
                  accountController.deleteAccount(account);
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
                  title: Text(account.name),
                  subtitle: Text(_buildAccountSubtitle(account)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _buildAccountSubtitle(AccountEntity account) {
    final typeLabel = account.type == AccountType.money
        ? 'Dinheiro'
        : account.type == AccountType.card
            ? 'Cartão'
            : 'Empréstimo';

    String subtitle = 'Tipo: $typeLabel\nValor: ${account.value.toCurrency()}';

    if (account.type == AccountType.card) {
      subtitle += '\nLimite: ${account.limit.toCurrency()}\nDia de fechamento: ${account.dayClose}';
    }

    return subtitle;
  }

  Future<dynamic> modalCreateAccount(BuildContext context) {
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
                    controller: accountController.nameEC,
                    focusNode: accountController.nameFN,
                    hintText: 'Nome da conta',
                  ),
                  const SizedBox(height: 24),
                  DropdownButtonFormField<AccountType>(
                    value: accountController.selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de conta',
                      border: OutlineInputBorder(),
                    ),
                    items: AccountType.values.map((AccountType type) {
                      return DropdownMenuItem<AccountType>(
                        value: type,
                        child: Text(
                          type == AccountType.money
                              ? 'Dinheiro'
                              : type == AccountType.card
                                  ? 'Cartão'
                                  : 'Empréstimo',
                        ),
                      );
                    }).toList(),
                    onChanged: (AccountType? newValue) {
                      if (newValue != null) {
                        setState(() {
                          accountController.selectedType = newValue;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFieldCustomWidget(
                    controller: accountController.valueEC,
                    focusNode: accountController.valueFN,
                    hintText: 'Valor',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  if (accountController.selectedType == AccountType.card) ...[
                    const SizedBox(height: 24),
                    TextFieldCustomWidget(
                      controller: accountController.limitEC,
                      focusNode: accountController.limitFN,
                      hintText: 'Limite',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 24),
                    TextFieldCustomWidget(
                      controller: accountController.dayCloseEC,
                      focusNode: accountController.dayCloseFN,
                      hintText: 'Dia de fechamento (1-31)',
                      keyboardType: TextInputType.number,
                    ),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      accountController.submit();
                      Navigator.of(contextModal).pop();
                    },
                    child: const Text('Salvar conta'),
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
