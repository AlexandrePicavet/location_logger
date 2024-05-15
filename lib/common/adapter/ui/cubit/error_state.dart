import 'package:location_logger/common/adapter/ui/cubit/cubit_state.dart';
import 'package:location_logger/common/model/exception/location_logger_exception.dart';

abstract class CubitErrorState extends CubitState {
  LocationLoggerException get error;
}
