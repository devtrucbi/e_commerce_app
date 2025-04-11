import 'package:ecommerce_app/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/screens/home_screen.dart';
import 'package:ecommerce_app/screens/login_screen.dart';
import 'package:ecommerce_app/screens/coupon_screen.dart';
import 'package:ecommerce_app/screens/order_screen.dart';
import 'package:ecommerce_app/screens/account_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => const MainScreen(),
        '/coupon': (context) => const CouponScreen(),
        '/order': (context) => const OrderScreen(),
        '/account': (context) => const AccountScreen(),
        '/cart': (context) => const CartScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void _onTap(int index) {
    if (_selectedIndex == index) {
      // Điều hướng lại trang đầu tiên của tab đó nếu đã ở trong tab
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          switch (index) {
            case 0:
              return MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              );
            case 1:
              return MaterialPageRoute(
                builder: (context) => const CouponScreen(),
              );
            case 2:
              return MaterialPageRoute(
                builder: (context) => const OrderScreen(),
              );
            case 3:
              return MaterialPageRoute(
                builder: (context) => const AccountScreen(),
              );
            default:
              return MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Kiểm tra xem có phải trang Login hoặc Register hay không
    final isLoginOrRegisterPage =
        ModalRoute.of(context)?.settings.name == '/login' ||
        ModalRoute.of(context)?.settings.name == '/register';

    return Scaffold(
      body: Stack(
        children: List.generate(
          4,
          _buildOffstageNavigator,
        ), // Hiển thị các navigator con
      ),
      bottomNavigationBar:
          isLoginOrRegisterPage
              ? null // Nếu đang ở trang Login/ Register thì không hiển thị BottomNavigationBar
              : BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: _onTap,
                selectedItemColor: Colors.red, // Màu khi chọn tab
                unselectedItemColor: Colors.grey, // Màu khi không chọn tab
                showUnselectedLabels: false, // Ẩn nhãn không được chọn
                backgroundColor: Colors.white, // Màu nền của bottom navigation
                type:
                    BottomNavigationBarType
                        .fixed, // Cho phép giữ lại tất cả các mục trong thanh điều hướng
                elevation: 10, // Hiệu ứng đổ bóng cho thanh navigation
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                    tooltip: 'Trang chủ',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.local_offer),
                    label: 'Coupon',
                    tooltip: 'Mã giảm giá',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.assignment_outlined),
                    label: 'Order',
                    tooltip: 'Đơn hàng',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle),
                    label: 'Account',
                    tooltip: 'Tài khoản',
                  ),
                ],
              ),
    );
  }
}
