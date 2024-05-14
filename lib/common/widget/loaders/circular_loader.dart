import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CircularLoader extends StatelessWidget {
  const CircularLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.indigo,
        strokeWidth: 3,
      ),
    );
  }
}
