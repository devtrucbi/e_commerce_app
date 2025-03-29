import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

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
            // Thanh tìm kiếm ở giữa
            Container(
              width: 240, // Chiều rộng của thanh tìm kiếm
              height: 40, // Chiều cao của thanh tìm kiếm
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Search products...',
                  hintStyle: TextStyle(
                    fontSize: 14,
                  ), // Giảm kích thước chữ trong thanh tìm kiếm
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.red),
            onPressed: () {
              // Mở màn hình giỏ hàng
            },
          ),
        ],
      ),
      body: Center(child: Text('Here are your orders!')),
    );
  }
}
