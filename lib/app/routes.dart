import 'package:flutter/material.dart';
import 'package:cisum5/features/home/home_screen.dart';
import 'package:cisum5/features/play/play_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String play = '/play';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
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