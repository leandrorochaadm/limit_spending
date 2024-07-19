extension StringExtention on String {
  // Método para susbstituir virgula por ponto
  String toPointFormat() => trim().replaceAll(',', '.');
}
