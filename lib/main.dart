import 'package:flutter/material.dart';
import 'package:flutter_laravel/services/auth.dart';
import 'package:provider/provider.dart';

import 'screens/landing_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Data(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Air Quality Detection System',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.green[600], // Use the green[600] color here
      ),
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
    );
  }
}

