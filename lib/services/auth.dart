import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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

  Future<void> fetchDataAndNotifyInBackground() async {
    try {
      // Fetch your data here
      List<Map<String, dynamic>> data = await fetchPMData();

      // Notify listeners with the fetched data
      notifyListeners();

      // Check criteria for sending notifications
      checkNotificationCriteria(data);
    } catch (e) {
      // Handle errors appropriately
      print('Error fetching data: $e');
    }
  }

  void checkNotificationCriteria(List<Map<String, dynamic>> data) {
    // Implement your notification criteria here
    // For example, compare the latest pm25 and pm10 values with thresholds

    // For demonstration purposes, let's assume a threshold of 50 for both pm25 and pm10
    double pm25Threshold = 35.1;
    double pm10Threshold = 154.1;

    bool sendNotification = false;

    // Check if the latest data point exceeds the threshold
    if (data.isNotEmpty) {
      Map<String, dynamic> latestData = data.last; // Assuming the latest data is the last item in the list
      if (latestData['pm25'] > pm25Threshold || latestData['pm10'] > pm10Threshold) {
        sendNotification = true;
      }
    }

    // Send notification if criteria are met
    if (sendNotification) {
      sendNotifications();
    }
  }

  Future<void> sendNotifications() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'air_quality_channel', // Use a unique identifier for your channel
      'Air Quality Alerts', // Display name for your channel
      importance: Importance.max,
      priority: Priority.high,
      playSound: true, // You can customize notification options here
      sound: RawResourceAndroidNotificationSound('notif'),
      styleInformation: DefaultStyleInformation(true, true),
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Air Quality Alert',
      'Air Quality is not Healthy! Check AQI Level',
      platformChannelSpecifics,
    );
  }

  void _startTimer() {
    // Fetch data immediately when the class is created
    fetchDataAndNotifyInBackground();

    // Set up a periodic timer to fetch data every 1 minute
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      fetchDataAndNotifyInBackground();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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
