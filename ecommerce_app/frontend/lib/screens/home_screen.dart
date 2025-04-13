import 'dart:async';
import 'package:ecommerce_app/screens/cart_screen.dart';
import 'package:ecommerce_app/services/api_service.dart';
import 'package:ecommerce_app/services/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/screens/product_details_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Map<String, dynamic>>>? _products;

  // Danh sách các danh mục sản phẩm
  final List<String> _categories = [
    "Sản phẩm giảm giá",
    "Sản phẩm mới",
    "Sản phẩm bán chạy",
    "Laptop",
    "Màn hình",
    "Ổ cứng",
    "Ram",
    "PC",
  ];

  @override
  void initState() {
    super.initState();
    _syncProducts();
  }

  // Đồng bộ dữ liệu từ API và lưu vào Hive
  Future<void> _syncProducts() async {
    setState(() {
      _products =
          ApiService.getProducts(); // Sử dụng ApiService để lấy dữ liệu sản phẩm
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 234, 150, 144),
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png', // Đường dẫn tới ảnh logo
              height: 60,
              width: 90,
            ),
            SizedBox(width: 20),
            // Thanh tìm kiếm ở giữa
            Expanded(
              child: Container(
                height: 40,
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
                      color: Color.fromARGB(255, 234, 150, 144),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color.fromARGB(255, 234, 150, 144),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
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
            return Center(child: Text('No products available'));
          }

          final products = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Banner khuyến mãi với kích thước linh hoạt
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/banner.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                // Hiển thị danh mục sản phẩm với cuộn ngang
                for (var category in _categories)
                  _buildCategorySection(category, products),
              ],
            ),
          );
        },
      ),
    );
  }

  // Hàm hiển thị phần danh mục sản phẩm cuộn ngang
  Widget _buildCategorySection(
    String category,
    List<Map<String, dynamic>> products,
  ) {
    List<Map<String, dynamic>> filteredProducts = [];

    if (category == "Sản phẩm giảm giá") {
      filteredProducts =
          products
              .where(
                (product) =>
                    product['discount'] != null && product['discount'] > 0,
              )
              .toList();
    } else if (category == "Sản phẩm mới") {
      filteredProducts =
          products.where((product) => product['status'] == "Mới").toList();
    } else if (category == "Laptop") {
      filteredProducts =
          products.where((product) => product['category'] == "Laptop").toList();
    } else if (category == "Sản phẩm bán chạy") {
      filteredProducts =
          products.where((product) => product['sold'] > 10).toList();
    } else if (category == "PC") {
      filteredProducts =
          products.where((product) => product['category'] == "PC").toList();
    } else {
      filteredProducts =
          products.where((product) {
            return product['categories'] != null &&
                product['categories'].contains(category);
          }).toList();
    }

    // Return the category section widget
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              category,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      String productId = product['_id'].toString();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  ProductDetailScreen(productId: productId),
                        ),
                      );
                    },
                    child: Container(
                      width: 230,
                      child: ProductCard(
                        name: product['name'],
                        imageUrl: product['images'][0],
                        oldPrice: product['oldprice'] ?? 0,
                        newPrice: product['newprice'] ?? 0,
                        discount: product['discount'].toString(),
                        stock: product['stock'] ?? 0,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final int oldPrice;
  final int newPrice;
  final String discount;
  final int stock;

  const ProductCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.oldPrice,
    required this.newPrice,
    required this.discount,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Image.network(
              imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          SizedBox(height: 20),
          if (int.tryParse(discount) != null && int.parse(discount) > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '${formatPrice(oldPrice)} VNĐ',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ),
          SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '${formatPrice(newPrice)} VNĐ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
          if (int.tryParse(discount) != null && int.parse(discount) > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '-$discount%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          if (stock > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Còn hàng",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          if (stock <= 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Hết hàng",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

String formatPrice(int price) {
  final NumberFormat format = NumberFormat('#,###', 'vi_VN');
  return format.format(price);
}
