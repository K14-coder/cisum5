import 'package:flutter/material.dart';
import 'package:cisum5/app/routes.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cisum5 Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.play);
          },
          child: Text('Go to Play Screen'),
        ),
      ),
    );
  }
}