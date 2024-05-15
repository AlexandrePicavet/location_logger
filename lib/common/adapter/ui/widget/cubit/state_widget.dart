import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:location_logger/common/adapter/ui/cubit/cubit_state.dart';

abstract class StateWidget<C extends Cubit, S extends CubitState>
    extends StatelessWidget {
  final C cubit;
  final S state;

  const StateWidget({super.key, required this.cubit, required this.state});
}
