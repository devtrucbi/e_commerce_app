import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        backgroundColor: Color.fromARGB(255, 210, 45, 34),
      ),
      body: Center(child: Text('Here are your orders!')),
    );
  }
}
