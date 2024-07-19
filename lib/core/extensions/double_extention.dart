import 'package:intl/intl.dart';

extension DoubleExtensions on double {
  // Método para formatar o número como moeda brasileira
  String toCurrency() => NumberFormat.simpleCurrency(
        decimalDigits: 2,
        locale: 'pt_BR',
      ).format(this);
}
