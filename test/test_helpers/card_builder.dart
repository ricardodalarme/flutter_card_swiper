import 'package:flutter/material.dart';

Widget? genericBuilder(
  BuildContext context,
  int index,
  int horizontalPercentage,
  int verticalPercentage,
) {
  return Container(
    width: 200,
    height: 200,
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      getIndexText(index),
      style: const TextStyle(fontSize: 24, color: Colors.white),
    ),
  );
}

String getIndexText(int index) {
  return 'Card $index';
}
