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
  StockList(User user) {
    this.user = user;
  }
  @override
  State<StatefulWidget> createState() {
    return _StockListState(user);
  }
}

class _StockListState extends State<StockList> {
  User user;
  var userWatchlist;
  _StockListState(User user) {
    this.user = user;
    DbHelper.getUserWatchlist(user).then((value) {
      if (value != null) {
        setState(() {
          this.userWatchlist = value;
        });
      } else {
        // Default values
        setState(() {
          this.userWatchlist = ["AAPL", "FB", "GOOG"];
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
                  title: Column(
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
                      Text(
                        "\$${stock.price}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      Container(
                          alignment: Alignment.center,
                          width: 75,
                          height: 25,
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            "${stock.change}",
                            style: UIHelper.returnChangeColor(stock.change),
                          )),
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
