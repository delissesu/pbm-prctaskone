class ProductModel {
  final int id;
  final String name;
  final double price;
  final String description;
  final String? createdAt;
  final String? updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      description: json['description'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class ProductRequestModel {
  final String name;
  final int price;
  final String description;

  ProductRequestModel({
    required this.name,
    required this.price,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'price': price, 'description': description};
  }
}

class SubmitTugasModel {
  final String name;
  final int price;
  final String description;
  final String githubUrl;

  SubmitTugasModel({
    required this.name,
    required this.price,
    required this.description,
    required this.githubUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'github_url': githubUrl,
    };
  }
}
