import 'package:ecommerce_app/screens/cart_screen.dart';
import 'package:ecommerce_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Future<Map<String, dynamic>>? _userInfo; // Fetch user info from API
  bool _isLoggedIn = false; // Track login status

  @override
  void initState() {
    super.initState();
    _loadUserInfo(); // Load user info when the screen initializes
  }

  // Load user information
  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    if (token != null && token.isNotEmpty) {
      setState(() {
        _isLoggedIn = true;
        _userInfo = ApiService.getUserInfo(token); // Fetch user info from API
      });
    } else {
      setState(() {
        _isLoggedIn = false;
        _userInfo = Future.value({}); // Set to an empty map if not logged in
      });
    }
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
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.red),
            onPressed: () async {
              // Kiểm tra xem người dùng đã đăng nhập chưa, nếu có thì chuyển hướng đến giỏ hàng
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Info Section (will show login message if not logged in)
            _isLoggedIn
                ? FutureBuilder<Map<String, dynamic>>(
                  future: _userInfo,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text('Thông tin người dùng không có.'),
                      );
                    }

                    final user = snapshot.data!;

                    return Container(
                      padding: EdgeInsets.all(16),
                      color: Color.fromARGB(255, 234, 150, 144),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Profile picture
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: const Color.fromARGB(
                              255,
                              234,
                              150,
                              144,
                            ),
                            child: Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: 16),
                          // User info
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    user['fullName'], // User's name from API
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    Icons.edit,
                                    size: 16,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                              Text(
                                user['email'], // Display email or other fields
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                )
                : Padding(padding: const EdgeInsets.symmetric(vertical: 20.0)),

            // Fixed sections: Always visible
            SizedBox(height: 16),

            // Settings & Log out options
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 234, 150, 144),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildMenuItem(Icons.settings, 'Cài đặt', () {
                    // Navigate to account detail screen
                  }),
                  Divider(color: Colors.black),
                  _buildMenuItem(
                    Icons.logout,
                    _isLoggedIn ? 'Đăng xuất' : 'Đăng nhập',
                    _isLoggedIn ? _signOut : _login,
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Company information
            _buildSectionTitle('Địa chỉ cửa hàng'),
            _buildInfoRow(
              Icons.location_on,
              '78-80-82 Hoàng Hoa Thám, Phường 12, Quận Tân Bình',
            ),
            _buildInfoRow(
              Icons.location_on,
              '905 Kha Vạn Cân, Phường Linh Tây, TP. Thủ Đức',
            ),
            _buildInfoRow(
              Icons.location_on,
              '1081 - 1083 Trần Hưng Đạo, Phường 5, Quận 5',
            ),

            SizedBox(height: 10),

            // Contact information
            _buildSectionTitle('Thông tin liên hệ'),
            _buildInfoRow(Icons.phone, 'Tổng đài: 1900 5301'),
            _buildInfoRow(Icons.email, 'Email: cskh@gearvn.com'),
            _buildInfoRow(Icons.public, 'Website: https://gearvn.com/'),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Menu item widget
  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(title, style: TextStyle(color: Colors.black, fontSize: 16)),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.black12, size: 16),
      onTap: onTap,
    );
  }

  // Section title widget
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Information row widget
  Widget _buildInfoRow(IconData icon, String info) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.red, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              info,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // Sign-out logic
  void _signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken'); // Remove token from shared preferences
    setState(() {
      _isLoggedIn = false;
    });
  }

  // Login logic
  void _login() {
    Navigator.pushReplacementNamed(context, '/login');
  }
}
