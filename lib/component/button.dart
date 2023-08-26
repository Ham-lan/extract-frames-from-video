import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CircleButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1, color: const Color(0xFF235594))),
        child: Center(
            child: Text(
          text,
          style: const TextStyle(color: Color(0xFF235594), fontSize: 18),
        )),
      ),
    );
  }
}
