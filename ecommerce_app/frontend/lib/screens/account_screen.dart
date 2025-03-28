import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        backgroundColor: Color.fromARGB(255, 210, 45, 34),
      ),
      body: Center(child: Text('Manage your account here!')),
    );
  }
}
