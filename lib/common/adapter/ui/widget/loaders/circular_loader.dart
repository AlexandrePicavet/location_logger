import 'package:flutter/material.dart';

class CircularLoader extends StatelessWidget {
  final Widget? annotation;

  const CircularLoader({super.key, this.annotation});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Colors.indigo,
            strokeWidth: 3,
          ),
          annotation ?? const SizedBox.shrink()
        ],
      ),
    );
  }
}
