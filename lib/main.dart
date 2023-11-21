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
import 'package:airtastic/pages/CO2.dart';
import 'package:airtastic/pages/co2_chart.dart';

void main() => runApp(MaterialApp(
      // the initial route is /Home
      initialRoute: '/Home',
      // all the links for the seperate pages are stored here
      routes: {
        // link for loading
        '/': (context) => const Loading(),
        // link for home page
        '/Home': (context) => const Home(),
        // link for temperature page
        '/Temperature': (context) => const TemperaturePage(),
        // link for temperature chart page
        '/Temperature_Chart': (context) => const TemperatureChart(),
        // link for humidity page
        '/Humidity': (context) => const Humidity(),
        // link for humidity chart page
        '/Humidity_Chart': (context) => const HumidityChart(),
        // link for ozone page
        '/Ozone': (context) => const Ozone(),
        // link for ozone chart page
        '/Ozone_Chart': (context) => const OzoneChart(),
        // link for co2 page
        '/CO2': (context) => const CO2(),
        // link for co2 chart page
        '/CO2_Chart': (context) => const CO2Chart(),
        // link for settings page
        '/settings': (context) => const Settings(),
        // link for about us page
        '/About': (context) => const About(),
      },
    ));
