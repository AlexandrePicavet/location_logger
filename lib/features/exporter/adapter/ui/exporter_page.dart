import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_logger/common/adapter/ui/widget/screen.dart';
import 'package:location_logger/features/exporter/adapter/ui/cubit/export_cubit.dart';
import 'package:location_logger/features/exporter/adapter/ui/widget/export.dart';

class ExporterPage extends StatelessWidget {
  const ExporterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExportCubit(),
      child: const Screen(child: Export()),
    );
  }
}
