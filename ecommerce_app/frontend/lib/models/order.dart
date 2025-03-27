class Order {
  final String id;
  final String userId;
  final List<String> products;
  final double totalAmount;
  final String status;

  Order({
    required this.id,
    required this.userId,
    required this.products,
    required this.totalAmount,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      userId: json['userId'],
      products: List<String>.from(json['products']),
      totalAmount: json['totalAmount'].toDouble(),
      status: json['status'],
    );
  }
}
