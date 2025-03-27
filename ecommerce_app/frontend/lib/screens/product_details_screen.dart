import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/screens/cart_screen.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Điều hướng tới màn hình giỏ hàng
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị hình ảnh sản phẩm
            Image.network(
              product.images.isNotEmpty
                  ? product.images[0]
                  : 'https://via.placeholder.com/150',
              height: 250,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            // Tên sản phẩm
            Text(
              product.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Giá sản phẩm
            Text(
              '\$${product.price}',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
            SizedBox(height: 10),
            // Mô tả sản phẩm
            Text(
              'Description: ${product.description}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            // Đánh giá sản phẩm
            Text('Rating: ${product.rating}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            // Thêm sản phẩm vào giỏ hàng
            ElevatedButton(
              onPressed: () {
                // Hàm để thêm sản phẩm vào giỏ hàng
                _addToCart(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm thêm sản phẩm vào giỏ hàng
  void _addToCart(BuildContext context) {
    // Thực hiện logic thêm vào giỏ hàng tại đây
    // Có thể sử dụng provider hoặc một state management khác để quản lý giỏ hàng
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} has been added to your cart!')),
    );
  }
}
