import 'package:ecommerce_app/screens/cart_screen.dart';
import 'package:ecommerce_app/screens/product_management.dart';
import 'package:ecommerce_app/screens/test_screen.dart';
import 'package:flutter/material.dart';

class CouponScreen extends StatelessWidget {
  const CouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 234, 150, 144),
        title: Row(
          children: [
            // Logo ở góc trái
            Image.asset(
              'assets/images/logo.png', // Đường dẫn tới ảnh logo
              height: 60, // Kích thước logo
              width: 90,
            ),
            SizedBox(width: 20), // Khoảng cách giữa logo và thanh tìm kiếm
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.red),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hiển thị thông tin mã giảm giá
            Text('Here are some coupons for you!'),

            // Nút chuyển hướng đến AddProductScreen
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Chuyển đến AddProductScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductListScreen()),
                );
              },
              child: Text('Go to Add Product Screen'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50), // Kích thước nút
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
