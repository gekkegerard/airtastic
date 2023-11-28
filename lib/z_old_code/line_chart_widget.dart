import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:airtastic/data/random_chart_data.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
        getData();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(
              show: true,
            ),
            borderData: FlBorderData(
              border: const Border(bottom: BorderSide(), left: BorderSide()),
              show: true,
            ),
            titlesData: const FlTitlesData(
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  // interval: 2.0,
                  reservedSize: 50,
                ),
                axisNameSize: 18,
                axisNameWidget: Text("Temperature in °C",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  // interval: 1.0,
                ),
                axisNameSize: 18,
                axisNameWidget: Text("Wat komt hier?",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                color: Colors.red[600],
                spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
                isCurved: false,
                dotData: const FlDotData(
                  show: false,
                ),
                aboveBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getData() async {
    var url =
        'https://markus.glumm.sites.nhlstenden.com/opdracht11_app_get_data.php';
    http.Response response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body) as List<dynamic>;

    setState(() {
      points = data
          .map((entry) => ValuePoint(
                x: double.parse(entry['id'].toString()),
                y: double.parse(entry['temperature'].toString()),
              ))
          .toList();
    });
  }
}
