import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../account/domain/entities/account_entity.dart';
import '../../category/domain/entities/category_entity.dart';
import 'quick_expense_controller.dart';
import 'quick_expense_state.dart';

class QuickExpensePage extends StatefulWidget {
  static const String routeName = '/quick-expense';

  final QuickExpenseController controller;

  const QuickExpensePage({super.key, required this.controller});

  @override
  State<QuickExpensePage> createState() => _QuickExpensePageState();
}

class _QuickExpensePageState extends State<QuickExpensePage> {
  final descriptionFocus = FocusNode();
  final valueFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller.load();

    widget.controller.onShowMessage = (String message, bool isError) {
      SnackBarCustom(context: context, message: message, isError: isError);

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

    widget.controller.onGoBack = () {
      Navigator.pop(context);
    };
  }

  @override
  void dispose() {
    descriptionFocus.dispose();
    valueFocus.dispose();
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Despesa'),
        elevation: 7,
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([
          widget.controller.state,
          widget.controller.descriptionEC,
          widget.controller.valueEC,
        ]),
        builder: (context, __) {
          final state = widget.controller.state.value;

          if (state.status == QuickExpenseStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == QuickExpenseStatus.error) {
            return Center(child: Text(state.errorMessage ?? 'Erro'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCategorySection(state),
                const SizedBox(height: 24),
                _buildAccountSection(state),
                const SizedBox(height: 24),
                _buildDescriptionField(),
                const SizedBox(height: 16),
                _buildValueField(),
                const SizedBox(height: 32),
                _buildSaveButton(state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategorySection(QuickExpenseState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📂 Categoria',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<CategoryEntity>(
          value: state.selectedCategory,
          decoration: const InputDecoration(
            filled: true,
            hintText: 'Selecione uma categoria',
            hintStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(),
          ),
          items: state.categories.map((category) {
            return DropdownMenuItem<CategoryEntity>(
              value: category,
              child: Text(
                '${category.name} • Gasto: ${category.consumed.toCurrency()} • Disp: ${category.balance.toCurrency()}',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            );
          }).toList(),
          onChanged: (category) {
            if (category != null) {
              widget.controller.selectCategory(category);
            }
          },
        ),
      ],
    );
  }

  Widget _buildAccountSection(QuickExpenseState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '💳 Conta',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<AccountEntity>(
          value: state.selectedAccount,
          decoration: const InputDecoration(
            filled: true,
            hintText: 'Selecione uma conta',
            hintStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(),
          ),
          items: state.accounts.map((account) {
            final icon = account.isMoney ? '💰' : '💳';
            final typeLabel = account.isMoney ? 'Dinheiro' : 'Cartão';
            return DropdownMenuItem<AccountEntity>(
              value: account,
              child: Text(
                '$icon ${account.name} ($typeLabel) • ${account.balance.toCurrency()}',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            );
          }).toList(),
          onChanged: (account) {
            if (account != null) {
              widget.controller.selectAccount(account);
            }
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return TextFieldCustomWidget(
      focusNode: descriptionFocus,
      controller: widget.controller.descriptionEC,
      hintText: 'Descrição da despesa',
      keyboardType: TextInputType.text,
    );
  }

  Widget _buildValueField() {
    return TextFieldCustomWidget(
      focusNode: valueFocus,
      controller: widget.controller.valueEC,
      hintText: 'Valor da despesa',
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }

  Widget _buildSaveButton(QuickExpenseState state) {
    return ElevatedButton(
      onPressed: widget.controller.isValid()
          ? () {
              widget.controller.createExpense();
            }
          : null,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text(
        'SALVAR DESPESA',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
