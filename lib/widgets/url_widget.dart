import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

Widget urlwidget(String url) {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 20.0),
    child: InkWell(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          url,
          style: const TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
            fontSize: 18.0,
          ),
        ),
      ),
      onTap: () => launchUrlString(url),
    ),
  );
}
