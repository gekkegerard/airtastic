import 'package:flutter/material.dart';
import 'package:airtastic/pages/home.dart';
import 'package:airtastic/pages/loading.dart';
import 'package:airtastic/pages/ozone.dart';
import 'package:airtastic/pages/settings.dart';
import 'package:airtastic/pages/temperature.dart';
import 'package:airtastic/pages/humidity.dart';
import 'package:airtastic/pages/about.dart';
import 'package:airtastic/z_old_code/connected_devices.dart';
import 'package:airtastic/pages/co2.dart';


void main() => runApp(MaterialApp(
      initialRoute: '/Home',
      routes: {
        '/': (context) => const Loading(),
        '/Home': (context) => const Home(),
        '/connected_devices': (context) => const Devices(),
        '/Temperature': (context) => const TemperaturePage(),
        '/Humidity': (context) => const Humidity(),
        '/Ozone': (context) => const Ozone(),
        '/CO2': (context) => const CO2(),
        '/settings': (context) => const Settings(),
        '/About': (context) => const About(),
      },
    ));
