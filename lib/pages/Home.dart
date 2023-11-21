import 'package:flutter/material.dart';
import 'package:airtastic/widgets/nav_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // https://help.syncfusion.com/flutter/backup/chart/getting-started

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const nav_bar(),
        appBar: AppBar(
          title: const Text('Airtastic'),
          centerTitle: true,
          backgroundColor: Colors.red[600],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 48.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SfCartesianChart(
                  // Initialize category axis with gap
                  primaryXAxis: NumericAxis(),
                  series: <ChartSeries>[
                    // Initialize scatter series
                    ScatterSeries<SalesData, double>(
                      color: Colors.red[600],
                      dataSource: [
                        // Bind data source
                        SalesData(1, 35),
                        SalesData(1.5, 28),
                        SalesData(3, 34),
                        SalesData(6, 32),
                        SalesData(7, 40)
                      ],
                      xValueMapper: (SalesData sales, _) => sales.year,
                      yValueMapper: (SalesData sales, _) => sales.sales,
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final double year;
  final double sales;
}
