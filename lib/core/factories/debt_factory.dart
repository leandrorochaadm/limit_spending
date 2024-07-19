import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/debt/debit.dart';
import 'firestore_factory.dart';

DebtPage makeDebtPage() {
  FirebaseFirestore firestore = makeFirestoreFactory();
  DebtRepository debtRepository = FirebaseDebtRepository(firestore);

  CreateDebtUseCase createDebtUseCase = CreateDebtUseCase(debtRepository);
  AddDebtValueUseCase addDebtValueUseCase = AddDebtValueUseCase(debtRepository);
  GetSumDebtsUseCase getSumDebtsUseCase = GetSumDebtsUseCase(debtRepository);
  GetDebtsUseCase getDebtsUseCase = GetDebtsUseCase(debtRepository);

  DebtController debtController = DebtController(
    addDebtValueUseCase: addDebtValueUseCase,
    getSumDebtsUseCase: getSumDebtsUseCase,
    getDebtsUseCase: getDebtsUseCase,
    createDebtUseCase: createDebtUseCase,
  );
  return DebtPage(debtController);
}
