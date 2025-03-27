class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final List<String> variants;
  final double rating;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.variants,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      images: List<String>.from(json['images']),
      variants: List<String>.from(json['variants']),
      rating: json['rating'].toDouble(),
    );
  }
}
