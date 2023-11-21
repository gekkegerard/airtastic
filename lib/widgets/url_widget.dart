import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

Widget urlwidget(String url) {
  return InkWell(
    child: const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        'Open Browser',
        style: TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    ),
    onTap: () => launchUrlString(url),
  );
}
