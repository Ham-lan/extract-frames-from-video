import 'package:flutter/material.dart';

class ThirdScreen extends StatelessWidget {
  const ThirdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Third Screen'),
      ),
      body: const Center(
        child: Text(
          'Fake',
          style: TextStyle(color: Color(0xFF235594), fontSize: 20.0),
        ),
      ),
    );
  }
}
