import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Import màn hình chính của bạn
import 'screens/coupon_screen.dart'; // Import màn hình Coupon
import 'screens/order_screen.dart'; // Import màn hình Order
import 'screens/account_screen.dart'; // Import màn hình Account

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(), // Màn hình chính khi khởi động
      routes: {
        '/home': (context) => HomeScreen(), // Định nghĩa route cho HomeScreen
        '/coupon': (context) => CouponScreen(), // Route cho CouponScreen
        '/order': (context) => OrderScreen(), // Route cho OrderScreen
        '/account': (context) => AccountScreen(), // Route cho AccountScreen
      },
    );
  }
}

// MainScreen với BottomNavigationBar
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Index của tab được chọn
  int _selectedIndex = 0;

  // Danh sách các màn hình ứng với từng tab
  final List<Widget> _screens = [
    HomeScreen(), // Màn hình Home
    CouponScreen(), // Màn hình Coupon
    OrderScreen(), // Màn hình Order
    AccountScreen(), // Màn hình Account
  ];

  // Hàm gọi khi chọn tab mới
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Hiển thị màn hình tương ứng
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Hiển thị tab đang chọn
        onTap: _onItemTapped, // Xử lý khi nhấn vào tab
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _selectedIndex == 0 ? Colors.red : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.home,
                color: _selectedIndex == 0 ? Colors.red : Colors.black,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _selectedIndex == 1 ? Colors.red : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.local_offer,
                color: _selectedIndex == 1 ? Colors.red : Colors.black,
              ),
            ),
            label: 'Coupon',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _selectedIndex == 2 ? Colors.red : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.list,
                color: _selectedIndex == 2 ? Colors.red : Colors.black,
              ),
            ),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _selectedIndex == 3 ? Colors.red : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.account_circle,
                color: _selectedIndex == 3 ? Colors.red : Colors.black,
              ),
            ),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
