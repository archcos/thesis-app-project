import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:timer_builder/timer_builder.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Data with ChangeNotifier {
  Timer? _timer;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Data() {
    // Initialize local notifications
    _initializeLocalNotifications();

    // Start the periodic timer when the class is created
    _startTimer();
  }

  // Method to fetch data and notify listeners
  Future<void> _fetchDataAndNotify() async {
    try {
      // Fetch your data here
      List<Map<String, dynamic>> data = await fetchPMData();

      // Fetch average data
      List<Map<String, dynamic>> average = await fetchAverage();

      // Notify listeners with the fetched data
      notifyListeners();

      // Check criteria for sending notifications
      _checkNotificationCriteria(data, average);
    } catch (e) {
      // Handle errors appropriately
      print('Error fetching data: $e');
    }
  }

  // Check criteria for sending notifications
  void _checkNotificationCriteria(
      List<Map<String, dynamic>> data, List<Map<String, dynamic>> average) {
    // Implement your notification criteria here
    // For example, compare pm25 and pm10 values with thresholds

    // For demonstration purposes, let's assume a threshold of 50 for both pm25 and pm10
    double pm25Threshold = 35.1;
    double pm10Threshold = 154.1;

    bool sendNotification = false;

    // Check if any data point exceeds the threshold
    if (data.any((item) => item['pm25'] > pm25Threshold || item['pm10'] > pm10Threshold)) {
      sendNotification = true;
    }

    // Check average values
    if (!sendNotification) {
      if (average.any((item) => item['pm25_average'] > pm25Threshold || item['pm10_average'] > pm10Threshold)) {
        sendNotification = true;
      }
    }

    // Send notification if criteria are met
    if (sendNotification) {
      _sendNotification();
    }
  }

  // Send local notification
  Future<void> _sendNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'air_quality_channel', // Use a unique identifier for your channel
      'Air Quality Alerts', // Display name for your channel
      importance: Importance.max,
      priority: Priority.high,
      playSound: true, // You can customize notification options here
      styleInformation: DefaultStyleInformation(true, true),
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Air Quality Alert',
      'Air quality is not within the healthy range!\n'
          'Please Wear A Mask or Avoid Going Outside\n'
          'Check The App to See AQI Level',
      platformChannelSpecifics,
    );
  }

  // Method to start the periodic timer
  void _startTimer() {
    // Fetch data immediately when the class is created
    _fetchDataAndNotify();

    // Set up a periodic timer to fetch data every 1 minute
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      _fetchDataAndNotify();
    });
  }

  // Cancel the timer when the Data class is disposed
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Initialize local notifications
// Initialize local notifications
// Initialize local notifications for Android
  void _initializeLocalNotifications() {
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }


  Future<List<Map<String, dynamic>>> fetchPMData() async {
    try {
      String apiUrl = 'https://airqms-cdo.000webhostapp.com/getdata.php';
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final dynamic decodedJson = jsonDecode(response.body);

        if (decodedJson != null && decodedJson is List) {
          List<Map<String, dynamic>> data =
          decodedJson.cast<Map<String, dynamic>>();

          // Convert relevant string values to double
          data.forEach((item) {
            item['pm25'] = double.tryParse(item['pm25']?.toString() ?? '0.0') ?? 0.0;
            item['pm10'] = double.tryParse(item['pm10']?.toString() ?? '0.0') ?? 0.0;
          });

          print(data);

          return data;
        } else {
          throw Exception('Invalid JSON format or null response');
        }
      } else {
        throw Exception(
            'Failed to load PM data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch PM data: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAverage() async {
    try {
      String apiUrl = 'https://airqms-cdo.000webhostapp.com/getaverage.php';
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final dynamic decodedJson = jsonDecode(response.body);

        if (decodedJson != null && decodedJson is List) {
          List<Map<String, dynamic>> average =
          decodedJson.cast<Map<String, dynamic>>();

          // Convert relevant string values to double
          average.forEach((item) {
            item['pm25_average'] =
                double.tryParse(item['pm25_average']?.toString() ?? '0.0') ??
                    0.0;
            item['pm10_average'] =
                double.tryParse(item['pm10_average']?.toString() ?? '0.0') ??
                    0.0;
          });

          print(average);

          return average;
        } else {
          throw Exception('Invalid JSON format or null response');
        }
      } else {
        throw Exception(
            'Failed to load PM data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch PM data: $e');
    }
  }
}
