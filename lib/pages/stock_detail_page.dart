import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_candlesticks/flutter_candlesticks.dart';
import 'package:stocks_app/helpers/db_helper.dart';
import 'package:stocks_app/helpers/http_helper.dart';
import 'package:stocks_app/helpers/ui_helper.dart';
import 'package:stocks_app/models/stock.dart';
import 'package:stocks_app/models/stock_chart.dart';
import 'package:stocks_app/pages/buy_transaction_page.dart';
import 'package:stocks_app/widgets/stock_info.dart';

import 'home_page.dart';

class StockDetail extends StatefulWidget {
  final Stock stock;
  StockDetail({Key key, @required this.stock});

  @override
  State<StatefulWidget> createState() {
    return new _StockDetailState(stock: stock);
  }
}

class _StockDetailState extends State {
  Stock stock;
  int chartTimeInterval = 90;
  List<bool> isSelected = [false, true, false];
  _StockDetailState({this.stock});

  void onTimeIntervalPressed(int timeInterval) {
    setState(() {
      chartTimeInterval = timeInterval;
    });
  }

  switchTimeInterval(int index) {
    setState(() {
      for (int i = 0; i < isSelected.length; ++i) {
        if (i == index) {
          isSelected[i] = true;
        } else {
          isSelected[i] = false;
        }
      }
      switch (index) {
        case 0:
          onTimeIntervalPressed(30);
          break;
        case 1:
          onTimeIntervalPressed(90);
          break;
        case 2:
          onTimeIntervalPressed(360);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return HomePage(user: DbHelper.currentUser);
            },
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber[800],
          title: Text(this.stock.name + " (" + this.stock.symbol + ")"),
          actions: [_actionsPopup(this.stock, context)],
        ),
        body: Column(children: [
          Container(
            child: FutureBuilder<StockChart>(
                future: HttpHelper.fetchStockHistoricalData(
                    this.stock.symbol, this.chartTimeInterval),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        height: 220,
                        margin: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.35),
                                blurRadius: 8.0),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 6.0),
                        child: new OHLCVGraph(
                            data: snapshot.data.stockChart,
                            enableGridLines: true,
                            volumeProp: 0.2),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleButtons(
                  constraints: BoxConstraints(minWidth: 40.0, minHeight: 34.0),
                  children: <Widget>[
                    const Text('Month', style: TextStyle(fontSize: 10)),
                    const Text('Quarter', style: TextStyle(fontSize: 10)),
                    const Text('Year', style: TextStyle(fontSize: 10)),
                  ],
                  onPressed: (index) => switchTimeInterval(index),
                  isSelected: isSelected,
                ),
              ],
            ),
          ),
          FutureBuilder<String>(
              future: HttpHelper.fetchStockDescription(stock.symbol),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ExpansionTile(
                    title: Text('Company description'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                            UIHelper.truncateWithEllipsis(600, snapshot.data)),
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              }),
          FutureBuilder<Object>(
              future: HttpHelper.fetchStock(stock.symbol),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return StockInfo(snapshot.data);
                } else {
                  return Container();
                }
              }),
        ]),
      ),
    );
  }
}

Widget _actionsPopup(Stock stock, BuildContext context) {
  final isWatchlistRemovePossible =
      DbHelper.checkRemovePossible(stock.symbol, true);
  final isPortfolioRemovePossible =
      DbHelper.checkRemovePossible(stock.symbol, false);
  return PopupMenuButton<int>(
    itemBuilder: (context) => [
      PopupMenuItem(
        value: isWatchlistRemovePossible ? 2 : 1,
        child: isWatchlistRemovePossible
            ? Text("Remove from watchlist")
            : Text("Add to watchlist"),
      ),
      PopupMenuDivider(),
      PopupMenuItem(
        value: isPortfolioRemovePossible ? 4 : 3,
        child: isPortfolioRemovePossible
            ? Text("Remove from portfolio")
            : Text("Add to portfolio"),
      ),
    ],
    onSelected: (value) {
      if (value == 1) {
        DbHelper.addToWatchlist(stock.symbol);
      } else if (value == 2) {
        DbHelper.removeFromWatchlist(stock.symbol);
      } else if (value == 3) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => BuyForm(stock: stock)));
      } else {
        print("Removed");
      }
    },
  );
}
