class ProductModel {
  final int id;
  final String name;
  final double price;
  final String description;
  final String? createdAt;
  final String? updatedAt;

  ProductModel(
    {
      required this.id,
      required this.name,
      required this.price,
      required this.description,
      this.createdAt,
      this.updatedAt
    }
  );
}