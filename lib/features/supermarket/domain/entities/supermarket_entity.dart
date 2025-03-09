class SupermarketEntity {
  final String id;
  final String name;

  SupermarketEntity({
    String? id,
    required this.name,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();
}
