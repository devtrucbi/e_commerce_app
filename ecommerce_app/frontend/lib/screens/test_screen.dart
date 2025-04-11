import 'package:flutter/material.dart';
import 'package:ecommerce_app/services/database_helper.dart';

class ProductListScreen extends StatelessWidget {
  Future<List<Map<String, dynamic>>> _loadProductsFromSQLite() async {
    return await DatabaseHelper.instance.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sản phẩm từ SQLite')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadProductsFromSQLite(),
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

          // Lấy danh sách sản phẩm
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
