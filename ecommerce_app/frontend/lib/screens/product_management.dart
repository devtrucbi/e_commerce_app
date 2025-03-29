import 'package:ecommerce_app/screens/add_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/services/api_service.dart';
import 'package:intl/intl.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  _ProductManagementScreenState createState() =>
      _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  late Future<List<Map<String, dynamic>>> _products;

  @override
  void initState() {
    super.initState();
    _products = ApiService.getProducts(); // Gọi API để lấy danh sách sản phẩm
  }

  // Hàm để xoá sản phẩm
  Future<void> _deleteProduct(String productId) async {
    final result = await ApiService.deleteProduct(productId);
    if (result) {
      setState(() {
        _products = ApiService.getProducts(); // Cập nhật lại danh sách sản phẩm
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sản phẩm đã được xoá thành công!')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi xoá sản phẩm')));
    }
  }

  String formatPrice(int price) {
    final NumberFormat format = NumberFormat(
      '#,###',
      'vi_VN',
    ); // Định dạng theo kiểu Việt Nam
    return format.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 234, 150, 144),
        title: Text("Quản lý sản phẩm"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddProductScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có sản phẩm nào.'));
          }

          final products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: Image.network(
                    product['images'][0], // Lấy ảnh đầu tiên của sản phẩm
                    width: 50, // Kích thước ảnh
                    height: 50,
                    fit: BoxFit.cover, // Cắt ảnh theo tỷ lệ
                  ),
                  title: Text(product['name']),
                  subtitle: Text(
                    'Loại: ${product['category']}\nGiá: ${formatPrice(product['oldprice'])} VNĐ\n Số lượng: ${product['stock']}',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteProduct(product['_id']); // Xoá sản phẩm
                    },
                  ),
                  onTap: () {
                    // Điều hướng đến màn hình cập nhật sản phẩm
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
