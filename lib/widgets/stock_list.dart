import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stocks_app/helpers/http_helper.dart';
import 'package:stocks_app/helpers/ui_helper.dart';
import 'package:stocks_app/helpers/db_helper.dart';
import 'package:stocks_app/models/stock.dart';
import 'package:stocks_app/pages/stock_detail_page.dart';

class StockList extends StatefulWidget {
  User user;
  bool isWatchlist;
  StreamController headerRebuildCtr;
  StockList(User user, bool isWatchlist, StreamController headerRebuildCtr) {
    this.user = user;
    this.isWatchlist = isWatchlist;
    this.headerRebuildCtr = headerRebuildCtr;
  }
  @override
  State<StatefulWidget> createState() {
    return _StockListState(user, isWatchlist, headerRebuildCtr);
  }
}

class _StockListState extends State<StockList> {
  User user;
  var stockList;
  bool isWatchlist;
  StreamController headerRebuildCtr;
  _StockListState(
      User user, bool isWatchlist, StreamController headerRebuildCtr) {
    this.user = user;
    this.isWatchlist = isWatchlist;
    this.headerRebuildCtr = headerRebuildCtr;

    if (isWatchlist == true) {
      DbHelper.getUserWatchlist(user).then((value) {
        if (value != null) {
          setState(() {
            this.stockList = value;
          });
        }
      });
    } else {
      DbHelper.getUserPortfolio(user).then((value) {
        if (value != null) {
          setState(() {
            this.stockList = value;
          });
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Stock>>(
        future: this.isWatchlist
            ? HttpHelper.fetchStocks(this.stockList)
            : HttpHelper.fetchPortfolioStocks(this.stockList).then((value) {
                headerRebuildCtr.add(true);
                return value;
              }),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              separatorBuilder: (context, index) {
                return Divider(color: Colors.grey);
              },
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final stock = snapshot.data[index];
                return ListTile(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StockDetail(stock: stock)))
                  },
                  leading: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${stock.symbol}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "${stock.name}",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  trailing: Column(
                    children: [
                      this.isWatchlist
                          ? Text(
                              "\$${stock.price}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            )
                          : Text(
                              "\$" +
                                  (stock.price * stock.quantity ?? 1)
                                      .toStringAsFixed(2),
                              style: TextStyle(
                                color: UIHelper.returnChangeColor(stock.change)
                                    .color,
                                fontSize: 18,
                              ),
                            ),
                      this.isWatchlist
                          ? Container(
                              alignment: Alignment.center,
                              width: 75,
                              height: 25,
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                "${stock.change}",
                                style: UIHelper.returnChangeColor(stock.change),
                              ))
                          : Text(
                              "${stock.quantity}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                    ],
                  ),
                );
              },
            );
          } else
            return Container(
              child: Center(child: Text("Add some stocks that interest you")),
            );
        });
  }
}
