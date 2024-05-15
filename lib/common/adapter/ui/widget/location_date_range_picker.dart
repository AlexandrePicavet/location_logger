import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:location_logger/common/adapter/ui/widget/date_display.dart';

class LocationDateRangePicker extends StatelessWidget {
  final DateTime start;
  final DateTime end;
  final void Function(Option<DateTimeRange>) onSelect;

  LocationDateRangePicker({
    super.key,
    DateTime? start,
    DateTime? end,
    required this.onSelect,
  })  : start = start != null
            ? DateUtils.dateOnly(start)
            : DateTime.now().subtract(const Duration(days: 1)),
        end = end != null ? DateUtils.dateOnly(end) : DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _dateRangeSelected(context),
      child: Flex(
        direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DateDisplay(date: start),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("=>"),
          ),
          DateDisplay(date: end),
        ],
      ),
    );
  }

  Future<void> _dateRangeSelected(BuildContext context) async {
    return onSelect(
        Option.fromNullable(
          await showDateRangePicker(
            context: context,
            initialDateRange: DateTimeRange(start: start, end: end),
            firstDate: DateTime.fromMillisecondsSinceEpoch(0),
            lastDate: end,
          ),
        ).map(
          (range) => DateTimeRange(
            start: range.start,
            end: end.add(
              const Duration(hours: 23, minutes: 59, seconds: 59),
            ),
        ),
      ),
    );
  }
}
