import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../services/auth.dart';
import '../circular.dart';
import '../details.dart';
import 'dashboard.dart';
import 'pm10tab.dart';

class LocationCard extends StatelessWidget {
  final String location;
  final List<Map<String, dynamic>> locationData;

  LocationCard({required this.location, required this.locationData});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> latestData = locationData.first;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        color: Colors.green[600],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
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
            width: double.infinity,
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 8),
                Text(
                  '$location',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
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

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(),
          ),
        );
        break;
      case 1:
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PM10Tab(),
          ),
        );
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAverage();
  }

  void _fetchAverage() async {
    try {
      final data = await auth.fetchPMData();
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
      appBar: AppBar(
        title: Text(
          'AQMS',
          style: TextStyle(
            fontFamily: 'Bulleto Killa',
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Center(
            child: CircularProgressWithDuration(duration: Duration(seconds: 5)),
          ),
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

                    return LocationCard(location: location, locationData: locationData);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.air),
            label: 'PM2.5',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on, color: Colors.white),
            label: 'Location',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'PM10',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[900],
        onTap: _onItemTapped,
        backgroundColor: Colors.green[600],
      ),
    );
  }
}
