import 'package:flutter/material.dart';
import 'package:location_logger/common/adapter/ui/cubit/error_state.dart';

class ErrorStateVisualizer extends StatelessWidget {
  final CubitErrorState state;
  final void Function()? retry;

  const ErrorStateVisualizer({super.key, required this.state, this.retry});

  @override
  Widget build(BuildContext context) {
    final causes = state.error.getCauses();

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: causes.length,
            itemBuilder: (context, index) {
              final cause = causes[index];
              return ListTile(
                key: Key(cause.toString()),
                title: Text(cause.runtimeType.toString()),
                subtitle: Text(cause.toString()),
                tileColor: Colors.red[300],
              );
            },
          ),
        ),
        retry != null
            ? TextButton(onPressed: retry, child: const Text("Retry"))
            : const SizedBox.shrink(),
      ],
    );
  }
}
