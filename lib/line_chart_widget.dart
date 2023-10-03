import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:airtastic/data/random_chart_data.dart';
import 'dart:async';

class LineChartWidget extends StatefulWidget {
  const LineChartWidget(this.points, {Key? key}) : super(key: key);

  final List<PricePoint> points;

  @override
  State<LineChartWidget> createState() =>
      _LineChartWidgetState(points: this.points);
}

class _LineChartWidgetState extends State<LineChartWidget> {
  List<PricePoint> points;

  _LineChartWidgetState({required this.points});

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 10), (timer) {
      // Update the data
      setState(() {
        points = generateRandomData();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              color: Colors.red[600],
              spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
              isCurved: false,
              dotData: FlDotData(
                show: false,
              ),
              aboveBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
