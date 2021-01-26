import 'package:flutter/material.dart';

Decoration _customStyle(context) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.shade200,
        offset: Offset(0.0, 10.0),
        blurRadius: 10.0,
        spreadRadius: 1.0,
      )
    ],
  );
}
