import 'package:ecommerce_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> _products;

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
    _products = ApiService.getProducts(); // Gọi API để lấy danh sách sản phẩm
  }

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner khuyến mãi
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/banner.png',
                    ), // Hình ảnh banner
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            // Hiển thị danh mục sản phẩm với cuộn ngang
            for (var category in _categories) _buildCategorySection(category),
          ],
        ),
      ),
    );
  }

  // Hàm hiển thị phần danh mục sản phẩm cuộn ngang
  Widget _buildCategorySection(String category) {
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
            child: FutureBuilder<List<Map<String, dynamic>>>(
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

                // Lọc sản phẩm theo category
                List<Map<String, dynamic>> filteredProducts = [];
                if (category == "Sản phẩm giảm giá") {
                  filteredProducts =
                      products
                          .where(
                            (product) =>
                                product['discount'] != null &&
                                product['discount'] > 0,
                          )
                          .toList();
                } else if (category == "Sản phẩm mới") {
                  filteredProducts =
                      products
                          .where((product) => product['status'] == "Mới")
                          .toList();
                } else if (category == "Laptop") {
                  filteredProducts =
                      products
                          .where((product) => product['category'] == "Laptop")
                          .toList();
                } else if (category == "Sản phẩm bán chạy") {
                  filteredProducts =
                      products
                          .where((product) => product['sold'] > 10)
                          .toList();
                } else {
                  filteredProducts =
                      products.where((product) {
                        return product['categories'] != null &&
                            product['categories'].contains(category);
                      }).toList();
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    // print(product['oldPrice']); // Để kiểm tra giá trị oldPrice
                    // print(product['newPrice']); // Để kiểm tra giá trị newPrice
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        width: 230,
                        child: ProductCard(
                          name: product['name'],
                          imageUrl: product['images'][0],
                          oldPrice: product['oldprice'] ?? 0,
                          newPrice: product['newprice'] ?? 0,
                          discount: product['discount'].toString(),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

String formatPrice(int price) {
  final NumberFormat format = NumberFormat(
    '#,###',
    'vi_VN',
  ); // Định dạng theo kiểu Việt Nam
  return format.format(price);
}

class ProductCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final int oldPrice;
  final int newPrice;
  final String discount;

  const ProductCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.oldPrice,
    required this.newPrice,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh sản phẩm
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

          // Tên sản phẩm (hiển thị 2 dòng, nếu dài hơn sẽ có dấu ba chấm)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis, // Thêm dấu ba chấm khi tên dài
              maxLines: 2, // Giới hạn tối đa 2 dòng
            ),
          ),
          SizedBox(height: 20),

          // Hiển thị giá cũ với dấu gạch ngang chỉ khi có discount
          if (int.tryParse(discount) != null && int.parse(discount) > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '${formatPrice(oldPrice)} VNĐ',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough, // Gạch ngang
                ),
              ),
            ),
          SizedBox(height: 2),

          // Hiển thị giá mới
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

          // Hiển thị phần trăm giảm giá chỉ khi có discount
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
        ],
      ),
    );
  }
}
