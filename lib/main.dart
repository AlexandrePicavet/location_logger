import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location_logger/register_features.dart';
import 'package:location_logger/location_logger.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  await WakelockPlus.toggle(enable: kDebugMode);

  FlutterError.onError = (error) {
    FlutterError.presentError(error);
    if (kReleaseMode) {
      exit(1);
    }
  };

  await RegisterFeatures()().run();

  runApp(const LocationLogger());
}
