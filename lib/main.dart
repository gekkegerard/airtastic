import 'package:flutter/material.dart';
import 'package:airtastic/pages/home.dart';
import 'package:airtastic/pages/loading.dart';
import 'package:airtastic/pages/Ozon.dart';
import 'package:airtastic/pages/settings.dart';
import 'package:airtastic/pages/Temperature.dart';
import 'package:airtastic/pages/Humidity.dart';
import 'package:airtastic/pages/About.dart';
import 'package:airtastic/pages/connected_devices.dart';

void main() => runApp(MaterialApp(
      initialRoute: '/home',
      routes: {
        '/': (context) => const Loading(),
        '/home': (context) => const Home(),
        '/Ozon': (context) => const Ozon(),
        '/settings': (context) => const Settings(),
        '/Temperature': (context) => const TemperaturePage(),
        '/Humidity': (context) => const Humidity(),
        '/About': (context) => const About(),
        '/connected_devices': (context) => const Devices(),
      },
    ));
