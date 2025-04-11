import 'package:ecommerce_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Map<String, dynamic>> _product;
  late Future<List<Map<String, dynamic>>> _reviews; // Reviews data
  int _quantity = 1; // Quantity selected by user
  TextEditingController _commentController = TextEditingController();
  int _rating = 0; // Rating selected by user
  bool _isLoggedIn = false; // Track if user is logged in
  String _userName = 'Anonymous'; // Default to anonymous if not logged in

  @override
  void initState() {
    super.initState();
    _product = ApiService.getProductDetail(
      widget.productId,
    ); // Fetch product details
    _reviews = ApiService.getProductReviews(
      productId: widget.productId,
    ); // Pass productId
    _checkUserLoginStatus(); // Check if the user is logged in when the screen loads
  }

  // Check if the user is logged in
  Future<void> _checkUserLoginStatus() async {
    _isLoggedIn = await _isUserLoggedIn(); // Get login status
    if (_isLoggedIn) {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _userName = prefs.getString('userName') ?? 'Anonymous';
      });
    }
    setState(() {}); // Trigger a rebuild to update the UI
  }

  // Check if user is logged in (using SharedPreferences)
  Future<bool> _isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');
    return token != null && token.isNotEmpty; // Return true if token exists
  }

  // Show dialog to add product to cart
  void _showAddToCartDialog(
    BuildContext context,
    Map<String, dynamic> product,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thêm sản phẩm vào giỏ hàng'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Product image
              Image.network(
                product['images'][0],
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 8),
              // Product name
              Text(
                product['name'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              // Product price
              Text(
                'Giá: ${formatPrice(product['newprice'] ?? 0)} VNĐ',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
              SizedBox(height: 8),
              // Stock information
              Text(
                'Tồn kho: ${product['stock'] ?? 0}',
                style: TextStyle(fontSize: 14, color: Colors.green),
              ),
              SizedBox(height: 8),
              // Quantity selector
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Số lượng', style: TextStyle(color: Colors.black)),
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      if (_quantity > 1) {
                        setState(() {
                          _quantity--;
                        });
                      }
                    },
                  ),
                  Text('$_quantity', style: TextStyle(fontSize: 16)),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      if (_quantity < product['stock']) {
                        setState(() {
                          _quantity++;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            // Add to cart button
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton(
                onPressed: () {
                  _addToCart(product);
                  Navigator.pop(context); // Close dialog after adding to cart
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFFFC663D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  'Thêm vào Giỏ hàng',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Add product to cart
  void _addToCart(Map<String, dynamic> product) {
    print('Product added to cart: ${product['name']} with quantity $_quantity');
  }

  // Add review and comment
  Future<void> _addReview() async {
    String comment = _commentController.text;
    try {
      await ApiService.submitReview(
        productId: widget.productId,
        rating: _rating,
        comment: comment,
        userName: _userName, // Use the logged in user's name or anonymous
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đánh giá đã được gửi thành công')),
      );
      _commentController.clear(); // Clear comment after submission
      setState(() {
        _reviews = ApiService.getProductReviews(
          productId: widget.productId,
        ); // Reload reviews
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi gửi đánh giá')));
    }
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
                  // Product image
                  Image.network(
                    product['images'][0],
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 16),

                  // Product name
                  Text(
                    product['name'],
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),

                  // Product rating
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow),
                      Text(
                        '${product['rating'] ?? 0} đánh giá',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Product price
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

                  // Buy now and Add to cart buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Logic to buy the product now
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text('Mua ngay', style: TextStyle(fontSize: 16)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _showAddToCartDialog(context, product);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Thêm vào giỏ hàng',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Product description
                  Text(
                    'Mô tả sản phẩm:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    product['description'] ?? 'Chưa có mô tả',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),

                  // Review section
                  Text(
                    'Đánh giá & Bình luận:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  // Display reviews
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _reviews,
                    builder: (context, reviewSnapshot) {
                      if (reviewSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (reviewSnapshot.hasError) {
                        return Center(
                          child: Text('Error: ${reviewSnapshot.error}'),
                        );
                      }
                      if (!reviewSnapshot.hasData ||
                          reviewSnapshot.data!.isEmpty) {
                        return Center(child: Text('Chưa có đánh giá nào.'));
                      }

                      final reviews = reviewSnapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          final review = reviews[index];
                          return ListTile(
                            title: Text(review['userName']),
                            subtitle: Text(review['comment']),
                            trailing: Icon(Icons.star, color: Colors.yellow),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 8),
                  // TextField and button for review
                  TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Viết bình luận...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _addReview,
                    child: Text('Gửi đánh giá'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Format the price
  String formatPrice(int price) {
    final NumberFormat format = NumberFormat('#,###', 'vi_VN');
    return format.format(price);
  }
}
