import 'package:flutter/material.dart';
import 'package:deep_fake_detection/second_screen.dart';

import 'component/button.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Screen'),
      ),
      body: Center(
        child: CircleButton(
          text: 'Detect',
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SecondScreen(),
                ));
          },
        ),
      ),
    );
  }
}
