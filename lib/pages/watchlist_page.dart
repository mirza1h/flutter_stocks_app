import 'package:flutter/material.dart';
import 'package:stocks_app/widgets/stock_list.dart';

class Watchlist extends StatelessWidget {
  const Watchlist({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: StockList());
  }
}
