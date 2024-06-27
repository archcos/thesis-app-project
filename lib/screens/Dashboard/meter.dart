import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class RadialGaugeWidget extends StatefulWidget {
  final double pmValue;
  final String pmRemarks;

  const RadialGaugeWidget({Key? key, required this.pmValue, required this.pmRemarks})
      : super(key: key);

  @override
  _RadialGaugeWidgetState createState() => _RadialGaugeWidgetState();
}

class _RadialGaugeWidgetState extends State<RadialGaugeWidget> {
  late double _pmValue;
  late String _pmRemarks;

  Color _getColorForRemarks(String remarks) {
    switch (remarks) {
      case 'Good':
        return Colors.green;
      case 'Fair':
        return Colors.yellow;
      case 'Unhealthy':
        return Colors.orange;
      case 'Very Unhealthy':
        return Colors.red;
      case 'Severely Unhealthy':
        return Colors.purple;
      case 'Emergency':
        return Color(0xFF800000);
      default:
        return Colors.white;
    }
  }

  @override
  void initState() {
    super.initState();
    _pmValue = widget.pmValue;
    _pmRemarks = widget.pmRemarks;
  }

  @override
  void didUpdateWidget(covariant RadialGaugeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pmValue != _pmValue || widget.pmRemarks != _pmRemarks) {
      setState(() {
        _pmValue = widget.pmValue;
        _pmRemarks = widget.pmRemarks;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage('assets/cardbg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: 0,
                  maximum: 100,
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
                      value: _pmValue,
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
                      endValue: 25,
                      color: Colors.green,
                    ),
                    GaugeRange(
                      startValue: 25.1,
                      endValue: 35,
                      color: Colors.yellow,
                    ),
                    GaugeRange(
                      startValue: 35.1,
                      endValue: 45,
                      color: Colors.orange,
                    ),
                    GaugeRange(
                      startValue: 45.1,
                      endValue: 55,
                      color: Colors.red,
                    ),
                    GaugeRange(
                      startValue: 55.1,
                      endValue: 90,
                      color: Colors.purple,
                    ),
                    GaugeRange(
                      startValue: 91,
                      endValue: 100,
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
                    color: _getColorForRemarks(_pmRemarks),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 5),
                      Text(
                        _pmValue.toString(),
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
                  _pmRemarks,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
