import 'package:flutter/material.dart';

class DateDisplay extends StatelessWidget {
  final DateTime date;

  const DateDisplay({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Text(
      "${date.year}-${date.month.toString().padLeft(2, "0")}-${date.day.toString().padLeft(2, "0")}",
    );
  }
}
