import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class RadialGaugeWidget1 extends StatelessWidget {
  final double pmValue;
  final String pmRemarks;


  RadialGaugeWidget1({required this.pmValue, required this.pmRemarks});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green[700],
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: 0,
                  maximum: 504,
                  startAngle: 173,
                  endAngle: 8,
                  showLabels: false,
                  showTicks: false,
                  axisLineStyle: AxisLineStyle(
                    thickness: 10,
                    color: Colors.white,
                    thicknessUnit: GaugeSizeUnit.logicalPixel,
                  ),
                  pointers: <GaugePointer>[
                    NeedlePointer(
                      value: pmValue,
                      needleLength: 0.8,
                      lengthUnit: GaugeSizeUnit.factor,
                      needleColor: Colors.black,
                      needleStartWidth: 1,
                      needleEndWidth: 10,
                      tailStyle: TailStyle(
                        width: 1,
                        length: 0,
                      ),
                    ),
                  ],
                  ranges: <GaugeRange>[
                    GaugeRange(
                      startValue: 0,
                      endValue: 54,
                      color: Colors.green,
                    ),
                    GaugeRange(
                      startValue: 54.1,
                      endValue: 154,
                      color: Colors.yellow,
                    ),
                    GaugeRange(
                      startValue: 154.1,
                      endValue: 254,
                      color: Colors.orange,
                    ),
                    GaugeRange(
                      startValue: 254.1,
                      endValue: 354,
                      color: Colors.red,
                    ),
                    GaugeRange(
                      startValue: 354.1,
                      endValue: 424,
                      color: Colors.purple,
                    ),
                    GaugeRange(
                      startValue: 424.1,
                      endValue: 504,
                      color: Color(0xFF934B50),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 163,
              right: 108,
              child: Container(
                width: 140,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Positioned(
              top: 48,
              child: Center(
                child: Container(
                  width: 120,
                  height: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100),
                      topRight: Radius.circular(100),
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 5),
                      Text(
                        pmValue.toString(),
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "AQI",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 130,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  pmRemarks,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
