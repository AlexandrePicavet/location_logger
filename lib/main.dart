import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location_logger/register_features.dart';
import 'package:location_logger/location_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  FlutterError.onError = (error) {
    FlutterError.presentError(error);
    if (kReleaseMode) {
      exit(1);
    }
  };

  await RegisterFeatures()().run();

  runApp(const LocationLogger());
}
