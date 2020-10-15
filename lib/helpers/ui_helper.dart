import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UIHelper {
  static TextStyle returnChangeColor(double change) {
    if (change < 0) {
      return TextStyle(color: Colors.red);
    } else {
      return TextStyle(color: Colors.green);
    }
  }

  static String formatDate(DateTime dateTime) {
    var formatter = new DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }
}
