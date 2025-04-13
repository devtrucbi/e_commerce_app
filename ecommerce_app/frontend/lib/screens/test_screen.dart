import 'package:flutter/material.dart';
import 'package:ecommerce_app/services/hive_service.dart'; // Import HiveService

class ProductListScreen extends StatelessWidget {
  // Load products from Hive
  Future<List<Map<String, dynamic>>> _loadProductsFromHive() async {
    return await HiveService.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sản phẩm từ Hive')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadProductsFromHive(), // Call to load data from Hive
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có sản phẩm'));
          }

          // Get the product list from Hive
          final products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product['name'] ?? 'Không có tên sản phẩm'),
                subtitle: Text(product['category'] ?? 'Không có danh mục'),
              );
            },
          );
        },
      ),
    );
  }
}
