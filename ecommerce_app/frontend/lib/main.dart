import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Import màn hình chính của bạn
import 'screens/add_product_screen.dart'; // Nếu bạn có thêm sản phẩm

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce App',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Màu chủ đạo của ứng dụng
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(), // Màn hình chính khi khởi động
      routes: {
        '/home': (context) => HomeScreen(), // Định nghĩa route cho HomeScreen
        '/add_product':
            (context) => AddProductScreen(), // Route cho màn hình thêm sản phẩm
      },
    );
  }
}
