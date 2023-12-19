import 'package:flutter/material.dart';
//import 'package:airtastic/widgets/page_colors.dart';

Widget paragraphBuilder(String header, List<dynamic> paragraphs) {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
    child: Column(
      children: [
        Text(
          header,
          style: const TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              /*color: AppColorsLightMode.textColor*/),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10.0),
        for (var paragraph in paragraphs)
          (paragraph is String)
              ? Text(
                  paragraph,
                  style: const TextStyle(
                      fontSize: 18.0, /*color: AppColorsLightMode.textColor*/),
                  textAlign: TextAlign.center,
                )
              : paragraph,
      ],
    ),
  );
}
