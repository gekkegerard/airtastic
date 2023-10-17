import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:airtastic/data/random_chart_data.dart';
import 'dart:async';

// https://blog.logrocket.com/build-beautiful-charts-flutter-fl-chart/

class LineChartWidget extends StatefulWidget {
  const LineChartWidget(this.points, {Key? key}) : super(key: key);

  final List<ValuePoint> points;

  @override
  State<LineChartWidget> createState() =>
      // ignore: no_logic_in_create_state
      _LineChartWidgetState(points: points);
}

class _LineChartWidgetState extends State<LineChartWidget> {
  List<ValuePoint> points;

  _LineChartWidgetState({required this.points});

  late Timer _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
      setState(() {
        points = generateRandomData();
      });
    });
  }

  @override
  // Stop the timer when the widget is disposed to prevent memory leaks
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio:
            1, // Prefer using *AspectRatio* over SizedBox so that the graph is not skewed on different screen sizes
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              0, 0, 30, 0), // Add a bit of padding to the right
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
              ),
              borderData: FlBorderData(
                // Add border only at the bottom and left
                border: const Border(bottom: BorderSide(), left: BorderSide()),
                show: true,
              ),
              titlesData: FlTitlesData(
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              lineBarsData: [
                LineChartBarData(
                  color: Colors.red[600],
                  spots:
                      points.map((point) => FlSpot(point.x, point.y)).toList(),
                  isCurved: false,
                  dotData: FlDotData(
                    show: false,
                  ),
                  aboveBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        ));
  }
}
