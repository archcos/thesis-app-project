import 'package:flutter/material.dart';
import 'package:flutter_laravel/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';
import 'screens/landing_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.notification.request();

  // Initialize work manager
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => Data(),
      child: MyApp(),
    ),
  );
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Run your background task logic here
    print("Background task executed!");

    // Fetch data and send notifications
    await fetchDataAndNotifyInBackground();

    return Future.value(true);
  });
}

Future<void> fetchDataAndNotifyInBackground() async {
  final data = Data();
  await data.startFetchingDataAndNotify();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Air Quality Monitoring System',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.green[600],
      ),
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
    );
  }
}