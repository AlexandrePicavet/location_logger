import 'package:go_router/go_router.dart';
import 'package:location_logger/features/exporter/adapter/ui/exporter_page.dart';
import 'package:location_logger/features/location/adapter/ui/location_page.dart';

enum Routes {
  home,
  export;

  @override
  String toString() => name;
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: Routes.home.toString(),
      builder: (context, state) => const LocationPage(),
    ),
    GoRoute(
      path: '/${Routes.export}',
      name: Routes.export.toString(),
      builder: (context, state) => const ExporterPage(),
    )
  ],
);
