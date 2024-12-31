import 'package:flutter/material.dart';
import 'package:cisum4/features/play/play_screen.dart';

class AppRoutes {
  static const String play = '/play';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case play:
        return MaterialPageRoute(builder: (_) => PlayScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}