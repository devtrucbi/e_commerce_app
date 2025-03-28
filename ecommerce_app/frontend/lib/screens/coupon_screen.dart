import 'package:flutter/material.dart';

class CouponScreen extends StatelessWidget {
  const CouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coupons'),
        backgroundColor: Color.fromARGB(255, 210, 45, 34),
      ),
      body: Center(child: Text('Here are some coupons for you!')),
    );
  }
}
