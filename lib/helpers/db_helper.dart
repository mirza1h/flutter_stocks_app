import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DbHelper {
  static User currentUser;
  static List<String> watchlist;
  static Future<List<String>> getUserWatchlist(User user) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("watchlist")
        .doc(user.uid)
        .get();
    List<String> list = List<String>();
    final result = querySnapshot.data()["watched_stocks"];
    if (result is String) {
      list.add(result);
    } else {
      list = List<String>.from(result);
    }
    watchlist = list;
    return list;
  }

  static void setUser(User user) {
    currentUser = user;
  }

  static void addToWatchlist(String ticker, BuildContext context,
      StreamController actionsRebuildCtr) async {
    final userRef =
        FirebaseFirestore.instance.collection("watchlist").doc(currentUser.uid);
    // Append to watched_stocks
    userRef.update({
      'watched_stocks': FieldValue.arrayUnion(['$ticker'])
    }).then((value) {
      Scaffold.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 1), content: Text('Position added')));
      watchlist.add(ticker);
      actionsRebuildCtr.add(true);
    }).catchError((error) => print("Failed to update watchlist: $error"));
  }

  static void removeFromWatchlist(String ticker, BuildContext context,
      StreamController actionsRebuildCtr) async {
    final userRef =
        FirebaseFirestore.instance.collection("watchlist").doc(currentUser.uid);
    // Remove from watched_stocks
    userRef.update({
      'watched_stocks': FieldValue.arrayRemove(['$ticker'])
    }).then((value) {
      Scaffold.of(context).showSnackBar(
          SnackBar(duration: Duration(seconds: 1), content: Text('Removed')));
      watchlist.remove(ticker);
      actionsRebuildCtr.add(true);
    }).catchError((error) => print("Failed to update watchlist: $error"));
  }

  static bool checkRemovePossible(String ticker, bool forWatchlist) {
    if (forWatchlist)
      return watchlist.contains(ticker);
    else
      return false;
  }
}
