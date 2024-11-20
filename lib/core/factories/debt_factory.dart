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

AddDebtValueUseCase makeAddDebtValueUseCase() {
  DebtRepository debtRepository = makeDebtRepository();
  AddDebtValueUseCase addDebtValueUseCase = AddDebtValueUseCase(debtRepository);
  return addDebtValueUseCase;
}

DeleteDebtUseCase deleteDebtUseCaseFactory() {
  DebtRepository debtRepository = makeDebtRepository();
  DeleteDebtUseCase deleteDebtUseCase = DeleteDebtUseCase(debtRepository);
  return deleteDebtUseCase;
}

UpdateDebitUseCase makeUpdateDebitUseCase() {
  DebtRepository debtRepository = makeDebtRepository();
  UpdateDebitUseCase updateDebitUseCase = UpdateDebitUseCase(debtRepository);
  return updateDebitUseCase;
}

DebtPage makeDebtPage() {
  DebtRepository debtRepository = makeDebtRepository();

  CreateDebtUseCase createDebtUseCase = CreateDebtUseCase(debtRepository);
  AddDebtValueUseCase addDebtValueUseCase = makeAddDebtValueUseCase();
  GetDebtsUseCase getDebtsUseCase = makeGetDebtsUseCase();
  DeleteDebtUseCase deleteDebtUseCase = deleteDebtUseCaseFactory();
  UpdateDebitUseCase updateDebitUseCase = makeUpdateDebitUseCase();

  DebtController debtController = DebtController(
    addDebtValueUseCase: addDebtValueUseCase,
    getDebtsUseCase: getDebtsUseCase,
    createDebtUseCase: createDebtUseCase,
    deleteDebtUseCase: deleteDebtUseCase,
    updateDebitUseCase: updateDebitUseCase,
  );
  return DebtPage(debtController);
}
