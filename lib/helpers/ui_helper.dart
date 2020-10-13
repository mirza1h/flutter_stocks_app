import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UIHelper {
  static TextStyle returnChangeColor(double change) {
    if (change < 0) {
      return TextStyle(color: Colors.red);
    } else {
      return TextStyle(color: Colors.green);
    }
  }
}
