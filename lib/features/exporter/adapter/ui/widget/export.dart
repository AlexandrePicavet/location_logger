import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_logger/common/adapter/ui/widget/location_date_range_picker.dart';
import 'package:location_logger/features/exporter/adapter/ui/cubit/export_cubit.dart';
import 'package:location_logger/features/exporter/domain/export_target.dart';
import 'package:location_logger/features/location/domain/location_date_time_interval.dart';

class Export extends StatelessWidget {
  const Export({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExportCubit, ExportState>(
      builder: (context, state) => Column(
        children: [
          state.isExportTargetSelectable
              ? DropdownMenu(
                  dropdownMenuEntries: ExportTarget.values
                      .map(
                        (target) => DropdownMenuEntry(
                          value: target,
                          label: target.toString(),
                        ),
                      )
                      .toList(),
                  onSelected: (target) => _onExportTargetSelect(
                    context.read<ExportCubit>(),
                    target,
                  ),
                )
              : const SizedBox.shrink(),
          state.isExportIntervalSelectable
              ? LocationDateRangePicker(
                  onSelect: (range) => _onExportIntervalSelect(
                    context.read<ExportCubit>(),
                    range,
                  ),
                )
              : const SizedBox.shrink(),
          state.isExportable
              ? ElevatedButton(
                  onPressed: context.read<ExportCubit>().export,
                  child: const Text("Export"),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  void _onExportTargetSelect(ExportCubit cubit, ExportTarget? exportTarget) {
    if (exportTarget == null) {
      return;
    }

    cubit.setExportTarget(exportTarget);
  }

  void _onExportIntervalSelect(
    ExportCubit cubit,
    Option<DateTimeRange> optionalRange,
  ) {
    optionalRange
        .map(
          (range) => LocationDateTimeInterval.between(
            start: range.start,
            end: range.end,
          ),
        )
        .fold(
          () => {},
          cubit.selectExportInterval,
        );
  }
}
