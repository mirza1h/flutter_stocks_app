import 'package:flutter/material.dart';
import 'package:flutter_candlesticks/flutter_candlesticks.dart';
import 'package:stocks_app/helpers/http_helper.dart';
import 'package:stocks_app/models/stock.dart';
import 'package:stocks_app/models/stock_chart.dart';

class StockDetail extends StatelessWidget {
  final Stock stock;

  StockDetail({Key key, @required this.stock});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.stock.name),
        ),
        body: FutureBuilder<StockChart>(
            future: HttpHelper.fetchStockHistoricalData(this.stock.symbol, 350),
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
            }));
  }
}
