import 'package:flutter/material.dart';

class Ghost2 extends StatelessWidget {
  const Ghost2({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Image.asset('assets/images/ghost2.png')
    );
  }
}