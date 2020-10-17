import 'package:flutter/material.dart';
import 'package:flutter_candlesticks/flutter_candlesticks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stocks_app/helpers/http_helper.dart';
import 'package:stocks_app/helpers/ui_helper.dart';
import 'package:stocks_app/models/stock.dart';
import 'package:stocks_app/models/stock_chart.dart';
import 'package:stocks_app/widgets/stock_info.dart';

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
  _StockDetailState({this.stock});

  void onTimeIntervalPressed(int timeInterval) {
    setState(() {
      chartTimeInterval = timeInterval;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[800],
        title: Text(this.stock.name + " (" + this.stock.symbol + ")"),
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
                      height: 200.0,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: () => onTimeIntervalPressed(30),
              child: const Text('Month', style: TextStyle(fontSize: 10)),
            ),
            RaisedButton(
              onPressed: () => onTimeIntervalPressed(90),
              child: const Text('Quarter', style: TextStyle(fontSize: 10)),
            ),
            RaisedButton(
              onPressed: () => onTimeIntervalPressed(365),
              child: const Text('Year', style: TextStyle(fontSize: 10)),
            ),
          ],
        ),
        FutureBuilder<String>(
            future: HttpHelper.fetchStockDescription(stock.symbol),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ExpansionTile(
                  title: Text('Company description'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                          UIHelper.truncateWithEllipsis(800, snapshot.data)),
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
