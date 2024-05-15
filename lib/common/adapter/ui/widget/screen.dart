import 'package:flutter/material.dart';
import 'package:location_logger/common/adapter/ui/widget/exception_handler/exception_handler.dart';

class Screen extends StatelessWidget {
  final Widget child;
  final Text? title;

  const Screen({
    required this.child,
    this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final title = this.title;

    final body = SafeArea(child: child);
    final appBar = title == null ? null : AppBar(title: title);

    try {
      return Scaffold(appBar: appBar, body: body);
    } on Exception catch (exception) {
      return ExceptionHandler(
        exception: exception,
      );
    }
  }
}
