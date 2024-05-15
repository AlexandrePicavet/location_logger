import 'package:flutter/material.dart';

class BadRouteArgumentsException {
  final Type expectedType;
  final String? route;
  final Object? arguments;

  BadRouteArgumentsException({
    required this.expectedType,
    required BuildContext context,
  })  : route = ModalRoute.of(context)?.settings.name,
        arguments = ModalRoute.of(context)?.settings.arguments;
}
