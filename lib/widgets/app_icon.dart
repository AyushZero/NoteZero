import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'icon.png',
      width: 48,
      height: 48,
    );
  }
} 