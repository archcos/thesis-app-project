import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {

  final List filteredData;
  const DetailsPage({
    required this.filteredData,
    Key? key}) : super(key: key);

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
        leading: Icon(Icons.details_rounded),
        title: Text("Information"),
          bottom: TabBar(
              controller: tabController,
              tabs: const [
                Tab(
                  child: Text('PM2.5'),
                ),
                Tab(
                  child: Text('PM10'),
                )
              ]
          )
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          ListView(
            children: [
              Text('${widget.filteredData}')
            ],
          ),
          ListView(
            children: [
              Text('${widget.filteredData}')
            ],
          )
        ],
      ),
    );
  }
}
