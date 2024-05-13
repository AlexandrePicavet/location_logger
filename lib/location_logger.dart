import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location_logger/router.dart';

class LocationLogger extends StatelessWidget {
  const LocationLogger({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    return MaterialApp.router(
      title: 'Location Logger',
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      routerConfig: router,
    );
  }
}
