import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Đây là nơi bạn có thể hiển thị các sản phẩm trong giỏ hàng
    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: Center(child: Text('No products in cart yet.')),
    );
  }
}
