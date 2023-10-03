import 'dart:math';
import 'package:collection/collection.dart';

class ValuePoint {
  final double x;
  final double y;

  ValuePoint({required this.x, required this.y});
}

List<ValuePoint> generateRandomData() {
  final Random random = Random();
  final randomNumbers = <double>[];
  for (var i = 0; i <= 11; i++) {
    randomNumbers.add(random.nextDouble() * 40);
  }

  return randomNumbers
      .mapIndexed(
          (index, element) => ValuePoint(x: index.toDouble(), y: element))
      .toList();
}
