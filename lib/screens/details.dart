import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  final List filteredData;

  const DetailsPage({required this.filteredData, Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.timer),
        title: Text("Full History"),
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.black,
        bottom: TabBar(
          controller: tabController,
          tabs: const [
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
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
              ),
              Center(
                child: Text(
                  'Particulate Matter (PM) 2.5 :',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ),
              // Show only 'PM2.5' data in the first tab
              for (var data in widget.filteredData)
                if (data['pm25'] != null)
                  Card(
                    margin: EdgeInsets.all(10),
                    elevation: 5,
                    child: ListTile(
                      title: Text(
                        'PM2.5: ${data['pm25']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Time: ${data['timestamp']}'),
                          SizedBox(height: 5),
                          Text('Location: ${data['location']}'),
                          SizedBox(height: 5),
                          Text('Remarks: ${data['pm25remarks']}'),
                        ],
                      ),
                    ),
                  ),
            ],
          ),
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
              ),
              Center(
                child: Text(
                  'Particulate Matter (PM) 2.5 :',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ),
              // Show only 'PM10' data in the second tab
              for (var data in widget.filteredData)
                if (data['pm10'] != null)
                  Card(
                    margin: EdgeInsets.all(10),
                    elevation: 5,
                    child: ListTile(
                      title: Text(
                        'PM10: ${data['pm10']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Time: ${data['timestamp']}'),
                          SizedBox(height: 5),
                          Text('Location: ${data['location']}'),
                          SizedBox(height: 5),
                          Text('Remarks: ${data['pm25remarks']}'),
                        ],
                      ),
                    ),
                  ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.keyboard_return_rounded,
        color: Colors.redAccent),
        backgroundColor: Colors.white,
      ),
    );
  }
}
