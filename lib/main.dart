import 'package:airtastic/pages/co2_chart.dart';
import 'package:flutter/material.dart';
import 'package:airtastic/pages/home.dart';
import 'package:airtastic/pages/loading.dart';
import 'package:airtastic/pages/ozone.dart';
import 'package:airtastic/pages/ozone_chart.dart';
import 'package:airtastic/pages/settings.dart';
import 'package:airtastic/pages/temperature.dart';
import 'package:airtastic/pages/Temperature_chart.dart';
import 'package:airtastic/pages/humidity.dart';
import 'package:airtastic/pages/humidity_chart.dart';
import 'package:airtastic/pages/about.dart';
import 'package:airtastic/z_old_code/connected_devices.dart';
import 'package:airtastic/pages/CO2.dart';
import 'package:airtastic/pages/co2_chart.dart';

void main() => runApp(MaterialApp(
      initialRoute: '/Home',
      routes: {
        '/': (context) => const Loading(),
        '/Home': (context) => const Home(),
        '/connected_devices': (context) => const Devices(),
        '/Temperature': (context) => const TemperaturePage(),
        '/Temperature_Chart': (context) => const TemperatureChart(),
        '/Humidity': (context) => const Humidity(),
        '/Humidity_Chart': (context) => const HumidityChart(),
        '/Ozone': (context) => const Ozone(),
        '/Ozone_Chart': (context) => const OzoneChart(),
        '/CO2': (context) => const CO2(),
        '/CO2_Chart': (context) => const CO2Chart(),
        '/settings': (context) => const Settings(),
        '/About': (context) => const About(),
      },
    ));
