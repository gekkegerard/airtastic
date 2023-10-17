import 'package:flutter/material.dart';

class CommonWidgets {
  Widget buildContainer(String header, String paragraph) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
      child: Column(
        children: [
          Text(
            header,
            style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          Text(
            paragraph,
            style: const TextStyle(fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
