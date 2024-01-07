import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../services/auth.dart';
import '../details.dart';
import 'package:intl/intl.dart';

class LocationCard extends StatelessWidget {
  final String location;
  final List<Map<String, dynamic>> locationData;
  final Map<String, String> remarkImages = {
    'Good': 'assets/colors/green.png',
    'Fair': 'assets/colors/yellow.png',
    'Unhealthy': 'assets/colors/red.png',
    'Very Unhealthy': 'assets/colors/orange.png',
    'Acutely Unhealthy': 'assets/colors/purple.png',
    'Emergency': 'assets/colors/maroon.png',
  };

  LocationCard({required this.location, required this.locationData});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> latestData = locationData.isNotEmpty ? locationData.first : {};
    String pm25Remark = latestData['pm25remarks'] ?? 'N/A';
    String backgroundImagePath = remarkImages.containsKey(pm25Remark)
        ? remarkImages[pm25Remark]!
        : 'assets/colors/default.png';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          image: DecorationImage(
            image: AssetImage(backgroundImagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsPage(filteredData: locationData),
              ),
            );
          },
          child: Container(
            height: 210,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.transparent,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 8),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            locationData.isNotEmpty
                                ? (locationData.first['location'] as String).split(' ')[0]
                                : '',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'DATE: ${latestData['timestamp'] != null ? DateFormat('yyyy-MM-dd').format(DateTime.parse(latestData['timestamp'])) : 'N/A'}',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'PM2.5: ${latestData['pm25']  ?? 'N/A '} µg/m³ -${latestData['pm25remarks'] ?? 'N/A'}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'PM10: ${latestData['pm10'] ?? 'N/A'} - µg/m³ ${latestData['pm10remarks'] ?? 'N/A'}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'See More',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
    );
  }
}

class LocationTab extends StatefulWidget {
  @override
  _LocationTabState createState() => _LocationTabState();
}

class _LocationTabState extends State<LocationTab> {
  final storage = FlutterSecureStorage();
  late bool isLoading = true;

  late List<Map<String, dynamic>> averageData = [];
  late Data auth = Data();
  late Map<String, List<Map<String, dynamic>>> locationGroupedData = {};

  @override
  void initState() {
    super.initState();
    _fetchAverage();
  }

  void _fetchAverage() async {
    try {
      final data = await auth.fetchAverage();
      setState(() {
        averageData = List<Map<String, dynamic>>.from(data);
        isLoading = false;

        averageData.sort((a, b) {
          final timestampA = DateTime.parse(a['timestamp']);
          final timestampB = DateTime.parse(b['timestamp']);
          return timestampB.compareTo(timestampA);
        });

        locationGroupedData = groupDataByLocation(averageData);
      });
    } catch (e) {
      print('Error fetching Average data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Map<String, List<Map<String, dynamic>>> groupDataByLocation(List<Map<String, dynamic>> data) {
    Map<String, List<Map<String, dynamic>>> groupedData = {};

    for (var item in data) {
      String location = item['location'] as String;

      if (!groupedData.containsKey(location)) {
        groupedData[location] = [];
      }

      groupedData[location]!.add(item);
    }

    return groupedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset(
            'assets/bg.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            color: Colors.transparent,
            child: Center(
              child: isLoading
                  ? CircularProgressIndicator()
                  : Center(
                child: ListView.builder(
                  itemCount: locationGroupedData.length,
                  itemBuilder: (BuildContext context, int index) {
                    String location = locationGroupedData.keys.elementAt(index);
                    List<Map<String, dynamic>> locationData = locationGroupedData[location]!;

                    return LocationCard(
                        location: location,
                        locationData: locationData,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
