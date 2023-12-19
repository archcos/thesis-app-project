import 'package:flutter/material.dart';
import 'package:flutter_laravel/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/landing_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.notification.request(); // Request notification permissions

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
      title: 'Air Quality Monitoring System',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.green[600], // Use the green[600] color here
      ),
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
    );
  }
}
