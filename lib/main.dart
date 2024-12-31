import 'package:flutter/material.dart';
import 'app/routes.dart';

void main() {
  runApp(CisumApp());
}

class CisumApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cisum5',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}