import 'package:flutter/material.dart';
import 'package:flutter_candlesticks/flutter_candlesticks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stocks_app/helpers/db_helper.dart';
import 'package:stocks_app/helpers/http_helper.dart';
import 'package:stocks_app/helpers/ui_helper.dart';
import 'package:stocks_app/models/stock.dart';
import 'package:stocks_app/models/stock_chart.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[800],
        title: Text(this.stock.name + " (" + this.stock.symbol + ")"),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(pageBuilder: (BuildContext context,
                      Animation animation, Animation secondaryAnimation) {
                    return HomePage(user: DbHelper.currentUser);
                  }, transitionsBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child) {
                    return new SlideTransition(
                      position: new Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  }),
                  (Route route) => false);
            }),
        actions: [_actionsPopup(this.stock.symbol)],
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
                      padding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
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
    );
  }
}

Widget _actionsPopup(String ticker) => PopupMenuButton<int>(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: DbHelper.checkRemovePossible(ticker) ? 2 : 1,
          child: DbHelper.checkRemovePossible(ticker)
              ? Text("Remove from watchlist")
              : Text("Add to watchlist"),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          value: 3,
          child: Text("Add to portfolio"),
        ),
      ],
      onSelected: (value) {
        if (value == 1) {
          DbHelper.addToWatchlist(ticker);
        } else if (value == 2) {
          DbHelper.removeFromWatchlist(ticker);
          _actionsPopup(ticker);
        } else {
          // DbHelper.addToPortfolio();
        }
      },
    );
