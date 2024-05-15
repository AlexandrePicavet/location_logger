import 'package:flutter/material.dart';
import 'package:location_logger/common/model/exception/BadRouteArgumentsException.dart';
import 'package:location_logger/common/adapter/ui/widget/exception_handler/bad_route_arguments_handler.dart';

class ExceptionHandler extends StatelessWidget {
  final Exception exception;

  const ExceptionHandler({required this.exception, super.key});

  @override
  Widget build(BuildContext context) {
    return exception is BadRouteArgumentsException
        ? BadRouteArgumentsHandler(
            exception: exception as BadRouteArgumentsException,
          )
        : Column(
            children: [
              const Text('Unhandled exception thrown'),
              Text(exception.toString())
            ],
          );
  }
}
