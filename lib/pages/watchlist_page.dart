import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stocks_app/widgets/stock_list.dart';

class Watchlist extends StatelessWidget {
  User user;
  Watchlist(User user) {
    this.user = user;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: StockList(user));
  }
}
