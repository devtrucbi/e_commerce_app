import 'package:ecommerce_app/services/api_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> _products;

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

            // Danh mục sản phẩm cuộn ngang
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Cuộn ngang
                child: Row(
                  children: [
                    CategoryCard(
                      imageUrl:
                          'https://static.vecteezy.com/system/resources/previews/026/153/161/non_2x/laptop-icon-for-graphic-and-web-design-device-icon-vector.jpg',
                      label: 'Laptop',
                    ),
                    CategoryCard(
                      imageUrl:
                          'https://static.vecteezy.com/system/resources/previews/019/549/367/non_2x/desktop-pc-icon-line-isolated-on-white-background-black-flat-thin-icon-on-modern-outline-style-linear-symbol-and-editable-stroke-simple-and-pixel-perfect-stroke-illustration-vector.jpg',
                      label: 'PC',
                    ),
                    CategoryCard(
                      imageUrl:
                          'https://static.vecteezy.com/system/resources/previews/006/507/888/non_2x/monitor-icon-screen-icon-black-and-white-monitor-icon-monitor-isolated-on-white-background-free-vector.jpg',
                      label: 'Màn hình',
                    ),
                    CategoryCard(
                      imageUrl:
                          'https://static.vecteezy.com/system/resources/previews/000/357/784/non_2x/ram-vector-icon.jpg',
                      label: 'Linh kiện',
                    ),
                    CategoryCard(
                      imageUrl:
                          'https://static.vecteezy.com/system/resources/previews/000/357/784/non_2x/ram-vector-icon.jpg',
                      label: 'Linh kiện',
                    ),
                    CategoryCard(
                      imageUrl:
                          'https://static.vecteezy.com/system/resources/previews/000/357/784/non_2x/ram-vector-icon.jpg',
                      label: 'Linh kiện',
                    ),
                  ],
                ),
              ),
            ),

            // Hiển thị sản phẩm (scroll dọc)
            Padding(
              padding: const EdgeInsets.all(15.0),
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
                  return GridView.builder(
                    shrinkWrap: true, // Điều chỉnh lại GridView
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductCard(
                        name: product['name'],
                        imageUrl:
                            product['images'][0], // Chọn hình ảnh đầu tiên
                        price: product['price'],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String imageUrl;
  final String label;

  const CategoryCard({super.key, required this.imageUrl, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          CircleAvatar(radius: 40, backgroundImage: NetworkImage(imageUrl)),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final int price;

  const ProductCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(name, style: TextStyle(fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${price.toString()} VNĐ',
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
