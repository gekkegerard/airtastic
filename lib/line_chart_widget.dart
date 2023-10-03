import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:airtastic/data/random_chart_data.dart';
import 'dart:async';

class LineChartWidget extends StatefulWidget {
  const LineChartWidget(this.points, {Key? key}) : super(key: key);

  final List<PricePoint> points;

  @override
  State<LineChartWidget> createState() =>
      // ignore: no_logic_in_create_state
      _LineChartWidgetState(points: points);
}

class _LineChartWidgetState extends State<LineChartWidget> {
  List<PricePoint> points;

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
  void dispose() {
    _timer
        .cancel(); // Zorg ervoor dat de timer wordt gestopt bij het opruimen van de state
    super.dispose();
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
