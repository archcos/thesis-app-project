import 'package:flutter/material.dart';

class HistoryContainer extends StatelessWidget {
  final List<Map<String, dynamic>> pmData;

  HistoryContainer({required this.pmData});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 280, // Adjust the maxHeight as needed
        maxWidth: 300, // Adjust the maxWidth as needed
      ),
      decoration: BoxDecoration(
        color: Colors.green[700],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 8),
          Text(
            'History',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),
          for (var pmEntry in pmData)
            Container(
              margin: EdgeInsets.symmetric(vertical: 5), // Add spacing between boxes
              padding: EdgeInsets.all(10), // Add padding to the box content
              decoration: BoxDecoration(
                color: Colors.green[700], // Background color of the box
                borderRadius: BorderRadius.circular(2), // Adjust the border radius as needed
              ),
              child: ListTile(
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${pmEntry['timestamp']}',
                      style: TextStyle(
                        color: Colors.white, // Text color
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 40, // Adjust the width as needed
                      height: 40, // Adjust the height as needed
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white, // Background color of the circle
                      ),
                      child: Center(
                        child: Text(
                          '${pmEntry['pm25']}',
                          style: TextStyle(
                            color: Colors.black, // Text color
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '${pmEntry['pm25remarks']}\t\t\t\t\t\t\t\t\t\t\t',
                      style: TextStyle(
                        color: Colors.white, // Text color
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            ),
        ],
      ),
    );
  }
}
