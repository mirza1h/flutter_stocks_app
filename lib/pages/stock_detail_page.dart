import 'package:flutter/material.dart';
import 'package:flutter_candlesticks/flutter_candlesticks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stocks_app/helpers/http_helper.dart';
import 'package:stocks_app/models/stock.dart';
import 'package:stocks_app/models/stock_chart.dart';

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
  int chartTimeInterval = 365;
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
        title: Text(this.stock.name),
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
        Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Text(
              "Apple, Inc. engages in the design, manufacture...Apple, Inc. engages in the design, manufacture..."),
        ),
        Expanded(
          child: ListView(children: <Widget>[
            ListTile(
              leading: FaIcon(FontAwesomeIcons.exchangeAlt),
              title: Text(
                "Exchange",
              ),
              trailing: Text("${stock.exchange}"),
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.shoppingCart),
              title: Text("Market capitalization"),
              trailing: Text("${stock.marketCap}"),
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.dollarSign),
              title: Text("Day low"),
              trailing: Text("${stock.dayLow}"),
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.dollarSign),
              title: Text("Day high"),
              trailing: Text("${stock.dayHigh}"),
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.database),
              title: Text("Volume"),
              trailing: Text("${stock.volume}"),
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.businessTime),
              title: Text("Earnings announcement"),
              trailing: Text("${stock.earningsAnnouncement}".substring(0, 10)),
            )
          ]),
        ),
      ]),
    );
  }
}
