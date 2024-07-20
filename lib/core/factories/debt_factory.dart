import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/debt/debit.dart';
import 'firestore_factory.dart';

DebtRepository makeDebtRepository() {
  FirebaseFirestore firestore = makeFirestoreFactory();
  DebtRepository debtRepository = FirebaseDebtRepository(firestore);
  return debtRepository;
}

GetDebtsUseCase makeGetDebtsUseCase() {
  DebtRepository debtRepository = makeDebtRepository();
  GetDebtsUseCase getDebtsUseCase = GetDebtsUseCase(debtRepository);
  return getDebtsUseCase;
}

GetSumDebtsUseCase makeGetSumDebtsUseCase() {
  DebtRepository debtRepository = makeDebtRepository();
  GetSumDebtsUseCase getSumDebtsUseCase = GetSumDebtsUseCase(debtRepository);
  return getSumDebtsUseCase;
}

AddDebtValueUseCase makeAddDebtValueUseCase() {
  DebtRepository debtRepository = makeDebtRepository();
  AddDebtValueUseCase addDebtValueUseCase = AddDebtValueUseCase(debtRepository);
  return addDebtValueUseCase;
}

DebtPage makeDebtPage() {
  DebtRepository debtRepository = makeDebtRepository();

  CreateDebtUseCase createDebtUseCase = CreateDebtUseCase(debtRepository);
  AddDebtValueUseCase addDebtValueUseCase = makeAddDebtValueUseCase();
  GetSumDebtsUseCase getSumDebtsUseCase = makeGetSumDebtsUseCase();
  GetDebtsUseCase getDebtsUseCase = makeGetDebtsUseCase();

  DebtController debtController = DebtController(
    addDebtValueUseCase: addDebtValueUseCase,
    getSumDebtsUseCase: getSumDebtsUseCase,
    getDebtsUseCase: getDebtsUseCase,
    createDebtUseCase: createDebtUseCase,
  );
  return DebtPage(debtController);
}
