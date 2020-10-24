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
  StockList(User user, bool isWatchlist) {
    this.user = user;
    this.isWatchlist = isWatchlist;
  }
  @override
  State<StatefulWidget> createState() {
    return _StockListState(user, isWatchlist);
  }
}

class _StockListState extends State<StockList> {
  User user;
  var userWatchlist;
  bool isWatchlist;
  _StockListState(User user, bool isWatchlist) {
    this.user = user;
    this.isWatchlist = isWatchlist;
    DbHelper.getUserWatchlist(user).then((value) {
      if (value != null) {
        setState(() {
          this.userWatchlist = value;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Stock>>(
        future: HttpHelper.fetchStocks(this.userWatchlist),
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
                                  (stock.price * stock.quantity)
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
