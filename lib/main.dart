import 'package:flutter/material.dart';
import 'package:flutter_laravel/screens/landing_screen.dart';
import 'package:flutter_laravel/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:background_fetch/background_fetch.dart'; // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.notification.request(); // Request notification permissions

  runApp(
    ChangeNotifierProvider(
      create: (context) => Data(),
      child: MyApp(),
    ),
  );

  // Register the headless task for background fetch
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  // Configure and start background fetch
  await BackgroundFetch.configure(BackgroundFetchConfig(
    minimumFetchInterval: 1, // Fetch data every 15 minutes (adjust as needed)
    stopOnTerminate: false,
    enableHeadless: true,
  ), (String taskId) async {
    // Handle the background fetch event
    print("[BackgroundFetch] Event received: $taskId");
    // Fetch data and send notifications
    await fetchDataAndNotifyInBackground();
    BackgroundFetch.finish(taskId);
  });
}

void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.
    // You must stop what you're doing and immediately .finish(taskId)
    print("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  print("[BackgroundFetch] Headless event received: $taskId");
  // Perform any background tasks here
  // For example, fetch data and send notifications
  await fetchDataAndNotifyInBackground();
  BackgroundFetch.finish(taskId);
}

Future<void> fetchDataAndNotifyInBackground() async {
  final data = Data();
  await data.fetchDataAndNotifyInBackground();
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
