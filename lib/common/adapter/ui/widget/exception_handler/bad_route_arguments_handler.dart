import 'package:flutter/material.dart';
import 'package:location_logger/common/model/exception/bad_route_arguments_exception.dart';
import 'package:location_logger/common/adapter/ui/widget/screen.dart';

class BadRouteArgumentsHandler extends StatelessWidget {
  final BadRouteArgumentsException exception;

  const BadRouteArgumentsHandler({required this.exception, super.key});

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: const Text('Bad Route Arguments'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Route: ${exception.route ?? 'Unknown'}'),
          Text('Expected arguments type: ${exception.expectedType.toString()}'),
          Text(
            'Given arguments type: '
            '${exception.arguments.runtimeType.toString()}',
          )
        ],
      ),
    );
  }
}
