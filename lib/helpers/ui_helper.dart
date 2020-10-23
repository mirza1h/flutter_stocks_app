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

  static String truncateWithEllipsis(int cutoff, String myString) {
    String trcString;
    if (myString.length <= cutoff) {
      trcString = myString;
    } else {
      trcString = myString.substring(0, cutoff) + "...";
    }
    return trcString;
  }

  static String formatAmount(double amount) {
    if (amount != null) {
      var nf = NumberFormat.compactCurrency(
          locale: "en_US", decimalDigits: 3, symbol: '\$');
      return nf.format(amount);
    } else
      return "N/A";
  }

  static String formatVolume(int volume) {
    if (volume != null) {
      var nf = NumberFormat.compact();
      return nf.format(volume);
    } else
      return "N/A";
  }
}
