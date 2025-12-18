import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/debt/debit.dart';
import 'firestore_factory.dart';
import 'payment_method_factory.dart';

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

GetDebtsPaginatedUseCase makeGetDebtsPaginatedUseCase() {
  DebtRepository debtRepository = makeDebtRepository();
  GetDebtsPaginatedUseCase getDebtsPaginatedUseCase =
      GetDebtsPaginatedUseCase(debtRepository);
  return getDebtsPaginatedUseCase;
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

CreateDebtUseCase makeCreateDebtUseCase() =>
    CreateDebtUseCase(makeDebtRepository());

DebtPage makeDebtPage() {
  CreateDebtUseCase createDebtUseCase = CreateDebtUseCase(makeDebtRepository());
  AddDebtValueUseCase addDebtValueUseCase = makeAddDebtValueUseCase();
  GetDebtsUseCase getDebtsUseCase = makeGetDebtsUseCase();
  GetDebtsPaginatedUseCase getDebtsPaginatedUseCase =
      makeGetDebtsPaginatedUseCase();
  DeleteDebtUseCase deleteDebtUseCase = deleteDebtUseCaseFactory();
  UpdateDebitUseCase updateDebitUseCase = makeUpdateDebitUseCase();

  DebtController debtController = DebtController(
    addDebtValueUseCase: addDebtValueUseCase,
    getDebtsUseCase: getDebtsUseCase,
    getDebtsPaginatedUseCase: getDebtsPaginatedUseCase,
    createDebtUseCase: createDebtUseCase,
    deleteDebtUseCase: deleteDebtUseCase,
    updateDebitUseCase: updateDebitUseCase,
    getCardPaymentMethodsUseCase: makeGetCardPaymentMethodsUseCase(),
  );
  return DebtPage(debtController);
}

PaymentDebitUseCase makePaymentDebitUseCase() {
  final paymentDebtUseCase = PaymentDebitUseCase(
    addDebtValueUseCase: makeAddDebtValueUseCase(),
    incrementValuePaymentMethodUseCase:
        makeIncrementValuePaymentMethodUseCase(),
  );
  return paymentDebtUseCase;
}
