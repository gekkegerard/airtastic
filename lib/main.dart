import 'package:flutter/material.dart';
import 'package:airtastic/pages/loading.dart';
import 'package:airtastic/pages/home.dart';

void main() => runApp(MaterialApp(
      initialRoute: '/home',
      routes: {
        '/': (context) => Loading(),
        '/home': (context) => Home(),
      },
    ));
