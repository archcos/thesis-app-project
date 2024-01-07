import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailsPage extends StatefulWidget {
  final List filteredData;

  const DetailsPage({required this.filteredData, Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late Future<List<Map<String, dynamic>>> pmData;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    pmData = fetchPMData(); // Fetch data when the widget is initialized
    super.initState();
  }

  Future<List<Map<String, dynamic>>> fetchPMData() async {
    try {
      String apiUrl = 'https://airqms-cdo.000webhostapp.com/getdata.php';
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final dynamic decodedJson = jsonDecode(response.body);

        if (decodedJson != null && decodedJson is List) {
          List<Map<String, dynamic>> data = decodedJson.cast<Map<String, dynamic>>();

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
        throw Exception('Failed to load PM data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch PM data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.history),
        title: Text("Full History"),
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.black,
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(
              child: Text('Daily Average'),
            ),
            Tab(
              child: Text('PM2.5'),
            ),
            Tab(
              child: Text('PM10'),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          // Daily Average tab
          FutureBuilder<List<Map<String, dynamic>>>(
            future: pmData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Map<String, dynamic>> data = snapshot.data!;
                List<Map<String, dynamic>> filteredData = data.where((item) =>
                    widget.filteredData.any((filteredItem) =>
                    item['location'] == filteredItem['location']
                    )
                ).toList();

                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                    ),
                    Center(
                      child: Text(
                        'Daily Average',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ),
                    // Show only 'PM2.5' and 'PM10' data in the first tab
                    for (var average in widget.filteredData)
                      if (average['pm25'] != null && average['pm10'] != null)
                        Card(
                          margin: EdgeInsets.all(10),
                          elevation: 5,
                          child: ListTile(
                            title: Text(
                              'Time: ${average['timestamp']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                Text('PM2.5: ${average['pm25']} µg/m³'),
                                SizedBox(height: 5),
                                Text('Remarks: ${average['pm25remarks']}'),
                                SizedBox(height: 5),
                                Text('PM10: ${average['pm10']} µg/m³'),
                                SizedBox(height: 5),
                                Text('Remarks: ${average['pm10remarks']}'),
                              ],
                            ),
                          ),
                        ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              // Display loading indicator while fetching data
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          // PM2.5 tab
          FutureBuilder<List<Map<String, dynamic>>>(
            future: pmData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Map<String, dynamic>> data = snapshot.data!;
                List<Map<String, dynamic>> filteredData = data.where((item) =>
                    widget.filteredData.any((filteredItem) =>
                    item['location'] == filteredItem['location']
                    )
                ).toList();

                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                    ),
                    Center(
                      child: Text(
                        'Particulate Matter (PM) 2.5:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ),
                    // Show only 'PM2.5' data in the second tab
                    for (var pm25Data in filteredData)
                      if (pm25Data['pm25'] != null)
                        Card(
                          margin: EdgeInsets.all(10),
                          elevation: 5,
                          child: ListTile(
                            title: Text(
                              'Data: ${pm25Data['pm25']} µg/m³',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Remarks: ${pm25Data['pm25remarks']}'),
                                SizedBox(height: 5),
                                Text('Time: ${pm25Data['timestamp']}'),
                              ],
                            ),
                          ),
                        ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              // Display loading indicator while fetching data
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          // PM10 tab
          FutureBuilder<List<Map<String, dynamic>>>(
            future: pmData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Map<String, dynamic>> data = snapshot.data!;
                List<Map<String, dynamic>> filteredData = data.where((item) =>
                    widget.filteredData.any((filteredItem) =>
                    item['location'] == filteredItem['location']
                    )
                ).toList();

                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                    ),
                    Center(
                      child: Text(
                        'Particulate Matter (PM) 10:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ),
                    // Show only 'PM10' data in the third tab
                    for (var pm10Data in filteredData)
                      if (pm10Data['pm10'] != null)
                        Card(
                          margin: EdgeInsets.all(10),
                          elevation: 5,
                          child: ListTile(
                            title: Text(
                              'Data: ${pm10Data['pm10']} µg/m³',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Remarks: ${pm10Data['pm10remarks']}'),
                                SizedBox(height: 5),
                                Text('Time: ${pm10Data['timestamp']}'),
                              ],
                            ),
                          ),
                        ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              // Display loading indicator while fetching data
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.keyboard_return_rounded,
            color: Colors.white),
        backgroundColor: Colors.red,
      ),
    );
  }
}
