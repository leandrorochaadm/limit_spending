enum UnitOfMeasure {
  grams('gramas', 'g'),
  milliliters('mililitros', 'ml');

  final String name;
  final String symbol;

  const UnitOfMeasure(this.name, this.symbol);
}
