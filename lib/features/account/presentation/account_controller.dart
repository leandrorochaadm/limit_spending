import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../domain/entities/account_entity.dart';
import '../domain/entities/account_type.dart';
import '../domain/usecases/usecases.dart';
import 'account_state.dart';

class AccountController {
  final CreateAccountUseCase createAccountUseCase;
  final GetAccountsUseCase getAccountsUseCase;
  final GetAccountsPaginatedUseCase getAccountsPaginatedUseCase;
  final UpdateAccountUseCase updateAccountUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;
  final IncrementAccountValueUseCase incrementAccountValueUseCase;
  final PaymentAccountUseCase paymentAccountUseCase;

  static const int _pageSize = 10;

  final ValueNotifier<AccountState> state = ValueNotifier(
    const AccountState(status: AccountStatus.initial),
  );

  AccountEntity? _accountSelected;

  set accountSelected(AccountEntity? account) {
    _accountSelected = account;
    nameEC.text = account?.name ?? '';
    valueEC.text = account?.value.toStringAsFixed(2) ?? '';
    limitEC.text = account?.limit.toStringAsFixed(2) ?? '';
    dayCloseEC.text = account?.dayClose.toString() ?? '';
    selectedType = account?.type ?? AccountType.money;
  }

  AccountType selectedType = AccountType.money;
  TextEditingController nameEC = TextEditingController();
  final FocusNode nameFN = FocusNode();
  TextEditingController valueEC = TextEditingController();
  final FocusNode valueFN = FocusNode();
  TextEditingController limitEC = TextEditingController();
  final FocusNode limitFN = FocusNode();
  TextEditingController dayCloseEC = TextEditingController();
  final FocusNode dayCloseFN = FocusNode();

  void Function(String message, bool isError)? onMessage;

  AccountController({
    required this.createAccountUseCase,
    required this.getAccountsUseCase,
    required this.getAccountsPaginatedUseCase,
    required this.updateAccountUseCase,
    required this.deleteAccountUseCase,
    required this.incrementAccountValueUseCase,
    required this.paymentAccountUseCase,
  }) {
    load();
  }

  Future<void> load() async {
    state.value = state.value.copyWith(
      status: AccountStatus.loading,
      clearLastDocument: true,
    );

    // Load first page
    final (errorMessage, result) = await getAccountsPaginatedUseCase(
      paginationParams: PaginationParams.firstPage(pageSize: _pageSize),
    );

    if (errorMessage != null) {
      state.value = state.value.copyWith(
        status: AccountStatus.error,
        messageToUser: errorMessage.message,
      );
      onMessage?.call(errorMessage.message, true);
      return;
    }

    if (result.items.isEmpty) {
      state.value = const AccountState(
        status: AccountStatus.information,
        messageToUser: 'Nenhuma conta cadastrada',
      );
      return;
    }

    // Calculate sums using non-paginated query
    final (_, allAccounts) = await getAccountsUseCase(false);

    final moneySum =
        allAccounts?.where((a) => a.type == AccountType.money).fold<double>(0, (sum, a) => sum + a.balance) ?? 0.0;

    final cardSum =
        allAccounts?.where((a) => a.type == AccountType.card).fold<double>(0, (sum, a) => sum + a.value) ?? 0.0;

    final loanSum =
        allAccounts?.where((a) => a.type == AccountType.loan).fold<double>(0, (sum, a) => sum + a.value) ?? 0.0;

    final totalSum = moneySum - cardSum-loanSum;

    clearForm();

    state.value = AccountState(
      status: AccountStatus.success,
      accounts: result.items,
      moneySum: moneySum.toCurrency(),
      cardSum: cardSum.toCurrency(),
      loanSum: loanSum.toCurrency(),
      totalSum: totalSum.toCurrency(),
      hasMore: result.hasMore,
      lastDocument: result.lastDocument,
      isLoadingMore: false,
    );
  }

  Future<void> loadMore() async {
    if (!state.value.canLoadMore) return;
    if (state.value.lastDocument == null) return;

    state.value = state.value.copyWith(
      isLoadingMore: true,
      status: AccountStatus.loadingMore,
    );

    final (errorMessage, result) = await getAccountsPaginatedUseCase(
      paginationParams: PaginationParams.nextPage(
        lastDocument: state.value.lastDocument!,
        pageSize: _pageSize,
      ),
    );

    if (errorMessage != null) {
      state.value = state.value.copyWith(
        status: AccountStatus.success,
        isLoadingMore: false,
      );
      onMessage?.call(errorMessage.message, true);
      return;
    }

    final allAccounts = [...state.value.accounts, ...result.items];

    state.value = state.value.copyWith(
      status: AccountStatus.success,
      accounts: allAccounts,
      hasMore: result.hasMore,
      lastDocument: result.lastDocument,
      isLoadingMore: false,
    );
  }

  void clearForm() {
    _accountSelected = null;
    nameEC.clear();
    valueEC.clear();
    limitEC.clear();
    dayCloseEC.clear();
    selectedType = AccountType.money;
  }

  Future<void> submit() async {
    state.value = state.value.copyWith(status: AccountStatus.loading);

    final bool isEdit = _accountSelected != null;

    if (isEdit) {
      final account = _accountSelected!.copyWith(
        name: nameEC.text,
        value: valueEC.text.isEmpty ? 0 : double.parse(valueEC.text.toPointFormat()),
        type: selectedType,
        limit: limitEC.text.isEmpty ? 0 : double.parse(limitEC.text.toPointFormat()),
        dayClose: dayCloseEC.text.isEmpty ? 0 : int.tryParse(dayCloseEC.text) ?? 0,
      );
      final failure = await updateAccountUseCase(account);
      if (failure != null) {
        onMessage?.call(failure.message, true);
        return;
      }
    } else {
      final account = AccountEntity(
        name: nameEC.text,
        type: selectedType,
        value: valueEC.text.isEmpty ? 0 : double.parse(valueEC.text.toPointFormat()),
        limit: limitEC.text.isEmpty ? 0 : double.parse(limitEC.text.toPointFormat()),
        dayClose: dayCloseEC.text.isEmpty ? 0 : int.tryParse(dayCloseEC.text) ?? 0,
      );
      final failure = await createAccountUseCase(account);
      if (failure != null) {
        onMessage?.call(failure.message, true);
        return;
      }
    }

    await load();
    onMessage?.call(isEdit ? 'Conta atualizada com sucesso' : 'Conta criada com sucesso', false);
  }

  Future<void> deleteAccount(AccountEntity account) async {
    state.value = state.value.copyWith(status: AccountStatus.loading);

    final failure = await deleteAccountUseCase(account);

    if (failure != null) {
      state.value = state.value.copyWith(status: AccountStatus.success);
      onMessage?.call(failure.message, true);
      return;
    }

    await load();
    onMessage?.call('Conta excluída com sucesso', false);
  }

  void dispose() {
    state.dispose();
    nameEC.dispose();
    valueEC.dispose();
    limitEC.dispose();
    dayCloseEC.dispose();
  }
}
