import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class DataChart extends StatelessWidget {
  final List<DataPoint> dataPoints;
  final String title;
  final String xAxisLabel;
  final String yAxisLabel;
  final String yAxisUnit; // Set the unit of the y-axis for the tooltip
  late TooltipBehavior _tooltipBehavior;

  DataChart({
    Key? key,
    required this.dataPoints,
    required this.title,
    required this.xAxisLabel,
    required this.yAxisLabel,
    required this.yAxisUnit,
  }) : super(key: key) {
    _tooltipBehavior = TooltipBehavior(
      duration: 5000,
      enable: true,
      builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
          int seriesIndex) {
        final DateTime time = point.x;
        final String formattedTime = DateFormat('HH:mm:ss').format(time);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Time: $formattedTime\nValue: ${point.y}$yAxisUnit',
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return /*SfCartesianChart(
      title: ChartTitle(
          text: title,
          textStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      primaryXAxis: DateTimeAxis(),
      tooltipBehavior: _tooltipBehavior,
      series: <ChartSeries>[
        ScatterSeries<DataPoint, DateTime>(
          color: Colors.red[600],
          dataSource: dataPoints,
          xValueMapper: (DataPoint data, _) => data.timestamp,
          yValueMapper: (DataPoint data, _) => data.value,
        ),
      ],
    );
    */

        SfCartesianChart(
      title: ChartTitle(
          text: title,
          textStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      primaryXAxis: DateTimeAxis(
        title: AxisTitle(
          text: xAxisLabel,
        ),
        dateFormat: DateFormat.Hm(),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(
          text: yAxisLabel,
        ),
      ),
      tooltipBehavior: _tooltipBehavior,
      series: <ChartSeries>[
        LineSeries<DataPoint, DateTime>(
          enableTooltip: true,
          color: Colors.red[600],
          dataSource: dataPoints,
          xValueMapper: (DataPoint data, _) => data.timestamp,
          yValueMapper: (DataPoint data, _) => data.value,
          width: 5,
          markerSettings: const MarkerSettings(
            shape: DataMarkerType.diamond,
            color: Color.fromARGB(255, 255, 255, 255),
            isVisible: true,
          ),
        ),
      ],
    );
  }
}

class DataPoint {
  final DateTime timestamp;
  final double value;

  DataPoint(this.timestamp, this.value);
}
