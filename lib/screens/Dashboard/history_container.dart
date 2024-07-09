import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../colors.dart';

class HistoryContainer extends StatelessWidget {
  final List<Map<String, dynamic>> pmData;

  HistoryContainer({required this.pmData});

  @override
  Widget build(BuildContext context) {
    // Reverse the list to start from the most recent data
    List<Map<String, dynamic>> reversedData = List.from(pmData.reversed);
    List<Map<String, dynamic>> latest24Records = reversedData.length >= 24
        ? reversedData.sublist(0, 24)
        : reversedData;

    var test = latest24Records.isNotEmpty ? latest24Records[0] : {};

    return Container(
      constraints: BoxConstraints(
        maxWidth: 300,
        maxHeight: 600,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/historybg.jpg'), // Replace with your actual image path
          fit: BoxFit.cover, // Adjust how the image is fitted within the box
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white, // Specify the color of the border
          width: 2.0,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 8),
          Text(
            'Recorded Data',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: getColorForRemarks(test['pm25remarks']), // Outer container transparent to show inner container
              borderRadius: BorderRadius.circular(2.0), // Outer border radius slightly larger
              border: Border.all(
                color: Colors.white, // Outer border color
                width: 2.0, // Outer border width
              ),
            ),
            child: ListTile(
              title: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'DATE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  VerticalDivider(
                    color: Colors.white, // Adjust color as needed
                    thickness: 2,
                    width: 1,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'PARTICULATE\nMATTER',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  VerticalDivider(
                    color: Colors.white, // Adjust color as needed
                    thickness: 1,
                    width: 1,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'LOCATION',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: latest24Records.length,
              itemBuilder: (BuildContext context, int index) {
                var pmEntry = latest24Records[index];
                String remarks = pmEntry['pm25remarks'] ?? '';
                Color color = getColorForRemarks(remarks);

                // Format the timestamp
                final DateFormat formatter = DateFormat("MM-dd-yyyy \nhh:mm a");
                String formattedTimestamp = formatter.format(DateTime.parse(pmEntry['timestamp']));

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: getColorForRemarks(remarks),
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                      color: Colors.white, // Specify the color of the border
                      width: 1.0,
                    ),
                  ),
                  child: ListTile(
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              formattedTimestamp,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        VerticalDivider(
                          color: Colors.white, // Adjust color as needed
                          thickness: 1,
                          width: 1,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color,
                              ),
                              child: Center(
                                child: Text(
                                  '${pmEntry['pm25']}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        VerticalDivider(
                          color: Colors.white, // Adjust color as needed
                          thickness: 1,
                          width: 1,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${pmEntry['location']}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
