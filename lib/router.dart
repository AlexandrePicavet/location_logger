import 'package:go_router/go_router.dart';
import 'package:location_logger/features/location/adapter/ui/location_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const LocationPage(),
    )
  ],
);
