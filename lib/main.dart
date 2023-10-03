import 'package:flutter/material.dart';
import 'package:airtastic/pages/Loading.dart';
import 'package:airtastic/pages/Home.dart';

void main() => runApp(MaterialApp(
      initialRoute: '/home',
      routes: {
        '/': (context) => Loading(),
        '/home': (context) => Home(),
      },
    ));
