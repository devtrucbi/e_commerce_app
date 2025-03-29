import 'package:ecommerce_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Map<String, dynamic>> _product;

  @override
  void initState() {
    super.initState();
    // print("Fetching details for productId: ${widget.productId}");
    _product = ApiService.getProductDetail(widget.productId);
    // _product
    //     .then((data) {
    //       print("Product Data: $data");
    //     })
    //     .catchError((e) {
    //       print("Error: $e");
    //     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 234, 150, 144),
        title: Text("Chi tiết sản phẩm"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _product,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('Không có sản phẩm nào.'));
          }

          final product = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hình ảnh sản phẩm
                  Image.network(
                    product['images'][0],
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 16),

                  // Tên sản phẩm
                  Text(
                    product['name'],
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),

                  // Đánh giá sản phẩm
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow),
                      Text(
                        '${product['rating'] ?? 0} đánh giá ',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Giá sản phẩm
                  Text(
                    'Giá: ${formatPrice(product['newprice'] ?? 0)} VNĐ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  if (product['oldprice'] != product['newprice'])
                    Text(
                      'Giá cũ: ${formatPrice(product['oldprice'] ?? 0)} VNĐ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  SizedBox(height: 16),

                  // Nút Mua ngay và Thêm vào giỏ hàng
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Logic mua ngay
                        },
                        child: Text('Mua ngay'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(horizontal: 50),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Logic thêm vào giỏ hàng
                        },
                        child: Text('Thêm vào giỏ hàng'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(horizontal: 50),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Mô tả sản phẩm
                  Text(
                    'Mô tả sản phẩm:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(product['description'], style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Hàm định dạng giá
  String formatPrice(int price) {
    final NumberFormat format = NumberFormat('#,###', 'vi_VN');
    return format.format(price);
  }
}
