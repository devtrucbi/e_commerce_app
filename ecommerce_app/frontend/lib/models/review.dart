import 'package:hive/hive.dart';

part 'review.g.dart'; // Đảm bảo sử dụng build_runner để tạo file review.g.dart

@HiveType(typeId: 1)
class Review {
  @HiveField(0)
  final String productId;

  @HiveField(1)
  final int rating;

  @HiveField(2)
  final String comment;

  @HiveField(3)
  final String userName;

  @HiveField(4)
  final String createdAt;

  Review({
    required this.productId,
    required this.rating,
    required this.comment,
    required this.userName,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      productId: json['productId'],
      rating: json['rating'],
      comment: json['comment'],
      userName: json['userName'],
      createdAt: json['createdAt'],
    );
  }
}
