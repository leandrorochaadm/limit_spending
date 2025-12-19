import 'package:equatable/equatable.dart';
import '../../category/domain/entities/category_entity.dart';
import '../../payment_method/domain/entities/payment_method_entity.dart';

enum QuickExpenseStatus { initial, loading, success, error, saved }

class QuickExpenseState extends Equatable {
  final QuickExpenseStatus status;
  final List<CategoryEntity> categories;
  final List<PaymentMethodEntity> paymentMethods;
  final CategoryEntity? selectedCategory;
  final PaymentMethodEntity? selectedPaymentMethod;
  final String? errorMessage;

  const QuickExpenseState({
    required this.status,
    this.categories = const [],
    this.paymentMethods = const [],
    this.selectedCategory,
    this.selectedPaymentMethod,
    this.errorMessage,
  });

  QuickExpenseState copyWith({
    QuickExpenseStatus? status,
    List<CategoryEntity>? categories,
    List<PaymentMethodEntity>? paymentMethods,
    CategoryEntity? selectedCategory,
    PaymentMethodEntity? selectedPaymentMethod,
    String? errorMessage,
  }) {
    return QuickExpenseState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        categories,
        paymentMethods,
        selectedCategory,
        selectedPaymentMethod,
        errorMessage,
      ];
}
