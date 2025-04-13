import 'package:hive/hive.dart';

part 'product.g.dart'; // Tạo file này bằng cách chạy build_runner

@HiveType(typeId: 0) // typeId duy nhất cho model Product
class Product {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final List<String> images;

  @HiveField(5)
  final List<String> variants;

  @HiveField(6)
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

  // Phương thức factory để chuyển từ JSON sang Product
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

  // Phương thức chuyển đổi thành Map để lưu vào Hive hoặc API
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'price': price,
      'images': images,
      'variants': variants,
      'rating': rating,
    };
  }
}
