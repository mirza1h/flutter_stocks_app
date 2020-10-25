import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stocks_app/models/stock.dart';

class DbHelper {
  static User currentUser;
  static List<String> watchlist;
  static List<String> portfolio;

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

  static Future<List<Stock>> getUserPortfolio(User user) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("portfolio")
        .doc(user.uid)
        .collection("stocks")
        .get();
    final stockCollection = querySnapshot.docs;
    List<Stock> result = new List<Stock>();
    portfolio = new List<String>();
    stockCollection.forEach((e) {
      portfolio.add(e.id);
      result.add(Stock(
          symbol: e.id,
          quantity: e.data()['quantity'],
          boughtAt: e.data()['boughtAt'].toDouble(),
          soldAt: e.data()['soldAt'].toDouble()));
    });
    return result;
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
      Scaffold.of(context).showSnackBar(
          SnackBar(duration: Duration(seconds: 1), content: Text('Added')));
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

  static bool checkRemovePossible(String ticker) {
    return watchlist.contains(ticker);
  }

  static bool checkSellPossible(String ticker) {
    return portfolio.contains(ticker);
  }

  static void addToPortfolio(Stock stock, BuildContext context) async {
    final userRef = FirebaseFirestore.instance
        .collection("portfolio")
        .doc(currentUser.uid)
        .collection("stocks");
    // Add to portfolio
    userRef.doc(stock.symbol).set({
      "boughtAt": stock.boughtAt ?? 0,
      "quantity": stock.quantity,
      "soldAt": stock.soldAt ?? 0,
    }).then((value) {
      Scaffold.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 1), content: Text('Position added')));
      new Future.delayed(const Duration(milliseconds: 1000), () {
        Navigator.pop(context);
      });
    }).catchError((error) => print("Failed to add: $error"));
  }
}
